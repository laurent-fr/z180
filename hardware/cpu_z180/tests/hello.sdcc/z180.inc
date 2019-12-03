; ------------------------------------
; Z180 constants
; ------------------------------------

; ASCI
; ----------

; ASCI Control Register A 0 (CNTLA0: 00H)
CNTLA0         .equ 0H00

CNTLA0_MPE     .equ 0H80
CNTLA0_RE      .equ 0H40
CNTLA0_TE      .equ 0H20
CNTLA0_RTS0    .equ 0H10
CNTLA0_MPBR    .equ 0H08
CNTLA0_MOD2    .equ 0H04
CNTLA0_MOD1    .equ 0H02
CNTLA0_MOD0    .equ 0H01

; ASCI Control Register A 1 (CNTLA1: 01H)
CNTLA1         .equ 0H01

CNTLA1_MPE     .equ 0H80
CNTLA1_RE      .equ 0H40
CNTLA1_TE      .equ 0H20
CNTLA1_CKA1D   .equ 0H10
CNTLA1_MPBR    .equ 0H08
CNTLA1_MOD2    .equ 0H04
CNTLA1_MOD1    .equ 0H02
CNTLA1_MOD0    .equ 0H01

; ASCI Control Register B 0 (CNTLB0: 02H)
CNTLB0         .equ 0H02

CNTLB0_MPBT    .equ 0H80
CNTLB0_MP      .equ 0H40
CNTLB0_CTS     .equ 0H20
CNTLB0_PEO     .equ 0H10
CNTLB0_DR      .equ 0H08
CNTLB0_SS2     .equ 0H04
CNTLB0_SS1     .equ 0H02
CNTLB0_SS0     .equ 0H01

; ASCI Control Register B 1 (CNTLB1: 03H)
CNTLB1         .equ 0H03

CNTLB1_MPBT    .equ 0H80
CNTLB1_MP      .equ 0H40
CNTLB1_CTS     .equ 0H20
CNTLB1_PEO     .equ 0H10
CNTLB1_DR      .equ 0H08
CNTLB1_SS2     .equ 0H04
CNTLB1_SS1     .equ 0H02
CNTLB1_SS0     .equ 0H01

; ASCI Status Register 0 (STAT0: 04H)
STAT0          .equ 0H04

STAT0_RDRF     .equ 0H80
STAT0_OVRN     .equ 0H40
STAT0_PE       .equ 0H20
STAT0_FE       .equ 0H10
STAT0_RIE      .equ 0H08
STAT0_DCD0     .equ 0H04
STAT0_TDRE     .equ 0H02
STAT0_TIE      .equ 0H01

; ASCI Status Register 1 (STAT1: 05H)
STAT1          .equ 0H05

STAT1_RDRF     .equ 0H80
STAT1_OVRN     .equ 0H40
STAT1_PE       .equ 0H20
STAT1_FE       .equ 0H10
STAT1_RIE      .equ 0H08
STAT1_CTS1E    .equ 0H04
STAT1_TDRE     .equ 0H02
STAT1_TIE      .equ 0H01

; ASCI Transmit Data Register Ch. 0 (TDR0: 06H)
TDR0           .equ 0H06

; ASCI Transmit Data Register Ch. 1 (TDR1: 07H)
TDR1           .equ 0H07

; ASCI Receive Data Register Ch. 0 (RDR0: 08H)
RDR0           .equ 0H08

; ASCI Receive Data Register Ch. 1 (RDR1: 09H)
RDR1           .equ 0H09

; ASCI0 Extension Control Register 0 (ASEXT0: 12H)
ASEXT0         .equ 0H12

ASEXT0_RDRFI   .equ 0H80
ASEXT0_DCD0D   .equ 0H40
ASEXT0_CTS0D   .equ 0H20
ASEXT0_X1      .equ 0H10
ASEXT0_BRG0    .equ 0H08
ASEXT0_BRKE    .equ 0H04
ASEXT0_BRK     .equ 0H02
ASEXT0_SBRK    .equ 0H01

; ASCI1 Extension Control Register 1 (ASEXT1: 13H)
ASEXT1         .equ 0H13

ASEXT1_RDRFI   .equ 0H80
ASEXT1_X1      .equ 0H10
ASEXT1_BRG1    .equ 0H08
ASEXT1_BRKE    .equ 0H04
ASEXT1_BRK     .equ 0H02
ASEXT1_SBRK    .equ 0H01

