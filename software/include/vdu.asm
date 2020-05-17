; VDU library

; CONSTANTS 
VDU_RAM  .equ $F000     ; Start of video RAM address

VDU_ATTR .equ $FFF0     ; Color Attribute
VDU_X    .equ $FFF1     ; Current X position
VDU_Y    .equ $FFF2     ; Current Y position
VDU_PTR  .equ $FFF4     ; Current position in video RAM, should always be equal to
                        ; VDU_RAM + X*2 + Y*160

; DATA
vdu_line_ptr    .dw     $F000,$F0A0,$F140,$F1E0,$F280,$F320,$F3C0,$F460,$F500,$F5A0,$F640,$F6E0
                .dw     $F780,$F820,$F8C0,$F960,$FA00,$FAA0,$FB40,$FBE0,$FC80,$FD20,$FDC0,$FE60,$FF00

; vdu_init
; init the vdu system
vdu_init:
    call vdu_cls
    ret

; vdu_cls
; clear screen using VDU_ATTR color
; input : none
; output : none 
vdu_cls:
    push de
    push hl
    push af 

    ld de,2000     ; number of chars
    ld hl,VDU_RAM    ; pointer to srart of ram
    ld a,(VDU_ATTR)  ; get color attribute   
    ld c,a

vdu_cls_loop:
    ld (hl),$20     ; write space char.
    inc hl
    ld (hl),c       ; set color attribute
    inc hl
    dec de          ; update chars counter  
    ld a,d         ; check if zero 
    or e
    jp nz,vdu_cls_loop  

    ld a,0          ; home cursor   
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
vdu_scroll:
    push af
    push hl
    push de
    push bc 

    ld hl,VDU_RAM+160 ; source pointer = start of 2nd line
    ld de,VDU_RAM ; destination pointer = start of 1st line
    ld bc,4000-160 ; all screen minus one line to move
vdu_scroll_loop:
    ldi     ; scroll the screen
    jp pe,vdu_scroll_loop
            ; here -> (de) points to the start of 25th line
    ld b,80   ; 80 chats to fill on last line
    ld a,(VDU_ATTR) ; get current color attribute
    ld c,a
vdu_scroll_loop_line25:
    ld a,' '
    ld (de),a ; put a space character
    inc de
    ld a,c
    ld (de),a ; ser the color attribute
    inc de
    djnz vdu_scroll_loop_line25
    
    pop bc
    pop de 
    pop hl
    pop af
    ret

; vdu_putc_term
; put a char on the screen, at current location, with current attribute, interpreting special codes :
;   VT-52 Terminal ( see http://toshyp.atari.org/en/VT_52_terminal.html )
;   BS - Backspace - 0x08
;   BEL - Bell - 0x07
;   ESC J - Clear to end of scren - 0x1b , J
;   ESC K - Clear to end of line - 0x1b , K
;   ESC E - Clear Screen - 0x1b , E
;   ESC l - Clear line - 0x1b , l
;   ESC o - Clear to start of line - 0x1b , o
;   ESC d - Clear to start of screen - 0x1b , d
;   ESC B - Cursor down - 0x1b , B
;   ESC H - Cursor home - 0x1b , H
;   ESC D - Cursor left - 0x1b , D
;   ESC C - Cursor right - 0x1b , C
;   ESC A - Cursor up - 0x1b , A
;   ESC M - Delete line - 0x1b , M
;   ESC Y - Set cursor position - 0x1b , Y , ' '+x , ' '+y
;   ESC b - Set text color - 0x1b , b , color
;   ESC L - Insert line - 0x1b , L
;   LF - Line feed - 0x0a
;   ESC k - Restore cursor position - 0x1b , k
;   ESC c - Set Background color - 0x1b , c , color
;   CR - Carriage return - 0x0d
;   ESC q - Normal video - 0x1b , q
;   ESC p - Reverse video - 0x1b , p
;   ESC j - Save cursor position - 0x1b , j
;   ESC I - Cursor up and insert - 0x1b , I
;   FF - Form feed - 0x0c
;   HT - Tabulator - 0x09
;   ESC w - Wrap off - 0x1b , w
;   ESC v - Wrap on - 0x1b , v
;   ESC e - Show cursor
;   ESC f - Hide cursor
;   blink on
;   blink off
; input : a = char to print
; output : none

vdu_putc_term:
    push bc
    push de
    ld de,(VDU_PTR)
    cp 13   
    jr nz,vdu_putc_term_print
    call vdu_next_line
    jr vdu_putc_term_exit

vdu_putc_term_print:
    call vdu_putc

vdu_putc_term_exit:
    ld (VDU_PTR),de
    pop de
    pop bc
    ret

; vdu_putc
; put a char on the screen, at current location, with current attribute
; input : a = char to display
; output : none
vdu_putc:
    push af
    ld (de),a           ; put char in a to current video memory location
    inc de              ; go to attribute
    ld a,(VDU_ATTR)     ; fetch attribute from VDU_ATTR
    ld (de),a           ; write attribute to video memory
    inc de              ; go to next char
    ld a,(VDU_X)        ; get X position
    inc a               ; increment
    ld (VDU_X),a
    cp 80              ; next line ?
    jr nz,vdu_putc_exit
    call vdu_next_line

vdu_putc_exit:
    pop af
    ret

; vdu_next_line
; set cursor at the beginning of next line. Verticall scroll of the screen if we are at 25th line.
; input: none
; output: none 
vdu_next_line:
    ld a,0              ; reset X
    ld (VDU_X),a
    ld a,(VDU_Y)        ; increment Y
    inc a
    ld (VDU_Y),a
    cp 25               ; bottom of the screen ?
    jr nz,vdu_next_line_exit
    call vdu_scroll
    ld a,24             ; set Y to 24
    ld (VDU_Y),a
    
    ld de,VDU_RAM+3840   ; set de to start of 24th line
vdu_next_line_exit:
    ret

; vdu_puts
; display a text on the screen, at current location, with current color attrributes.
; input : hl = pointer to a null terminated string
; output : none
vdu_puts:
    push af
    push hl

vdu_puts_loop:
    ld a,(hl)   ; load char fromm string
    or 0
    jr z,vdu_puts_exit  ; exit if =0
    call vdu_putc
    inc hl  ; next character
    jr vdu_puts_loop

vdu_puts_exit:
    pop hl
    pop af
    ret

; vdu_locate
; set cursor position
; input : b=X (0-79), c=Y (0-24)
; output : none
vdu_locate:
    push af 
    push hl
    push de 

    ld hl,vdu_line_ptr ; hl = pointer to array of start of line addresses
    ld d,0  ; de = Y*2
    ld a,c
    add a,a
    ld e,a
    add hl,de ; hl = pointer to start of line
    
    ld d,(hl)  ; de = (hl) = start of line address
    inc hl
    ld e,(hl)

    ld h,0 ; hl=X*2
    ld a,b  
    add a,a
    ld l,a
    add hl,de ; hl = start of line address + X*2 

    ld (VDU_PTR),hl ; save PTR, X and Y 
    ld (VDU_X),b 
    ld (VDU_Y),c 

    pop de
    pop hl
    pop af
    ret
