; VDU
; ----------------------------------------------------------------------------

VDU_RAM   .equ $F000     ; Start of video RAM address

CURSOR_SOLID .equ 1


; vdu_init
; init the vdu system
; input : none
; output : none
_vdu_init:

    ; clear screen
    call _vdu_cls

    ; set PRT0 interrupt at 1/60s
     ld a,$1A
     out0 (RLDR0H),a
     ld a,$0A
     out0 (RLDR0L),a

    ; enable PRT0 interrupt
    in0 a,(TCR) 
    or TCR_TIE0|TCR_TDE0
    out0 (TCR),a 

    ; init variables 
    xor a
    ld (vdu_cursor_status),a        ; vdu_cursor_status <- 0
    ld (vdu_term_flag),a            ; vdu_termc_flag <- 0
    ld hl,(VDU_PTR)                 ; (vdu_cursor_ptr) <- (VDU_PTR)
    ld (vdu_cursor_ptr),hl
    inc hl                          ; (vdu_cursor_save_attr) <- (VDU_ATTR+1)
    ld a,(hl)
    ld (vdu_cursor_save_attr),a
    ld a,30                         ; (vdu_cursor_blink) <- 30
    ld (vdu_cursor_blink),a

    ret

_int_vdu:
    push af
    push hl
    push de

    in0 a,(TCR)         ; clear TIFE0
    in0 a,(TMDR0L)

    ld hl,(vdu_cursor_ptr) ; compare vdu_cusror_ptr and VDU_PTR
    ld de,(VDU_PTR)
    
    sbc hl,de ; test if hl==de 
    ld a,h 
    or l 

    jr Z,_int_vdu_dec_blink_timer

    ld a,(vdu_cursor_status)  ; test if vdu_cursor_status==0
    cp 0
    jp Z,_int_vdu_update_ptr

    ld hl,(vdu_cursor_ptr)  ; delete cursor at old location
    inc hl
    ld a,(vdu_cursor_save_attr)
    ld (hl),a

    xor a                      ; reset cursor status
    ld (vdu_cursor_status),a

_int_vdu_update_ptr:
    ld hl,(VDU_PTR)
    ld (vdu_cursor_ptr),hl  ; update cursor_ptr
    jr _int_vdu_do_blink

    inc hl
    ld a,(hl)
    ld (vdu_cursor_save_attr),a

_int_vdu_dec_blink_timer:

    ld a,(vdu_cursor_blink)     ; /60 divider for cursor blink
    dec a 
    ld (vdu_cursor_blink),a
    cp 0
    jp nz,_int_vdu_exit

_int_vdu_blink:

    ld a,30                     ; set blink counter to 30 (1/2s blink speed)
    ld (vdu_cursor_blink),a

_int_vdu_do_blink:

    ld hl,(VDU_PTR) ; reverse current location colour attribute
    inc hl          ; hl <- current color attribute address
    ld a,(hl)
    rlca
    rlca
    rlca
    rlca
    ld (hl),a

    ld a,(vdu_cursor_status)     ; reverse cursor_status
    xor 1
    ld (vdu_cursor_status),a


_int_vdu_exit:

    ; TMP !
    ;ld a,(vdu_cursor_status)
    ;add '0'
    ;ld hl,VDU_RAM
    ;ld (hl),a

    ;push bc 
    ;ld a,(VDU_X)
    ;call _util_byte_to_ascii_hex
    ;ld hl,VDU_RAM+10
    ;ld a,b
    ;ld (hl),a
    ;inc hl 
    ;inc hl 
    ;ld a,c 
    ;ld (hl),a

    ;ld a,(VDU_Y)
    ;call _util_byte_to_ascii_hex
    ;ld hl,VDU_RAM+16
    ;ld a,b
    ;ld (hl),a
    ;inc hl 
    ;inc hl 
    ;ld a,c 
    ;ld (hl),a

    ;ld a,(VDU_PTR+1)
    ;call _util_byte_to_ascii_hex
    ;ld hl,VDU_RAM+22
    ;ld a,b
    ;ld (hl),a
    ;inc hl 
    ;inc hl 
    ;ld a,c 
    ;ld (hl),a

    ;ld a,(VDU_PTR)
    ;call _util_byte_to_ascii_hex
    ;ld hl,VDU_RAM+26
    ;ld a,b
    ;ld (hl),a
    ;inc hl 
    ;inc hl 
    ;ld a,c 
    ;ld (hl),a

    ;ld a,(vdu_cursor_ptr+1)
    ;call _util_byte_to_ascii_hex
    ;ld hl,VDU_RAM+32
    ;ld a,b
    ;ld (hl),a
    ;inc hl 
    ;inc hl 
    ;ld a,c 
    ;ld (hl),a

    ;ld a,(vdu_cursor_ptr)
    ;call _util_byte_to_ascii_hex
    ;ld hl,VDU_RAM+36
    ;ld a,b
    ;ld (hl),a
    ;inc hl 
    ;inc hl 
    ;ld a,c 
    ;ld (hl),a
    ;pop bc

    pop de
    pop hl
    pop af
    ei
    ret

