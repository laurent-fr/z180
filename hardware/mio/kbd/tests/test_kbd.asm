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

    ; init kbd
    ld a,0
    ld (kbd_buffer_pos),a
    ld (kbd_state),a

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

; Get next key in buffer
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

; Keyboard Interruption
int_kbd:
    push af
    push bc
    push de
    push hl

    in0 a,(KBD_DATA)            ; read scancode
    ld b,a                      ; stored in B register

int_kbd_test_F0:
    ;cp $70                      ; F0 = release key
    cp $F0
    jp NZ,int_kbd_test_E0
 
    ld hl,kbd_state             ; set F0 flag in kbd_state
    set KBD_STATE_F0,(hl)
    jp int_kbd_exit

int_kbd_test_E0:
    cp $60                      ; E0 = extended scancodes
    jp NZ,int_kbd_check_state
 
    ld hl,kbd_state             ; set E0 flag in kbd_state
    set KBD_STATE_E0,(hl)
    jp int_kbd_exit

int_kbd_check_state:
    ld a,(kbd_state)            

    bit KBD_STATE_F0,a          ; if previous scancode was F0, jumps to F0 routine
    jp NZ,int_kbd_F0            ; (release key)

    bit KBD_STATE_E0,a          ; if previous scancode was E0, jumps to E0 routinr
    jp NZ,int_kbd_E0            ; (extended scancode)

int_kbd_shift:                  ; manage SHIFT key
    ld a,b
    cp $12 ; lshift
    jp Z,int_kbd_is_shift
    cp $59 ; rshift
    jp NZ,int_kbd_alt

int_kbd_is_shift:
    ld hl,kbd_state             ; set SHIFT flag in kbd_state
    set KBD_STATE_SHIFT,(hl)
    jp int_kbd_exit

int_kbd_alt:                    ; manage ALT key
    cp $11
    jp NZ,int_kbd_capslock

    ld hl,kbd_state             ; set ALT flag in kbd_state
    set KBD_STATE_ALT,(hl)
    jp int_kbd_exit

int_kbd_capslock:                ; manage CAPS LOCK key
    cp $58
    jp NZ,int_kbd_get_key

    ld hl,kbd_state
    ld a,(hl)                   ; toggle CAPS LOCK flag in kbd_stte
    xor KBD_XOR_CAPS
    ld (hl),a
    jp int_kbd_exit

int_kbd_get_key:
    ld d,0                      ; hl <- kbd_buffer+(kbd_buffer_pos)
    ld a,(kbd_buffer_pos)
    ld e,a
    ld hl,kbd_buffer
    add hl,de
    push hl                     ; save current buffer pointer on stack (1)

    ld hl,(kbd_state)

int_kbd_get_key_caps:
    ld  a,1                    ; a==1 -> lowercase , a==0 -> shift

    bit KBD_STATE_CAPS,(hl)
    jp Z,int_kbd_get_key_shift
    xor 1                      ; a<-0 (shift)

int_kbd_get_key_shift:
    bit KBD_STATE_SHIFT,(hl)
    jp Z,int_kbd_get_key_set_shift
    xor 1                       ; flip a 

int_kbd_get_key_set_shift:
    ld hl,scan_codes_shift
    xor 1
    jp Z,int_kbd_get_key_scancode

    ld hl,kbd_state
    bit KBD_STATE_ALT,(hl)      ; use ALT scancode set if ALT flag==1
    jp Z,int_kbd_get_key_set_lowcase
    ld hl,scan_codes_alt
    jr int_kbd_get_key_scancode

int_kbd_get_key_set_lowcase:
    ld hl,scan_codes


int_kbd_get_key_scancode:
    ld a,b
    call kbd_decode_scancode
    pop hl                      ; get back current buffer pointer (see 1)

    cp 0                        ; do nothing if no code found
    jp Z,int_kbd_exit

    ld (hl),a                   ; save it to  kbd_buffer+(kbd_buffer_pos)
          
    cp 10                       ; insert CR if ASCII code == LF (10)
    jp NZ,kbd_int_incr_buffer_pos
    inc hl
    ld a,13
    ld (hl),a
    ld a,e
    inc a 
    ld (kbd_buffer_pos),a

