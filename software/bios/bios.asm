; BIOS

    .CR z180
    .TF bios.hex,INT,24
    .LF bios.lst

    .include ../../include/z180_defs.asm



    .org $E000

    ; SYSTEM
.int_noop:      ret

    ; ASCI
.asci0_init:        jp _asci0_init
.int_asci0:         jp _int_asci0

.asci0_getc:        jp _asci0_getc
.asci0_rx_empty:    jp _asci0_rx_empty
.asci0_putc:        jp _asci0_putc
.asci0_puts:        jp _asci0_puts

.asci1_init:        jp _asci1_init
.int_asci1:         jp _int_asci1

.asci1_getc:        jp _asci1_getc
.asci1_rx_empty:    jp _asci1_rx_empty
.asci1_putc:        jp _asci1_putc
.asci1_puts:        jp _asci1_puts   

    ; VDU
.vdu_init:          jp _vdu_init
.int_vdu:           jp _int_vdu

.vdu_set_attr:      jp _vdu_set_attr
.vdu_cls:           jp _vdu_cls
.vdu_scroll_up      jp _vdu_scroll_up
.vdu_putc_term      jp _vdu_putc_term
.vdu_putc           jp _vdu_putc
.vdu_next_line      jp _vdu_next_line
.vdu_puts           jp _vdu_puts

    ; KBD
.kbd_init:          jp _kbd_init
.int_kbd:           jp _int_kbd 
.kbd_is_empty       jp _kbd_is_empty
.kbd_get_key        jp _kbd_get_key

    ; SND

    ; RTC


    ; SYSTEM


; ASCI
; ----------------------------------------------------------------------------

; init ASCI0
; input : none
; output : none
_asci0_init:
    ; RE : Receiver Enable
    ; TE : Transmitter Enable
    ; MOD2 : 8 bits data ( No parity, 1 stop bit)
    ld a,CNTLA0_RE|CNTLA0_TE|CNTLA0_MOD2
    out0 (CNTLA0),a

    ; DR=0
    ld a,0
    out0 (CNTLB0),a
    
    ; BRG0 : Enable 16 bit BRG counter
    ; X1 ( + DR=0) : Clock mode = /1
    ld a,ASEXT0_BRG0|ASEXT0_X1
    out0 (ASEXT0),a

    ; 9600 bauds : TC=1665 (681H) --> 9603 bauds
    ; TC = fphi/(2*baud rate*clock mode) - 2
    ; TC = 32000000/(2*9600*1) - 2
    ld a,$81
    out0 (ASTC0L),a
    ld a,$06
    out0 (ASTC0H),a

    ; RIE : enable Rx Interrupt
    ld a,STAT0_RIE
    out0 (STAT0),a

    xor a                  ; init RX buffer
    ld (asci0_buffer_pos),a

    ret

; INT ASCI0
; put received char in ASCI0 RX buffer
_int_asci0:
    push af
    push bc
    push de
    push hl
    
_int_asci0_test:
    in0 a,(STAT0)                ; check if there is a char in the FIFO
    tst STAT0_RDRF
    jr Z,_int_asci0_exit

    in0 c,(RDR0)                ; c <- received char

    ; check for error
    and STAT0_OVRN|STAT0_PE|STAT0_FE
    jr Z,_int_asci0_ok
    
    in0 a,(CNTLA0)           ; clear error
    and CNTLA0_EFR!$FF
    out0 (CNTLA0),a 
    jr _int_asci0_test                    ; exit

_int_asci0_ok:
    ld d,0                      ; hl <- asci0_buffer+(asci0_buffer_pos)
    ld a,(asci0_buffer_pos)
    ld e,a
    ld hl,asci0_buffer
    add hl,de

    inc a                       ; ; inc kbd_buffer_pos 
    ld (asci0_buffer_pos),a

    ld a,c                      ; a <- received char
    ld (hl),a                   ; save it to asci0_buffer+(asci0_buffer_pos)

_int_asci0_exit:
    pop hl 
    pop de
    pop bc
    pop af
    ei
    ret

; get a char on ASCI0 RX buffer
; input : none
; output : a <- received char
_asci0_getc:
    push hl
    push de

    ld a,(asci0_buffer_pos)     ; load buffer position
    or 0
    jp  Z,_asci0_getc_exit      ; exit if 0
    
    dec a                       ; decrement and update buffer position
    ld (asci0_buffer_pos),a

    ld d,0                      ; get char in buffer
    ld e,a
    ld hl,asci0_buffer
    add hl,de
    ld a,(hl)                   ; into A register

