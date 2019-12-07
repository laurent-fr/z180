; assembler : sbasm
; sbasm

    .CR z180
    .TF monitor.hex,INT,16
    .LF monitor.lst
    
    .INCLUDE z180_defs.asm

    .ORG $0000

    jp reset

    .ORG $0100

reset:

    di ; disable interrupts

    ; CMR_X2 : clock * 2 => xtal 16Mhz ---> 32Mhz, phi 8Mhz --> 16Mhz
    ld a,CMR_X2
    out0 (CMR),a

    ; CCR_CD : phi = XTAL/1 => phi 16Mhz ---> 32Mhz !!!
    ld a,CCR_CD
    out0 (CCR),a

    ld  a,0
    out0 (RCR),a    ; Refresh disable

    ; MMU 
    ; $0000-$0FFF = ROM ( $00000 - $00FFF )
    ; $1000-$FFFF = RAM ( $80000 - $8EFFF )
    ld a,$11 ; Common Area 1 = Bank Area 1 = 4Kb
    out0 (CBAR),a

    ld a,$80 ; Common Area Base = $80000
    out0 (CBR),a

    ; Stack pointer = $1100
    ld sp,$1100

    call asci0_init

main:
    ld hl,str_welcome ; show welcome message
    call asci0_puts

prompt:
    ld hl,str_prompt ; show prompt
    call asci0_puts

waitcommand:

loop:
    jp loop

; initialize asci0
asci0_init:

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

    ret

; put a string on asci0
; input : (hl) = address of null terminated string
asci0_puts:
    push bc
    push hl
    push af 

asci0_puts_loop:
    ld a,(hl)
    or 0
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
    and STAT0_TDRE
    jr Z,asci0_putc_wait

    out0 (TDR0),c ; output the char to asci0

    pop af
    ret

asci0_waitc:

    ret

asci0_getc:
    call asci0_getc
    ret

str_welcome:    .DB $1B,"[2J",$1B,"[H","Z180 CPU - Monitor V1.0",13,10,13,10,0
str_prompt:     .DB "? ",0