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
KBD_STATE_CTRL .equ 5

KBD_XOR_CAPS .equ 4


_kbd_init:
    ; enable INT1
    in0 a,(ITC)
    or ITC_ITE1 
    out0 (ITC),a

    ; init keyboad variables
    xor a
    ld (kbd_buffer_pos),a
    ld (kbd_state),a

    ret

_int_kbd:
    push af
    exx 

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
    jp NZ,_int_kbd_ctrl

    ld hl,kbd_state             ; set ALT flag in kbd_state
    set KBD_STATE_ALT,(hl)
    jp _int_kbd_exit

_int_kbd_ctrl:                  ; manage CTRL KEY
    cp $14
    jp NZ,_int_kbd_capslock
    set KBD_STATE_CTRL,(hl)
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

_int_kbd_F0_rshift:                      ; clear SHIFT flag if key was RSHIFT
   cp $59 ; RSHIFT
   jp NZ,_int_kbd_F0_alt
   res KBD_STATE_SHIFT,(hl)
   jr _int_kbd_exit

_int_kbd_F0_alt:                         ; clear ALT flag if key was ALT
   cp $11 ; ALT
   jp NZ,_int_kbd_F0_ctrl
   res KBD_STATE_ALT,(hl)
   jp _int_kbd_exit

_int_kbd_F0_ctrl:                       ; clear CTRL flag if key was LCTRL
    cp $14 ; LCTRL
    jp NZ,_int_kbd_exit
    res KBD_STATE_CTRL,(hl)

_int_kbd_exit:  
    exx                         ; end of keyboard interrupt routine.
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
    push de
    push hl

     ld a,(kbd_buffer_pos)

     cp 0                       ; exit value=0 if no key in buffer
     jr Z,_kbd_get_key_exit

     dec a
     ld (kbd_buffer_pos),a
     ld d,0 
     ld e,a
     ld hl,kbd_buffer
     add hl,de
     ld a,(hl)

_kbd_get_key_exit:
    pop hl
    pop de
    ret

; wait for and get a key
_kbd_wait_get_key:
    ld a,(kbd_buffer_pos)
    cp 0
    jr z,_kbd_wait_get_key
    call _kbd_get_key
    ret

; input : a = scan code, hl = pointer to scan code table
; output : a = decoded scan code
_kbd_decode_scancode:
    push de
    push hl

    ld d,0  
    ld e,a
    add hl,de
    ld a,(hl)

    pop hl
    pop de
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
    .db '0',',','2','5','6','8',27,0,0,'+','3','-','*','9',0
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
    .db '0',',','2','5','6','8',27,0,0,'+','3','-','*','9',0
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

scan_codes_ctrl:
    ; 00-0F : n/a F9 n/a F5 F3 F1 F2 F12 n/a F10 F8 F6 F4 TAB ² n/a
    .db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    ; 10-1F : n/a n/a LSHIFT n/a n/a a & n/a n/a n/a n/a w s q z é n/a
    .db 0,0,0,0,0,1,0,0,0,0,23,19,17,26,0,0
    ; 20-2F : n/a c x d e ' " n/a n/a SPACE v f t r ( n/a
    .db 0,3,24,4,5,0,0,0,0,0,22,6,20,18,0,0
    ; 30-3F : n/a n b h g y - n/a n/a n/a , j u è _ n/a
    .db 0,14,2,8,7,25,0,0,0,0,0,10,21,0,0,0
    ; 40-4F : n/a ; k i o à ç n/a n/a : ! l m p ) n/a
    .db 0,0,11,9,15,0,0,0,0,0,0,12,13,16,0,0
    ; 50-5F : n/a n/a ù n/a ^ = n/a n/a CAPS RSHIFT RETURN $ n/a * n/a n/a
    .db 0,0,0,0,0,0,0,0,0,0,10,0,0,0,0,0
    ; 60-6F : n/a < n/a n/a n/a n/a BACKSPACE n/a n/a PAD_1 n/a PAD_4 PAD_7 n/a n/a n/a
    .db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    ; 70-7F : PAD_0 PAD_, PAD_2 PAD_5 PAD_6 PAD_8 ESC P_VERNUM F11 PAD_+ PAD_3 PAD_- PAD_* PAD_9 ARRET_DEFIL
    .db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    ; 80-83 : n/a n/a n/a F7
    .db 0,0,0,0


     ; RAM
     .SM ram 
kbd_state: .bs 1
kbd_buffer_pos:    .bs 1
kbd_buffer: .bs 64
    .SM code