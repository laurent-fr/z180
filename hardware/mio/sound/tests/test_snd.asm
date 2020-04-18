; assembler: sbasm
; command: sbasm monitor.asm

    .CR z180
    .TF test_snd.hex,INT,16
    .LF test_snd.lst
    
    .include z180_defs.asm

    .org $0000
    jp mreset        ; RESET


    .org $0038
    jp int_noop    ; INT0

    .org $0066
    jp int_noop    ; NMI

; interrupt vector table
    .org $0080
    .dw int_noop    ; INT1
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
    ; ld a,CMR_X2
    ; out0 (CMR),a

    ; CCR_CD : phi = XTAL/1 => phi 16Mhz ---> 32Mhz !!!
    ; ld a,CCR_CD
    ; out0 (CCR),a

    ld  a,0
    out0 (RCR),a    ; Refresh disable

    ; MMU    
    ; $F000-$FFFF = VDU ( $20000 - $20FFF ) - Common Area 1
    ; $2000-$EFFF = RAM ( $80000 - $8EFFF ) - Bank Area
    ; $0000-$1FFF = ROM ( $00000 - $01FFF ) - Common Area 0
    
    ld a,$FE ; Common Area 1 = $F000-$FFFF, Bank Area 1 =  $2000-$EFFF
    out0 (CBAR),a
    ld a,$11 ; Common Area Base = $20000
    out0 (CBR),a
    ld a,$7E ; Bank Area Base = $80000 
    out0 (BBR),a

    ; Stack pointer = $10FF
    ld sp,$E0FF

    ;call asci0_init
    call asci1_init

    ; setup interupts
    im 1    ; interrupt mode 1
    ld a,0  ; interrupts high order byte : 00H
    ld i,a
    ld a,0b10000000 ; interrupts low order byte : 80H
    out0 (IL),a

   ; ei      ; enable interrupts


KBD_DATA    .equ $80
KBD_STATUS  .equ $81
SND_L       .equ $82
SND_H       .equ $83
PRT         .equ $84
CF          .equ $88
RTC         .equ $90

main:
 
   ; ld hl,str_welcome
   ; call asci1_puts
    
    ;ld a,$80
   ; out0 (SND_L),a
    ;out0 (SND_H),a

    ld hl,wav_data
    ld de,NB_SAMPLE

    ld c,5

loop:
   ; ld a,$f0
   ; out0 (SND_L),a
   ; call pause  
   ; ld a,0
   ;   out0 (SND_L),a
   ; call pause
   ; inc c
   ; jp loop


   ; inc a
   ; out0 (SND_L),a
   ; nop
   ; nop
   ; call pause2
   ; jp loop

  ;  out0 (SND_L),a
   ; call pause
    ;inc a
    ;jp loop 
   

    ld a,(hl)
    ;ld a,e
    out0 (SND_L),a
    inc hl

    call pause
    dec de
    ld a,d
    or e
    jp nz,loop  

end:
    jp end

pause2:
    push af
    ld d,$ff
    ld e,$ff
pause2_loop:
    nop
    nop
    nop
    nop
   dec de
    ld a,d
    or e
    jp nz,pause2_loop
    pop af
    ret    

pause:
    push bc
    ld b,c

pause_loop:    
    nop
    nop
    nop
    nop
    nop

    nop
    nop
    nop
    nop
    djnz pause_loop
    pop bc
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




int_noop:
    reti


str_welcome:    .db $1B,"[2J",$1B,"[H","Test Kbd",13,10,13,10,0
;str_prompt:     .db "? ",0
;str_error:       .db 13,10,"Err.",13,10,0

    .include batman.asm

    .org $E100

RX_BUFFER_SIZE: .equ 127

rx0_buffer:     .bs RX_BUFFER_SIZE+1
rx0_buffer_ptr: .bs 2
rx0_buffer_cpt: .bs 2
rx1_buffer:     .bs RX_BUFFER_SIZE+1
rx1_buffer_ptr: .bs 2
rx1_buffer_cpt: .bs 2

    