; assembler: sbasm
; command: sbasm monitor.asm

    .CR z180
    .TF test_kbd.hex,INT,16
    .LF test_kbd.lst
    
    .include ../../../../include/z180_defs.asm

    .org $0000
    jp mreset        ; RESET    

    .org $0038
    jp int_noop    ; INT0

    .org $0066
    jp int_noop    ; NMI

; interrupt vector table
    .org $0080
    .dw int_kbd    ; INT1
    .dw int_noop    ; INT2
    .dw int_noop    ; PRT0
    .dw int_noop    ; PRT1
    .dw int_noop    ; DMA0
    .dw int_noop    ; DMA1
    .dw int_noop    ; CSIO
    .dw int_noop   ; ASCI0
    .dw int_noop    ; ASCI1

    .org $0100
mreset:

    di ; disable interrupts

    ; CMR_X2 : clock * 2 => xtal 16Mhz ---> 32Mhz, phi 8Mhz --> 16Mhz
    ;ld a,CMR_X2
    ;out0 (CMR),a

    ; CCR_CD : phi = XTAL/1 => phi 16Mhz ---> 32Mhz !!!
    ;ld a,CCR_CD
    ;out0 (CCR),a

    ld  a,0
    out0 (RCR),a    ; Refresh disable

    ; MMU    
    ; $F000-$FFFF = VDU ( $20000 - $20FFF ) - Common Area 1
    ; $2000-$EFFF = RAM ( $80000 - $8EFFF ) - Bank Area
    ; $0000-$1FFF = ROM ( $00000 - $01FFF ) - Common Area 0
    
    ld a,$F2 ; Common Area 1 = $F000-$FFFF, Bank Area 1 =  $2000-$EFFF
    out0 (CBAR),a
    ld a,$11 ; Common Area Base = $20000
    out0 (CBR),a
    ld a,$7E ; Bank Area Base = $80000 
    out0 (BBR),a

    ; Stack pointer = $10FF
    ld sp,$20FF

    call asci1_init

    ; setup interupts
    im 1    ; interrupt mode 1
    ld a,0  ; interrupts high order byte : 00H
    ld i,a
    ld a,0b10000000 ; interrupts low order byte : 80H
    out0 (IL),a

    ; enable INT1
    ld a,ITC_ITE1 
    out0 (ITC),a

   ei      ; enable interrupts

KBD_DATA    .equ $80
KBD_STATUS  .equ $81

main:
    ld hl,str_welcome ; show welcome message
    call asci1_puts

    ld a,0
    ld (kbd_buffer_pos),a

loop:
 ;in0 a,(KBD_DATA)
 ;   call decode_scancode
    ld a,(kbd_buffer_pos)
    cp $0
    jp Z,loop
    call kbd_get_key
   ; ld a,(kbd_buffer_pos)
    call asci1_putc
    jp loop


kbd_get_key:
    push hl
    push de
    ld a,(kbd_buffer_pos)
    dec a
    ld (kbd_buffer_pos),a
    ld d,0 
    ld e,a
    ld hl,kbd_buffer
    add hl,de
    ld a,(hl)

    pop de
    pop hl
    ret

int_kbd:
    push af
    push hl
    push de

    in0 a,(KBD_DATA)
    cp $70                      ; F0 = release key
    jp Z,int_kbd_release_key

    ld a,(kbd_state)            ; state==1 -> released key scancode after $F0
    cp $01
    jp Z,int_kbd_release_key_2
  
    ld d,0                      ; hl <- kbd_buffer+(kbd_buffer_pos)
    ld a,(kbd_buffer_pos)
    ld e,a
    ld hl,kbd_buffer
    add hl,de

    in0 a,(KBD_DATA)            ; get ASCII code
    call decode_scancode
    ld (hl),a

    ld a,e                      ; inc kbd_buffer_pos 
    inc a
    ld (kbd_buffer_pos),a

    jr int_kbd_exit

int_kbd_release_key_2:
    ld a,0
    ld (kbd_state),a
    jr int_kbd_exit

int_kbd_release_key:
    ld a,1
    ld (kbd_state),a

int_kbd_exit:
    pop de
    pop hl
    pop af
    ei
    ret


; -----------------------------------------------------------------