kbd_int_incr_buffer_pos:
    ld a,(kbd_buffer_pos)               ; inc kbd_buffer_pos 
    inc a
    ld (kbd_buffer_pos),a
    jr int_kbd_exit

int_kbd_E0:
    ld hl,kbd_state                     ; clear E0 flag in kbd_state
    res KBD_STATE_E0,(hl)
    jr int_kbd_exit

int_kbd_F0:
   ld hl,kbd_state                      ; clear F0 flag in kbd_state
   res KBD_STATE_F0,(hl)

   ld a,b                               ; clear SHIFT flag if key was LSHIFT 
   cp $12 ; LSHIFT
   jp NZ,int_kbd_F0_rshift
   res KBD_STATE_SHIFT,(hl)
   jr int_kbd_exit

int_kbd_F0_rshift:                      ; clear SHIFT flag if key was LSHIFT
   cp $59 ; RSHIFT
   jp NZ,int_kbd_F0_alt
   res KBD_STATE_SHIFT,(hl)
   jr int_kbd_exit

int_kbd_F0_alt:                         ; clear ALT flag if key was LSHIFT
   cp $11 ; ALT
   jp NZ,int_kbd_exit
   res KBD_STATE_ALT,(hl)

int_kbd_exit:                           ; end of keyboard interrupt routine.
    pop hl
    pop de
    pop bc
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

    
; input : a = scan code, hl = pointer to scan code table
; output : a = decoded scan code
kbd_decode_scancode:
    push hl
    push de

    ;ld hl,scan_codes
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
    .db 0,0,0,0,0,0,0,0,0,0,0,0,9,'²',0
    ; 10-1F : n/a n/a LSHIFT n/a n/a a & n/a n/a n/a n/a w s q z é n/a
    .db 0,0,0,0,0,'a','&',0,0,0,'w','s','q','z',130,0
    ; 20-2F : n/a c x d e ' " n/a n/a SPACE v f t r ( n/a
    .db 0,'c','x','d','e',39,34,0,0,' ','v','f','t','r','(',0
    ; 30-3F : n/a n b h g y - n/a n/a n/a , j u è _ n/a
    .db 0,'n','b','h','g','y','-',0,0,0,',','j','u',138,'_',0
    ; 40-4F : n/a ; k i o à ç n/a n/a : ! l m p ) n/a
    .db 0,59,'k','i','o',133,135,0,0,':','!','l','m','p',')',0
    ; 50-5F : n/a n/a ù n/a ^ = n/a n/a CAPS RSHIFT RETURN $ n/a * n/a n/a
    .db 0,0,151,0,'^','=',0,0,0,0,10,'$',0,'*',0,0
    ; 60-6F : n/a < n/a n/a n/a n/a BACKSPACE n/a n/a PAD_1 n/a PAD_4 PAD_7 n/a n/a n/a
    .db 0,'<',0,0,0,0,8,0,0,'1',0,'4','7',0,0,0
    ; 70-7F : PAD_0 PAD_, PAD_2 PAD_5 PAD_6 PAD_8 ESC P_VERNUM F11 PAD_+ PAD_3 PAD_- PAD_* PAD_9 ARRET_DEFIL
    .db '0',',','2','5','6','8',0,0,0,'+','3','-','*','9',0
    ; 80-83 : n/a n/a n/a F7
    .db 0,0,0,0

