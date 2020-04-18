; assembler: sbasm
; command: sbasm monitor.asm

    .CR z180
    .TF monitor.hex,INT,16
    .LF monitor.lst
    
    .include z180_defs.asm

    .org $0000
    jp mreset        ; RESET

rst08:
    .org $0008
    jp asci1_putc

rst10:
    .org $0010
    jp asci1_getc

rst18:
    .org $0018
    ld a,(rx1_buffer_cpt)
    cp 0
    ret
    

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
    .dw int_asci1    ; ASCI1

    .org $0100
mreset:

    di ; disable interrupts

    ; CMR_X2 : clock * 2 => xtal 16Mhz ---> 32Mhz, phi 8Mhz --> 16Mhz
    ; ld a,CMR_X2
    ; out0 (CMR),a

    ; CCR_CD : phi = XTAL/1 => phi 16Mhz ---> 32Mhz !!!
    ; ld a,CCR_CD
    ; out0 (CCR),a

    ld  a,0
    out0 (RCR),a    ; Refresh disable

    ; MMU    
    ; $F000-$FFFF = VDU ( $20000 - $20FFF ) - Common Area 1
    ; $2000-$EFFF = RAM ( $80000 - $8EFFF ) - Bank Area
    ; $0000-$1FFF = ROM ( $00000 - $01FFF ) - Common Area 0
    
    ld a,$F2 ; Common Area 1 = $F000-$FFFF, Bank Area 1 =  $2000-$EFFF
    out0 (CBAR),a
    ld a,$11 ; Common Area Base = $20000
    out0 (CBR),a
    ld a,$7E ; Bank Area Base = $80000 
    out0 (BBR),a

    ; Stack pointer = $10FF
    ld sp,$20FF

    call asci0_init
    call asci1_init

    ; setup interupts
    im 1    ; interrupt mode 1
    ld a,0  ; interrupts high order byte : 00H
    ld i,a
    ld a,0b10000000 ; interrupts low order byte : 80H
    out0 (IL),a

    ei      ; enable interrupts

main:
    ld a,'B'
    call asci1_putc
    ld hl,str_welcome ; show welcome message
    call asci1_puts

    ; TEST VDU
    ;ld hl,$F000
    ;ld a,$55
    ;testvdu:
    ;ld (hl),a
    ;jr testvdu
    ;jp main
    
    ; BASIC
    ;jp $0300

mprompt:
    ld hl,str_prompt ; show prompt
    call asci0_puts

waitcommand:
   ; call asci0_getc
   ; ld c,a 
   ; call asci0_putc
    call int_asci0
    jp waitcommand


; -----------------------------------------------------------------

; Load HEX file routine
hex_load:

hex_load_new_line:
    call asci0_getc
    cp ':'                  ; start of line ':'
    jr NZ,hex_load_err
    call get_byte           ; first byte = number of bytes per line
    ld b,a
    call get_byte           ; 2 bytes address
    ld h,a 
    call get_byte
    ld l,a
    call get_byte           ; line type 
    cp 0
    jr NZ,hex_load_end

    ld c,0          ; checksum

hex_line_bytes:
    call get_byte
    ld (hl),a
    inc hl
    add a,c
    ld c,a
    djnz hex_line_bytes


    neg c

hex_load_end:

hex_load_err:
    ld hl,str_error
    call asci0_puts
    ret

get_byte:
    call asci0_getc
    ld d,c
    call asci0_getc
    ld e,c
    call ascii_to_byte
    ret

; in : 2 ascii chars in de
; out : a = byte value
ascii_to_byte:
    ld a,d

    ret

; -----------------------------------------------------------------

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

; initialize asci1
asci1_init:

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
    ld (rx0_buffer_cpt),a
    ld hl,rx0_buffer
    dec hl
    ld (rx0_buffer_ptr),hl
    
    ret

; put a string on asci0
; input : (hl) = address of null terminated string
asci0_puts:
    push hl
    push af 

asci0_puts_loop:
    ld a,(hl)
    or 0
    jr z,asci0_puts_exit
    call asci0_putc
    inc hl
    jr asci0_puts_loop

asci0_puts_exit:
    pop af
    pop hl
    ret

; put a string on asci1
; input : (hl) = address of null terminated string
asci1_puts:
    push hl
    push af 

asci1_puts_loop:
    ld a,(hl)
    or 0
    jr z,asci1_puts_exit
    call asci1_putc
    inc hl
    jr asci1_puts_loop

asci1_puts_exit:
    pop af
    pop hl
    ret

; put a char on asci0
; input : a = char ascii code
asci0_putc:
    push af
