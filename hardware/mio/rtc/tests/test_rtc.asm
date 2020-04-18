; assembler: sbasm
; command: sbasm monitor.asm

    .CR z180
    .TF test_rtc.hex,INT,16
    .LF test_rtc.lst
    
    .include ../../../../include/z180_defs.asm

    .org $0000
    jp mreset        ; RESET    

    .org $0038
    jp int_noop    ; INT0

    .org $0066
    jp int_noop    ; NMI

; interrupt vector table
    .org $0080
    .dw int_kbd    ; INT1
    .dw int_noop    ; INT2
    .dw int_noop    ; PRT0
    .dw int_noop    ; PRT1
    .dw int_noop    ; DMA0
    .dw int_noop    ; DMA1
    .dw int_noop    ; CSIO
    .dw int_noop   ; ASCI0
    .dw int_noop    ; ASCI1

    .org $0100
mreset:

    di ; disable interrupts

    ; CMR_X2 : clock * 2 => xtal 16Mhz ---> 32Mhz, phi 8Mhz --> 16Mhz
    ;ld a,CMR_X2
    ;out0 (CMR),a

    ; CCR_CD : phi = XTAL/1 => phi 16Mhz ---> 32Mhz !!!
    ;ld a,CCR_CD
    ;out0 (CCR),a

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

    call asci1_init

    ; setup interupts
    im 1    ; interrupt mode 1
    ld a,0  ; interrupts high order byte : 00H
    ld i,a
    ld a,0b10000000 ; interrupts low order byte : 80H
    out0 (IL),a

    ; enable INT1
    ld a,ITC_ITE1 
    out0 (ITC),a

   ei      ; enable interrupts

KBD_DATA    .equ $80
KBD_STATUS  .equ $81

;RTC_SECOND_1 .equ $90
RTC_SECOND_1 .equ $90
RTC_SECOND_10 .equ $91
RTC_MINUTE_1 .equ $92
RTC_MINUTE_10 .equ $93
RTC_HOUR_1 .equ $94
RTC_HOUR_10 .equ $95


main:
    ld hl,str_welcome ; show welcome message
    call asci1_puts

loop:

 ld hl,str_home
 call asci1_puts

 in0 a,(RTC_HOUR_10)
 and a,$03
 add a,'0'
 call asci1_putc

 in0 a,(RTC_HOUR_1)
 and a,$0f
 add a,'0'
 call asci1_putc

 ld a,':'
 call asci1_putc

 in0 a,(RTC_MINUTE_10)
 and a,$0f
 add a,'0'
 call asci1_putc

 in0 a,(RTC_MINUTE_1)
 and a,$0f
 add a,'0'
 call asci1_putc

 ld a,':'
 call asci1_putc

 in0 a,(RTC_SECOND_10)
 and a,$0f
 add a,'0'
 call asci1_putc


 in0 a,(RTC_SECOND_1)
 and a,$0f
 add a,'0'
 call asci1_putc

 ;out0 (KBD_DATA),a
  ;  call asci1_getc

  ; call asci1_putc
    jp loop



int_kbd:
    push af
    in0 a,(KBD_DATA)
    ;ld a,'K'
    call asci1_putc
    pop af
    ei
    ret


; -----------------------------------------------------------------

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



; put a char on asci1
; input : a = char ascii code
asci1_putc:
    push af

asci1_putc_wait:  ; wait for asci0 TX ready
    in0 a,(STAT1) ; TDRE=1 -> empty
    and STAT1_TDRE
    jr Z,asci1_putc_wait
    pop af
    out0 (TDR1),a ; output the char to asci0
    ret


int_noop:
    ei
    ret


str_welcome:    .db $1B,"[2J",$1B,"[H","Test RTC",13,10,13,10,0
str_home: .db $1B,"[H",$1B,"[?25h",0
    .org $2100

   