scan_codes_shift:
    ; 00-0F : n/a n/a n/a n/a n/a n/a n/a n/a n/a n/a n/a n/a n/a TAB n/a n/a
    .db 0,0,0,0,0,0,0,0,0,0,0,0,0,9,0,0
    ; 10-1F : n/a n/a n/a n/a n/a A 1 n/a n/a n/a n/a W S Q Z 2 n/a
    .db 0,0,0,0,0,'A','1',0,0,0,'W','S','Q','Z','2',0
    ; 20-2F : n/a C X D E 4 3 n/a n/a SPACE V F T R 5 n/a
    .db 0,'C','X','D','E','4','3',0,0,' ','V','F','T','R','5',0
    ; 30-3F : n/a N B H G Y 6 n/a n/a n/a ? J U 7 8 n/a
    .db 0,'N','B','H','G','Y','6',0,0,0,'?','J','U','7','8',0
    ; 40-4F : n/a . K I O 0 9 n/a n/a / § L M P ° n/a
    .db 0,'.','K','I','O','0','9',0,0,'/',158,'L','M','P',167,0
    ; 50-5F : n/a n/a % n/a ¨ + n/a n/a CAPS RSHIFT RETURN £ n/a µ n/a n/a
    .db 0,0,'%',0,126,'+',0,0,0,0,10,156,0,230,0,0
    ; 60-6F : n/a > n/a n/a n/a n/a BACKSPACE n/a n/a PAD_1 n/a PAD_4 PAD_7 n/a n/a n/a
    .db 0,'>',0,0,0,0,8,0,0,'1',0,'4','7',0,0,0
    ; 70-7F : PAD_0 PAD_, PAD_2 PAD_5 PAD_6 PAD_8 ESC P_VERNUM F11 PAD_+ PAD_3 PAD_- PAD_* PAD_9 ARRET_DEFIL
    .db '0',',','2','5','6','8',0,0,0,'+','3','-','*','9',0
    ; 80-83 : n/a n/a n/a F7
    .db 0,0,0,0

scan_codes_alt:
    ; 00-0F : n/a n/a n/a n/a n/a n/a n/a n/a n/a n/a n/a n/a n/a n/a n/a n/a
    .db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    ; 10-1F : n/a n/a n/a n/a n/a n/a n/a n/a n/a n/a n/a n/a n/a n/a n/a ~ n/a
    .db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,'~',0
    ; 20-2F : n/a n/a n/a n/a n/a { # n/a n/a SPACE n/a n/a n/a n/a [ n/a
    .db 0,0,0,0,0,'{','#',0,0,' ',0,0,0,0,'[',0
    ; 30-3F : n/a n/a n/a n/a n/a n/a | n/a n/a n/a n/a n/a n/a ` \ n/a
    .db 0,0,0,0,0,0,'|',0,0,0,0,0,0,'`',92,0
    ; 40-4F : n/a n/a n/a n/a n/a @ ^ n/a n/a n/a n/a n/a n/a n/a ] n/a
    .db 0,0,0,0,0,'@','^',0,0,0,0,0,0,0,']',0
    ; 50-5F : n/a n/a n/a n/a n/a } n/a n/a n/a n/a n/a n/a n/a n/a n/a n/a
    .db 0,0,0,0,0,'}',0,0,0,0,0,0,0,0,0,0
    ; 60-6F : n/a n/a n/a n/a n/a n/a n/a n/a n/a n/a n/a n/a n/a n/a n/a n/a
    .db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    ; 70-7F : n/a n/a n/a n/a n/a n/a n/a n/a n/a n/a n/a n/a n/a n/a n/a n/a
    .db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    ; 80-83 : n/a n/a n/a F7
    .db 0,0,0,0


    .org $2100

; bit 0 : shift
; bit 1 : alt
; bit 2 : caps lock
KBD_STATE_SHIFT .equ 0
KBD_STATE_ALT .equ 1
KBD_STATE_CAPS .equ 2
KBD_STATE_F0   .equ 3
KBD_STATE_E0  .equ 4

KBD_XOR_CAPS .equ 4

kbd_state: .bs 1

kbd_buffer_pos:    .bs 1
kbd_buffer: .bs 64