asci0_putc_wait:  ; wait for asci0 TX ready
    
    in0 a,(STAT0) ; TDRE=1 -> empty
    and STAT0_TDRE
    jr Z,asci0_putc_wait
    pop af
    out0 (TDR0),a ; output the char to asci0

    ret

; put a char on asci1
; input : c = char ascii code
asci1_putc:
    push af

asci1_putc_wait:  ; wait for asci0 TX ready
    in0 a,(STAT1) ; TDRE=1 -> empty
    and STAT1_TDRE
    jr Z,asci1_putc_wait
    pop af
    out0 (TDR1),a ; output the char to asci0


    ret

; int asci0
int_asci0:
    push af
    push bc
    push hl

int_asci0_test:
    in0 a,(STAT0)                ; check if there is a char in the FIFO
    tst STAT0_RDRF
    jr Z,int_asci0_exit

    in0 c,(RDR0)

    ; check for error
    and STAT0_OVRN|STAT0_PE|STAT0_FE
    jr Z,int_asci0_ok
    
    in0 a,(CNTLA0)           ; clear error
    and CNTLA0_EFR!$FF
    out0 (CNTLA0),a 
    jr int_asci0_test                    ; exit

int_asci0_ok:
    

    ld a,(rx0_buffer_cpt)
    cp RX_BUFFER_SIZE
    jr Z,int_asci0_exit

    inc a
    ld (rx0_buffer_cpt),a
    
    ld hl,(rx0_buffer_ptr)
    inc hl
    ld (rx0_buffer_ptr),hl

    ld (hl),c
    call asci0_putc

    jr int_asci0_test           ; is there more characters ?

int_asci0_exit:
    pop hl
    pop bc
    pop af
    ei
    ret

; int asci1
int_asci1:
    push af
    push bc
    push hl

int_asci1_test:
    in0 a,(STAT1)                ; check if there is a char in the FIFO
    tst STAT1_RDRF
    jr Z,int_asci1_exit

    in0 c,(RDR1)

    ; check for error
    and STAT1_OVRN|STAT1_PE|STAT1_FE
    jr Z,int_asci1_ok
    
    in0 a,(CNTLA1)           ; clear error
    and CNTLA1_EFR!$FF
    out0 (CNTLA1),a 
    jr int_asci1_test                    ; exit

int_asci1_ok:

    ld a,(rx1_buffer_cpt)
    cp RX_BUFFER_SIZE
    jr Z,int_asci1_exit

    inc a
    ld (rx1_buffer_cpt),a
    
    ld hl,(rx1_buffer_ptr)
    inc hl
    ld (rx1_buffer_ptr),hl

    ld (hl),c

    jr int_asci1_test           ; is there more characters ?

int_asci1_exit:
    pop hl
    pop bc
    pop af
    ei
    ret


asci0_getc:
    push bc
    push hl
 
asci0_getc_wait:
    ld a,(rx0_buffer_cpt)
    cp 0
    jr Z,asci0_getc_wait
  
    ld a,(rx0_buffer_cpt)   ; get  buffer counter
    cp 0                    ; if 0 : nothing to get
    jr Z,asci0_getc_exit    ; exit
    
    dec a
    ld (rx0_buffer_cpt),a
    ld hl,(rx0_buffer_ptr)
    ld a,(hl)

    dec hl
    ld (rx0_buffer_ptr),hl

asci0_getc_exit:
    pop hl
    pop bc
    ret

asci1_getc:
    push bc
    push hl
 
asci1_getc_wait:
    ld a,(rx1_buffer_cpt)
    cp 0
    jr Z,asci1_getc_wait
  
    ld a,(rx1_buffer_cpt)   ; get  buffer counter
    cp 0                    ; if 0 : nothing to get
    jr Z,asci1_getc_exit    ; exit
    
    dec a
    ld (rx1_buffer_cpt),a
    ld hl,(rx1_buffer_ptr)
    ld a,(hl)

    dec hl
    ld (rx1_buffer_ptr),hl

asci1_getc_exit:
    pop hl
    pop bc
    ret



int_noop:
    reti


str_welcome:    .db $1B,"[2J",$1B,"[H","Z180 CPU - Monitor V0.1",13,10,13,10,0
str_prompt:     .db "? ",0
str_error:       .db 13,10,"Err.",13,10,0

    .org $2100

RX_BUFFER_SIZE: .equ 127

rx0_buffer:     .bs RX_BUFFER_SIZE+1
rx0_buffer_ptr: .bs 2
rx0_buffer_cpt: .bs 2
rx1_buffer:     .bs RX_BUFFER_SIZE+1
rx1_buffer_ptr: .bs 2
rx1_buffer_cpt: .bs 2

   