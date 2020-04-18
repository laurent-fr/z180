; ------------------------------------
; Z180 constants
; ------------------------------------

; ASCI
; ----------

; ASCI Control Register A 0 (CNTLA0: 00H)
CNTLA0         .equ $00

CNTLA0_MPE     .equ $80
CNTLA0_RE      .equ $40
CNTLA0_TE      .equ $20
CNTLA0_RTS0    .equ $10
CNTLA0_EFR     .equ $08
CNTLA0_MOD2    .equ $04
CNTLA0_MOD1    .equ $02
CNTLA0_MOD0    .equ $01

; ASCI Control Register A 1 (CNTLA1: 01H)
CNTLA1         .equ $01

CNTLA1_MPE     .equ $80
CNTLA1_RE      .equ $40
CNTLA1_TE      .equ $20
CNTLA1_CKA1D   .equ $10
CNTLA1_EFR     .equ $08
CNTLA1_MOD2    .equ $04
CNTLA1_MOD1    .equ $02
CNTLA1_MOD0    .equ $01

; ASCI Control Register B 0 (CNTLB0: 02H)
CNTLB0         .equ $02

CNTLB0_MPBT    .equ $80
CNTLB0_MP      .equ $40
CNTLB0_CTS     .equ $20
CNTLB0_PEO     .equ $10
CNTLB0_DR      .equ $08
CNTLB0_SS2     .equ $04
CNTLB0_SS1     .equ $02
CNTLB0_SS0     .equ $01

; ASCI Control Register B 1 (CNTLB1: 03H)
CNTLB1         .equ $03

CNTLB1_MPBT    .equ $80
CNTLB1_MP      .equ $40
CNTLB1_CTS     .equ $20
CNTLB1_PEO     .equ $10
CNTLB1_DR      .equ $08
CNTLB1_SS2     .equ $04
CNTLB1_SS1     .equ $02
CNTLB1_SS0     .equ $01

; ASCI Status Register 0 (STAT0: 04H)
STAT0          .equ $04

STAT0_RDRF     .equ $80
STAT0_OVRN     .equ $40
STAT0_PE       .equ $20
STAT0_FE       .equ $10
STAT0_RIE      .equ $08
STAT0_DCD0     .equ $04
STAT0_TDRE     .equ $02
STAT0_TIE      .equ $01

; ASCI Status Register 1 (STAT1: 05H)
STAT1          .equ $05

STAT1_RDRF     .equ $80
STAT1_OVRN     .equ $40
STAT1_PE       .equ $20
STAT1_FE       .equ $10
STAT1_RIE      .equ $08
STAT1_CTS1E    .equ $04
STAT1_TDRE     .equ $02
STAT1_TIE      .equ $01

; ASCI Transmit Data Register Ch. 0 (TDR0: 06H)
TDR0           .equ $06

; ASCI Transmit Data Register Ch. 1 (TDR1: 07H)
TDR1           .equ $07

; ASCI Receive Data Register Ch. 0 (RDR0: 08H)
RDR0           .equ $08

; ASCI Receive Data Register Ch. 1 (RDR1: 09H)
RDR1           .equ $09

; ASCI0 Extension Control Register 0 (ASEXT0: 12H)
ASEXT0         .equ $12

ASEXT0_RDRFI   .equ $80
ASEXT0_DCD0D   .equ $40
ASEXT0_CTS0D   .equ $20
ASEXT0_X1      .equ $10
ASEXT0_BRG0    .equ $08
ASEXT0_BRKE    .equ $04
ASEXT0_BRK     .equ $02
ASEXT0_SBRK    .equ $01

; ASCI1 Extension Control Register 1 (ASEXT1: 13H)
ASEXT1         .equ $13

ASEXT1_RDRFI   .equ $80
ASEXT1_X1      .equ $10
ASEXT1_BRG1    .equ $08
ASEXT1_BRKE    .equ $04
ASEXT1_BRK     .equ $02
ASEXT1_SBRK    .equ $01

