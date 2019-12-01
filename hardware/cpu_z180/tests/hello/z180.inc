; ------------------------------------
; Z180 constants
; ------------------------------------

; ASCI
; ----------

; ASCI Control Register A 0 (CNTLA0: 00H)
DEFC CNTLA0         = $00

DEFC CNTLA0_MPE     = $80
DEFC CNTLA0_RE      = $40
DEFC CNTLA0_TE      = $20
DEFC CNTLA0_RTS0    = $10
DEFC CNTLA0_MPBR    = $08
DEFC CNTLA0_MOD2    = $04
DEFC CNTLA0_MOD1    = $02
DEFC CNTLA0_MOD0    = $01

; ASCI Control Register A 1 (CNTLA1: 01H)
DEFC CNTLA1         = $01

DEFC CNTLA1_MPE     = $80
DEFC CNTLA1_RE      = $40
DEFC CNTLA1_TE      = $20
DEFC CNTLA1_CKA1D   = $10
DEFC CNTLA1_MPBR    = $08
DEFC CNTLA1_MOD2    = $04
DEFC CNTLA1_MOD1    = $02
DEFC CNTLA1_MOD0    = $01

; ASCI Control Register B 0 (CNTLB0: 02H)
DEFC CNTLB0         = $02

DEFC CNTLB0_MPBT    = $80
DEFC CNTLB0_MP      = $40
DEFC CNTLB0_CTS     = $20
DEFC CNTLB0_PEO     = $10
DEFC CNTLB0_DR      = $08
DEFC CNTLB0_SS2     = $04
DEFC CNTLB0_SS1     = $02
DEFC CNTLB0_SS0     = $01

; ASCI Control Register B 1 (CNTLB1: 03H)
DEFC CNTLB1         = $03

DEFC CNTLB1_MPBT    = $80
DEFC CNTLB1_MP      = $40
DEFC CNTLB1_CTS     = $20
DEFC CNTLB1_PEO     = $10
DEFC CNTLB1_DR      = $08
DEFC CNTLB1_SS2     = $04
DEFC CNTLB1_SS1     = $02
DEFC CNTLB1_SS0     = $01

; ASCI Status Register 0 (STAT0: 04H)
DEFC STAT0          = $04

DEFC STAT0_RDRF     = $80
DEFC STAT0_OVRN     = $40
DEFC STAT0_PE       = $20
DEFC STAT0_FE       = $10
DEFC STAT0_RIE      = $08
DEFC STAT0_DCD0     = $04
DEFC STAT0_TDRE     = $02
DEFC STAT0_TIE      = $01

; ASCI Status Register 1 (STAT1: 05H)
DEFC STAT1          = $05

DEFC STAT1_RDRF     = $80
DEFC STAT1_OVRN     = $40
DEFC STAT1_PE       = $20
DEFC STAT1_FE       = $10
DEFC STAT1_RIE      = $08
DEFC STAT1_CTS1E    = $04
DEFC STAT1_TDRE     = $02
DEFC STAT1_TIE      = $01

; ASCI Transmit Data Register Ch. 0 (TDR0: 06H)
DEFC TDR0           = $06

; ASCI Transmit Data Register Ch. 1 (TDR1: 07H)
DEFC TDR1           = $07

; ASCI Receive Data Register Ch. 0 (RDR0: 08H)
DEFC RDR0           = $08

; ASCI Receive Data Register Ch. 1 (RDR1: 09H)
DEFC RDR1           = $09

; ASCI0 Extension Control Register 0 (ASEXT0: 12H)
DEFC ASEXT0         = $12

DEFC ASEXT0_RDRFI   = $80
DEFC ASEXT0_DCD0D   = $40
DEFC ASEXT0_CTS0D   = $20
DEFC ASEXT0_X1      = $10
DEFC ASEXT0_BRG0    = $08
DEFC ASEXT0_BRKE    = $04
DEFC ASEXT0_BRK     = $02
DEFC ASEXT0_SBRK    = $01

; ASCI1 Extension Control Register 1 (ASEXT1: 13H)
DEFC ASEXT1         = $13