; initialize asci1
asci1_init:

    ; RE : Receiver Enable
    ; TE : Transmitter Enable
    ; MOD2 : 8 bits data ( No parity, 1 stop bit)
    ld a,CNTLA1_RE|CNTLA1_TE|CNTLA1_MOD2
    out0 (CNTLA1),a

    ; DR=0
    ld a,0
    out0 (CNTLB1),a
    
    ; BRG0 : Enable 16 bit BRG counter
    ; X1 ( + DR=0) : Clock mode = /1
    ld a,ASEXT1_BRG1|ASEXT1_X1
    out0 (ASEXT1),a

    ; 9600 bauds : TC=1665 (681H) --> 9603 bauds
    ; TC = fphi/(2*baud rate*clock mode) - 2
    ; TC = 32000000/(2*9600*1) - 2
    ld a,$81
    out0 (ASTC1L),a
    ld a,$06
    out0 (ASTC1H),a
    
    ret

; put a string on asci1
; input : (hl) = address of null terminated string
asci1_puts:
    push hl
    push af 

asci1_puts_loop:
    ld a,(hl)
    or 0
    jr z,asci1_puts_exit
    call asci1_putc
    inc hl
    jr asci1_puts_loop

asci1_puts_exit:
    pop af
    pop hl
    ret



; put a char on asci1
; input : a = char ascii code
asci1_putc:
    push af

asci1_putc_wait:  ; wait for asci0 TX ready
    in0 a,(STAT1) ; TDRE=1 -> empty
    and STAT1_TDRE
    jr Z,asci1_putc_wait
    pop af
    out0 (TDR1),a ; output the char to asci0
    ret


int_noop:
    ei
    ret


str_welcome:    .db $1B,"[2J",$1B,"[H","Test Kbd",13,10,13,10,0

    
; input : a = last scan code
; output : a = decodes scan code
decode_scancode:
    push hl
    push de

    ld hl,scan_codes
    ld d,0  
    ld e,a
    add hl,de
    ld a,(hl)

decode_scancode_exit:

    pop de
    pop hl
    ret
   

scan_codes:
    ; 00-0F : n/a F9 n/a F5 F3 F1 F2 F12 n/a F10 F8 F6 F4 TAB ² n/a
    .db 0,0,0,0,0,0,0,0,0,0,0,0,0,'²',0
    ; 10-1F : n/a n/a LSHIFT n/a n/a a 1 n/a n/a n/a n/a w s q z 2 n/a
    .db 0,0,0,0,0,'a','1',0,0,0,'w','s','q','z','2',0
    ; 20-2F : n/a c x d e 4 3 n/a n/a SPACE v f t r 5 n/a
    .db 0,'c','x','d','e','4','3',0,0,' ','v','f','t','r','5',0
    ; 30-3F : n/a n b h g y 6 n/a n/a n/a , j u 7 8 n/a
    .db 0,'n','b','h','g','y','6',0,0,0,',','j','u','7','8',0
    ; 40-4F : n/a ; k i o 0 9 n/a n/a : ! l m p ) n/a
    .db 0,58,'k','i','o','0','9',0,0,':','!','l','m','p',')',0
    ; 50-5F : n/a n/a ù n/a ^ = n/a n/a CAPS RSHIFT RETURN $ n/a * n/a n/a
    .db 0,0,'ù',0,'^','=',0,0,0,0,0,'$',0,'*',0,0
    ; 60-6F : n/a < n/a n/a n/a n/a BACKSPACE n/a n/a PAD_1 n/a PAD_4 n/a n/a n/a
    .db 0,'<',0,0,0,0,0,0,0,'1',0,'4',0,0,0
    ; 70-7F : PAD_0 PAD_, PAD_2 PAD_5 PAD_6 PAD_8 ESC P_VERNUM F11 PAD_+ PAD_3 PAD_- PAD_* PAD_9 ARRET_DEFIL
    .db '0',',','2','5','6','8',0,0,0,'+','3','-','*','9',0
    ; 80-83 : n/a n/a n/a F7
    .db 0,0,0,0


    .org $2100

kbd_state: .bs 1
kbd_buffer_pos:    .bs 1
kbd_buffer: .bs 64