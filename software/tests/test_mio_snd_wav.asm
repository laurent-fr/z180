; assembler: sbasm
; command: sbasm test_mio_snd_wav.asm

    .CR z180
    .TF test_mio_snd_wav.hex,INT,16
    .LF test_mio_snd_wav.lst
    
CLOCK       .equ 8
INT_BASE    .equ $0080

    .include ../include/z180_defs.asm

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

    call _util_init_cpu

   ; ei      ; enable interrupts


main:
 
    ld hl,wav_data
    ld de,NB_SAMPLE

    ld c,5

loop:
  
    ld a,(hl)
    out0 (SND_REG),a
    inc hl

    call pause
    dec de
    ld a,d
    or e
    jp nz,loop  

end:
    jp end

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

int_noop:
    ei
    ret



    .include iambatman.asm

    .SM ram 
    .ORG $8F00

    .SM code 
    .include ../bios/bios_snd.asm
    .include ../bios/bios_util.asm
   