DEFC ASEXT1_RDRFI   = $80
DEFC ASEXT1_X1      = $10
DEFC ASEXT1_BRG1    = $08
DEFC ASEXT1_BRKE    = $04
DEFC ASEXT1_BRK     = $02
DEFC ASEXT1_SBRK    = $01

; ASCI0 Time Constant Low Register (ASTC0L : 1AH)
DEFC ASTC0L         = $1A
; ASCI0 Time Constant High Register (ASTC0H: 1BH)
DEFC ASTC0H         = $1B
; ASCI1 Time Constant Low Register (ASTC1L : 1AH)
DEFC ASTC1L         = $1C
; ASCI1 Time Constant High Register (ASTC1H: 1BH)
DEFC ASTC1H         = $1D

; CSI/0
; ------------------------------------

; CSI/O Control Register (CNTR: 0AH)
DEFC CNTR           = $0A

DEFC CNTR_EF        = $80
DEFC CNTR_EIE       = $40
DEFC CNTR_RE        = $20
DEFC CNTR_TE        = $10
DEFC CNTR_SS2       = $04
DEFC CNTR_SS1       = $02
DEFC CNTR_SS0       = $01

; CSI/O Transmit/Receive Data Register (TRD: 0BH)
DEFC TRDR           = $0B

; Timer
; ------------------------------------

; Data Register Ch 0 L (TMDR0L: 0CH)
DEFC TMDR0L         = $0C
; Data Register Ch 0 H (TMDR0H: 0DH)
DEFC TMDR0H         = $0D
; Reload Register Ch 0 L (RLDR0L: OEH)
DEFC RLDR0L         = $0E
; Reload Register Ch 0 H (RLDR0H: 0FH)
DEFC RLDR0H         = $0F

; Timer Control Register (TCR: 10H)
DEFC TCR            = $10

DEFC TCR_TF1        = $80
DEFC TCR_TF0        = $40
DEFC TCR_TE1        = $20
DEFC TCR_TE0        = $10
DEFC TCR_TOC1       = $08
DEFC TCR_TOC0       = $04
DEFC TCR_TDE1       = $02
DEFC TCR_TDE0       = $01

; Data Register Ch 1 L (TMDR1L: 14h)
DEFC TMDR1L         = $14
; Data Register Ch 1 H (TMDR1H: 15H)
DEFC TMDR1H         = $15
; Reload Register Ch 1 L (RLDR1L: 16H)
DEFC RLDR1L         = $16
; Reload Register Ch 1 H (RLDR1H: 17H)
DEFC RLDR1H         = $17

; Others
; ------------------------------------

; Clock Multiplier Register (CMR: 1EH)
DEFC CMR            = $1E

DEFC CMR_X2         = $80

; Free Running Counter (FRC: 18H)
DEFC FRC            = $18

; CPU Control Register (CCR: 1FH)
DEFC CCR            = $1F
DEFC CCR_CD         = $80
DEFC CCR_SB1        = $40
DEFC CCR_BREXT      = $20
DEFC CCR_LNPHI      = $10
DEFC CCR_SB2        = $08
DEFC CCR_LNIO       = $04
DEFC CCR_LNCPU      = $02
DEFC CCR_LNAD       = $01  

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
DEFC RCR            = $36
DEFC RCR_REFE       = $80
DEFC RCR_REFW       = $40
DEFC RCR_CYC1       = $02
DEFC RCR_CYC0       = $01

; MMU
; ---------------------------------------------------------------------------

; MMU Common Base Register (CBR: 38H)
DEFC CBR            = $38
; MMU Bank Base Register (BBR: 39H)
DEFC BBR            = $39
; MMU Common/Bank Register (CBAR: 3AH)
DEFC CBAR           = $3A 
; I/O
; ---------------------------------------------------------------------------

; Operation Mode Control Register (OMCR: 3EH)
DEFC OMCR           = $3E

DEFC OMCR_M1E       = $80
DEFC OMCR_M1TE      = $40
;DEFC OMCR_M1E       = $20

; I/O Control Register (ICR: 3FH)
DEFC ICR            = $3F

DEFC ICR_IOA7       = $80
DEFC ICR_IOA6       = $40
DEFC ICR_IOSTP      = $20
