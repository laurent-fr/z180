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

    ; KBD
.kbd_init:          jp _kbd_init
.int_kbd            jp _int_kbd 

    ; SND

    ; RTC


    ; SYSTEM


    ; ASCI

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

_vdu_init:
    ret
    ; KBD

_kbd_init:
    ret

_int_kbd:
    ret

    ; SND

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

kbd_buffer_pos:     .bs 1
kbd_buffer:         .bs 64