_asci0_getc_exit:

    pop de
    pop hl
    ret

; check if rx buffer is empty
; input : NONE
; output : flag=Z if empty
_asci0_rx_empty:
    ld a,(asci0_buffer_pos)
    cp 0
    ret

; put a char on asci0
; input : a = char ascii code
; output : none
_asci0_putc:
    push af

_asci0_putc_wait:  ; wait for asci0 TX ready   
    in0 a,(STAT0) ; TDRE=1 -> empty
    and STAT0_TDRE
    jr Z,_asci0_putc_wait

    pop af
    out0 (TDR0),a ; output the char to asci0

    ret

; put a string on asci0
; input : (hl) = address of null terminated string
; output : none
_asci0_puts:
    push hl
    push af 

_asci0_puts_loop:
    ld a,(hl)
    or 0
    jr z,_asci0_puts_exit
    call _asci0_putc
    inc hl
    jr _asci0_puts_loop

_asci0_puts_exit:
    pop af
    pop hl
    ret

_asci1_init:
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

    ; RIE : enable Rx Interrupt
    ld a,STAT1_RIE
    out0 (STAT1),a

    xor a                  ; init RX buffer
    ld (asci1_buffer_pos),a

    ret
  
_int_asci1:
    push af
    push bc
    push de
    push hl
    
_int_asci1_test:
    in0 a,(STAT1)                ; check if there is a char in the FIFO
    tst STAT1_RDRF
    jr Z,_int_asci1_exit

    in0 c,(RDR1)                ; c <- received char

    ; check for error
    and STAT1_OVRN|STAT1_PE|STAT1_FE
    jr Z,_int_asci1_ok
    
    in0 a,(CNTLA1)           ; clear error
    and CNTLA1_EFR!$FF
    out0 (CNTLA1),a 
    jr _int_asci1_test                    ; exit

_int_asci1_ok:
    ld d,0                      ; hl <- asci0_buffer+(asci0_buffer_pos)
    ld a,(asci1_buffer_pos)
    ld e,a
    ld hl,asci1_buffer
    add hl,de

    inc a                       ; ; inc kbd_buffer_pos 
    ld (asci1_buffer_pos),a

    ld a,c                      ; a <- received char
    ld (hl),a                   ; save it to  asci1_buffer+(asci1_buffer_pos)

_int_asci1_exit:
    pop hl 
    pop de
    pop bc
    pop af
    ei
    ret

_asci1_getc:
    push hl
    push de

    ld a,(asci1_buffer_pos)     ; load buffer position
    or 0
    jp  Z,_asci1_getc_exit      ; exit if 0
    
    dec a                       ; decrement and update buffer position
    ld (asci1_buffer_pos),a

    ld d,0                      ; get char in buffer
    ld e,a
    ld hl,asci1_buffer
    add hl,de
    ld a,(hl)                   ; into A register

_asci1_getc_exit:

    pop de
    pop hl
    ret

; check if rx buffer is empty
; input : NONE
; output : flag=Z if empty
_asci1_rx_empty:
    ld a,(asci1_buffer_pos)
    cp 0
    ret

; put a char on asci1
; input : a = char ascii code
; output : none
_asci1_putc:
    push af

_asci1_putc_wait:  ; wait for asci0 TX ready   
    in0 a,(STAT1) ; TDRE=1 -> empty
    and STAT1_TDRE
    jr Z,_asci1_putc_wait

    pop af
    out0 (TDR1),a ; output the char to asci0

    ret

; put a string on asci1
; input : (hl) = address of null terminated string
; output : none
_asci1_puts:
    push hl
    push af 

_asci1_puts_loop:
    ld a,(hl)
    or 0
    jr z,_asci1_puts_exit
    call _asci1_putc
    inc hl
    jr _asci1_puts_loop

_asci1_puts_exit:
    pop af
    pop hl
    ret


; VDU
; ----------------------------------------------------------------------------

VDU_RAM   .equ $F000     ; Start of video RAM address

; vdu_init
; init the vdu system
; input : none
; output : none
_vdu_init:

    ; clear screen
    call _vdu_cls

    ; set PRT0 interrupt at 1/60s
     ld a,$0D
     out0 (RLDR0H),a
     ld a,$05
     out0 (RLDR0L),a

    ; enable PRT0 interrupt
    ld a, TCR_TIE0 | TCR_TDE0
    out0 (TCR),a 

    ret