; ASCI0 Time Constant Low Register (ASTC0L : 1AH)
ASTC0L         .equ $1A
; ASCI0 Time Constant High Register (ASTC0H: 1BH)
ASTC0H         .equ $1B
; ASCI1 Time Constant Low Register (ASTC1L : 1AH)
ASTC1L         .equ $1C
; ASCI1 Time Constant High Register (ASTC1H: 1BH)
ASTC1H         .equ $1D

; CSI/0
; ------------------------------------

; CSI/O Control Register (CNTR: 0AH)
CNTR           .equ $0A

CNTR_EF        .equ $80
CNTR_EIE       .equ $40
CNTR_RE        .equ $20
CNTR_TE        .equ $10
CNTR_SS2       .equ $04
CNTR_SS1       .equ $02
CNTR_SS0       .equ $01

; CSI/O Transmit/Receive Data Register (TRD: 0BH)
TRDR           .equ $0B

; Timer
; ------------------------------------

; Data Register Ch 0 L (TMDR0L: 0CH)
TMDR0L         .equ $0C
; Data Register Ch 0 H (TMDR0H: 0DH)
TMDR0H         .equ $0D
; Reload Register Ch 0 L (RLDR0L: OEH)
RLDR0L         .equ $0E
; Reload Register Ch 0 H (RLDR0H: 0FH)
RLDR0H         .equ $0F

; Timer Control Register (TCR: 10H)
TCR            .equ $10

TCR_TF1        .equ $80
TCR_TF0        .equ $40
TCR_TE1        .equ $20
TCR_TE0        .equ $10
TCR_TOC1       .equ $08
TCR_TOC0       .equ $04
TCR_TDE1       .equ $02
TCR_TDE0       .equ $01

; Data Register Ch 1 L (TMDR1L: 14h)
TMDR1L         .equ $14
; Data Register Ch 1 H (TMDR1H: 15H)
TMDR1H         .equ $15
; Reload Register Ch 1 L (RLDR1L: 16H)
RLDR1L         .equ $16
; Reload Register Ch 1 H (RLDR1H: 17H)
RLDR1H         .equ $17

; Others
; ------------------------------------

; Clock Multiplier Register (CMR: 1EH)
CMR            .equ $1E

CMR_X2         .equ $80

; Free Running Counter (FRC: 18H)
FRC            .equ $18

; CPU Control Register (CCR: 1FH)
CCR            .equ $1F
CCR_CD         .equ $80
CCR_SB1        .equ $40
CCR_BREXT      .equ $20
CCR_LNPHI      .equ $10
CCR_SB2        .equ $08
CCR_LNIO       .equ $04
CCR_LNCPU      .equ $02
CCR_LNAD       .equ $01  

; DMA
; ---------------------------------------------------------------------------


; DMA/WAIT Control Register (DCNTL: 32H)

; INT
; ---------------------------------------------------------------------------

; Interrupt Vector Low Register (IL: 33H)
IL              .equ $33

; INT/TRAP Control Register (ITC: 34H)
ITC             .equ $34

ITC_TRAP        .equ $80
ITC_UFO         .equ $40
ITC_ITE2        .equ $04
ITC_ITE1        .equ $02
ITC_ITE0        .equ $01


; Refresh
; ---------------------------------------------------------------------------

; Refresh Control Register (RCR: 36H)
RCR            .equ $36
RCR_REFE       .equ $80
RCR_REFW       .equ $40
RCR_CYC1       .equ $02
RCR_CYC0       .equ $01

; MMU
; ---------------------------------------------------------------------------

; MMU Common Base Register (CBR: 38H)
CBR            .equ $38
; MMU Bank Base Register (BBR: 39H)
BBR            .equ $39
; MMU Common/Bank Register (CBAR: 3AH)
CBAR           .equ $3A 
; I/O
; ---------------------------------------------------------------------------

; Operation Mode Control Register (OMCR: 3EH)
OMCR           .equ $3E

OMCR_M1E       .equ $80
OMCR_M1TE      .equ $40
;OMCR_M1E       .equ $20

; I/O Control Register (ICR: 3FH)
ICR            .equ $3F

ICR_IOA7       .equ $80
ICR_IOA6       .equ $40
ICR_IOSTP      .equ $20