; ASCI0 Time Constant Low Register (ASTC0L : 1AH)
ASTC0L         .equ 0H1A
; ASCI0 Time Constant High Register (ASTC0H: 1BH)
ASTC0H         .equ 0H1B
; ASCI1 Time Constant Low Register (ASTC1L : 1AH)
ASTC1L         .equ 0H1C
; ASCI1 Time Constant High Register (ASTC1H: 1BH)
ASTC1H         .equ 0H1D

; CSI/0
; ------------------------------------

; CSI/O Control Register (CNTR: 0AH)
CNTR           .equ 0H0A

CNTR_EF        .equ 0H80
CNTR_EIE       .equ 0H40
CNTR_RE        .equ 0H20
CNTR_TE        .equ 0H10
CNTR_SS2       .equ 0H04
CNTR_SS1       .equ 0H02
CNTR_SS0       .equ 0H01

; CSI/O Transmit/Receive Data Register (TRD: 0BH)
TRDR           .equ 0H0B

; Timer
; ------------------------------------

; Data Register Ch 0 L (TMDR0L: 0CH)
TMDR0L         .equ 0H0C
; Data Register Ch 0 H (TMDR0H: 0DH)
TMDR0H         .equ 0H0D
; Reload Register Ch 0 L (RLDR0L: OEH)
RLDR0L         .equ 0H0E
; Reload Register Ch 0 H (RLDR0H: 0FH)
RLDR0H         .equ 0H0F

; Timer Control Register (TCR: 10H)
TCR            .equ 0H10

TCR_TF1        .equ 0H80
TCR_TF0        .equ 0H40
TCR_TE1        .equ 0H20
TCR_TE0        .equ 0H10
TCR_TOC1       .equ 0H08
TCR_TOC0       .equ 0H04
TCR_TDE1       .equ 0H02
TCR_TDE0       .equ 0H01

; Data Register Ch 1 L (TMDR1L: 14h)
TMDR1L         .equ 0H14
; Data Register Ch 1 H (TMDR1H: 15H)
TMDR1H         .equ 0H15
; Reload Register Ch 1 L (RLDR1L: 16H)
RLDR1L         .equ 0H16
; Reload Register Ch 1 H (RLDR1H: 17H)
RLDR1H         .equ 0H17

; Others
; ------------------------------------

; Clock Multiplier Register (CMR: 1EH)
CMR            .equ 0H1E

CMR_X2         .equ 0H80

; Free Running Counter (FRC: 18H)
FRC            .equ 0H18

; CPU Control Register (CCR: 1FH)
CCR            .equ 0H1F
CCR_CD         .equ 0H80
CCR_SB1        .equ 0H40
CCR_BREXT      .equ 0H20
CCR_LNPHI      .equ 0H10
CCR_SB2        .equ 0H08
CCR_LNIO       .equ 0H04
CCR_LNCPU      .equ 0H02
CCR_LNAD       .equ 0H01  

; DMA
; ---------------------------------------------------------------------------


; DMA/WAIT Control Register (DCNTL: 32H)

; INT
; ---------------------------------------------------------------------------

; Interrupt Vector Low Register (IL: 33H)

; INT/TRAP Control Register (ITC: 34H)

; Refresh
; ---------------------------------------------------------------------------

; Refresh Control Register (RCR: 36H)
RCR            .equ 0H36
RCR_REFE       .equ 0H80
RCR_REFW       .equ 0H40
RCR_CYC1       .equ 0H02
RCR_CYC0       .equ 0H01

; MMU
; ---------------------------------------------------------------------------

; MMU Common Base Register (CBR: 38H)
CBR            .equ 0H38
; MMU Bank Base Register (BBR: 39H)
BBR            .equ 0H39
; MMU Common/Bank Register (CBAR: 3AH)
CBAR           .equ 0H3A 
; I/O
; ---------------------------------------------------------------------------

; Operation Mode Control Register (OMCR: 3EH)
OMCR           .equ 0H3E

OMCR_M1E       .equ 0H80
OMCR_M1TE      .equ 0H40
;OMCR_M1E       .equ 0H20

; I/O Control Register (ICR: 3FH)
ICR            .equ 0H3F

ICR_IOA7       .equ 0H80
ICR_IOA6       .equ 0H40
ICR_IOSTP      .equ 0H20