_int_vdu:
    push af
    push hl

    in0 a,(TCR)         ; clear TIFE0
    in0 a,(TMDR0L)

    ld hl,(VDU_PTR)
    ld (hl),'X'

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

_vdu_putc_term:


_vdu_putc_term_LF:
    cp $0A
    jr nz,_vdu_putc_term_CS
    call _vdu_do_LF
    jr _vdu_putc_term_exit

_vdu_putc_term_CS:  
    cp $0C
    jr nz,_vdu_putc_term_CR
    call _vdu_cls
    jr _vdu_putc_term_exit

_vdu_putc_term_CR:
   cp $0D 
   jr nz,_vdu_putc_term_print
   call _vdu_do_CR
   jr _vdu_putc_term_exit

_vdu_putc_term_print:
    call _vdu_putc

_vdu_putc_term_exit:
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


_vdu_hide_cursor:
    push af
    push hl 

    ld hl,(VDU_PTR)
    inc hl          ; hl <- current color attribute address
    ld a,(hl)
    rlca
    rlca
    rlca
    rlca
    ld (hl),a

    pop hl
    pop af

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
    ld a,(VDU_X)        ; get X position
    inc a               ; increment
    ld (VDU_X),a
    cp 80              ; next line ?
    jr nz,_vdu_putc_exit
    call _vdu_next_line

_vdu_putc_exit:
    ld (VDU_PTR),de

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

    ld a,0              ; reset X
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


; KBD
; ----------------------------------------------------------------------------

KBD_DATA    .equ $80
KBD_STATUS  .equ $81

; bit 0 : shift
; bit 1 : alt
; bit 2 : caps lock
KBD_STATE_SHIFT .equ 0
KBD_STATE_ALT .equ 1
KBD_STATE_CAPS .equ 2
KBD_STATE_F0   .equ 3
KBD_STATE_E0  .equ 4

KBD_XOR_CAPS .equ 4


_kbd_init:
    ; enable INT1
    in0 a,(ITC)
    or ITC_ITE1 
    out0 (ITC),a
    ret

_int_kbd:
    push af
    push hl
    push de

    in0 a,(KBD_DATA)            ; read scancode
    ld b,a                      ; stored in B register

_int_kbd_test_F0:
    cp $F0                      ; F0 = release key
    jp NZ,_int_kbd_test_E0
 
    ld hl,kbd_state             ; set F0 flag in kbd_state
    set KBD_STATE_F0,(hl)
    jp _int_kbd_exit

_int_kbd_test_E0:
    cp $E0                      ; E0 = extended scancodes
    jp NZ,_int_kbd_check_state
 
    ld hl,kbd_state             ; set E0 flag in kbd_state
    set KBD_STATE_E0,(hl)
    jp _int_kbd_exit

_int_kbd_check_state:
    ld a,(kbd_state)            

    bit KBD_STATE_F0,a          ; if previous scancode was F0, jumps to F0 routine
    jp NZ,_int_kbd_F0            ; (release key)

    bit KBD_STATE_E0,a          ; if previous scancode was E0, jumps to E0 routinr
    jp NZ,_int_kbd_E0            ; (extended scancode)

_int_kbd_shift:                  ; manage SHIFT key
    ld a,b
    cp $12 ; lshift
    jp Z,_int_kbd_is_shift
    cp $59 ; rshift
    jp NZ,_int_kbd_alt

_int_kbd_is_shift:
    ld hl,kbd_state             ; set SHIFT flag in kbd_state
    set KBD_STATE_SHIFT,(hl)
    jp _int_kbd_exit

_int_kbd_alt:                    ; manage ALT key
    cp $11
    jp NZ,_int_kbd_capslock

    ld hl,kbd_state             ; set ALT flag in kbd_state
    set KBD_STATE_ALT,(hl)
    jp _int_kbd_exit

_int_kbd_capslock:                ; manage CAPS LOCK key
    cp $58
    jp NZ,_int_kbd_get_key

    ld hl,kbd_state
    ld a,(hl)                   ; toggle CAPS LOCK flag in kbd_stte
    xor KBD_XOR_CAPS
    ld (hl),a
    jp _int_kbd_exit

