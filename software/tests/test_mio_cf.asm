; assembler: sbasm
; command: sbasm test_mio_cf.asm

    .CR z180
    .TF test_mio_cf.hex,INT,16
    .LF test_mio_cf.lst

CLOCK       .equ    8
INT_BASE    .equ    $0080 

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
    ; $8000-$EFFF = RAM ( $80000 - $8EFFF ) - Bank Area
    ; $0000-$7FFF = ROM ( $00000 - $01FFF ) - Common Area 0
    
    ld a,$F2 ; Common Area 1 = $F000-$FFFF, Bank Area 1 =  $2000-$EFFF
    out0 (CBAR),a
    ld a,$11 ; Common Area Base = $20000
    out0 (CBR),a
    ld a,$7E ; Bank Area Base = $80000 
    out0 (BBR),a


    ld sp,$20FF ; Stack pointer = $20FF

    call _util_init_cpu

    call _asci1_init

    ;ei      ; enable interrupts


main:

    ld hl,str_welcome
    call _asci1_puts

;test:
;    in0 a,($88+7)
;    call _util_byte_to_ascii_hex
;    ld a,b 
;    call _asci1_putc
;    ld a,c 
;    call _asci1_putc 

;    out0 ($88),a
;    jp test

    

    call _cf_init  

    call test_data_sector

    ld hl,lba_addr
    call _cf_load_lba 
    ld ix,sector
    call _cf_write_sector

    call zero_sector

    ld hl,lba_addr
    call _cf_load_lba 
    ld ix,sector
    call _cf_read_sector

    ld hl,sector

    ld de,512
display_sector_loop:
    ld a,(hl)
    inc hl
    call _util_byte_to_ascii_hex
    ld a,b 
    call _asci1_putc
    ld a,c 
    call _asci1_putc 
    dec de 

    ld a,d 
    or e
    jr nz,display_sector_loop

loop:
    jr loop

int_noop:
    ei
    ret

zero_sector:
    ld hl,sector 
    ld de,512
zero_sector_loop:
    xor a
    inc hl 
    ld (hl),a 
    dec de 
    ld a,d 
    or e 
    jr nz,zero_sector_loop
    ret

test_data_sector:
    ld hl,sector 
    ld de,512
test_data_sector_loop:
    ld a,e
    inc hl 
    ld (hl),a 
    dec de 
    ld a,d 
    or e 
    jr nz,test_data_sector_loop
    ret


lba_addr    .db 0,0,0,0

str_welcome:    .db $1B,"[2J",$1B,"[H","Test Compact-Flash",13,10,13,10,0

    .SM ram 
    .ORG $8F00

    .SM code 
    .include ../bios/bios_asci.asm
    .include ../bios/bios_cf.asm
    .include ../bios/bios_util.asm

    .org $8100

sector  .bs 512