; vdu_set_attr
; set the color attribute
; input : a = color attribute
; output : none
_vdu_set_attr:
    ld (VDU_ATTR),a
    ret

; vdu_cls
; clear screen using VDU_ATTR color
; input : none
; output : none 
_vdu_cls:
    push de
    push hl
    push af 

    ld de,2000     ; number of chars
    ld hl,VDU_RAM    ; pointer to srart of ram
    ld a,(VDU_ATTR)  ; get color attribute   
    ld c,a
    
_vdu_cls_loop:
    ld (hl),$20     ; write space char.
    inc hl
    ld (hl),c       ; set color attribute
    inc hl
    dec de          ; update chars counter  
    ld a,d         ; check if zero 
    or e
    jp nz,_vdu_cls_loop  

    xor a          ; home cursor   
    ld (VDU_X),a    ; X=0
    ld (VDU_Y),a    ; Y=0
    ld de,VDU_RAM   ; PTR = start of video RAM
    ld (VDU_PTR),de

    pop af 
    pop hl 
    pop de

    ret 

; vdu_scroll
; scroll all the screen UP one line
; input : none
; output : none
_vdu_scroll_up:
    push af
    push hl
    push de
    push bc 

    ld hl,VDU_RAM+160 ; source pointer = start of 2nd line
    ld de,VDU_RAM ; destination pointer = start of 1st line
    ld bc,4000-160 ; all screen minus one line to move
_vdu_scroll_loop:
    ldi     ; scroll the screen
    jp pe,_vdu_scroll_loop
            ; here -> (de) points to the start of 25th line
    ld b,80   ; 80 chars to fill on last line
    ld a,(VDU_ATTR) ; get current color attribute
    ld c,a
_vdu_scroll_loop_line25:
    ld a,' '
    ld (de),a ; put a space character
    inc de
    ld a,c
    ld (de),a ; ser the color attribute
    inc de
    djnz _vdu_scroll_loop_line25
    
    pop bc
    pop de 
    pop hl
    pop af
    ret