_int_kbd_get_key:
    ld d,0                      ; hl <- kbd_buffer+(kbd_buffer_pos)
    ld a,(kbd_buffer_pos)
    ld e,a
    ld hl,kbd_buffer
    add hl,de
    push hl                     ; save current buffer pointer on stack (1)

    ld hl,(kbd_state)

_int_kbd_get_key_caps:
    ld  a,1                    ; a==1 -> lowercase , a==0 -> shift

    bit KBD_STATE_CAPS,(hl)
    jp Z,_int_kbd_get_key_shift
    xor 1                      ; a<-0 (shift)

_int_kbd_get_key_shift:
    bit KBD_STATE_SHIFT,(hl)
    jp Z,_int_kbd_get_key_set_shift
    xor 1                       ; flip a 

_int_kbd_get_key_set_shift:
    ld hl,scan_codes_shift
    xor 1
    jp Z,_int_kbd_get_key_scancode

    ld hl,kbd_state
    bit KBD_STATE_ALT,(hl)      ; use ALT scancode set if ALT flag==1
    jp Z,_int_kbd_get_key_set_lowcase
    ld hl,scan_codes_alt
    jr _int_kbd_get_key_scancode

_int_kbd_get_key_set_lowcase:
    ld hl,scan_codes

_int_kbd_get_key_scancode:
    ld a,b
    call _kbd_decode_scancode
    pop hl                      ; get back current buffer pointer (see 1)

    cp 0                        ; do nothing if no code found
    jp Z,_int_kbd_exit

    ld (hl),a                   ; save it to  kbd_buffer+(kbd_buffer_pos)
          
    cp 10                       ; insert CR if ASCII code == LF (10)
    jp NZ,_kbd_int_incr_buffer_pos
    inc hl
    ld a,13
    ld (hl),a
    ld a,e
    inc a 
    ld (kbd_buffer_pos),a

_kbd_int_incr_buffer_pos:
    ld a,(kbd_buffer_pos)               ; inc kbd_buffer_pos 
    inc a
    ld (kbd_buffer_pos),a
    jr _int_kbd_exit

_int_kbd_E0:
    ld hl,kbd_state                     ; clear E0 flag in kbd_state
    res KBD_STATE_E0,(hl)
    jr _int_kbd_exit

_int_kbd_F0:
   ld hl,kbd_state                      ; clear F0 flag in kbd_state
   res KBD_STATE_F0,(hl)

   ld a,b                               ; clear SHIFT flag if key was LSHIFT 
   cp $12 ; LSHIFT
   jp NZ,_int_kbd_F0_rshift
   res KBD_STATE_SHIFT,(hl)
   jr _int_kbd_exit

_int_kbd_F0_rshift:                      ; clear SHIFT flag if key was LSHIFT
   cp $59 ; RSHIFT
   jp NZ,_int_kbd_F0_alt
   res KBD_STATE_SHIFT,(hl)
   jr _int_kbd_exit

_int_kbd_F0_alt:                         ; clear ALT flag if key was LSHIFT
   cp $11 ; ALT
   jp NZ,_int_kbd_exit
   res KBD_STATE_ALT,(hl)

_int_kbd_exit:                           ; end of keyboard interrupt routine.
    pop de
    pop hl
    pop af
    ei
    ret

; check if kbd buffer is empty
; input : NONE
; output : flag=Z if empty
_kbd_is_empty:
    ld a,(kbd_buffer_pos)
    cp 0
    ret

; Get next key in buffer
_kbd_get_key:
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



; input : a = scan code, hl = pointer to scan code table
; output : a = decoded scan code
_kbd_decode_scancode:
    push hl
    push de

    ld d,0  
    ld e,a
    add hl,de
    ld a,(hl)

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



; SND
; ----------------------------------------------------------------------------

_snd_init:
    ret

_snd_play_wav:
    ret

_snd_beep:
    ret

     ; RAM
asci0_buffer_pos:   .bs 1
asci0_buffer:       .bs 64
asci1_buffer_pos:   .bs 1
asci1_buffer:       .bs 64

VDU_ATTR            .bs 1   ; Color Attribute
VDU_X               .bs 1   ; Current X position
VDU_Y               .bs 1   ; Current Y position
VDU_PTR             .bs 2     ; Current position in video RAM, should always be equal to
                        ; VDU_RAM + X*2 + Y*160
vdu_cursor_x          .bs 1
vdu_cursor_y          .bs 1

kbd_state: .bs 1
kbd_buffer_pos:    .bs 1
kbd_buffer: .bs 64