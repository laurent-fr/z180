; BASIC boot

    .CR z180
    .TF basic_boot.hex,INT,24
    .LF basic_boot.lst

    .include ../../include/z180_defs.asm

; bios entries
asci1_putc  .equ $E01F
asci1_getc  .equ $E019
asci1_rx_empty .equ $E01C
int_noop .equ $E000
int_asci0 .equ $E004
int_asci1 .equ $E016
asci0_init .equ $E001
asci1_init .equ $E013
vdu_init .equ $E025
int_vdu .equ $E028
vdu_set_attr .equ $E02B
vdu_cls .equ $E02E
vdu_putc_term .equ $E034
kbd_init .equ $E040 
int_kbd .equ $E043 
kbd_is_empty .equ $E046 
kbd_get_key .equ $E049

    .org $0000
    jp  mreset

rst08:
    .org $0008
    ;jp asci1_putc
    jp vdu_putc_term

rst10:
    .org $0010
    jp asci1_getc
    ;jp kbd_get_key

rst18:
    .org $0018
    jp asci1_rx_empty
    ;jp kbd_is_empty
    
    .org $0038
    jp int_noop    ; INT0

    .org $0066
    jp int_noop    ; NMI

; interrupt vector table
    .org $0080
    .dw int_kbd    ; INT1
    .dw int_noop    ; INT2
    .dw int_vdu    ; PRT0
    .dw int_noop    ; PRT1
    .dw int_noop    ; DMA0
    .dw int_noop    ; DMA1
    .dw int_noop    ; CSIO
    .dw int_asci0   ; ASCI0
    .dw int_asci1    ; ASCI1

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

    ; Temporary stack pointer = $DFFF
    ld sp,$DFFF

    call asci0_init
    call asci1_init

    ld a,$4B
    call vdu_set_attr
    call vdu_init

    call kbd_init

    ; setup interupts
    im 1    ; interrupt mode 1
    ld a,0  ; interrupts high order byte : 00H
    ld i,a
    ld a,0b10000000 ; interrupts low order byte : 80H
    out0 (IL),a

    ei      ; enable interrupts

    jp COLD

    .include basic.asm