; vdu_putc_term
; put a char on the screen, at current location, with current attribute, interpreting special codes :
;   VT-52 Terminal ( see http://toshyp.atari.org/en/VT_52_terminal.html )
;   * NUL - Null - 0x00
;   ~ BEL - Bell - 0x07
;   ~ BS - Backspace - 0x08
;   HT - Tabulator - 0x09
;   FF - Form feed - 0x0c
;   * CR - Carriage return - 0x0d
;   * LF - Line feed - 0x0a
;   ESC A - Cursor up - 0x1b , A
;   ESC B - Cursor down - 0x1b , B
;   ESC C - Cursor right - 0x1b , C
;   ESC D - Cursor left - 0x1b , D
;   ~ ESC E - Clear Screen - 0x1b , E
;   ESC H - Cursor home - 0x1b , H
;   ESC I - Cursor up and insert - 0x1b , I
;   ESC J - Clear to end of scren - 0x1b , J
;   ESC K - Clear to end of line - 0x1b , K
;   ESC L - Insert line - 0x1b , L
;   ESC M - Delete line - 0x1b , M
;   ESC Y - Set cursor position - 0x1b , Y , ' '+x , ' '+y
;   * ESC b - Set text color - 0x1b , b , color
;   ~ ESC c - Set Background color - 0x1b , c , color
;   ESC e - Show cursor
;   ESC f - Hide cursor
; input : a = char to print
; output : none

_vdu_putc_term:

    ;call _asci1_putc

    ; TMP
    ;push af 
    ;push bc 
    ;push hl 
    ;call _util_byte_to_ascii_hex
    ;ld hl,VDU_RAM+42
    ;ld a,b
    ;ld (hl),a
    ;inc hl 
    ;inc hl 
    ;ld a,c 
    ;ld (hl),a
    ;pop hl 
    ;pop bc 
    ;pop af 

    ; check if a flag is set in vdu_term_flag
    push hl                     ; <---- must be POPed in subprogram
    ld hl,vdu_term_flag

    bit VDU_TERM_ESC,(hl)       ; check if previous char was ESC
    jr NZ,_vdu_do_ESC2
    bit VDU_TERM_FCOL,(hl)      ; check if previous chars were ESC+'b'
    jp NZ,_vdu_do_set_fcol2
    bit VDU_TERM_BCOL,(hl)      ; check if previous chars were ESC+'c'
    jp NZ,_vdu_do_set_bcol2

    pop hl                      ; pop HL if no flag matched

    ; non printable chars
    cp $00 ; NUL
    ret Z
    cp $07 ; BEL
    jr Z,_vdu_do_bell
    cp  $08 ; BS
    jr Z,_vdu_do_BS
    cp $0A ; LF
    jr Z,_vdu_do_LF
    cp $0C ; CS
    jp Z,_vdu_cls
    cp $0D ; CR 
    jr Z,_vdu_do_CR
    cp $1B ; ESC
    jr Z,_vdu_do_ESC

    ; printable char
    call _vdu_putc
    ret

_vdu_do_bell:
    call _snd_beep
    ret

_vdu_do_BS:
    push af
    push hl

    ld a,(VDU_X)                ; go left if X>0
    cp 0
    jp z,_vdu_do_BS_exit
  
    ld hl,VDU_RAM+70
    ld (hl),'B'

    dec a
    ld (VDU_X),a
    ld hl,(VDU_PTR)
    dec hl
    dec hl
    ld (VDU_PTR),hl

_vdu_do_BS_exit:
    pop hl
    pop af
    ret


_vdu_do_CR:
    push af
    xor a
    ld (VDU_X),a
    call _vdu_xy_to_ptr
    pop af
    ret


_vdu_do_LF:
    push af
    ld a,(VDU_Y)
    inc a 
    ld (VDU_Y),a
    cp 25
    jp nz,_vdu_do_LF_set_ptr
    call _vdu_scroll_up
    ld a,24
    ld (VDU_Y),a
_vdu_do_LF_set_ptr:
    call _vdu_xy_to_ptr
    pop af
    ret


; ESC key
; set VDU_TERM_ESC flag
_vdu_do_ESC:
    push hl 
    ld hl,vdu_term_flag
    set VDU_TERM_ESC,(hl)
    pop hl 
    ret 

; ESC key 2
; input : a <- char after ESC
_vdu_do_ESC2:
                 ; reset ESC flag
    ld hl,vdu_term_flag
    res VDU_TERM_ESC,(hl)
    pop hl                  ; "push hl" was in _vdu_putc_term

    cp 'b'  
    jr Z,_vdu_do_set_fcol
    cp 'c'
    jr Z,_vdu_do_set_bcol
    ; cp 'e'
    ; cp 'f'
    ; cp 'A'
    ; cp 'B'
    ; cp 'C'
    ; cp 'D'
    cp 'E'
    jp Z,_vdu_cls
    ; cp 'H'
    ; cp 'I'
    ; cp 'J'
    ; cp 'K'
    ; cp 'L'
    ; cp 'M'
    ; cp 'Y'

    ret

; ESC + "b"
; set VDU_TERM_FCOL flag 
_vdu_do_set_fcol:
    push hl
    ld hl,vdu_term_flag
    set VDU_TERM_FCOL,(hl)
    pop hl
    ret

; ESC + "b" + color
; reset VDU_TERM_FCOL flag and update foreground color in VDU_ATTR 
; input : a : foreground color code (0-15)
_vdu_do_set_fcol2:
    push af 
    push bc 
                ; reset FCOL flag
    ld hl,vdu_term_flag
    res VDU_TERM_FCOL,(hl)
 
    and $0F
    ld b,a 

    ld a,(VDU_ATTR)
    and $F0
    or b 
    ld (VDU_ATTR),a 

    pop bc 
    pop af 

    pop hl ; "push hl" was in _vdu_putc_term
    ret

; ESC + "c"
; set VDU_TERM_BCOL flag 
_vdu_do_set_bcol:
    push hl
    ld hl,vdu_term_flag
    set VDU_TERM_BCOL,(hl)
    pop hl
    ret

; ESC + "c" + color
; reset VDU_TERM_FCOL flag and update background color in VDU_ATTR 
; input : a : background color code (0-15)
_vdu_do_set_bcol2:
    push af 
    push bc 
                ; reset FCOL flag
    ld hl,vdu_term_flag
    res VDU_TERM_BCOL,(hl)
 
    rla
    rla
    rla
    rla
    and $F0
    ld b,a 

    ld a,(VDU_ATTR)
    and $0F
    or b 
    ld (VDU_ATTR),a 

    pop bc 
    pop af 

    pop hl ; "push hl" was in _vdu_putc_term
    ret


; vdu_putc
; put a char on the screen, at current location, with current attribute
; input : a = char to display
; output : none
_vdu_putc:
    push af
    push de

    ld de,(VDU_PTR)
    ld (de),a           ; put char in a to current video memory location
    inc de              ; go to attribute
    ld a,(VDU_ATTR)     ; fetch attribute from VDU_ATTR
    ld (de),a           ; write attribute to video memory
    inc de              ; go to next char
    ld (VDU_PTR),de     ; save VDU_PTR
    ld a,(VDU_X)        ; get X position
    inc a               ; increment
    ld (VDU_X),a
    cp 80              ; next line ?
    jr nz,_vdu_putc_exit
    call _vdu_next_line

_vdu_putc_exit:

    pop de
    pop af
    ret

; vdu_next_line
; set cursor at the beginning of next line. Verticall scroll of the screen if we are at 25th line.
; input: none
; output: none 
_vdu_next_line:
    push af
    push de

    xor a              ; reset X
    ld (VDU_X),a
    ld a,(VDU_Y)        ; increment Y
    inc a
    ld (VDU_Y),a
    cp 25               ; bottom of the screen ?
    jr nz,_vdu_next_line_exit
    call _vdu_scroll_up
    ld a,24             ; set Y to 24
    ld (VDU_Y),a
    
    ld de,VDU_RAM+3840   ; set de to start of 24th line
    ld (VDU_PTR),de

_vdu_next_line_exit:
    pop de
    pop af
    ret

; vdu_puts
; display a text on the screen, at current location, with current color attrributes.
; input : hl = pointer to a null terminated string
; output : none
_vdu_puts:
    push af
    push hl

_vdu_puts_loop:
    ld a,(hl)   ; load char fromm string
    or 0
    jr z,_vdu_puts_exit  ; exit if =0
    call _vdu_putc
    inc hl  ; next character
    jr _vdu_puts_loop

_vdu_puts_exit:
    pop hl
    pop af
    ret

; vdu_locate
; set cursor position
; input : b=X (0-79), c=Y (0-24)
; output : none
_vdu_locate:
    push af 
    ld a,b 
    ld (VDU_X),a
    ld a,c  
    ld (VDU_Y),a
    call _vdu_xy_to_ptr
    pop af
    ret 

_vdu_xy_to_ptr

    push af 
    push hl 
    push de 

    ld hl,vdu_line_ptr ; hl = pointer to array of start of line addresses
    ld d,0  ; de = Y*2
    ld a,(VDU_Y)
    add a,a
    ld e,a
    add hl,de ; hl = pointer to start of line
    
    ld e,(hl)  ; de = (hl) = start of line address
    inc hl
    ld d,(hl)

     ld h,0 ; hl=X*2
     ld a,(VDU_X) 
     add a,a
     ld l,a
    add hl,de ; hl = start of line address + X*2 

    
    ld (VDU_PTR),hl ; save PTR

    pop de
    pop hl
    pop af
    ret

; VDU DATA
vdu_line_ptr    .dw     $F000,$F0A0,$F140,$F1E0,$F280,$F320,$F3C0,$F460,$F500,$F5A0,$F640,$F6E0
                .dw     $F780,$F820,$F8C0,$F960,$FA00,$FAA0,$FB40,$FBE0,$FC80,$FD20,$FDC0,$FE60,$FF00


; RAM

    .SM ram 

VDU_ATTR            .bs 1   ; Color Attribute
VDU_X               .bs 1   ; Current X position
VDU_Y               .bs 1   ; Current Y position
VDU_PTR             .bs 2     ; Current position in video RAM, should always be equal to
                        ; VDU_RAM + X*2 + Y*160
vdu_cursor_ptr          .bs 2
vdu_cursor_blink      .bs 1
vdu_cursor_status     .bs 1
vdu_cursor_save_attr    .bs 1

VDU_TERM_ESC        .equ 1
VDU_TERM_FCOL       .equ 2
VDU_TERM_BCOL       .equ 3
VDU_TERM_SETX       .equ 4
VDU_TERM_SETY       .equ 5
VDU_TERM_CURSOR     .equ 6

vdu_term_flag   .bs 1

    .SM code