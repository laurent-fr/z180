; assembler: sbasm
; command: sbasm monitor.asm

    .CR z180
    .TF mz180.hex,INT,16
    .LF mz180.lst
    
CLOCK       .equ 8
INT_BASE    .equ $0080

    .include ../include/z180_defs.asm

BIOS_ADDR   .equ    $1000
BIOS_SIZE   .equ    $1000 
BASIC_ADDR  .equ    $2000
BASIC_SIZE  .equ    $2000

RAM_START   .equ    $8000

    .org $0000
    jp rom_reset        ; RESET    

    ; switch to all-RAM memory map
    .org $00EC
switch_to_ram:
    ; $0000-$EFFF = RAM ( $80000 - $8EFFF) - Common Area 0
    ; $F000-$FFFF = VDU ( $20000 - $20FFF) - Common Area 1
    ld a,$F8 ; Commona Area 1 = $F000-$FFFF - Bank Area = $8000-$EFFF
    out0 (CBAR),a
    ld a,$11 ; Common Area Base = $20000
    out0 (CBR),a
    ld a,$80 ; Bank Area Base = $80000
    out0 (BBR),a
    ld a,$F0 ; Commona Area 1 = $F000-$FFFF - Bank Area = $0000-$EFFF
    out0 (CBAR),a
   
    ; the user program starts HERE
    ; .org $0100

rom_reset:

    di ; disable interrupts

    xor a           ; a <- 0
    out0 (RCR),a    ; Refresh disable

    ; setup interupts
    im 1    ; interrupt mode 1
    xor a  ; interrupts high order byte : 00H
    ld i,a
    ld a,0b10000000 ; interrupts low order byte : 80H
    out0 (IL),a


    ; MMU    
    ld a,$88 ; Common Area 1 = Bank Area 1 =  $8000-$FFFF
    out0 (CBAR),a
 
    ; Stack pointer = $FFFF
    ld sp,$FFFF

    ; copy BIOS from EPROM TO RAM

    ; RAM START $8000 -> $8E000
    ld a,$86 
    out0 (CBR),a
    
    ld hl,BIOS_ADDR ; source pointer 
    ld de,RAM_START ; destination pointer
    ld bc,BIOS_SIZE ; size of block
copy_bios_loop:
    ldi    
    jp pe,copy_bios_loop

    ; copy BASIC from EPROM TO RAM

    ; RAM START $8000 -> $80000
    ld a,$78 
    out0 (CBR),a

    ld hl,BASIC_ADDR ; source pointer 
    ld de,RAM_START ; destination pointer
    ld bc,BASIC_SIZE ; size of block
copy_basic_loop:
    ldi    
    jp pe,copy_basic_loop

    ; boot to BASIC
    jp switch_to_ram