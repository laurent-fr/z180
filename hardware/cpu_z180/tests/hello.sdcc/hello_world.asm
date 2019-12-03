.z180

.include "z180.inc"

.area CODE (ABS)

.org 0x0000

    jp reset

.org 0x0100

reset:

    di ; disable interrupts

    ld  a,#0
    out0 (RCR),a    ; Refresh disable

    ; MMU 
    ; 0x0000-0x0FFF = ROM ( 0H00000 - 0H00FFF )
    ; 0x1000-0xFFFF = RAM ( 0H80000 - 0H8EFFF )
    ld a,#0x11 ; Common Area 1 = Bank Area 1 = 4Kb
    out0 (CBAR),a

    ld a,#0x80 ; Common Area Base = 0x80000
    out0 (CBR),a

    ; Stack pointer = 0x1100
    ld sp,#0x1100

    call asci0_init

loop:
    ld hl,#str_hello
    call asci0_puts

    jp loop

; initialize asci0
asci0_init:

    ; RE : Receiver Enable
    ; TE : Transmitter Enable
    ; MOD2 : 8 bits data ( No parity, 1 stop bit)
    ; RTS0 : RTS0 high
    ld a,#CNTLA0_RE|#CNTLA0_TE|#CNTLA0_MOD2|#CNTLA0_RTS0
    out0 (CNTLA0),a

    ; DR=0
    ld a,#0
    out0 (CNTLB0),a
    
    ; BRG0 : Enable 16 bit BRG counter
    ; X1 ( + DR=0) : Clock mode = /1
    ld a,#ASEXT0_BRG0|#ASEXT0_X1
    out0 (ASEXT0),a

    ; 9600 bauds : TC=415 (19FH) --> 9592 bauds
    ; TC = fphi/(2*baud rate*clock mode) - 2
    ; TC = 8000000/(2*9600*1) - 2
    ld a,#0x9F
    out0 (ASTC0L),a
    ld a,#0x01
    out0 (ASTC0x),a

    ret

; put a string on asci0
; input : (hl) = address of null terminated string
asci0_puts:
    push bc
    push hl
    push af 

asci0_puts_loop:
    ld a,(hl)
    or #0
    jr z,asci0_puts_exit
    ld c,a
    call asci0_putc
    inc hl
    jr asci0_puts_loop

asci0_puts_exit:
    pop af
    pop hl
    pop bc
    ret

; put a char on asci0
; input : c = char ascii code
asci0_putc:
    push af

asci0_putc_wait:  ; wait for asci0 TX ready
    in0 a,(STAT0) ; TDRE=1 -> empty
    and #STAT0_TDRE
    jr Z,asci0_putc_wait

    out0 (TDR0),c ; output the char to asci0

    pop af
    ret


str_hello:
   .str "Hello, world !"
   .db 13,10,0

