
INCLUDE "z180.inc"

ORG $0000

.asci0_init

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

    ; 9600 bauds : TC=415 (19FH) --> 9592 bauds
    ; TC = fphi/(2*baud rate*clock mode) - 2
    ; TC = 8000000/(2*9600*1) - 2
    ld a,$9F
    out0 (ASTC0L),a

    ld a,$01
    out0 (ASTC0H),a

.asci0_putc

    in0 a,(STAT0) ; TDRE=1 -> empty
    and STAT0_TDRE
    jr NZ,asci0_putc

    ld a,'A'
    out0 (TDR0),a

    jp asci0_putc
