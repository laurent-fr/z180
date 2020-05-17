; CF
; ----------------------------------------------------------------------------

CF_BASE .EQU $88

CF_DATA_REG	        .EQU	CF_BASE+0	; Data Register
CF_ERROR_REG	    .EQU	CF_BASE+1	; Error Register (Read)
CF_FEATURE_REG      .EQU    CF_BASE+1   ; Feature Register (Write)
CF_SECTOR_COUNT_REG .EQU    CF_BASE+2   ; Sector count register
CF_SECTOR_NUM_REG   .EQU    CF_BASE+3   ; Sector number
CF_LBA_B0           .EQU    CF_BASE+3   ; LBA byte 0 LSB (bits 07..00)
CF_CYL_LOW_REG      .EQU    CF_BASE+4   ; Cylinder low register
CF_LBA_B1           .EQU    CF_BASE+4   ; LBA byte 1 (bits 15..08)
CF_CYL_HIGH_REG     .EQU    CF_BASE+5   ; Cylinder high register
CF_LBA_B2           .EQU    CF_BASE+5   ; LBA byte 3 (bits 23..16)
CF_DRIVE_HEAD_REG   .EQU    CF_BASE+6   ; Drive head register
CF_LBA_B3           .EQU    CF_BASE+6   ; LBA byte 4 MSB (bits 27..24)
CF_STATUS_REG       .EQU    CF_BASE+7   ; Status register (read)
CF_COMMAND_REG      .EQU    CF_BASE+7   ; Command Reg (write)


CF_CMD_RESET        .EQU    $04
CF_CMD_READ_SECTOR  .EQU    $20
CF_CMD_WRITE_SECTOR .EQU    $30
CF_CMD_SET_FEATURE  .EQU    $EF

CF_FEATURE_8BIT     .EQU    $01
CF_FEATURE_NOCACHE  .EQU    $82

_cf_init:
    push af

    ; reset command
    ld      a,CF_CMD_RESET
    out0    (CF_COMMAND_REG),a

    ; set lba mode 
    call    _cf_wait
    ld      a,%11100000 ; bit 7=1 , bit 6= set LBA mode, bit 5=1
    out0    (CF_LBA_B3),a 

    ; set 8 bits mode
    call    _cf_wait	
	ld      a,CF_FEATURE_8BIT
	out0    (CF_FEATURE_REG),a
	ld      a,CF_CMD_SET_FEATURE
	out0	(CF_COMMAND_REG),a

    ; no write cache
    call    _cf_wait
	ld      a,CF_FEATURE_NOCACHE
	out0	(CF_FEATURE_REG),a
	ld      a,CF_CMD_SET_FEATURE
	out0	(CF_COMMAND_REG),a

    pop af
    ret

; read 512 bits into (ix)
; input : (ix) destination address
; output : (ix) points to the next 512 bytes
_cf_read_sector:
    push af
    push bc 

    call _cf_wait

    ld      a,CF_CMD_READ_SECTOR
	out0 	(CF_COMMAND_REG),a

	call _cf_wait

    ld  bc,512
_cf_read_sector_loop:
    in0 	a,(CF_DATA_REG)
    ld      (ix),a
    inc     ix
    dec bc         
    ld a,b 
    or c
    jp nz,_cf_read_sector_loop 

    pop bc 
    pop af 
    ret

; write 512 bits at (ix)
; input : (ix) source address
; output : (ix) points to the next 512 bytes
_cf_write_sector:
    push af
    push bc 

    call _cf_wait

    ld      a,CF_CMD_WRITE_SECTOR
	out0 	(CF_COMMAND_REG),a

	call _cf_wait

    ld  bc,512
_cf_write_sector_loop:
    ld      a,(ix)
    out0 	(CF_DATA_REG),a
    inc     ix
    dec bc         
    ld a,b 
    or c
    jp nz,_cf_write_sector_loop 

    pop bc 
    pop af 
    ret

_cf_wait:
		push af 
_cf_wait_loop:
		in0 	a,(CF_STATUS_REG)
		and     $80
		cp 	    $80
		jr      z,_cf_wait_loop

		pop     af
		ret

; input : (hl) address of LBA_B0
_cf_load_lba:
    push af 
    push hl

    ; set LBA address
    ld a,(hl)
    out0 (CF_LBA_B0),a 
    inc hl 
    ld a,(hl)
    out0 (CF_LBA_B1),a 
    inc hl 
    ld a,(hl)
    out0 (CF_LBA_B2),a 
    inc hl 
    ld a,(hl)
    or %11100000    ; bit 7=1 , bit 6= set LBA mode, bit 5=1 
    out0 (CF_LBA_B3),a 

    ; read 1 sector
    ld a,1
	out0 (CF_SECTOR_COUNT_REG),a

    pop hl 
    pop af 
    ret


    .SM ram 

cf_lba .dw 4

    .SM code