


; bios entry point
; input : c = BIOS call
bios_enter:
    push af 
    push de
    push hl

    ld de,bios_table
    ld h,0
    ld l,c
    add hl,hl 
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    jp (hl)


bios_exit:

    ret

; bios table 
bios_table:
    .dw vdu_set_cursor_shape
    .dw vdu_set_cursor_pos


; VDU
; ----------------------------------------------------------------------------

VDU_RAM     .equ $F000


    .db vdu_cursor_x
    .db vdu_cursor_y
    .db vdu_cursor_shape
    .db vdu_atribute 
    .db vdu_frame_counter




; VDU interruption routine
;


; Set Cursor Shape
; input:
;   a = a7..a0
;      a0: 1 = cursor visible, 0 = cursor invisible
;      a1: 1 = cursor blinking, 0 = cursor not blinking
vdu_set_cursor_shape:

    ret

; Set Cursor Position
; input:
;   h = X position 0..79
;   l = Y position 0..24
vdu_set_cursor_pos:
    ld (vdu_cursor_x),hl

    ret

; Get Cursor Position
; output:
;   h = X position 0..79
;   l = Y position 0..24
vdu_set_cursor_shape:
    ld hl,(vdu_curosr_x)

    ret 

; Set current Attribute
; input:
;   a = Attribute
vdu_set_attribute:
    ld (vdu_atribute),a

    ret

; Get current Attribute
; output:
;   a = Attribute
vdu_get_attribute:
    ld a,(vdu_attribute)

    ret

; Clear Screen
vdu_clear_screen:

    ld de,1000     ; number of chars
    ld hl,VDU_RAM    ; pointer to srart of ram
    ld c,(vdu_attribute)  ; get color attribute   
vdu_clear_screen_loop:
    ld (hl),$20     ; space char.
    inc hl
    ld (hl),c       ; set color attribute
    inc hl
    dec de          ; update chars counter  
    ld a,de         ; check if zero 
    or e
    jp nz,vdu_clear_screen_loop  
    ld a,0          ; home cursor   
    ld (vdu_cursor_x),a
    ld (vdu_cursor_y),a

    ret

; Scroll Up
vdu_scroll_up:

    ret

; Scroll Down
vdu_scroll_down:

    ret

; Read Character and attribute at Cursor
; output:
;   h = character
;   l = attribute
vdu_read_char_attr:

    ret

; Write Character and attribute at Cursor
; input:
;   h = character
;   l = attribute
vdu_write_char_attr:

    ret

; Write Character at Cursor
; input:
;   a = character 
vdu_write_char:

    ret

; Write Character in TTY Mode
; input:
;   a = character 
vdu_write_char_tty:

    ret

; Write String
;   hl = pointer to null-terminated string
vdu_write_string:

    ret

; Serial Port initialization
; Transmit Character
; Receive Character
; Status

; Read Character
; Read Input Status 

; Print Character to Printer
; Initialize Printer 
; Check Printer Status 

; Read RTC Time
; Set RTC Time 
; Read RTC Date
; Set RTC Date