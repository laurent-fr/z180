; assembler: sbasm
; command: sbasm monitor.asm

    .CR z180
    .TF monitor.hex,INT,16
    .LF monitor.lst
    
    .include z180_defs.asm

    .org $0000
    jp reset        ; RESET

    .org $0038
    jp int_noop    ; INT0

    .org $0066
    jp int_noop    ; NMI

; interrupt vector table
    .org $0080
    .dw int_noop    ; INT1
    .dw int_noop    ; INT2
    .dw int_noop    ; PRT0
    .dw int_noop    ; PRT1
    .dw int_noop    ; DMA0
    .dw int_noop    ; DMA1
    .dw int_noop    ; CSIO
    .dw int_asci0   ; ASCI0
    .dw int_noop    ; ASCI1

    .org $0100
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

    ; Stack pointer = $10FF
    ld sp,$10FF

    call asci0_init

    ; setup interupts
    im 1    ; interrupt mode 1
    ld a,0  ; interrupts high order byte : 00H
    ld i,a
    ld a,0b10000000 ; interrupts low order byte : 80H
    out0 (IL),a

    ei      ; enable interrupts

main:
    ld hl,str_welcome ; show welcome message
    call asci0_puts

prompt:
    ld hl,str_prompt ; show prompt
    call asci0_puts

waitcommand:
    call asci0_waitc
    call asci0_getc
    ld c,a 
    call asci0_putc

    jp waitcommand

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

    ; RIE : enable Rx Interrupt
    ld a,STAT0_RIE
    out0 (STAT0),a

    xor a                  ; init RX buffer
    ld (rx0_buffer_cpt),a
    ld hl,rx0_buffer
    dec hl
    ld (rx0_buffer_ptr),hl
    
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

int_asci0:
    push af
    push bc
    push hl

int_asci0_test:
    in0 a,(STAT0)                ; check if there is a char in the FIFO
    tst STAT0_RDRF
    jr Z,int_asci0_exit

    ; check for error
    and STAT0_OVRN|STAT0_PE|STAT0_FE
    jr Z,int_asci0_ok
    
    in0 a,(CNTLA0)           ; clear error
    and CNTLA0_EFR!$FF
    out0 (CNTLA0),a 
    jr int_asci0_exit                     ; exit

int_asci0_ok:
    in0 c,(RDR0)

    ld a,(rx0_buffer_cpt)
    cp RX_BUFFER_SIZE
    jr Z,int_asci0_exit

    inc a
    ld (rx0_buffer_cpt),a
    
    ld hl,(rx0_buffer_ptr)
    inc hl
    ld (rx0_buffer_ptr),hl

    ld (hl),c

    jr int_asci0_test           ; is there more characters ?

int_asci0_exit:
    pop hl
    pop bc
    pop af
    ei
    ret

asci0_waitc:
 
    ld a,(rx0_buffer_cpt)
    cp 0
    jr Z,asci0_waitc
    ret

asci0_getc:
    push bc
    push hl
    di
    ld a,(rx0_buffer_cpt)   ; get  buffer counter
    cp 0                    ; if 0 : nothing to get
    jr Z,asci0_getc_exit    ; exit
    
    dec a
    ld (rx0_buffer_cpt),a
    ld hl,(rx0_buffer_ptr)
    ld a,(hl)

    dec hl
    ld (rx0_buffer_ptr),hl
    ei
asci0_getc_exit:
    pop hl
    pop bc
    ret


int_noop:
    reti


str_welcome:    .DB $1B,"[2J",$1B,"[H","Z180 CPU - Monitor V0.1",13,10,13,10,0
str_prompt:     .DB "? ",0

    .org $1100

RX_BUFFER_SIZE: .equ 127

rx0_buffer:     .bs RX_BUFFER_SIZE+1
rx0_buffer_ptr: .bs 2
rx0_buffer_cpt: .bs 2