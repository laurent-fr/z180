; NASCOM ROM BASIC Ver 4.7, (C) 1978 Microsoft
; Scanned from source published in 80-BUS NEWS from Vol 2, Issue 3
; (May-June 1983) to Vol 3, Issue 3 (May-June 1984)
; Adapted for the freeware Zilog Macro Assembler 2.10 to produce
; the original ROM code (checksum 0xA934). PA

.z180

.area CODE (ABS)


; MONITOR EQUATES (RESTART INSTRUCTIONS)

_ROUT   .equ     0xF7            ; ROUT - Output char in A
_BLNK   .equ     0x7BDF          ; SCAL BLINK - Get input char in A
_INLN   .equ     0x63DF          ; SCAL INLIN - Get input line
_MFLP   .equ     0x5FDF          ; SCAL MFLP - Toggle tape drv LED
_MRET   .equ     0x5BDF          ; SCAL MRET - Return to monitor
_READ   .equ     0x52DF          ; SCAL READ
_RIN    .equ     0x62DF          ; SCAL RIN - Scan for input char
_VRFY   .equ     0x56DF          ; SCAL VERIFY
_WRIT   .equ     0x57DF          ; SCAL WRITE

; GENERAL .equATES

UARTD   .equ     0x01             ; UART data port
UARTS   .equ     0x02             ; UART status port
CTRLC   .equ     0x03             ; Control "C"
CTRLG   .equ     0x07             ; Control "G"
BKSP    .equ     0x08             ; Back space
LF      .equ     0x0A             ; Line feed
CS      .equ     0x0C             ; Clear screen
CR      .equ     0x0D             ; Carriage return
CTRLO   .equ     0x0F             ; Control "O"
CTRLR   .equ     0x12             ; Control "R"
CTRLS   .equ     0x13             ; Control "S"
CTRLU   .equ     0x15             ; Control "U"
CTRLZ   .equ     0x1A             ; Control "Z"
ESC     .equ     0x1B             ; Escape
TBRK    .equ     0x1C             ; "T" monitor break
TBS     .equ     0x1D             ; "T" monitor back space
TCS     .equ     0x1E             ; "T" monitor clear screen
TCR     .equ     0x1F             ; "T" monitor carriage return
DEL     .equ     0x7F             ; Delete

; MONITOR LOCATIONS

MONSTT  .equ     0x0000           ; Start of monitor
STMON   .equ     0x000D           ; NAS-SYS initialisation
MFLP    .equ     0x0051           ; Flip tape LED ("T")
MONTYP  .equ     0x008D           ; Type of "T" monitor
T2DUMP  .equ     0x03D1           ; "T2" Dump routine
T4WR    .equ     0x0400           ; "T4" Write routine
T4READ  .equ     0x070C           ; "T4" Read routine
VDU     .equ     0x0800           ; NASCOM Video RAM base

; MONITOR WORK SPACE LOCATIONS

PORT0   .equ     0x0C00           ; Copy of output port 0
ARG1    .equ     0x0C0C           ; Argument 1
ARG2    .equ     0x0C0E           ; Argument 2
TCUR    .equ     0x0C18           ; "T" monitor cursor
CURSOR  .equ     0x0C29           ; NAS-SYS Cursor
ARGN    .equ     0x0C2B           ; Number of ARGS
TOUT    .equ     0x0C4A           ; "T" Output reflection
TIN     .equ     0x0C4D           ; "T" Input reflection
CIN     .equ     0x0C75           ; NAS-SYS Input table
NMI     .equ     0x0C7E           ; NAS-SYS NMI Jump

; BASIC WORK SPACE LOCATIONS

WRKSPC  .equ     0x1000           ; BASIC Work space
USR     .equ     0x1003           ; "USR (x)" jump
OUTSUB  .equ     0x1006           ; "OUT p,n"
OTPORT  .equ     0x1007           ; Port (p)
DIVSUP  .equ     0x1009           ; Division support routine
DIV1    .equ     0x100A           ; <- Values
DIV2    .equ     0x100E           ; <-   to
DIV3    .equ     0x1012           ; <-   be
DIV4    .equ     0x1015           ; <-inserted
SEED    .equ     0x1017           ; Random number seed
LSTRND  .equ     0x103A           ; Last random number
INPSUB  .equ     0x103E           ; #INP (x)" Routine
INPORT  .equ     0x103F           ; PORT (x)
NULLS   .equ     0x1041           ; Number of nulls
LWIDTH  .equ     0x1042           ; Terminal width
COMMAN  .equ     0x1043           ; Width for commas
NULFLG  .equ     0x1044           ; Null after input byte flag
CTLOFG  .equ     0x1045           ; Control "O" flag
LINESC  .equ     0x1046           ; Lines counter
LINESN  .equ     0x1048           ; Lines number
CHKSUM  .equ     0x104A           ; Array load/save check sum
NMIFLG  .equ     0x104C           ; Flag for NMI break routine
BRKFLG  .equ     0x104D           ; Break flag
RINPUT  .equ     0x104E           ; Input reflection
POINT   .equ     0x1051           ; "POINT" reflection (unused)
PSET    .equ     0x1054           ; "SET"   reflection
RESET   .equ     0x1057           ; "RESET" reflection
STRSPC  .equ     0x105A           ; Bottom of string space
LINEAT  .equ     0x105C           ; Current line number
BASTXT  .equ     0x105E           ; Pointer to start of program
BUFFER  .equ     0x1061           ; Input buffer
STACK   .equ     0x1066           ; Initial stack
CURPOS  .equ     0x10AB           ; Character position on line
LCRFLG  .equ     0x10AC           ; Locate/Create flag
TYPE    .equ     0x10AD           ; Data type flag
DATFLG  .equ     0x10AE           ; Literal statement flag
LSTRAM  .equ     0x10AF           ; Last available RAM
TMSTPT  .equ     0x10B1           ; Temporary string pointer
TMSTPL  .equ     0x10B3           ; Temporary string pool
TMPSTR  .equ     0x10BF           ; Temporary string
STRBOT  .equ     0x10C3           ; Bottom of string space
CUROPR  .equ     0x10C5           ; Current operator in EVAL
LOOPST  .equ     0x10C7           ; First statement of loop
DATLIN  .equ     0x10C9           ; Line of current DATA item
FORFLG  .equ     0x10CB           ; "FOR" loop flag
LSTBIN  .equ     0x10CC           ; Last byte entered
READFG  .equ     0x10CD           ; Read/Input flag
BRKLIN  .equ     0x10CE           ; Line of break
NXTOPR  .equ     0x10D0           ; Next operator in EVAL
ERRLIN  .equ     0x10D2           ; Line of error
CONTAD  .equ     0x10D4           ; Where to CONTinue
PROGND  .equ     0x10D6           ; End of program
VAREND  .equ     0x10D8           ; End of variables
ARREND  .equ     0x10DA           ; End of arrays
NXTDAT  .equ     0x10DC           ; Next data item
FNRGNM  .equ     0x10DE           ; Name of FN argument
FNARG   .equ     0x10E0           ; FN argument value
FPREG   .equ     0x10E4           ; Floating point register
FPEXP   .equ     FPREG+3         ; Floating point exponent
SGNRES  .equ     0x10E8           ; Sign of result
PBUFF   .equ     0x10E9           ; Number print buffer
MULVAL  .equ     0x10F6           ; Multiplier
PROGST  .equ     0x10F9           ; Start of program text area
STLOOK  .equ     0x115D           ; Start of memory test

; BASIC ERROR CODE VALUES

NF      .equ     0x00             ; NEXT without FOR
SN      .equ     0x02             ; Syntax error
RG      .equ     0x04             ; RETURN without GOSUB
OD      .equ     0x06             ; Out of DATA
FC      .equ     0x08             ; Function call error
OV      .equ     0x0A             ; Overflow
OM      .equ     0x0C             ; Out of memory
UL      .equ     0x0E             ; Undefined line number
BS      .equ     0x10             ; Bad subscript
DD      .equ     0x12             ; Re-DIMensioned array
DZ      .equ     0x14             ; Division by zero (/0)
ID      .equ     0x16             ; Illegal direct
TM      .equ     0x18             ; Type miss-match
OS      .equ     0x1A             ; Out of string space
LS      .equ     0x1C             ; String too long
ST      .equ     0x1E             ; String formula too complex
CN      .equ     0x20             ; Can't CONTinue
UF      .equ     0x22             ; UnDEFined FN function
MO      .equ     0x24             ; Missing operand

        .org     0xE000

START:  JP      STARTB          ; Jump for restart jump
STARTB: DI                      ; No interrupts
        LD      IX,#0            ; Flag cold start
        JP      CSTART          ; Jump to initialise

        .dw      DEINT           ; Get integer -32768 to 32767
        .dw      ABPASS          ; Return integer in AB

        JP      LDNMI1          ; << NO REFERENCE TO HERE >>

CSTART: LD      HL,#WRKSPC       ; Start of workspace RAM
        LD      SP,HL           ; Set up a temporary stack
        JP      INITST          ; Go to initialise

INIT:   LD      DE,#INITAB       ; Initialise workspace
        LD      B,#INITBE-#INITAB+#3; Bytes to copy
        LD      HL,#WRKSPC       ; Into workspace RAM
COPY:   LD      A,(DE)          ; Get source
        LD      (HL),A          ; To destination
        INC     HL              ; Next destination
        INC     DE              ; Next source
        DEC     B               ; Count bytes
        JP      NZ,#COPY         ; More to move
        LD      SP,HL           ; Temporary stack
        CALL    CLREG           ; Clear registers and stack
        CALL    PRNTCR          ; Output CRLF
        LD      (BUFFER+72+1),A ; Mark end of buffer
        LD      (PROGST),A      ; Initialise program area
MSIZE:  LD      HL,#MEMMSG       ; Point to message
        CALL    PRS             ; Output "Memory size"
        CALL    PROMPT          ; Get input with "?"
        CALL    GETCHR          ; Get next character
        OR      A               ; Set flags
        JP      NZ,TSTMEM       ; If number - Test if RAM there
        LD      HL,#STLOOK       ; Point to start of RAM
MLOOP:  INC     HL              ; Next byte
        LD      A,H             ; Above address FFFF ?
        OR      L
        JP      Z,SETTOP        ; Yes - 64K RAM
        LD      A,(HL)          ; Get contents
        LD      B,A             ; Save it
        CPL                     ; Flip all bits
        LD      (HL),A          ; Put it back
        CP      (HL)            ; RAM there if same
        LD      (HL),B          ; Restore old contents
        JP      Z,MLOOP         ; If RAM - test next byte
        JP      SETTOP          ; Top of RAM found

TSTMEM: CALL    ATOH            ; Get high memory into DE
        OR      A               ; Set flags on last byte
        JP      NZ,SNERR        ; ?SN Error if bad character
        EX      DE,HL           ; Address into HL
        DEC     HL              ; Back one byte
        LD      A,#0b11011001     ; Test byte
        LD      B,(HL)          ; Get old contents
        LD      (HL),A          ; Load test byte
        CP      (HL)            ; RAM there if same
        LD      (HL),B          ; Restore old contents
        JP      NZ,MSIZE        ; Ask again if no RAM

SETTOP: DEC     HL              ; Back one byte
        LD      DE,#STLOOK-1     ; See if enough RAM
        CALL    CPDEHL          ; Compare DE with HL
        JP      C,MSIZE         ; Ask again if not enough RAM
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        LD      DE,#0-50         ; 50 Bytes string space
        LD      (LSTRAM),HL     ; Save last available RAM
        ADD     HL,DE           ; Allocate string space
        LD      (STRSPC),HL     ; Save string space
        CALL    CLRPTR          ; Clear program area
        LD      HL,(STRSPC)     ; Get end of memory
        LD      DE,#0-17         ; Offset for free bytes
        ADD     HL,DE           ; Adjust HL
        LD      DE,#PROGST       ; Start of program text
        LD      A,L             ; Get LSB
        SUB     E               ; Adjust it
        LD      L,A             ; Re-save
        LD      A,H             ; Get MSB
        SBC     A,D             ; Adjust it
        LD      H,A             ; Re-save
        PUSH    HL              ; Save bytes free
        LD      HL,#SIGNON       ; Sign-on message
        CALL    PRS             ; Output string
        POP     HL              ; Get bytes free back
        CALL    PRNTHL          ; Output amount of free memory
        LD      HL,#BFREE        ; " Bytes free" message
        CALL    PRS             ; Output string

WARMST: LD      SP,#STACK        ; Temporary stack
BRKRET: CALL    CLREG           ; Clear registers and stack
        JP      PRNTOK          ; Go to get command line

BFREE:  .ascii      " Bytes free"
        .db         CR,0,0

SIGNON: .ascii      "NASCOM ROM BASIC Ver 4.7   "
        .db CR
        .ascii      "Copyright (C) 1978 by Microsoft"
        .db CR,0,0

MEMMSG: .ascii      "Memory size"
        .db 0

; FUNCTION ADDRESS TABLE

FNCTAB: .dw      SGN
        .dw      INT
        .dw      ABS
        .dw      USR
        .dw      FRE
        .dw      INP
        .dw      POS
        .dw      SQR
        .dw      RND
        .dw      LOG
        .dw      EXP
        .dw      COS
        .dw      SIN
        .dw      TAN
        .dw      ATN
        .dw      PEEK
        .dw      DEEK
        .dw      POINT
        .dw      LEN
        .dw      STR
        .dw      VAL
        .dw      ASC
        .dw      CR
        .dw      LEFT
        .dw      RIGHT
        .dw      MID

; RESERVED WORD LIST

WORDS:  .db      "E"+0x80,"N","D"
        .db      "F"+0x80,"O","R"
        .db      "N"+0x80,"E","X","T"
        .db      "D"+0x80,"A","T","A"
        .db      "I"+0x80,"N","P","U","T"
        .db      "D"+0x80,"I","M"
        .db      "R"+0x80,"E","A","D"
        .db      "L"+0x80,"E","T"
        .db      "G"+0x80,"O","T","O"
        .db      "R"+0x80,"U","N"
        .db      "I"+0x80,"F"
        .db      "R"+0x80,"E","S","T","O","R","E"
        .db      "G"+0x80,"O","S","U","B"
        .db      "R"+0x80,"E","T","U","R","N"
        .db      "R"+0x80,"E","M"
        .db      "S"+0x80,"T","O","P"
        .db      "O"+0x80,"U","T"
        .db      "O"+0x80,"N"
        .db      "N"+0x80,"U","L","L"
        .db      "W"+0x80,"A","I","T"
        .db      "D"+0x80,"E","F"
        .db      "P"+0x80,"O","K","E"
        .db      "D"+0x80,"O","K","E"
        .db      "S"+0x80,"C","R","E","E","N"
        .db      "L"+0x80,"I","N","E","S"
        .db      "C"+0x80,"L","S"
        .db      "W"+0x80,"I","D","T","H"
        .db      "M"+0x80,"O","N","I","T","O","R"
        .db      "S"+0x80,"E","T"
        .db      "R"+0x80,"E","S","E","T"
        .db      "P"+0x80,"R","I","N","T"
        .db      "C"+0x80,"O","N","T"
        .db      "L"+0x80,"I","S","T"
        .db      "C"+0x80,"L","E","A","R"
        .db      "C"+0x80,"L","O","A","D"
        .db      "C"+0x80,"S","A","V","E"
        .db      "N"+0x80,"E","W"
        .db      "T"+0x80,"A","B","("
        .db      "T"+0x80,"O"
        .db      "F"+0x80,"N"
        .db      "S"+0x80,"P","C","("
        .db      "T"+0x80,"H","E","N"
        .db      "N"+0x80,"O","T"
        .db      "S"+0x80,"T","E","P"

        .db      "+"+0x80
        .db      "-"+0x80
        .db      "*"+0x80
        .db      "/"+0x80
        .db      "^"+0x80
        .db      "A"+0x80,"N","D"
        .db      "O"+0x80,"R"
        .db      ">"+0x80
        .db      "="+0x80
        .db      "<"+0x80

        .db      "S"+0x80,"G","N"
        .db      "I"+0x80,"N","T"
        .db      "A"+0x80,"B","S"
        .db      "U"+0x80,"S","R"
        .db      "F"+0x80,"R","E"
        .db      "I"+0x80,"N","P"
        .db      "P"+0x80,"O","S"
        .db      "S"+0x80,"Q","R"
        .db      "R"+0x80,"N","D"
        .db      "L"+0x80,"O","G"
        .db      "E"+0x80,"X","P"
        .db      "C"+0x80,"O","S"
        .db      "S"+0x80,"I","N"
        .db      "T"+0x80,"A","N"
        .db      "A"+0x80,"T","N"
        .db      "P"+0x80,"E","E","K"
        .db      "D"+0x80,"E","E","K"
        .db      "P"+0x80,"O","I","N","T"
        .db      "L"+0x80,"E","N"
        .db      "S"+0x80,"T","R","$"
        .db      "V"+0x80,"A","L"
        .db      "A"+0x80,"S","C"
        .db      "C"+0x80,"H","R","$"
        .db      "L"+0x80,"E","F","T","$"
        .db      "R"+0x80,"I","G","H","T","$"
        .db      "M"+0x80,"I","D","$"
        .db      0x80             ; End of list marker

; KEYWORD ADDRESS TABLE

WORDTB: .dw      PEND
        .dw      FOR
        .dw      NEXT
        .dw      DATA
        .dw      INPUT
        .dw      DIM
        .dw      READ
        .dw      LET
        .dw      GOTO
        .dw      RUN
        .dw      IF
        .dw      RESTOR
        .dw      GOSUB
        .dw      RETURN
        .dw      REM
        .dw      STOP
        .dw      POUT
        .dw      ON
        .dw      NULL
        .dw      WAIT
        .dw      DEF
        .dw      POKE
        .dw      DOKE
        .dw      SCREEN
        .dw      LINES
        .dw      CLS
        .dw      WIDTH
        .dw      MONITR
        .dw      PSET
        .dw      RESET
        .dw      PRINT
        .dw      CONT
        .dw      LIST
        .dw      CLEAR
        .dw      CLOAD
        .dw      CSAVE
        .dw      NEW

; RESERVED WORD TOKEN VALUES

ZEND    .equ     0x080            ; END
ZFOR    .equ     0x081            ; FOR
ZDATA   .equ     0x083            ; DATA
ZGOTO   .equ     0x088            ; GOTO
ZGOSUB  .equ     0x08C            ; GOSUB
ZREM    .equ     0x08E            ; REM
ZPRINT  .equ     0x09E            ; PRINT
ZNEW    .equ     0x0A4            ; NEW

ZTAB    .equ     0x0A5            ; TAB
ZTO     .equ     0x0A6            ; TO
ZFN     .equ     0x0A7            ; FN
ZSPC    .equ     0x0A8            ; SPC
ZTHEN   .equ     0x0A9            ; THEN
ZNOT    .equ     0x0AA            ; NOT
ZSTEP   .equ     0x0AB            ; STEP

ZPLUS   .equ     0x0AC            ; +
ZMINUS  .equ     0x0AD            ; -
ZTIMES  .equ     0x0AE            ; *
ZDIV    .equ     0x0AF            ; /
ZOR     .equ     0x0B2            ; OR
ZGTR    .equ     0x0B3            ; >
ZEQUAL  .equ     0x0B4            ; M
ZLTH    .equ     0x0B5            ; <
ZSGN    .equ     0x0B6            ; SGN
ZPOINT  .equ     0x0C7            ; POINT
ZLEFT   .equ     0x0CD            ; LEFT$

; ARITHMETIC PRECEDENCE TABLE

PRITAB: .db      0x79             ; Precedence value
        .dw      PADD            ; FPREG = <last> + FPREG

        .db      0x79             ; Precedence value
        .dw      PSUB            ; FPREG = <last> - FPREG

        .db      0x7C             ; Precedence value
        .dw      MULT            ; PPREG = <last> * FPREG

        .db      0x7C             ; Precedence value
        .dw      DIV             ; FPREG = <last> / FPREG

        .db      0x7F             ; Precedence value
        .dw      POWER           ; FPREG = <last> ^ FPREG

        .db      0x50             ; Precedence value
        .dw      PAND            ; FPREG = <last> AND FPREG

        .db      0x46             ; Precedence value
        .dw      POR             ; FPREG = <last> OR FPREG

; BASIC ERROR CODE LIST

ERRORS: .db      "N","F"            ; NEXT without FOR
        .db      "S","N"            ; Syntax error
        .db      "R","G"            ; RETURN without GOSUB
        .db      "O","D"            ; Out of DATA
        .db      "F","C"            ; Illegal function call
        .db      "O","V"            ; Overflow error
        .db      "O","M"            ; Out of memory
        .db      "U","L"            ; Undefined line
        .db      "B","S"            ; Bad subscript
        .db      "D","D"            ; Re-DIMensioned array
        .db      "/","0"            ; Division by zero
        .db      "I","D"            ; Illegal direct
        .db      "T","M"            ; Type mis-match
        .db      "O","S"            ; Out of string space
        .db      "L","S"            ; String too long
        .db      "S","T"            ; String formula too complex
        .db      "C","N"            ; Can't CONTinue
        .db      "U","F"            ; Undefined FN function
        .db      "M","O"            ; Missing operand

; INITIALISATION TABLE

INITAB: JP      WARMST          ; Warm start jump
        JP      FCERR           ; "USR (X)" jump (Set to Error)

        OUT     (0),A           ; "OUT p,n" skeleton
        RET

        SUB     #0               ; Division support routine
        LD      L,A
        LD      A,H
        SBC     A,#0
        LD      H,A
        LD      A,B
        SBC     A,#0
        LD      B,A
        LD      A,#0
        RET

        .db      0,0,0                   ; Random number seed
                                        ; Table used by RND
        .db      0x35,0x4A,0xCA,0x99     ;-2.65145E+07
        .db      0x39,0x1C,0x76,0x98     ; 1.61291E+07
        .db      0x22,0x95,0xB3,0x98     ;-1.17691E+07
        .db      0x0A,0xDD,0x47,0x98     ; 1.30983E+07
        .db      0x53,0xD1,0x99,0x99     ;-2-01612E+07
        .db      0x0A,0x1A,0x9F,0x98     ;-1.04269E+07
        .db      0x65,0xBC,0xCD,0x98     ;-1.34831E+07
        .db      0xD6,0x77,0x3E,0x98     ; 1.24825E+07
        .db      0x52,0xC7,0x4F,0x80     ; Last random number

        IN      A,(0)           ; INP (x) skeleton
        RET

        .db      1               ; POS (x) number (1)
        .db      47              ; Terminal width (47)
        .db      28              ; Width for commas (3 columns)
        .db      0               ; No nulls after input bytes
        .db      0               ; Output enabled (^O off)

        .dw      5               ; Initial lines counter
        .dw      5               ; Initial lines number
        .dw      0               ; Array load/save check sum

        .db      0               ; Break not by NMI
        .db      0               ; Break flag

        JP      TTYLIN          ; Input reflection (set to TTY)
        JP      POINTB          ; POINT reflection unused
        JP      SETB            ; SET reflection
        JP      RESETB          ; RESET reflection

        .dw      STLOOK          ; Temp string space
        .dw      -2              ; Current line number (cold)
        .dw      PROGST+1        ; Start of program text
INITBE:                         ; END OF INITIALISATION TABLE

ERRMSG: .ascii      " Error"
        .db 0
INMSG:  .ascii      " in "
        .db 0
ZERBYT:  .dw     0             ; A zero byte
OKMSG:  .ascii     "Ok"
        .db     CR,0,0
BRKMSG: .ascii      "Break"
        .db 0

BAKSTK: LD      HL,#4            ; Look for "FOR" block with
        ADD     HL,SP           ; same index as specified
LOKFOR: LD      A,(HL)          ; Get block ID
        INC     HL              ; Point to index address
        CP      #ZFOR            ; Is it a "FOR" token
        RET     NZ              ; No - exit
        LD      C,(HL)          ; BC = Address of "FOR" index
        INC     HL
        LD      B,(HL)
        INC     HL              ; Point to sign of STEP
        PUSH    HL              ; Save pointer to sign
        LD      L,C             ; HL = address of "FOR" index
        LD      H,B
        LD      A,D             ; See if an index was specified
        OR      E               ; DE = 0 if no index specified
        EX      DE,HL           ; Specified index into HL
        JP      Z,INDFND        ; Skip if no index given
        EX      DE,HL           ; Index back into DE
        CALL    CPDEHL          ; Compare index with one given
INDFND: LD      BC,#16-3         ; Offset to next block
        POP     HL              ; Restore pointer to sign
        RET     Z               ; Return if block found
        ADD     HL,BC           ; Point to next block
        JP      LOKFOR          ; Keep on looking

MOVUP:  CALL    ENFMEM          ; See if enough memory
MOVSTR: PUSH    BC              ; Save end of source
        EX      (SP),HL         ; Swap source and dest" end
        POP     BC              ; Get end of destination
MOVLP:  CALL    CPDEHL          ; See if list moved
        LD      A,(HL)          ; Get byte
        LD      (BC),A          ; Move it
        RET     Z               ; Exit if all done
        DEC     BC              ; Next byte to move to
        DEC     HL              ; Next byte to move
        JP      MOVLP           ; Loop until all bytes moved

CHKSTK: PUSH    HL              ; Save code string address
        LD      HL,(ARREND)     ; Lowest free memory
        LD      B,#0             ; BC = Number of levels to test
        ADD     HL,BC           ; 2 Bytes for each level
        ADD     HL,BC
        .db      0x3E             ; Skip "PUSH HL"
ENFMEM: PUSH    HL              ; Save code string address
        LD      A,#-48   ;TODO   ; 48 Bytes minimum RAM
        SUB     L
        LD      L,A
        LD      A,#-48   ;TODO   ; 48 Bytes minimum RAM
        SBC     A,H
        JP      C,OMERR         ; Not enough - ?OM Error
        LD      H,A
        ADD     HL,SP           ; Test if stack is overflowed
        POP     HL              ; Restore code string address
        RET     C               ; Return if enough mmory
OMERR:  LD      E,#OM            ; ?OM Error
        JP      ERROR

DATSNR: LD      HL,(DATLIN)     ; Get line of current DATA item
        LD      (LINEAT),HL     ; Save as current line
SNERR:  LD      E,#SN            ; ?SN Error
        .db      0x01             ; Skip "LD E,DZ"
DZERR:  LD      E,#DZ            ; ?/0 Error
        .db      0x01             ; Skip "LD E,NF"
NFERR:  LD      E,#NF            ; ?NF Error
        .db      0x01             ; Skip "LD E,DD"
DDERR:  LD      E,#DD            ; ?DD Error
        .db      0x01             ; Skip "LD E,UF"
UFERR:  LD      E,#UF            ; ?UF Error
        .db      0x01             ; Skip "LD E,OV
OVERR:  LD      E,#OV            ; ?OV Error
        .db      0x01             ; Skip "LD E,TM"
TMERR:  LD      E,#TM            ; ?TM Error

ERROR:  CALL    CLREG           ; Clear registers and stack
        LD      (CTLOFG),A      ; Enable output (A is 0)
        CALL    STTLIN          ; Start new line
        LD      HL,#ERRORS       ; Point to error codes
        LD      D,A             ; D = 0 (A is 0)
        LD      A,#"?"
        CALL    OUTC            ; Output "?"
        ADD     HL,DE           ; Offset to correct error code
        LD      A,(HL)          ; First character
        CALL    OUTC            ; Output it
        CALL    GETCHR          ; Get next character
        CALL    OUTC            ; Output it
        LD      HL,#ERRMSG       ; "Error" message
ERRIN:  CALL    PRS             ; Output message
        LD      HL,(LINEAT)     ; Get line of error
        LD      DE,#-2           ; Cold start error if -2
        CALL    CPDEHL          ; See if cold start error
        JP      Z,CSTART        ; Cold start error - Restart
        LD      A,H             ; Was it a direct error?
        AND     L               ; Line = -1 if direct error
        INC     A
        CALL    NZ,LINEIN       ; No - output line of error
        .db      0x3E             ; Skip "POP BC"
POPNOK: POP     BC              ; Drop address in input buffer

PRNTOK: XOR     A               ; Output "Ok" and get command
        LD      (CTLOFG),A      ; Enable output
        CALL    STTLIN          ; Start new line
        LD      HL,#OKMSG        ; "Ok" message
        CALL    PRS             ; Output "Ok"
GETCMD: LD      HL,#-1           ; Flag direct mode
        LD      (LINEAT),HL     ; Save as current line
        CALL    GETLIN          ; Get an input line
        JP      C,GETCMD        ; Get line again if break
        CALL    GETCHR          ; Get first character
        INC     A               ; Test if end of line
        DEC     A               ; Without affecting Carry
        JP      Z,GETCMD        ; Nothing entered - Get another
        PUSH    AF              ; Save Carry status
        CALL    ATOH            ; Get line number into DE
        PUSH    DE              ; Save line number
        CALL    CRUN0xC          ; Tokenise rest of line
        LD      B,A             ; Length of tokenised line
        POP     DE              ; Restore line number
        POP     AF              ; Restore Carry
        JP      NC,EXCUTE       ; No line number - Direct mode
        PUSH    DE              ; Save line number
        PUSH    BC              ; Save length of tokenised line
        XOR     A
        LD      (LSTBIN),A      ; Clear last byte input
        CALL    GETCHR          ; Get next character
        OR      A               ; Set flags
        PUSH    AF              ; And save them
        CALL    SRCHLN          ; Search for line number in DE
        JP      C,LINFND        ; Jump if line found
        POP     AF              ; Get status
        PUSH    AF              ; And re-save
        JP      Z,ULERR         ; Nothing after number - Error
        OR      A               ; Clear Carry
LINFND: PUSH    BC              ; Save address of line in prog
        JP      NC,INEWLN       ; Line not found - Insert new
        EX      DE,HL           ; Next line address in DE
        LD      HL,(PROGND)     ; End of program
SFTPRG: LD      A,(DE)          ; Shift rest of program down
        LD      (BC),A
        INC     BC              ; Next destination
        INC     DE              ; Next source
        CALL    CPDEHL          ; All done?
        JP      NZ,SFTPRG       ; More to do
        LD      H,B             ; HL - New end of program
        LD      L,C
        LD      (PROGND),HL     ; Update end of program

INEWLN: POP     DE              ; Get address of line,
        POP     AF              ; Get status
        JP      Z,SETPTR        ; No text - Set up pointers
        LD      HL,(PROGND)     ; Get end of program
        EX      (SP),HL         ; Get length of input line
        POP     BC              ; End of program to BC
        ADD     HL,BC           ; Find new end
        PUSH    HL              ; Save new end
        CALL    MOVUP           ; Make space for line
        POP     HL              ; Restore new end
        LD      (PROGND),HL     ; Update end of program pointer
        EX      DE,HL           ; Get line to move up in HL
        LD      (HL),H          ; Save MSB
        POP     DE              ; Get new line number
        INC     HL              ; Skip pointer
        INC     HL
        LD      (HL),E          ; Save LSB of line number
        INC     HL
        LD      (HL),D          ; Save MSB of line number
        INC     HL              ; To first byte in line
        LD      DE,#BUFFER       ; Copy buffer to program
MOVBUF: LD      A,(DE)          ; Get source
        LD      (HL),A          ; Save destinations
        INC     HL              ; Next source
        INC     DE              ; Next destination
        OR      A               ; Done?
        JP      NZ,MOVBUF       ; No - Repeat
SETPTR: CALL    RUNFST          ; Set line pointers
        INC     HL              ; To LSB of pointer
        EX      DE,HL           ; Address to DE
PTRLP:  LD      H,D             ; Address to HL
        LD      L,E
        LD      A,(HL)          ; Get LSB of pointer
        INC     HL              ; To MSB of pointer
        OR      (HL)            ; Compare with MSB pointer
        JP      Z,GETCMD        ; Get command line if end
        INC     HL              ; To LSB of line number
        INC     HL              ; Skip line number
        INC     HL              ; Point to first byte in line
        XOR     A               ; Looking for 00 byte
FNDEND: CP      (HL)            ; Found end of line?
        INC     HL              ; Move to next byte
        JP      NZ,FNDEND       ; No - Keep looking
        EX      DE,HL           ; Next line address to HL
        LD      (HL),E          ; Save LSB of pointer
        INC     HL
        LD      (HL),D          ; Save MSB of pointer
        JP      PTRLP           ; Do next line

SRCHLN: LD      HL,(BASTXT)     ; Start of program text
SRCHLP: LD      B,H             ; BC = Address to look at
        LD      C,L
        LD      A,(HL)          ; Get address of next line
        INC     HL
        OR      (HL)            ; End of program found?
        DEC     HL
        RET     Z               ; Yes - Line not found
        INC     HL
        INC     HL
        LD      A,(HL)          ; Get LSB of line number
        INC     HL
        LD      H,(HL)          ; Get MSB of line number
        LD      L,A
        CALL    CPDEHL          ; Compare with line in DE
        LD      H,B             ; HL = Start of this line
        LD      L,C
        LD      A,(HL)          ; Get LSB of next line address
        INC     HL
        LD      H,(HL)          ; Get MSB of next line address
        LD      L,A             ; Next line to HL
        CCF
        RET     Z               ; Lines found - Exit
        CCF
        RET     NC              ; Line not found,at line after
        JP      SRCHLP          ; Keep looking

NEW:    RET     NZ              ; Return if any more on line
CLRPTR: LD      HL,(BASTXT)     ; Point to start of program
        XOR     A               ; Set program area to empty
        LD      (HL),A          ; Save LSB = 00
        INC     HL
        LD      (HL),A          ; Save MSB = 00
        INC     HL
        LD      (PROGND),HL     ; Set program end

RUNFST: LD      HL,(BASTXT)     ; Clear all variables
        DEC     HL

INTVAR: LD      (BRKLIN),HL     ; Initialise RUN variables
        LD      HL,(LSTRAM)     ; Get end of RAM
        LD      (STRBOT),HL     ; Clear string space
        XOR     A
        CALL    RESTOR          ; Reset DATA pointers
        LD      HL,(PROGND)     ; Get end of program
        LD      (VAREND),HL     ; Clear variables
        LD      (ARREND),HL     ; Clear arrays

CLREG:  POP     BC              ; Save return address
        LD      HL,(STRSPC)     ; Get end of working RAN
        LD      SP,HL           ; Set stack
        LD      HL,#TMSTPL       ; Temporary string pool
        LD      (TMSTPT),HL     ; Reset temporary string ptr
        XOR     A               ; A = 00
        LD      L,A             ; HL = 0000
        LD      H,A
        LD      (CONTAD),HL     ; No CONTinue
        LD      (FORFLG),A      ; Clear FOR flag
        LD      (FNRGNM),HL     ; Clear FN argument
        PUSH    HL              ; HL = 0000
        PUSH    BC              ; Put back return
DOAGN:  LD      HL,(BRKLIN)     ; Get address of code to RUN
        RET                     ; Return to execution driver

PROMPT: LD      A,#"?"           ; "?"
        CALL    OUTC            ; Output character
        LD      A,#" "           ; Space
        CALL    OUTC            ; Output character
        JP      RINPUT          ; Get input line

CRUN0xC: XOR     A               ; Tokenise line @ HL to BUFFER
        LD      (DATFLG),A      ; Reset literal flag
        LD      C,#2+3           ; 2 byte number and 3 nulls
        LD      DE,#BUFFER       ; Start of input buffer
CRNCLP: LD      A,(HL)          ; Get byte
        CP      #" "             ; Is it a space?
        JP      Z,MOVDIR        ; Yes - Copy direct
        LD      B,A             ; Save character
        CP      #'"'             ; Is it a quote?"
        JP      Z,CPYLIT        ; Yes - Copy literal string
        OR      A               ; Is it end of buffer?
        JP      Z,ENDBUF        ; Yes - End buffer
        LD      A,(DATFLG)      ; Get data type
        OR      A               ; Literal?
        LD      A,(HL)          ; Get byte to copy
        JP      NZ,MOVDIR       ; Literal - Copy direct
        CP      #"?"             ; Is it "?" short for PRINT
        LD      A,#ZPRINT        ; "PRINT" token
        JP      Z,MOVDIR        ; Yes - replace it
        LD      A,(HL)          ; Get byte again
        CP      #"0"             ; Is it less than "0"
        JP      C,FNDWRD        ; Yes - Look for reserved words
        CP      #";"+1           ; Is it "0123456789:;" ?
        JP      C,MOVDIR        ; Yes - copy it direct
FNDWRD: PUSH    DE              ; Look for reserved words
        LD      DE,#WORDS-1      ; Point to table
        PUSH    BC              ; Save count
        LD      BC,#RETNAD       ; Where to return to
        PUSH    BC              ; Save return address
        LD      B,#ZEND-1        ; First token value -1
        LD      A,(HL)          ; Get byte
        CP      #"a"             ; Less than "a" ?
        JP      C,SEARCH        ; Yes - search for words
        CP      #"z"+1           ; Greater than "z" ?
        JP      NC,SEARCH       ; Yes - search for words
        AND     #0b01011111       ; Force upper case
        LD      (HL),A          ; Replace byte
SEARCH: LD      C,(HL)          ; Search for a word
        EX      DE,HL
GETNXT: INC     HL              ; Get next reserved word
        OR      (HL)            ; Start of word?
        JP      P,GETNXT        ; No - move on
        INC     B               ; Increment token value
        LD      A, (HL)         ; Get byte from table
        AND     #0b01111111       ; Strip bit 7
        RET     Z               ; Return if end of list
        CP      C               ; Same character as in buffer?
        JP      NZ,GETNXT       ; No - get next word
        EX      DE,HL
        PUSH    HL              ; Save start of word

NXTBYT: INC     DE              ; Look through rest of word
        LD      A,(DE)          ; Get byte from table
        OR      A               ; End of word ?
        JP      M,#MATCH         ; Yes - Match found
        LD      C,A             ; Save it
        LD      A,B             ; Get token value
        CP      #ZGOTO           ; Is it "GOTO" token ?
        JP      NZ,NOSPC        ; No - Don't allow spaces
        CALL    GETCHR          ; Get next character
        DEC     HL              ; Cancel increment from GETCHR
NOSPC:  INC     HL              ; Next byte
        LD      A,(HL)          ; Get byte
        CP      #"a"             ; Less than "a" ?
        JP      C,NOCHNG        ; Yes - don't change
        AND     #0b01011111       ; Make upper case
NOCHNG: CP      C               ; Same as in buffer ?
        JP      Z,NXTBYT        ; Yes - keep testing
        POP     HL              ; Get back start of word
        JP      SEARCH          ; Look at next word

MATCH:  LD      C,B             ; Word found - Save token value
        POP     AF              ; Throw away return
        EX      DE,HL
        RET                     ; Return to "RETNAD"
RETNAD: EX      DE,HL           ; Get address in string
        LD      A,C             ; Get token value
        POP     BC              ; Restore buffer length
        POP     DE              ; Get destination address
MOVDIR: INC     HL              ; Next source in buffer
        LD      (DE),A          ; Put byte in buffer
        INC     DE              ; Move up buffer
        INC     C               ; Increment length of buffer
        SUB     #":"             ; End of statement?
        JP      Z,SETLIT        ; Jump if multi-statement line
        CP      #ZDATA-0x3A       ; Is it DATA statement ?
        JP      NZ,TSTREM       ; No - see if REM
SETLIT: LD      (DATFLG),A      ; Set literal flag
TSTREM: SUB     #ZREM-0x3A        ; Is it REM?
        JP      NZ,CRNCLP       ; No - Leave flag
        LD      B,A             ; Copy rest of buffer
NXTCHR: LD      A,(HL)          ; Get byte
        OR      A               ; End of line ?
        JP      Z,ENDBUF        ; Yes - Terminate buffer
        CP      B               ; End of statement ?
        JP      Z,MOVDIR        ; Yes - Get next one
CPYLIT: INC     HL              ; Move up source string
        LD      (DE),A          ; Save in destination
        INC     C               ; Increment length
        INC     DE              ; Move up destination
        JP      NXTCHR          ; Repeat

ENDBUF: LD      HL,#BUFFER-1     ; Point to start of buffer
        LD      (DE),A          ; Mark end of buffer (A = 00)
        INC     DE
        LD      (DE),A          ; A = 00
        INC     DE
        LD      (DE),A          ; A = 00
        RET

DODEL:  LD      A,(NULFLG)      ; Get null flag status
        OR      A               ; Is it zero?
        LD      A,#0             ; Zero A - Leave flags
        LD      (NULFLG),A      ; Zero null flag
        JP      NZ,ECHDEL       ; Set - Echo it
        DEC     B               ; Decrement length
        JP      Z,GETLIN        ; Get line again if empty
        CALL    OUTC            ; Output null character
        .db      0x3E             ; Skip "DEC B"
ECHDEL: DEC     B               ; Count bytes in buffer
        DEC     HL              ; Back space buffer
        JP      Z,OTKLN         ; No buffer - Try again
        LD      A,(HL)          ; Get deleted byte
        CALL    OUTC            ; Echo it
        JP      MORINP          ; Get more input

DELCHR: DEC     B               ; Count bytes in buffer
        DEC     HL              ; Back space buffer
        CALL    OUTC            ; Output character in A
        JP      NZ,MORINP       ; Not end - Get more
OTKLN:  CALL    OUTC            ; Output character in A
KILIN:  CALL    PRNTCR          ; Output CRLF
        JP      TTYLIN          ; Get line again

GETLIN: CALL    MONTST          ; Is it NAS-SYS?
        JP      Z,TTYLIN        ; No - Character input
        LD      HL,(CIN)        ; Point to NAS-SYS input table
        LD      A,(HL)          ; Get input mode
        CP      #0x74             ; Is it "X" mode?
        JP      Z,TTYLIN        ; Yes - Teletype line input
        CALL    INLINE          ; Get a line from NAS-SYS
        JP      DONULL          ; POS(X)=0 and do nulls

TTYLIN: LD      HL,#BUFFER       ; Get a line by character
        LD      B,#1             ; Set buffer as empty
        XOR     A
        LD      (NULFLG),A      ; Clear null flag
MORINP: CALL    CLOTST          ; Get character and test ^O
        LD      C,A             ; Save character in C
        CP      #DEL             ; Delete character?
        JP      Z,DODEL         ; Yes - Process it
        LD      A,(NULFLG)      ; Get null flag
        OR      A               ; Test null flag status
        JP      Z,PROCES        ; Reset - Process character
        LD      A,#0             ; Set a null
        CALL    OUTC            ; Output null
        XOR     A               ; Clear A
        LD      (NULFLG),A      ; Reset null flag
PROCES: LD      A,C             ; Get character
        CP      #CTRLG           ; Bell?
        JP      Z,PUTCTL        ; Yes - Save it
        CP      #CTRLC           ; Is it control "C"?
        CALL    Z,PRNTCR        ; Yes - Output CRLF
        SCF                     ; Flag break
        RET     Z               ; Return if control "C"
        CP      #CR              ; Is it enter?
        JP      Z,ENDINP        ; Yes - Terminate input
        CP      #CTRLU           ; Is it control "U"?
        JP      Z,KILIN         ; Yes - Get another line
        CP      #"@"             ; Is it "kill line"?
        JP      Z,OTKLN         ; Yes - Kill line
        CP      #"_"             ; Is it delete?
        JP      Z,DELCHR        ; Yes - Delete character
        CP      #BKSP            ; Is it backspace?
        JP      Z,DELCHR        ; Yes - Delete character
        CP      #CTRLR           ; Is it control "R"?
        JP      NZ,PUTBUF       ; No - Put in buffer
        PUSH    BC              ; Save buffer length
        PUSH    DE              ; Save DE
        PUSH    HL              ; Save buffer address
        LD      (HL),#0          ; Mark end of buffer
        CALL    OUTNCR          ; Output and do CRLF
        LD      HL,#BUFFER       ; Point to buffer start
        CALL    PRS             ; Output buffer
        POP     HL              ; Restore buffer address
        POP     DE              ; Restore DE
        POP     BC              ; Restore buffer length
        JP      MORINP          ; Get another character

PUTBUF: CP      #" "             ; Is it a control code?
        JP      C,MORINP        ; Yes - Ignore
PUTCTL: LD      A,B             ; Get number of bytes in buffer
        CP      #72+1            ; Test for line overflow
        LD      A,#CTRLG         ; Set a bell
        JP      NC,OUTNBS       ; Ring bell if buffer full
        LD      A,C             ; Get character
        LD      (HL),C          ; Save in buffer
        LD      (LSTBIN),A      ; Save last input byte
        INC     HL              ; Move up buffer
        INC     B               ; Increment length
OUTIT:  CALL    OUTC            ; Output the character entered
        JP      MORINP          ; Get another character

OUTNBS: CALL    OUTC            ; Output bell and back over it
        LD      A,#BKSP          ; Set back space
        JP      OUTIT           ; Output it and get more

CPDEHL: LD      A,H             ; Get H
        SUB     D               ; Compare with D
        RET     NZ              ; Different - Exit
        LD      A,L             ; Get L
        SUB     E               ; Compare with E
        RET                     ; Return status

CHKSYN: LD      A,(HL)          ; Check syntax of character
        EX      (SP),HL         ; Address of test byte
        CP      (HL)            ; Same as in code string?
        INC     HL              ; Return address
        EX      (SP),HL         ; Put it back
        JP      Z,GETCHR        ; Yes - Get next character
        JP      SNERR           ; Different - ?SN Error

OUTC:   PUSH    AF              ; Save character
        LD      A,(CTLOFG)      ; Get control "O" flag
        OR      A               ; Is it set?
        JP      NZ,POPAF        ; Yes - don't output
        POP     AF              ; Restore character
        PUSH    BC              ; Save buffer length
        PUSH    AF              ; Save character
        CP      #" "             ; Is it a control code?
        JP      C,DINPOS        ; Yes - Don't INC POS(X)
        LD      A,(LWIDTH)      ; Get line width
        LD      B,A             ; To B
        LD      A,(CURPOS)      ; Get cursor position
        INC     B               ; Width 255?
        JP      Z,INCLEN        ; Yes - No width limit
        DEC     B               ; Restore width
        CP      B               ; At end of line?
        CALL    Z,PRNTCR        ; Yes - output CRLF
INCLEN: INC     A               ; Move on one character
        LD      (CURPOS),A      ; Save new position
DINPOS: POP     AF              ; Restore character
        POP     BC              ; Restore buffer length
        PUSH    AF              ; << This sequence >>
        POP     AF              ; << is not needed >>
        PUSH    AF              ; Save character
        PUSH    BC              ; Save buffer length
        LD      C,A             ; Character to C
        CALL    CONMON          ; Send it
        POP     BC              ; Restore buffer length
        POP     AF              ; Restore character
        RET

CLOTST: CALL    GETINP          ; Get input character
        AND     #0b01111111       ; Strip bit 7
        CP      #CTRLO           ; Is it control "O"?
        RET     NZ              ; No don't flip flag
        LD      A,(CTLOFG)      ; Get flag
        CPL                     ; Flip it
        LD      (CTLOFG),A      ; Put it back
        XOR     A               ; Null character
        RET

LIST:   CALL    ATOH            ; ASCII number to DE
        RET     NZ              ; Return if anything extra
        POP     BC              ; Rubbish - Not needed
        CALL    SRCHLN          ; Search for line number in DE
        PUSH    BC              ; Save address of line
        CALL    SETLIN          ; Set up lines counter
LISTLP: POP     HL              ; Restore address of line
        LD      C,(HL)          ; Get LSB of next line
        INC     HL
        LD      B,(HL)          ; Get MSB of next line
        INC     HL
        LD      A,B             ; BC = 0 (End of program)?
        OR      C
        JP      Z,PRNTOK        ; Yes - Go to command mode
        CALL    COUNT           ; Count lines
        CALL    TSTBRK          ; Test for break key
        PUSH    BC              ; Save address of next line
        CALL    PRNTCR          ; Output CRLF
        LD      E,(HL)          ; Get LSB of line number
        INC     HL
        LD      D,(HL)          ; Get MSB of line number
        INC     HL
        PUSH    HL              ; Save address of line start
        EX      DE,HL           ; Line number to HL
        CALL    PRNTHL          ; Output line number in decimal
        LD      A,#" "           ; Space after line number
        POP     HL              ; Restore start of line address
LSTLP2: CALL    OUTC            ; Output character in A
LSTLP3: LD      A,(HL)          ; Get next byte in line
        OR      A               ; End of line?
        INC     HL              ; To next byte in line
        JP      Z,LISTLP        ; Yes - get next line
        JP      P,LSTLP2        ; No token - output it
        SUB     #ZEND-1          ; Find and output word
        LD      C,A             ; Token offset+1 to C
        LD      DE,#WORDS        ; Reserved word list
FNDTOK: LD      A,(DE)          ; Get character in list
        INC     DE              ; Move on to next
        OR      A               ; Is it start of word?
        JP      P,FNDTOK        ; No - Keep looking for word
        DEC     C               ; Count words
        JP      NZ,FNDTOK       ; Not there - keep looking
OUTWRD: AND     #0b01111111       ; Strip bit 7
        CALL    OUTC            ; Output first character
        LD      A,(DE)          ; Get next character
        INC     DE              ; Move on to next
        OR      A               ; Is it end of word?
        JP      P,OUTWRD        ; No - output the rest
        JP      LSTLP3          ; Next byte in line

SETLIN: PUSH    HL              ; Set up LINES counter
        LD      HL,(LINESN)     ; Get LINES number
        LD      (LINESC),HL     ; Save in LINES counter
        POP     HL
        RET

LDNMI1: LD      HL,#BREAK        ; Break routine
        LD      (NMI),HL        ; NMI forces break
        JP      PRNTOK          ; Go to command mode

        .db      0x0FE            ; <<< NO REFERENCE TO HERE >>>

COUNT:  PUSH    HL              ; Save code string address
        PUSH    DE
        LD      HL,(LINESC)     ; Get LINES counter
        LD      DE,#-1
        ADC     HL,DE           ; Decrement
        LD      (LINESC),HL     ; Put it back
        POP     DE
        POP     HL              ; Restore code string address
        RET     P               ; Return if more lines to go
        PUSH    HL              ; Save code string address
        LD      HL,(LINESN)     ; Get LINES number
        LD      (LINESC),HL     ; Reset LINES counter
        LD      A,(NMIFLG)      ; Break by NMI?
        OR      A
        JP      NZ,ARETN        ; Yes - "RETN"
        CALL    GETINP          ; Get input character
        CP      #CTRLC           ; Is it control "C"?
        JP      Z,RSLNBK        ; Yes - Reset LINES an break
        POP     HL              ; Restore code string address
        JP      COUNT           ; Keep on counting

RSLNBK: LD      HL,(LINESN)     ; Get LINES number
        LD      (LINESC),HL     ; Reset LINES counter
        JP      BRKRET          ; Go and output "Break"

FOR:    LD      A,#0x64           ; Flag "FOR" assignment
        LD      (FORFLG),A      ; Save "FOR" flag
        CALL    LET             ; Set up initial index
        POP     BC              ; Drop RETurn address
        PUSH    HL              ; Save code string address
        CALL    DATA            ; Get next statement address
        LD      (LOOPST),HL     ; Save it for start of lo6p
        LD      HL,#2            ; Offset for "FOR" block
        ADD     HL,SP           ; Point to it
FORSLP: CALL    LOKFOR          ; Look for existing "FOR" block
        POP     DE              ; Get code string address
        JP      NZ,FORFND       ; No nesting found
        ADD     HL,BC           ; Move into "FOR" block
        PUSH    DE              ; Save code string address
        DEC     HL
        LD      D,(HL)          ; Get MSB of loop statement
        DEC     HL
        LD      E,(HL)          ; Get LSB of loop statement
        INC     HL
        INC     HL
        PUSH    HL              ; Save block address
        LD      HL,(LOOPST)     ; Get address of loop statement
        CALL    CPDEHL          ; Compare the FOR loops
        POP     HL              ; Restore block address
        JP      NZ,FORSLP       ; Different FORs - Find another
        POP     DE              ; Restore code string address
        LD      SP,HL           ; Remove all nested loops

FORFND: EX      DE,HL           ; Code string address to HL
        LD      C,#8
        CALL    CHKSTK          ; Check for 8 levels of stack
        PUSH    HL              ; Save code string address
        LD      HL,(LOOPST)     ; Get first statement of loop
        EX      (SP),HL         ; Save and restore code string
        PUSH    HL              ; Re-save code string address
        LD      HL,(LINEAT)     ; Get current line number
        EX      (SP),HL         ; Save and restore code string
        CALL    TSTNUM          ; Make sure it's a number
        CALL    CHKSYN          ; Make sure "TO" is next
        .db      ZTO             ; "TO" token
        CALL    GETNUM          ; Get "TO" expression value
        PUSH    HL              ; Save code string address
        CALL    BCDEFP          ; Move "TO" value to BCDE
        POP     HL              ; Restore code string address
        PUSH    BC              ; Save "TO" value in block
        PUSH    DE
        LD      BC,#0x8100        ; BCDE - 1 (default STEP)
        LD      D,C             ; C=0
        LD      E,D             ; D=0
        LD      A,(HL)          ; Get next byte in code string
        CP      #ZSTEP           ; See if "STEP" is stated
        LD      A,#1             ; Sign of step = 1
        JP      NZ,SAVSTP       ; No STEP given - Default to 1
        CALL    GETCHR          ; Jump over "STEP" token
        CALL    GETNUM          ; Get step value
        PUSH    HL              ; Save code string address
        CALL    BCDEFP          ; Move STEP to BCDE
        CALL    TSTSGN          ; Test sign of FPREG
        POP     HL              ; Restore code string address
SAVSTP: PUSH    BC              ; Save the STEP value in block
        PUSH    DE
        PUSH    AF              ; Save sign of STEP
        INC     SP              ; Don't save flags
        PUSH    HL              ; Save code string address
        LD      HL,(BRKLIN)     ; Get address of index variable
        EX      (SP),HL         ; Save and restore code string
PUTFID: LD      B,#ZFOR          ; "FOR" block marker
        PUSH    BC              ; Save it
        INC     SP              ; Don't save C

RUNCNT: CALL    CHKBRK          ; Execution driver - Test break
        OR      A               ; Break key hit?
        CALL    NZ,STALL        ; Yes - Pause for a key
        LD      (BRKLIN),HL     ; Save code address for break
        LD      A,(HL)          ; Get next byte in code string
        CP      #":"             ; Multi statement line?
        JP      Z,EXCUTE        ; Yes - Execute it
        OR      A               ; End of line?
        JP      NZ,SNERR        ; No - Syntax error
        INC     HL              ; Point to address of next line
        LD      A,(HL)          ; Get LSB of line pointer
        INC     HL
        OR      (HL)            ; Is it zero (End of prog)?
        JP      Z,ENDPRG        ; Yes - Terminate execution
        INC     HL              ; Point to line number
        LD      E,(HL)          ; Get LSB of line number
        INC     HL
        LD      D,(HL)          ; Get MSB of line number
        EX      DE,HL           ; Line number to HL
        LD      (LINEAT),HL     ; Save as current line number
        EX      DE,HL           ; Line number back to DE
EXCUTE: CALL    GETCHR          ; Get key word
        LD      DE,#RUNCNT       ; Where to RETurn to
        PUSH    DE              ; Save for RETurn
IFJMP:  RET     Z               ; Go to RUNCNT if end of STMT
ONJMP:  SUB     #ZEND            ; Is it a token?
        JP      C,LET           ; No - try to assign it
        CP      #ZNEW+1-ZEND     ; END to NEW ?
        JP      NC,SNERR        ; Not a key word - ?SN Error
        RLCA                    ; Double it
        LD      C,A             ; BC = Offset into table
        LD      B,#0
        EX      DE,HL           ; Save code string address
        LD      HL,#WORDTB       ; Keyword address table
        ADD     HL,BC           ; Point to routine address
        LD      C,(HL)          ; Get LSB of routine address
        INC     HL
        LD      B,(HL)          ; Get MSB of routine address
        PUSH    BC              ; Save routine address
        EX      DE,HL           ; Restore code string address

GETCHR: INC     HL              ; Point to next character
        LD      A,(HL)          ; Get next code string byte
        CP      #":"             ; Z if ":"
        RET     NC              ; NC if > "9"
        CP      #" "
        JP      Z,GETCHR        ; Skip over spaces
        CP      #"0"
        CCF                     ; NC if < "0"
        INC     A               ; Test for zero - Leave carry
        DEC     A               ; Z if Null
        RET

RESTOR: EX      DE,HL           ; Save code string address
        LD      HL,(BASTXT)     ; Point to start of program
        JP      Z,RESTNL        ; Just RESTORE - reset pointer
        EX      DE,HL           ; Restore code string address
        CALL    ATOH            ; Get line number to DE
        PUSH    HL              ; Save code string address
        CALL    SRCHLN          ; Search for line number in DE
        LD      H,B             ; HL = Address of line
        LD      L,C
        POP     DE              ; Restore code string address
        JP      NC,ULERR        ; ?UL Error if not found
RESTNL: DEC     HL              ; Byte before DATA statement
UPDATA: LD      (NXTDAT),HL     ; Update DATA pointer
        EX      DE,HL           ; Restore code string address
        RET

TSTBRK: CALL    CHKBRK          ; Test for interrupts
        OR      A
        RET     Z               ; Return if no key pressed
STALL:  CALL    CLOTST          ; Get input and test for ^O
        CP      #CTRLS           ; Is it control "S"
        CALL    Z,CLOTST        ; Yes - Get another character
        CP      #CTRLC           ; Return if not control "C"
STOP:   RET     NZ              ; Exit if anything else
        .db      0x0F6            ; Flag "STOP"
PEND:   RET     NZ              ; Exit if anything else
        LD      (BRKLIN),HL     ; Save point of break
        .db      0x21             ; Skip "OR 11111111B"
INPBRK: OR      #0b11111111       ; Flag "Break" wanted
        POP     BC              ; Return not needed and more
ENDPRG: LD      HL,(LINEAT)     ; Get current line number
        PUSH    AF              ; Save STOP / END status
        LD      A,L             ; Is it direct break?
        AND     H
        INC     A               ; Line is -1 if direct break
        JP      Z,NOLIN         ; Yes - No line number
        LD      (ERRLIN),HL     ; Save line of break
        LD      HL,(BRKLIN)     ; Get point of break
        LD      (CONTAD),HL     ; Save point to CONTinue
NOLIN:  XOR     A
        LD      (CTLOFG),A      ; Enable output
        CALL    STTLIN          ; Start a new line
        POP     AF              ; Restore STOP / END status
        LD      HL,#BRKMSG       ; "Break" message
        JP      NZ,ERRIN        ; "in line" wanted?
        JP      PRNTOK          ; Go to command mode

CONT:   LD      HL,(CONTAD)     ; Get CONTinue address
        LD      A,H             ; Is it zero?
        OR      L
        LD      E,#CN            ; ?CN Error
        JP      Z,ERROR         ; Yes - output "?CN Error"
        EX      DE,HL           ; Save code string address
        LD      HL,(ERRLIN)     ; Get line of last break
        LD      (LINEAT),HL     ; Set up current line number
        EX      DE,HL           ; Restore code string address
        RET                     ; CONTinue where left off

NULL:   CALL    GETINT          ; Get integer 0-255
        RET     NZ              ; Return if bad value
        LD      (NULLS),A       ; Set nulls number
        RET

ARRLD1: LD      B,#-1            ; Flag array load
ARRSV1: CALL    GETCHR          ; Skip "*"
        LD      A,B             ; CLOAD* or CSAVE*
        LD      (BRKLIN),A      ; Save it
        LD      A,#1             ; It's an array
        LD      (FORFLG),A      ; Flag array name
        CALL    GETVAR          ; Get address of array name
        PUSH    HL              ; Save code string address
        LD      (FORFLG),A      ; Clear flag
        LD      H,B             ; Address of array to HL
        LD      L,C
        DEC     BC              ; Back space
        DEC     BC              ;  to point
        DEC     BC              ;  to the
        DEC     BC              ; array name
        LD      A,(BRKLIN)      ; CLOAD* or CSAVE* ?
        OR      A
        PUSH    AF              ; Save CLOAD* / CSAVE* status
        EX      DE,HL           ; Array data length
        ADD     HL,DE           ; End of data
        EX      DE,HL           ; To DE
        LD      C,(HL)          ; Get dimension bytes
        LD      B,#0
        ADD     HL,BC           ; 2 Bytes each dimension
        ADD     HL,BC
        INC     HL              ; Over number of dimensions
        PUSH    HL              ; Address of array data
        PUSH    DE              ; End of array data
        PUSH    BC              ; Number of dimensions
        LD      A,(BRKLIN)      ; CLOAD* or CSAVE* ?
        CP      #-1
        CALL    Z,CASFF         ; CLOAD* - Cassette on
        LD      A,(BRKLIN)      ; CLOAD* or CSAVE* ?
        CP      #-1
        CALL    NZ,CASFFW       ; CSAVE* - Cassette on and wait
        NOP
        NOP
        NOP
        LD      HL,#0
        LD      (CHKSUM),HL     ; Zero check sum
        POP     BC              ; Number of dimensions
        POP     DE              ; End of array data
        POP     HL              ; Address of array data
        LD      B,#0b11010010     ; Header byte
        JP      JPLDSV          ; CSAVE-SNDHDR , CLOAD-GETHDR

SNDHDR: LD      A,B             ; Get header byte
        CALL    WUART2          ; Send 2 bytes to UART
        CALL    WUART2          ; Send 2 bytes to UART
        JP      SNDARY          ; Send array data

GETHDR: LD      C,#4             ; 4 Bytes to check
HDRLP:  CALL    RUART           ; Read byte from UART
        CP      B               ; Same as header?
        JP      NZ,GETHDR       ; No - Wait for another
        DEC     C               ; Count bytes
        JP      NZ,HDRLP        ; More needed
SNDARY: CALL    TSTNUM          ; Check it's a numerical array
ARYLP:  CALL    CPDEHL          ; All array data done
        JP      Z,SUMOFF        ; Yes - Do check sum
        POP     AF              ; CLOAD* or CSAVE* ?
        PUSH    AF              ; Re-save flags
        LD      A,(HL)          ; Get byte
        CALL    P,WUART         ; CSAVE* - Write byte
        CALL    M,RUART         ; CLOAD* - Read byte
        LD      (HL),A          ; Save byte in case of CLOAD*
        CALL    ACCSUM          ; Accumulate check sum
        INC     HL              ; Next byte
        JP      ARYLP           ; Repeat

SUMOFF: CALL    DOSUM           ; Do check sum
        CALL    CASFF           ; Cassette off
        POP     AF              ; Not needed any more
        POP     HL              ; Restore code string address
        RET

ACCSUM: PUSH    HL              ; Save address in array
        LD      HL,(CHKSUM)     ; Get check sum
        LD      B,#0             ; BC - Value of byte
        LD      C,A
        ADD     HL,BC           ; Add byte to check sum
        LD      (CHKSUM),HL     ; Re-save check sum
        POP     HL              ; Restore address in array
        RET

DOSUM:  LD      A,(BRKLIN)      ; CLOAD* or CSAVE* ?
        OR      A
        JP      M,CHSUMS        ; CLOAD* - Check if sums match
        LD      A,(CHKSUM)      ; Get LSB of check sum
        CALL    WUART           ; Write to UART
        LD      A,(CHKSUM+1)    ; Get MSB of check sum
        JP      WUART           ; Write to UART and return

CHSUMS: CALL    RUART           ; Read LSB of check sum
        PUSH    AF              ; Save it
        CALL    RUART           ; Read MSB of check sum
        POP     BC              ; LSB to B
        LD      E,B             ; LSB to E
        LD      D,A             ; MSB to D
        LD      HL,(CHKSUM)     ; Get accumulated check sum
        CALL    CPDEHL          ; Are they the same?
        RET     Z               ; Yes - End CLOAD*
        CALL    CASFF           ; Cassette off
        JP      OUTBAD          ; Different - Output "Bad"

CHKLTR: LD      A,(HL)          ; Get byte
        CP      #"A"             ; < "A" ?
        RET     C               ; Carry set if not letter
        CP      #"Z"+1           ; > "Z" ?
        CCF
        RET                     ; Carry set if not letter

FPSINT: CALL    GETCHR          ; Get next character
POSINT: CALL    GETNUM          ; Get integer 0 to 32767
DEPINT: CALL    TSTSGN          ; Test sign of FPREG
        JP      M,FCERR         ; Negative - ?FC Error
DEINT:  LD      A,(FPEXP)       ; Get integer value to DE
        CP      #0x80+16          ; Exponent in range (16 bits)?
        JP      C,FPINT         ; Yes - convert it
        LD      BC,#0x9080        ; BCDE = -32768
        LD      DE,#0000
        PUSH    HL              ; Save code string address
        CALL    CMPNUM          ; Compare FPREG with BCDE
        POP     HL              ; Restore code string address
        LD      D,C             ; MSB to D
        RET     Z               ; Return if in range
FCERR:  LD      E,#FC            ; ?FC Error
        JP      ERROR           ; Output error-

ATOH:   DEC     HL              ; ASCII number to DE binary
GETLN:  LD      DE,#0            ; Get number to DE
GTLNLP: CALL    GETCHR          ; Get next character
        RET     NC              ; Exit if not a digit
        PUSH    HL              ; Save code string address
        PUSH    AF              ; Save digit
        LD      HL,#65529/10     ; Largest number 65529
        CALL    CPDEHL          ; Number in range?
        JP      C,SNERR         ; No - ?SN Error
        LD      H,D             ; HL = Number
        LD      L,E
        ADD     HL,DE           ; Times 2
        ADD     HL,HL           ; Times 4
        ADD     HL,DE           ; Times 5
        ADD     HL,HL           ; Times 10
        POP     AF              ; Restore digit
        SUB     #"0"             ; Make it 0 to 9
        LD      E,A             ; DE = Value of digit
        LD      D,#0
        ADD     HL,DE           ; Add to number
        EX      DE,HL           ; Number to DE
        POP     HL              ; Restore code string address
        JP      GTLNLP          ; Go to next character

CLEAR:  JP      Z,INTVAR        ; Just "CLEAR" Keep parameters
        CALL    POSINT          ; Get integer 0 to 32767 to DE
        DEC     HL              ; Cancel increment
        CALL    GETCHR          ; Get next character
        PUSH    HL              ; Save code string address
        LD      HL,(LSTRAM)     ; Get end of RAM
        JP      Z,STORED        ; No value given - Use stored
        POP     HL              ; Restore code string address
        CALL    CHKSYN          ; Check for comma
        .db      ","
        PUSH    DE              ; Save number
        CALL    POSINT          ; Get integer 0 to 32767
        DEC     HL              ; Cancel increment
        CALL    GETCHR          ; Get next character
        JP      NZ,SNERR        ; ?SN Error if more on line
        EX      (SP),HL         ; Save code string address
        EX      DE,HL           ; Number to DE
STORED: LD      A,L             ; Get LSB of new RAM top
        SUB     E               ; Subtract LSB of string space
        LD      E,A             ; Save LSB
        LD      A,H             ; Get MSB of new RAM top
        SBC     A,D             ; Subtract MSB of string space
        LD      D,A             ; Save MSB
        JP      C,OMERR         ; ?OM Error if not enough mem
        PUSH    HL              ; Save RAM top
        LD      HL,(PROGND)     ; Get program end
        LD      BC,#40           ; 40 Bytes minimum working RAM
        ADD     HL,BC           ; Get lowest address
        CALL    CPDEHL          ; Enough memory?
        JP      NC,OMERR        ; No - ?OM Error
        EX      DE,HL           ; RAM top to HL
        LD      (STRSPC),HL     ; Set new string space
        POP     HL              ; End of memory to use
        LD      (LSTRAM),HL     ; Set new top of RAM
        POP     HL              ; Restore code string address
        JP      INTVAR          ; Initialise variables

RUN:    JP      Z,RUNFST        ; RUN from start if just RUN
        CALL    INTVAR          ; Initialise variables
        LD      BC,#RUNCNT       ; Execution driver loop
        JP      RUNLIN          ; RUN from line number

GOSUB:  LD      C,#3             ; 3 Levels of stack needed
        CALL    CHKSTK          ; Check for 3 levels of stack
        POP     BC              ; Get return address
        PUSH    HL              ; Save code string for RETURN
        PUSH    HL              ; And for GOSUB routine
        LD      HL,(LINEAT)     ; Get current line
        EX      (SP),HL         ; Into stack - Code string out
        LD      A,#ZGOSUB        ; "GOSUB" token
        PUSH    AF              ; Save token
        INC     SP              ; Don't save flags

RUNLIN: PUSH    BC              ; Save return address
GOTO:   CALL    ATOH            ; ASCII number to DE binary
        CALL    REM             ; Get end of line
        PUSH    HL              ; Save end of line
        LD      HL,(LINEAT)     ; Get current line
        CALL    CPDEHL          ; Line after current?
        POP     HL              ; Restore end of line
        INC     HL              ; Start of next line
        CALL    C,SRCHLP        ; Line is after current line
        CALL    NC,SRCHLN       ; Line is before current line
        LD      H,B             ; Set up code string address
        LD      L,C
        DEC     HL              ; Incremented after
        RET     C               ; Line found
ULERR:  LD      E,#UL            ; ?UL Error
        JP      ERROR           ; Output error message

RETURN: RET     NZ              ; Return if not just RETURN
        LD      D,#-1            ; Flag "GOSUB" search
        CALL    BAKSTK          ; Look "GOSUB" block
        LD      SP,HL           ; Kill all FORs in subroutine
        CP      #ZGOSUB          ; Test for "GOSUB" token
        LD      E,#RG            ; ?RG Error
        JP      NZ,ERROR        ; Error if no "GOSUB" found
        POP     HL              ; Get RETURN line number
        LD      (LINEAT),HL     ; Save as current
        INC     HL              ; Was it from direct statement?
        LD      A,H
        OR      L               ; Return to line
        JP      NZ,RETLIN       ; No - Return to line
        LD      A,(LSTBIN)      ; Any INPUT in subroutine?
        OR      A               ; If so buffer is corrupted
        JP      NZ,POPNOK       ; Yes - Go to command mode
RETLIN: LD      HL,#RUNCNT       ; Execution driver loop
        EX      (SP),HL         ; Into stack - Code string out
        .db      0x3E             ; Skip "POP HL"
NXTDTA: POP     HL              ; Restore code string address

DATA:   .db      0x01,0x3A         ; ":" End of statement
REM:    LD      C,#0             ; 00  End of statement
        LD      B,#0
NXTSTL: LD      A,C             ; Statement and byte
        LD      C,B
        LD      B,A             ; Statement end byte
NXTSTT: LD      A,(HL)          ; Get byte
        OR      A               ; End of line?
        RET     Z               ; Yes - Exit
        CP      B               ; End of statement?
        RET     Z               ; Yes - Exit
        INC     HL              ; Next byte
        CP      #'"'             ; Literal string?"
        JP      Z,NXTSTL        ; Yes - Look for another '"'
        JP      NXTSTT          ; Keep looking

LET:    CALL    GETVAR          ; Get variable name
        CALL    CHKSYN          ; Make sure "=" follows
        .db      ZEQUAL          ; "=" token
        PUSH    DE              ; Save address of variable
        LD      A,(TYPE)        ; Get data type
        PUSH    AF              ; Save type
        CALL    EVAL            ; Evaluate expression
        POP     AF              ; Restore type
        EX      (SP),HL         ; Save code - Get var addr
        LD      (BRKLIN),HL     ; Save address of variable
        RRA                     ; Adjust type
        CALL    CHKTYP          ; Check types are the same
        JP      Z,LETNUM        ; Numeric - Move value
LETSTR: PUSH    HL              ; Save address of string var
        LD      HL,(FPREG)      ; Pointer to string entry
        PUSH    HL              ; Save it on stack
        INC     HL              ; Skip over length
        INC     HL
        LD      E,(HL)          ; LSB of string address
        INC     HL
        LD      D,(HL)          ; MSB of string address
        LD      HL,(BASTXT)     ; Point to start of program
        CALL    CPDEHL          ; Is string before program?
        JP      NC,CRESTR       ; Yes - Create string entry
        LD      HL,(STRSPC)     ; Point to string space
        CALL    CPDEHL          ; Is string literal in program?
        POP     DE              ; Restore address of string
        JP      NC,MVSTPT       ; Yes - Set up pointer
        LD      HL,#TMPSTR       ; Temporary string pool
        CALL    CPDEHL          ; Is string in temporary pool?
        JP      NC,MVSTPT       ; No - Set up pointer
        .db      0x3E             ; Skip "POP DE"
CRESTR: POP     DE              ; Restore address of string
        CALL    BAKTMP          ; Back to last tmp-str entry
        EX      DE,HL           ; Address of string entry
        CALL    SAVSTR          ; Save string in string area
MVSTPT: CALL    BAKTMP          ; Back to last tmp-str entry
        POP     HL              ; Get string pointer
        CALL    DETHL4          ; Move string pointer to var
        POP     HL              ; Restore code string address
        RET

LETNUM: PUSH    HL              ; Save address of variable
        CALL    FPTHL           ; Move value to variable
        POP     DE              ; Restore address of variable
        POP     HL              ; Restore code string address
        RET

ON:     CALL    GETINT          ; Get integer 0-255
        LD      A,(HL)          ; Get "GOTO" or "GOSUB" token
        LD      B,A             ; Save in B
        CP      #ZGOSUB          ; "GOSUB" token?
        JP      Z,ONGO          ; Yes - Find line number
        CALL    CHKSYN          ; Make sure it's "GOTO"
        .db      ZGOTO           ; "GOTO" token
        DEC     HL              ; Cancel increment
ONGO:   LD      C,E             ; Integer of branch value
ONGOLP: DEC     C               ; Count branches
        LD      A,B             ; Get "GOTO" or "GOSUB" token
        JP      Z,ONJMP         ; Go to that line if right one
        CALL    GETLN           ; Get line number to DE
        CP      #","             ; Another line number?
        RET     NZ              ; No - Drop through
        JP      ONGOLP          ; Yes - loop

IF:     CALL    EVAL            ; Evaluate expression
        LD      A,(HL)          ; Get token
        CP      #ZGOTO           ; "GOTO" token?
        JP      Z,IFGO          ; Yes - Get line
        CALL    CHKSYN          ; Make sure it's "THEN"
        .db      ZTHEN           ; "THEN" token
        DEC     HL              ; Cancel increment
IFGO:   CALL    TSTNUM          ; Make sure it's numeric
        CALL    TSTSGN          ; Test state of expression
        JP      Z,REM           ; False - Drop through
        CALL    GETCHR          ; Get next character
        JP      C,GOTO          ; Number - GOTO that line
        JP      IFJMP           ; Otherwise do statement

MRPRNT: DEC     HL              ; DEC 'cos GETCHR INCs
        CALL    GETCHR          ; Get next character
PRINT:  JP      Z,PRNTCR        ; CRLF if just PRINT
PRNTLP: RET     Z               ; End of list - Exit
        CP      #ZTAB            ; "TAB(" token?
        JP      Z,DOTAB         ; Yes - Do TAB routine
        CP      #ZSPC            ; "SPC(" token?
        JP      Z,DOTAB         ; Yes - Do SPC routine
        PUSH    HL              ; Save code string address
        CP      #","             ; Comma?
        JP      Z,DOCOM         ; Yes - Move to next zone
        CP      #";"             ; Semi-colon?
        JP      Z,NEXITM        ; Do semi-colon routine
        POP     BC              ; Code string address to BC
        CALL    EVAL            ; Evaluate expression
        PUSH    HL              ; Save code string address
        LD      A,(TYPE)        ; Get variable type
        OR      A               ; Is it a string variable?
        JP      NZ,PRNTST       ; Yes - Output string contents
        CALL    NUMASC          ; Convert number to text
        CALL    CRTST           ; Create temporary string
        LD      (HL),#" "        ; Followed by a space
        LD      HL,(FPREG)      ; Get length of output
        INC     (HL)            ; Plus 1 for the space
        LD      HL,(FPREG)      ; < Not needed >
        LD      A,(LWIDTH)      ; Get width of line
        LD      B,A             ; To B
        INC     B               ; Width 255 (No limit)?
        JP      Z,PRNTNB        ; Yes - Output number string
        INC     B               ; Adjust it
        LD      A,(CURPOS)      ; Get cursor position
        ADD     A,(HL)          ; Add length of string
        DEC     A               ; Adjust it
        CP      B               ; Will output fit on this line?
        CALL    NC,PRNTCR       ; No - CRLF first
PRNTNB: CALL    PRS1            ; Output string at (HL)
        XOR     A               ; Skip CALL by setting "Z" flag
PRNTST: CALL    NZ,PRS1         ; Output string at (HL)
        POP     HL              ; Restore code string address
        JP      MRPRNT          ; See if more to PRINT

STTLIN: LD      A,(CURPOS)      ; Make sure on new line
        OR      A               ; Already at start?
        RET     Z               ; Yes - Do nothing
        JP      PRNTCR          ; Start a new line

ENDINP: LD      (HL),#0          ; Mark end of buffer
        LD      HL,#BUFFER-1     ; Point to buffer
PRNTCR: LD      A,#CR            ; Load a CR
        CALL    OUTC            ; Output character
DONULL: XOR     A               ; Set to position 0
        LD      (CURPOS),A      ; Store it
        LD      A,(NULLS)       ; Get number of nulls
NULLP:  DEC     A               ; Count them
        RET     Z               ; Return if done
        PUSH    AF              ; Save count
        XOR     A               ; Load a null
        CALL    OUTC            ; Output it
        POP     AF              ; Restore count
        JP      NULLP           ; Keep counting

DOCOM:  LD      A,(COMMAN)      ; Get comma width
        LD      B,A             ; Save in B
        LD      A,(CURPOS)      ; Get current position
        CP      B               ; Within the limit?
        CALL    NC,PRNTCR       ; No - output CRLF
        JP      NC,NEXITM       ; Get next item
ZONELP: SUB     #14              ; Next zone of 14 characters
        JP      NC,ZONELP       ; Repeat if more zones
        CPL                     ; Number of spaces to output
        JP      ASPCS           ; Output them

DOTAB:  PUSH    AF              ; Save token
        CALL    FNDNUM          ; Evaluate expression
        CALL    CHKSYN          ; Make sure ")" follows
        .db      ")"
        DEC     HL              ; Back space on to ")"
        POP     AF              ; Restore token
        SUB     #ZSPC            ; Was it "SPC(" ?
        PUSH    HL              ; Save code string address
        JP      Z,DOSPC         ; Yes - Do "E" spaces
        LD      A,(CURPOS)      ; Get current position
DOSPC:  CPL                     ; Number of spaces to print to
        ADD     A,E             ; Total number to print
        JP      NC,NEXITM       ; TAB < Current POS(X)
ASPCS:  INC     A               ; Output A spaces
        LD      B,A             ; Save number to print
        LD      A,#" "           ; Space
SPCLP:  CALL    OUTC            ; Output character in A
        DEC     B               ; Count them
        JP      NZ,SPCLP        ; Repeat if more
NEXITM: POP     HL              ; Restore code string address
        CALL    GETCHR          ; Get next character
        JP      PRNTLP          ; More to print

REDO:   .ascii      "?Redo from start"
        .db CR,LF,0

BADINP: LD      A,(READFG)      ; READ or INPUT?
        OR      A
        JP      NZ,DATSNR       ; READ - ?SN Error
        POP     BC              ; Throw away code string addr
        LD      HL,#REDO         ; "Redo from start" message
        CALL    PRS             ; Output string
        JP      DOAGN           ; Do last INPUT again

INPUT:  CALL    IDTEST          ; Test for illegal direct
        LD      A,(HL)          ; Get character after "INPUT"
        CP      #'"'             ; Is there a prompt string?"
        LD      A,#0             ; Clear A and leave flags
        LD      (CTLOFG),A      ; Enable output
        JP      NZ,NOPMPT       ; No prompt - get input
        CALL    QTSTR           ; Get string terminated by '"'
        CALL    CHKSYN          ; Check for ";" after prompt
        .db      ";"
        PUSH    HL              ; Save code string address
        CALL    PRS1            ; Output prompt string
        .db      0x3E             ; Skip "PUSH HL"
NOPMPT: PUSH    HL              ; Save code string address
        CALL    PROMPT          ; Get input with "? " prompt
        POP     BC              ; Restore code string address
        JP      C,INPBRK        ; Break pressed - Exit
        INC     HL              ; Next byte
        LD      A,(HL)          ; Get it
        OR      A               ; End of line?
        DEC     HL              ; Back again
        PUSH    BC              ; Re-save code string address
        JP      Z,NXTDTA        ; Yes - Find next DATA stmt
        LD      (HL),#","        ; Store comma as separator
        JP      NXTITM          ; Get next item

READ:   PUSH    HL              ; Save code string address
        LD      HL,(NXTDAT)     ; Next DATA statement
        .db      0x0F6            ; Flag "READ"
NXTITM: XOR     A               ; Flag "INPUT"
        LD      (READFG),A      ; Save "READ"/"INPUT" flag
        EX      (SP),HL         ; Get code str' , Save pointer
        JP      GTVLUS          ; Get values

NEDMOR: CALL    CHKSYN          ; Check for comma between items
        .db      ","
GTVLUS: CALL    GETVAR          ; Get variable name
        EX      (SP),HL         ; Save code str" , Get pointer
        PUSH    DE              ; Save variable address
        LD      A,(HL)          ; Get next "INPUT"/"DATA" byte
        CP      #","             ; Comma?
        JP      Z,ANTVLU        ; Yes - Get another value
        LD      A,(READFG)      ; Is it READ?
        OR      A
        JP      NZ,FDTLP        ; Yes - Find next DATA stmt
        LD      A,#"?"           ; More INPUT needed
        CALL    OUTC            ; Output character
        CALL    PROMPT          ; Get INPUT with prompt
        POP     DE              ; Variable address
        POP     BC              ; Code string address
        JP      C,INPBRK        ; Break pressed
        INC     HL              ; Point to next DATA byte
        LD      A,(HL)          ; Get byte
        OR      A               ; Is it zero (No input) ?
        DEC     HL              ; Back space INPUT pointer
        PUSH    BC              ; Save code string address
        JP      Z,NXTDTA        ; Find end of buffer
        PUSH    DE              ; Save variable address
ANTVLU: LD      A,(TYPE)        ; Check data type
        OR      A               ; Is it numeric?
        JP      Z,INPBIN        ; Yes - Convert to binary
        CALL    GETCHR          ; Get next character
        LD      D,A             ; Save input character
        LD      B,A             ; Again
        CP      #'"'             ; Start of literal sting?"
        JP      Z,STRENT        ; Yes - Create string entry
        LD      A,(READFG)      ; "READ" or "INPUT" ?
        OR      A
        LD      D,A             ; Save 00 if "INPUT"
        JP      Z,ITMSEP        ; "INPUT" - End with 00
        LD      D,#":"           ; "DATA" - End with 00 or ":"
ITMSEP: LD      B,#","           ; Item separator
        DEC     HL              ; Back space for DTSTR
STRENT: CALL    DTSTR           ; Get string terminated by D
        EX      DE,HL           ; String address to DE
        LD      HL,#LTSTND       ; Where to go after LETSTR
        EX      (SP),HL         ; Save HL , get input pointer
        PUSH    DE              ; Save address of string
        JP      LETSTR          ; Assign string to variable

INPBIN: CALL    GETCHR          ; Get next character
        CALL    ASCTFP          ; Convert ASCII to FP number
        EX      (SP),HL         ; Save input ptr, Get var addr
        CALL    FPTHL           ; Move FPREG to variable
        POP     HL              ; Restore input pointer
LTSTND: DEC     HL              ; DEC 'cos GETCHR INCs
        CALL    GETCHR          ; Get next character
        JP      Z,MORDT         ; End of line - More needed?
        CP      #","             ; Another value?
        JP      NZ,BADINP       ; No - Bad input
MORDT:  EX      (SP),HL         ; Get code string address
        DEC     HL              ; DEC 'cos GETCHR INCs
        CALL    GETCHR          ; Get next character
        JP      NZ,NEDMOR       ; More needed - Get it
        POP     DE              ; Restore DATA pointer
        LD      A,(READFG)      ; "READ" or "INPUT" ?
        OR      A
        EX      DE,HL           ; DATA pointer to HL
        JP      NZ,UPDATA       ; Update DATA pointer if "READ"
        PUSH    DE              ; Save code string address
        OR      (HL)            ; More input given?
        LD      HL,#EXTIG        ; "?Extra ignored" message
        CALL    NZ,PRS          ; Output string if extra given
        POP     HL              ; Restore code string address
        RET

EXTIG:  .ascii      "?Extra ignored"
        .db CR,LF,0

FDTLP:  CALL    DATA            ; Get next statement
        OR      A               ; End of line?
        JP      NZ,FANDT        ; No - See if DATA statement
        INC     HL
        LD      A,(HL)          ; End of program?
        INC     HL
        OR      (HL)            ; 00 00 Ends program
        LD      E,#OD            ; ?OD Error
        JP      Z,ERROR         ; Yes - Out of DATA
        INC     HL
        LD      E,(HL)          ; LSB of line number
        INC     HL
        LD      D,(HL)          ; MSB of line number
        EX      DE,HL
        LD      (DATLIN),HL     ; Set line of current DATA item
        EX      DE,HL
FANDT:  CALL    GETCHR          ; Get next character
        CP      #ZDATA           ; "DATA" token
        JP      NZ,FDTLP        ; No "DATA" - Keep looking
        JP      ANTVLU          ; Found - Convert input

NEXT:   LD      DE,#0            ; In case no index given
NEXT1:  CALL    NZ,GETVAR       ; Get index address
        LD      (BRKLIN),HL     ; Save code string address
        CALL    BAKSTK          ; Look for "FOR" block
        JP      NZ,NFERR        ; No "FOR" - ?NF Error
        LD      SP,HL           ; Clear nested loops
        PUSH    DE              ; Save index address
        LD      A,(HL)          ; Get sign of STEP
        INC     HL
        PUSH    AF              ; Save sign of STEP
        PUSH    DE              ; Save index address
        CALL    PHLTFP          ; Move index value to FPREG
        EX      (SP),HL         ; Save address of TO value
        PUSH    HL              ; Save address of index
        CALL    ADDPHL          ; Add STEP to index value
        POP     HL              ; Restore address of index
        CALL    FPTHL           ; Move value to index variable
        POP     HL              ; Restore address of TO value
        CALL    LOADFP          ; Move TO value to BCDE
        PUSH    HL              ; Save address of line of FOR
        CALL    CMPNUM          ; Compare index with TO value
        POP     HL              ; Restore address of line num
        POP     BC              ; Address of sign of STEP
        SUB     B               ; Compare with expected sign
        CALL    LOADFP          ; BC = Loop stmt,DE = Line num
        JP      Z,KILFOR        ; Loop finished - Terminate it
        EX      DE,HL           ; Loop statement line number
        LD      (LINEAT),HL     ; Set loop line number
        LD      L,C             ; Set code string to loop
        LD      H,B
        JP      PUTFID          ; Put back "FOR" and continue

KILFOR: LD      SP,HL           ; Remove "FOR" block
        LD      HL,(BRKLIN)     ; Code string after "NEXT"
        LD      A,(HL)          ; Get next byte in code string
        CP      #","             ; More NEXTs ?
        JP      NZ,#RUNCNT       ; No - Do next statement
        CALL    GETCHR          ; Position to index name
        CALL    NEXT1           ; Re-enter NEXT routine
; < will not RETurn to here , Exit to RUNCNT or Loop >

GETNUM: CALL    EVAL            ; Get a numeric expression
TSTNUM: .db      0x0F6            ; Clear carry (numeric)
TSTSTR: SCF                     ; Set carry (string)
CHKTYP: LD      A,(TYPE)        ; Check types match
        ADC     A,A             ; Expected + actual
        OR      A               ; Clear carry , set parity
        RET     PE              ; Even parity - Types match
        JP      TMERR           ; Different types - Error

; <<< NO REFERENCE TO HERE >>>

        CALL    CHKSYN          ; Make sure "=" follows
        .db      ZEQUAL          ; "="
        JP      EVAL            ; Evaluate expression

OPNPAR: CALL    CHKSYN          ; Make sure "(" follows
        .db      #"("
EVAL:   DEC     HL              ; Evaluate expression & save
        LD      D,#0             ; Precedence value
EVAL1:  PUSH    DE              ; Save precedence
        LD      C,#1
        CALL    CHKSTK          ; Check for 1 level of stack
        CALL    OPRND           ; Get next expression value
EVAL2:  LD      (NXTOPR),HL     ; Save address of next operator
EVAL3:  LD      HL,(NXTOPR)     ; Restore address of next opr
        POP     BC              ; Precedence value and operator
        LD      A,B             ; Get precedence value
        CP      #0x78             ; "AND" or "OR" ?
        CALL    NC,TSTNUM       ; No - Make sure it's a number
        LD      A,(HL)          ; Get next operator / function
        LD      D,#0             ; Clear Last relation
RLTLP:  SUB     #ZGTR            ; ">" Token
        JP      C,FOPRND        ; + - * / ^ AND OR - Test it
        CP      #ZLTH+1-ZGTR     ; < = >
        JP      NC,FOPRND       ; Function - Call it
        CP      #ZEQUAL-ZGTR     ; "="
        RLA                     ; <- Test for legal
        XOR     D               ; <- combinations of < = >
        CP      D               ; <- by combining last token
        LD      D,A             ; <- with current one
        JP      C,SNERR         ; Error if "<<" "==" or ">>"
        LD      (CUROPR),HL     ; Save address of current token
        CALL    GETCHR          ; Get next character
        JP      RLTLP           ; Treat the two as one

FOPRND: LD      A,D             ; < = > found ?
        OR      A
        JP      NZ,TSTRED       ; Yes - Test for reduction
        LD      A,(HL)          ; Get operator token
        LD      (CUROPR),HL     ; Save operator address
        SUB     #ZPLUS           ; Operator or function?
        RET     C               ; Neither - Exit
        CP      #ZOR+1-ZPLUS     ; Is it + - * / ^ AND OR ?
        RET     NC              ; No - Exit
        LD      E,A             ; Coded operator
        LD      A,(TYPE)        ; Get data type
        DEC     A               ; FF = numeric , 00 = string
        OR      E               ; Combine with coded operator
        LD      A,E             ; Get coded operator
        JP      Z,CONCAT        ; String concatenation
        RLCA                    ; Times 2
        ADD     A,E             ; Times 3
        LD      E,A             ; To DE (D is 0)
        LD      HL,#PRITAB       ; Precedence table
        ADD     HL,DE           ; To the operator concerned
        LD      A,B             ; Last operator precedence
        LD      D,(HL)          ; Get evaluation precedence
        CP      D               ; Compare with eval precedence
        RET     NC              ; Exit if higher precedence
        INC     HL              ; Point to routine address
        CALL    TSTNUM          ; Make sure it's a number

STKTHS: PUSH    BC              ; Save last precedence & token
        LD      BC,#EVAL3        ; Where to go on prec' break
        PUSH    BC              ; Save on stack for return
        LD      B,E             ; Save operator
        LD      C,D             ; Save precedence
        CALL    STAKFP          ; Move value to stack
        LD      E,B             ; Restore operator
        LD      D,C             ; Restore precedence
        LD      C,(HL)          ; Get LSB of routine address
        INC     HL
        LD      B,(HL)          ; Get MSB of routine address
        INC     HL
        PUSH    BC              ; Save routine address
        LD      HL,(CUROPR)     ; Address of current operator
        JP      EVAL1           ; Loop until prec' break

OPRND:  XOR     A               ; Get operand routine
        LD      (TYPE),A        ; Set numeric expected
        CALL    GETCHR          ; Get next character
        LD      E,#MO            ; ?MO Error
        JP      Z,ERROR         ; No operand - Error
        JP      C,ASCTFP        ; Number - Get value
        CALL    CHKLTR          ; See if a letter
        JP      NC,CONVAR       ; Letter - Find variable
        CP      #ZPLUS           ; "+" Token ?
        JP      Z,OPRND         ; Yes - Look for operand
        CP      #"."             ; "." ?
        JP      Z,ASCTFP        ; Yes - Create FP number
        CP      #ZMINUS          ; "-" Token ?
        JP      Z,MINUS         ; Yes - Do minus
        CP      #'"'             ; Literal string ?"
        JP      Z,QTSTR         ; Get string terminated by '"'
        CP      #ZNOT            ; "NOT" Token ?
        JP      Z,EVNOT         ; Yes - Eval NOT expression
        CP      #ZFN             ; "FN" Token ?
        JP      Z,DOFN          ; Yes - Do FN routine
        SUB     #ZSGN            ; Is it a function?
        JP      NC,FNOFST       ; Yes - Evaluate function
EVLPAR: CALL    OPNPAR          ; Evaluate expression in "()"
        CALL    CHKSYN          ; Make sure ")" follows
        .db      ")"
        RET

MINUS:  LD      D,#0x7D           ; "-" precedence
        CALL    EVAL1           ; Evaluate until prec' break
        LD      HL,(NXTOPR)     ; Get next operator address
        PUSH    HL              ; Save next operator address
        CALL    INVSGN          ; Negate value
RETNUM: CALL    TSTNUM          ; Make sure it's a number
        POP     HL              ; Restore next operator address
        RET

CONVAR: CALL    GETVAR          ; Get variable address to DE
FRMEVL: PUSH    HL              ; Save code string address
        EX      DE,HL           ; Variable address to HL
        LD      (FPREG),HL      ; Save address of variable
        LD      A,(TYPE)        ; Get type
        OR      A               ; Numeric?
        CALL    Z,PHLTFP        ; Yes - Move contents to FPREG
        POP     HL              ; Restore code string address
        RET

FNOFST: LD      B,#0             ; Get address of function
        RLCA                    ; Double function offset
        LD      C,A             ; BC = Offset in function table
        PUSH    BC              ; Save adjusted token value
        CALL    GETCHR          ; Get next character
        LD      A,C             ; Get adjusted token value
        CP      #2*(ZPOINT-ZSGN) ; Adjusted "POINT" token?
        JP      Z,POINTB        ; Yes - Do "POINT" (not POINTB)
        CP      #2*(ZLEFT-ZSGN)-1; Adj' LEFT$,RIGHT$ or MID$ ?
        JP      C,FNVAL         ; No - Do function
        CALL    OPNPAR          ; Evaluate expression  (X,...
        CALL    CHKSYN          ; Make sure "," follows
        .db     #","
        CALL    TSTSTR          ; Make sure it's a string
        EX      DE,HL           ; Save code string address
        LD      HL,(FPREG)      ; Get address of string
        EX      (SP),HL         ; Save address of string
        PUSH    HL              ; Save adjusted token value
        EX      DE,HL           ; Restore code string address
        CALL    GETINT          ; Get integer 0-255
        EX      DE,HL           ; Save code string address
        EX      (SP),HL         ; Save integer,HL = adj' token
        JP      GOFUNC          ; Jump to string function

FNVAL:  CALL    EVLPAR          ; Evaluate expression
        EX      (SP),HL         ; HL = Adjusted token value
        LD      DE,#RETNUM       ; Return number from function
        PUSH    DE              ; Save on stack
GOFUNC: LD      BC,#FNCTAB       ; Function routine addresses
        ADD     HL,BC           ; Point to right address
        LD      C,(HL)          ; Get LSB of address
        INC     HL              ;
        LD      H,(HL)          ; Get MSB of address
        LD      L,C             ; Address to HL
        JP      (HL)            ; Jump to function

SGNEXP: DEC     D               ; Dee to flag negative exponent
        CP      #ZMINUS          ; "-" token ?
        RET     Z               ; Yes - Return
        CP      #"-"             ; "-" ASCII ?
        RET     Z               ; Yes - Return
        INC     D               ; Inc to flag positive exponent
        CP      #"+"             ; "+" ASCII ?
        RET     Z               ; Yes - Return
        CP      #ZPLUS           ; "+" token ?
        RET     Z               ; Yes - Return
        DEC     HL              ; DEC 'cos GETCHR INCs
        RET                     ; Return "NZ"

POR:    .db      0x0F6            ; Flag "OR"
PAND:   XOR     A               ; Flag "AND"
        PUSH    AF              ; Save "AND" / "OR" flag
        CALL    TSTNUM          ; Make sure it's a number
        CALL    DEINT           ; Get integer -32768 to 32767
        POP     AF              ; Restore "AND" / "OR" flag
        EX      DE,HL           ; <- Get last
        POP     BC              ; <-  value
        EX      (SP),HL         ; <-  from
        EX      DE,HL           ; <-  stack
        CALL    FPBCDE          ; Move last value to FPREG
        PUSH    AF              ; Save "AND" / "OR" flag
        CALL    DEINT           ; Get integer -32768 to 32767
        POP     AF              ; Restore "AND" / "OR" flag
        POP     BC              ; Get value
        LD      A,C             ; Get LSB
        LD      HL,#ACPASS       ; Address of save AC as current
        JP      NZ,POR1         ; Jump if OR
        AND     E               ; "AND" LSBs
        LD      C,A             ; Save LSB
        LD      A,B             ; Get MBS
        AND     D               ; "AND" MSBs
        JP      (HL)            ; Save AC as current (ACPASS)

POR1:   OR      E               ; "OR" LSBs
        LD      C,A             ; Save LSB
        LD      A,B             ; Get MSB
        OR      D               ; "OR" MSBs
        JP      (HL)            ; Save AC as current (ACPASS)

TSTRED: LD      HL,#CMPLOG       ; Logical compare routine
        LD      A,(TYPE)        ; Get data type
        RRA                     ; Carry set = string
        LD      A,D             ; Get last precedence value
        RLA                     ; Times 2 plus carry
        LD      E,A             ; To E
        LD      D,#0x64           ; Relational precedence
        LD      A,B             ; Get current precedence
        CP      D               ; Compare with last
        RET     NC              ; Eval if last was rel' or log'
        JP      STKTHS          ; Stack this one and get next

CMPLOG: .dw      CMPLG1          ; Compare two values / strings
CMPLG1: LD      A,C             ; Get data type
        OR      A
        RRA
        POP     BC              ; Get last expression to BCDE
        POP     DE
        PUSH    AF              ; Save status
        CALL    CHKTYP          ; Check that types match
        LD      HL,#CMPRES       ; Result to comparison
        PUSH    HL              ; Save for RETurn
        JP      Z,CMPNUM        ; Compare values if numeric
        XOR     A               ; Compare two strings
        LD      (TYPE),A        ; Set type to numeric
        PUSH    DE              ; Save string name
        CALL    GSTRCU          ; Get current string
        LD      A,(HL)          ; Get length of string
        INC     HL
        INC     HL
        LD      C,(HL)          ; Get LSB of address
        INC     HL
        LD      B,(HL)          ; Get MSB of address
        POP     DE              ; Restore string name
        PUSH    BC              ; Save address of string
        PUSH    AF              ; Save length of string
        CALL    GSTRDE          ; Get second string
        CALL    LOADFP          ; Get address of second string
        POP     AF              ; Restore length of string 1
        LD      D,A             ; Length to D
        POP     HL              ; Restore address of string 1
CMPSTR: LD      A,E             ; Bytes of string 2 to do
        OR      D               ; Bytes of string 1 to do
        RET     Z               ; Exit if all bytes compared
        LD      A,D             ; Get bytes of string 1 to do
        SUB     #1
        RET     C               ; Exit if end of string 1
        XOR     A
        CP      E               ; Bytes of string 2 to do
        INC     A
        RET     NC              ; Exit if end of string 2
        DEC     D               ; Count bytes in string 1
        DEC     E               ; Count bytes in string 2
        LD      A,(BC)          ; Byte in string 2
        CP      (HL)            ; Compare to byte in string 1
        INC     HL              ; Move up string 1
        INC     BC              ; Move up string 2
        JP      Z,CMPSTR        ; Same - Try next bytes
        CCF                     ; Flag difference (">" or "<")
        JP      FLGDIF          ; "<" gives -1 , ">" gives +1

CMPRES: INC     A               ; Increment current value
        ADC     A,A             ; Double plus carry
        POP     BC              ; Get other value
        AND     B               ; Combine them
        ADD     A,#-1            ; Carry set if different
        SBC     A,A             ; 00 - Equal , FF - Different
        JP      FLGREL          ; Set current value & continue

EVNOT:  LD      D,#0x5A           ; Precedence value for "NOT"
        CALL    EVAL1           ; Eval until precedence break
        CALL    TSTNUM          ; Make sure it's a number
        CALL    DEINT           ; Get integer -32768 - 32767
        LD      A,E             ; Get LSB
        CPL                     ; Invert LSB
        LD      C,A             ; Save "NOT" of LSB
        LD      A,D             ; Get MSB
        CPL                     ; Invert MSB
        CALL    ACPASS          ; Save AC as current
        POP     BC              ; Clean up stack
        JP      EVAL3           ; Continue evaluation

DIMRET: DEC     HL              ; DEC 'cos GETCHR INCs
        CALL    GETCHR          ; Get next character
        RET     Z               ; End of DIM statement
        CALL    CHKSYN          ; Make sure "," follows
        .db      ","
DIM:    LD      BC,#DIMRET       ; Return to "DIMRET"
        PUSH    BC              ; Save on stack
        .db      0x0F6            ; Flag "Create" variable
GETVAR: XOR     A               ; Find variable address,to DE
        LD      (LCRFLG),A      ; Set locate / create flag
        LD      B,(HL)          ; Get First byte of name
GTFNAM: CALL    CHKLTR          ; See if a letter
        JP      C,SNERR         ; ?SN Error if not a letter
        XOR     A
        LD      C,A             ; Clear second byte of name
        LD      (TYPE),A        ; Set type to numeric
        CALL    GETCHR          ; Get next character
        JP      C,SVNAM2        ; Numeric - Save in name
        CALL    CHKLTR          ; See if a letter
        JP      C,CHARTY        ; Not a letter - Check type
SVNAM2: LD      C,A             ; Save second byte of name
ENDNAM: CALL    GETCHR          ; Get next character
        JP      C,ENDNAM        ; Numeric - Get another
        CALL    CHKLTR          ; See if a letter
        JP      NC,ENDNAM       ; Letter - Get another
CHARTY: SUB     #"$"             ; String variable?
        JP      NZ,NOTSTR       ; No - Numeric variable
        INC     A               ; A = 1 (string type)
        LD      (TYPE),A        ; Set type to string
        RRCA                    ; A = 0x80 , Flag for string
        ADD     A,C             ; 2nd byte of name has bit 7 on
        LD      C,A             ; Resave second byte on name
        CALL    GETCHR          ; Get next character
NOTSTR: LD      A,(FORFLG)      ; Array name needed ?
        DEC     A
        JP      Z,ARLDSV        ; Yes - Get array name
        JP      P,NSCFOR        ; No array with "FOR" or "FN"
        LD      A,(HL)          ; Get byte again
        SUB     #"("             ; Subscripted variable?
        JP      Z,SBSCPT        ; Yes - Sort out subscript

NSCFOR: XOR     A               ; Simple variable
        LD      (FORFLG),A      ; Clear "FOR" flag
        PUSH    HL              ; Save code string address
        LD      D,B             ; DE = Variable name to find
        LD      E,C
        LD      HL,(FNRGNM)     ; FN argument name
        CALL    CPDEHL          ; Is it the FN argument?
        LD      DE,#FNARG        ; Point to argument value
        JP      Z,POPHRT        ; Yes - Return FN argument value
        LD      HL,(VAREND)     ; End of variables
        EX      DE,HL           ; Address of end of search
        LD      HL,(PROGND)     ; Start of variables address
FNDVAR: CALL    CPDEHL          ; End of variable list table?
        JP      Z,CFEVAL        ; Yes - Called from EVAL?
        LD      A,C             ; Get second byte of name
        SUB     (HL)            ; Compare with name in list
        INC     HL              ; Move on to first byte
        JP      NZ,FNTHR        ; Different - Find another
        LD      A,B             ; Get first byte of name
        SUB     (HL)            ; Compare with name in list
FNTHR:  INC     HL              ; Move on to LSB of value
        JP      Z,RETADR        ; Found - Return address
        INC     HL              ; <- Skip
        INC     HL              ; <- over
        INC     HL              ; <- F.P.
        INC     HL              ; <- value
        JP      FNDVAR          ; Keep looking

CFEVAL: POP     HL              ; Restore code string address
        EX      (SP),HL         ; Get return address
        PUSH    DE              ; Save address of variable
        LD      DE,#FRMEVL       ; Return address in EVAL
        CALL    CPDEHL          ; Called from EVAL ?
        POP     DE              ; Restore address of variable
        JP      Z,RETNUL        ; Yes - Return null variable
        EX      (SP),HL         ; Put back return
        PUSH    HL              ; Save code string address
        PUSH    BC              ; Save variable name
        LD      BC,#6            ; 2 byte name plus 4 byte data
        LD      HL,(ARREND)     ; End of arrays
        PUSH    HL              ; Save end of arrays
        ADD     HL,BC           ; Move up 6 bytes
        POP     BC              ; Source address in BC
        PUSH    HL              ; Save new end address
        CALL    MOVUP           ; Move arrays up
        POP     HL              ; Restore new end address
        LD      (ARREND),HL     ; Set new end address
        LD      H,B             ; End of variables to HL
        LD      L,C
        LD      (VAREND),HL     ; Set new end address

ZEROLP: DEC     HL              ; Back through to zero variable
        LD      (HL),#0          ; Zero byte in variable
        CALL    CPDEHL          ; Done them all?
        JP      NZ,ZEROLP       ; No - Keep on going
        POP     DE              ; Get variable name
        LD      (HL),E          ; Store second character
        INC     HL
        LD      (HL),D          ; Store first character
        INC     HL
RETADR: EX      DE,HL           ; Address of variable in DE
        POP     HL              ; Restore code string address
        RET

RETNUL: LD      (FPEXP),A       ; Set result to zero
        LD      HL,#ZERBYT       ; Also set a null string
        LD      (FPREG),HL      ; Save for EVAL
        POP     HL              ; Restore code string address
        RET

SBSCPT: PUSH    HL              ; Save code string address
        LD      HL,(LCRFLG)     ; Locate/Create and Type
        EX      (SP),HL         ; Save and get code string
        LD      D,A             ; Zero number of dimensions
SCPTLP: PUSH    DE              ; Save number of dimensions
        PUSH    BC              ; Save array name
        CALL    FPSINT          ; Get subscript (0-32767)
        POP     BC              ; Restore array name
        POP     AF              ; Get number of dimensions
        EX      DE,HL
        EX      (SP),HL         ; Save subscript value
        PUSH    HL              ; Save LCRFLG and TYPE
        EX      DE,HL
        INC     A               ; Count dimensions
        LD      D,A             ; Save in D
        LD      A,(HL)          ; Get next byte in code string
        CP      #","             ; Comma (more to come)?
        JP      Z,SCPTLP        ; Yes - More subscripts
        CALL    CHKSYN          ; Make sure ")" follows
        .db     # ")"
        LD      (NXTOPR),HL     ; Save code string address
        POP     HL              ; Get LCRFLG and TYPE
        LD      (LCRFLG),HL     ; Restore Locate/create & type
        LD      E,#0             ; Flag not CSAVE* or CLOAD*
        PUSH    DE              ; Save number of dimensions (D)
        .db      0x11             ; Skip "PUSH HL" and "PUSH AF'

ARLDSV: PUSH    HL              ; Save code string address
        PUSH    AF              ; A = 00 , Flags set = Z,N
        LD      HL,(VAREND)     ; Start of arrays
        .db      0x3E             ; Skip "ADD HL,DE"
FNDARY: ADD     HL,DE           ; Move to next array start
        EX      DE,HL
        LD      HL,(ARREND)     ; End of arrays
        EX      DE,HL           ; Current array pointer
        CALL    CPDEHL          ; End of arrays found?
        JP      Z,CREARY        ; Yes - Create array
        LD      A,(HL)          ; Get second byte of name
        CP      C               ; Compare with name given
        INC     HL              ; Move on
        JP      NZ,NXTARY       ; Different - Find next array
        LD      A,(HL)          ; Get first byte of name
        CP      B               ; Compare with name given
NXTARY: INC     HL              ; Move on
        LD      E,(HL)          ; Get LSB of next array address
        INC     HL
        LD      D,(HL)          ; Get MSB of next array address
        INC     HL
        JP      NZ,FNDARY       ; Not found - Keep looking
        LD      A,(LCRFLG)      ; Found Locate or Create it?
        OR      A
        JP      NZ,DDERR        ; Create - ?DD Error
        POP     AF              ; Locate - Get number of dim'ns
        LD      B,H             ; BC Points to array dim'ns
        LD      C,L
        JP      Z,POPHRT        ; Jump if array load/save
        SUB     (HL)            ; Same number of dimensions?
        JP      Z,FINDEL        ; Yes - Find element
BSERR:  LD      E,#BS            ; ?BS Error
        JP      ERROR           ; Output error

CREARY: LD      DE,#4            ; 4 Bytes per entry
        POP     AF              ; Array to save or 0 dim'ns?
        JP      Z,FCERR         ; Yes - ?FC Error
        LD      (HL),C          ; Save second byte of name
        INC     HL
        LD      (HL),B          ; Save first byte of name
        INC     HL
        LD      C,A             ; Number of dimensions to C
        CALL    CHKSTK          ; Check if enough memory
        INC     HL              ; Point to number of dimensions
        INC     HL
        LD      (CUROPR),HL     ; Save address of pointer
        LD      (HL),C          ; Set number of dimensions
        INC     HL
        LD      A,(LCRFLG)      ; Locate of Create?
        RLA                     ; Carry set = Create
        LD      A,C             ; Get number of dimensions
CRARLP: LD      BC,#10+1         ; Default dimension size 10
        JP      NC,DEFSIZ       ; Locate - Set default size
        POP     BC              ; Get specified dimension size
        INC     BC              ; Include zero element
DEFSIZ: LD      (HL),C          ; Save LSB of dimension size
        INC     HL
        LD      (HL),B          ; Save MSB of dimension size
        INC     HL
        PUSH    AF              ; Save num' of dim'ns an status
        PUSH    HL              ; Save address of dim'n size
        CALL    MLDEBC          ; Multiply DE by BC to find
        EX      DE,HL           ; amount of mem needed (to DE)
        POP     HL              ; Restore address of dimension
        POP     AF              ; Restore number of dimensions
        DEC     A               ; Count them
        JP      NZ,CRARLP       ; Do next dimension if more
        PUSH    AF              ; Save locate/create flag
        LD      B,D             ; MSB of memory needed
        LD      C,E             ; LSB of memory needed
        EX      DE,HL
        ADD     HL,DE           ; Add bytes to array start
        JP      C,OMERR         ; Too big - Error
        CALL    ENFMEM          ; See if enough memory
        LD      (ARREND),HL     ; Save new end of array

ZERARY: DEC     HL              ; Back through array data
        LD      (HL),#0          ; Set array element to zero
        CALL    CPDEHL          ; All elements zeroed?
        JP      NZ,ZERARY       ; No - Keep on going
        INC     BC              ; Number of bytes + 1
        LD      D,A             ; A=0
        LD      HL,(CUROPR)     ; Get address of array
        LD      E,(HL)          ; Number of dimensions
        EX      DE,HL           ; To HL
        ADD     HL,HL           ; Two bytes per dimension size
        ADD     HL,BC           ; Add number of bytes
        EX      DE,HL           ; Bytes needed to DE
        DEC     HL
        DEC     HL
        LD      (HL),E          ; Save LSB of bytes needed
        INC     HL
        LD      (HL),D          ; Save MSB of bytes needed
        INC     HL
        POP     AF              ; Locate / Create?
        JP      C,ENDDIM        ; A is 0 , End if create
FINDEL: LD      B,A             ; Find array element
        LD      C,A
        LD      A,(HL)          ; Number of dimensions
        INC     HL
        .db      0x16             ; Skip "POP HL"
FNDELP: POP     HL              ; Address of next dim' size
        LD      E,(HL)          ; Get LSB of dim'n size
        INC     HL
        LD      D,(HL)          ; Get MSB of dim'n size
        INC     HL
        EX      (SP),HL         ; Save address - Get index
        PUSH    AF              ; Save number of dim'ns
        CALL    CPDEHL          ; Dimension too large?
        JP      NC,BSERR        ; Yes - ?BS Error
        PUSH    HL              ; Save index
        CALL    MLDEBC          ; Multiply previous by size
        POP     DE              ; Index supplied to DE
        ADD     HL,DE           ; Add index to pointer
        POP     AF              ; Number of dimensions
        DEC     A               ; Count them
        LD      B,H             ; MSB of pointer
        LD      C,L             ; LSB of pointer
        JP      NZ,FNDELP       ; More - Keep going
        ADD     HL,HL           ; 4 Bytes per element
        ADD     HL,HL
        POP     BC              ; Start of array
        ADD     HL,BC           ; Point to element
        EX      DE,HL           ; Address of element to DE
ENDDIM: LD      HL,(NXTOPR)     ; Got code string address
        RET

FRE:    LD      HL,(ARREND)     ; Start of free memory
        EX      DE,HL           ; To DE
        LD      HL,#0            ; End of free memory
        ADD     HL,SP           ; Current stack value
        LD      A,(TYPE)        ; Dummy argument type
        OR      A
        JP      Z,FRENUM        ; Numeric - Free variable space
        CALL    GSTRCU          ; Current string to pool
        CALL    GARBGE          ; Garbage collection
        LD      HL,(STRSPC)     ; Bottom of string space in use
        EX      DE,HL           ; To DE
        LD      HL,(STRBOT)     ; Bottom of string space
FRENUM: LD      A,L             ; Get LSB of end
        SUB     E               ; Subtract LSB of beginning
        LD      C,A             ; Save difference if C
        LD      A,H             ; Get MSB of end
        SBC     A,D             ; Subtract MSB of beginning
ACPASS: LD      B,C             ; Return integer AC
ABPASS: LD      D,B             ; Return integer AB
        LD      E,#0
        LD      HL,#TYPE         ; Point to type
        LD      (HL),E          ; Set type to numeric
        LD      B,#0x80+16        ; 16 bit integer
        JP      RETINT          ; Return the integr

POS:    LD      A,(CURPOS)      ; Get cursor position
PASSA:  LD      B,A             ; Put A into AB
        XOR     A               ; Zero A
        JP      ABPASS          ; Return integer AB

DEF:    CALL    CHEKFN          ; Get "FN" and name
        CALL    IDTEST          ; Test for illegal direct
        LD      BC,#DATA         ; To get next statement
        PUSH    BC              ; Save address for RETurn
        PUSH    DE              ; Save address of function ptr
        CALL    CHKSYN          ; Make sure "(" follows
        .db      "("
        CALL    GETVAR          ; Get argument variable name
        PUSH    HL              ; Save code string address
        EX      DE,HL           ; Argument address to HL
        DEC     HL
        LD      D,(HL)          ; Get first byte of arg name
        DEC     HL
        LD      E,(HL)          ; Get second byte of arg name
        POP     HL              ; Restore code string address
        CALL    TSTNUM          ; Make sure numeric argument
        CALL    CHKSYN          ; Make sure ")" follows
        .db      ")"
        CALL    CHKSYN          ; Make sure "=" follows
        .db      ZEQUAL          ; "=" token
        LD      B,H             ; Code string address to BC
        LD      C,L
        EX      (SP),HL         ; Save code str , Get FN ptr
        LD      (HL),C          ; Save LSB of FN code string
        INC     HL
        LD      (HL),B          ; Save MSB of FN code string
        JP      SVSTAD          ; Save address and do function

DOFN:   CALL    CHEKFN          ; Make sure FN follows
        PUSH    DE              ; Save function pointer address
        CALL    EVLPAR          ; Evaluate expression in "()"
        CALL    TSTNUM          ; Make sure numeric result
        EX      (SP),HL         ; Save code str , Get FN ptr
        LD      E,(HL)          ; Get LSB of FN code string
        INC     HL
        LD      D,(HL)          ; Get MSB of FN code string
        INC     HL
        LD      A,D             ; And function DEFined?
        OR      E
        JP      Z,UFERR         ; No - ?UF Error
        LD      A,(HL)          ; Get LSB of argument address
        INC     HL
        LD      H,(HL)          ; Get MSB of argument address
        LD      L,A             ; HL = Arg variable address
        PUSH    HL              ; Save it
        LD      HL,(FNRGNM)     ; Get old argument name
        EX      (SP),HL ;       ; Save old , Get new
        LD      (FNRGNM),HL     ; Set new argument name
        LD      HL,(FNARG+2)    ; Get LSB,NLSB of old arg value
        PUSH    HL              ; Save it
        LD      HL,(FNARG)      ; Get MSB,EXP of old arg value
        PUSH    HL              ; Save it
        LD      HL,#FNARG        ; HL = Value of argument
        PUSH    DE              ; Save FN code string address
        CALL    FPTHL           ; Move FPREG to argument
        POP     HL              ; Get FN code string address
        CALL    GETNUM          ; Get value from function
        DEC     HL              ; DEC 'cos GETCHR INCs
        CALL    GETCHR          ; Get next character
        JP      NZ,SNERR        ; Bad character in FN - Error
        POP     HL              ; Get MSB,EXP of old arg
        LD      (FNARG),HL      ; Restore it
        POP     HL              ; Get LSB,NLSB of old arg
        LD      (FNARG+2),HL    ; Restore it
        POP     HL              ; Get name of old arg
        LD      (FNRGNM),HL     ; Restore it
        POP     HL              ; Restore code string address
        RET

IDTEST: PUSH    HL              ; Save code string address
        LD      HL,(LINEAT)     ; Get current line number
        INC     HL              ; -1 means direct statement
        LD      A,H
        OR      L
        POP     HL              ; Restore code string address
        RET     NZ              ; Return if in program
        LD      E,#ID            ; ?ID Error
        JP      ERROR

CHEKFN: CALL    CHKSYN          ; Make sure FN follows
        .db      ZFN             ; "FN" token
        LD      A,#0x80
        LD      (FORFLG),A      ; Flag FN name to find
        OR      (HL)            ; FN name has bit 7 set
        LD      B,A             ; in first byte of name
        CALL    GTFNAM          ; Get FN name
        JP      TSTNUM          ; Make sure numeric function

STR:    CALL    TSTNUM          ; Make sure it's a number
        CALL    NUMASC          ; Turn number into text
        CALL    CRTST           ; Create string entry for it
        CALL    GSTRCU          ; Current string to pool
        LD      BC,#TOPOOL       ; Save in string pool
        PUSH    BC              ; Save address on stack

SAVSTR: LD      A,(HL)          ; Get string length
        INC     HL
        INC     HL
        PUSH    HL              ; Save pointer to string
        CALL    TESTR           ; See if enough string space
        POP     HL              ; Restore pointer to string
        LD      C,(HL)          ; Get LSB of address
        INC     HL
        LD      B,(HL)          ; Get MSB of address
        CALL    CRTMST          ; Create string entry
        PUSH    HL              ; Save pointer to MSB of addr
        LD      L,A             ; Length of string
        CALL    TOSTRA          ; Move to string area
        POP     DE              ; Restore pointer to MSB
        RET

MKTMST: CALL    TESTR           ; See if enough string space
CRTMST: LD      HL,#TMPSTR       ; Temporary string
        PUSH    HL              ; Save it
        LD      (HL),A          ; Save length of string
        INC     HL
SVSTAD: INC     HL
        LD      (HL),E          ; Save LSB of address
        INC     HL
        LD      (HL),D          ; Save MSB of address
        POP     HL              ; Restore pointer
        RET

CRTST:  DEC     HL              ; DEC - INCed after
QTSTR:  LD      B,#'"'           ; Terminating quote"
        LD      D,B             ; Quote to D
DTSTR:  PUSH    HL              ; Save start
        LD      C,#-1            ; Set counter to -1
QTSTLP: INC     HL              ; Move on
        LD      A,(HL)          ; Get byte
        INC     C               ; Count bytes
        OR      A               ; End of line?
        JP      Z,CRTSTE        ; Yes - Create string entry
        CP      D               ; Terminator D found?
        JP      Z,CRTSTE        ; Yes - Create string entry
        CP      B               ; Terminator B found?
        JP      NZ,QTSTLP       ; No - Keep looking
CRTSTE: CP      #'"'             ; End with '"'?
        CALL    Z,GETCHR        ; Yes - Get next character
        EX      (SP),HL         ; Starting quote
        INC     HL              ; First byte of string
        EX      DE,HL           ; To DE
        LD      A,C             ; Get length
        CALL    CRTMST          ; Create string entry
TSTOPL: LD      DE,#TMPSTR       ; Temporary string
        LD      HL,(TMSTPT)     ; Temporary string pool pointer
        LD      (FPREG),HL      ; Save address of string ptr
        LD      A,#1
        LD      (TYPE),A        ; Set type to string
        CALL    DETHL4          ; Move string to pool
        CALL    CPDEHL          ; Out of string pool?
        LD      (TMSTPT),HL     ; Save new pointer
        POP     HL              ; Restore code string address
        LD      A,(HL)          ; Get next code byte
        RET     NZ              ; Return if pool OK
        LD      E,#ST            ; ?ST Error
        JP      ERROR           ; String pool overflow

PRNUMS: INC     HL              ; Skip leading space
PRS:    CALL    CRTST           ; Create string entry for it
PRS1:   CALL    GSTRCU          ; Current string to pool
        CALL    LOADFP          ; Move string block to BCDE
        INC     E               ; Length + 1
PRSLP:  DEC     E               ; Count characters
        RET     Z               ; End of string
        LD      A,(BC)          ; Get byte to output
        CALL    OUTC            ; Output character in A
        CP      #CR              ; Return?
        CALL    Z,DONULL        ; Yes - Do nulls
        INC     BC              ; Next byte in string
        JP      PRSLP           ; More characters to output

TESTR:  OR      A               ; Test if enough room
        .db      0x0E             ; No garbage collection done
GRBDON: POP     AF              ; Garbage collection done
        PUSH    AF              ; Save status
        LD      HL,(STRSPC)     ; Bottom of string space in use
        EX      DE,HL           ; To DE
        LD      HL,(STRBOT)     ; Bottom of string area
        CPL                     ; Negate length (Top down)
        LD      C,A             ; -Length to BC
        LD      B,#-1            ; BC = -ve length of string
        ADD     HL,BC           ; Add to bottom of space in use
        INC     HL              ; Plus one for 2's complement
        CALL    CPDEHL          ; Below string RAM area?
        JP      C,TESTOS        ; Tidy up if not done else err
        LD      (STRBOT),HL     ; Save new bottom of area
        INC     HL              ; Point to first byte of string
        EX      DE,HL           ; Address to DE
POPAF:  POP     AF              ; Throw away status push
        RET

TESTOS: POP     AF              ; Garbage collect been done?
        LD      E,#OS            ; ?OS Error
        JP      Z,ERROR         ; Yes - Not enough string apace
        CP      A               ; Flag garbage collect done
        PUSH    AF              ; Save status
        LD      BC,#GRBDON       ; Garbage collection done
        PUSH    BC              ; Save for RETurn
GARBGE: LD      HL,(LSTRAM)     ; Get end of RAM pointer
GARBLP: LD      (STRBOT),HL     ; Reset string pointer
        LD      HL,#0
        PUSH    HL              ; Flag no string found
        LD      HL,(STRSPC)     ; Get bottom of string space
        PUSH    HL              ; Save bottom of string space
        LD      HL,#TMSTPL       ; Temporary string pool
GRBLP:  EX      DE,HL
        LD      HL,(TMSTPT)     ; Temporary string pool pointer
        EX      DE,HL
        CALL    CPDEHL          ; Temporary string pool done?
        LD      BC,#GRBLP        ; Loop until string pool done
        JP      NZ,STPOOL       ; No - See if in string area
        LD      HL,(PROGND)     ; Start of simple variables
SMPVAR: EX      DE,HL
        LD      HL,(VAREND)     ; End of simple variables
        EX      DE,HL
        CALL    CPDEHL          ; All simple strings done?
        JP      Z,ARRLP         ; Yes - Do string arrays
        LD      A,(HL)          ; Get type of variable
        INC     HL
        INC     HL
        OR      A               ; "S" flag set if string
        CALL    STRADD          ; See if string in string area
        JP      SMPVAR          ; Loop until simple ones done

GNXARY: POP     BC              ; Scrap address of this array
ARRLP:  EX      DE,HL
        LD      HL,(ARREND)     ; End of string arrays
        EX      DE,HL
        CALL    CPDEHL          ; All string arrays done?
        JP      Z,SCNEND        ; Yes - Move string if found
        CALL    LOADFP          ; Get array name to BCDE
        LD      A,E             ; Get type of array     
        PUSH    HL              ; Save address of num of dim'ns
        ADD     HL,BC           ; Start of next array
        OR      A               ; Test type of array
        JP      P,GNXARY        ; Numeric array - Ignore it
        LD      (CUROPR),HL     ; Save address of next array
        POP     HL              ; Get address of num of dim'ns
        LD      C,(HL)          ; BC = Number of dimensions
        LD      B,#0
        ADD     HL,BC           ; Two bytes per dimension size
        ADD     HL,BC
        INC     HL              ; Plus one for number of dim'ns
GRBARY: EX      DE,HL
        LD      HL,(CUROPR)     ; Get address of next array
        EX      DE,HL
        CALL    CPDEHL          ; Is this array finished?
        JP      Z,ARRLP         ; Yes - Get next one
        LD      BC,#GRBARY       ; Loop until array all done
STPOOL: PUSH    BC              ; Save return address
        OR      #0x80             ; Flag string type
STRADD: LD      A,(HL)          ; Get string length
        INC     HL
        INC     HL
        LD      E,(HL)          ; Get LSB of string address
        INC     HL
        LD      D,(HL)          ; Get MSB of string address
        INC     HL
        RET     P               ; Not a string - Return
        OR      A               ; Set flags on string length
        RET     Z               ; Null string - Return
        LD      B,H             ; Save variable pointer
        LD      C,L
        LD      HL,(STRBOT)     ; Bottom of new area
        CALL    CPDEHL          ; String been done?
        LD      H,B             ; Restore variable pointer
        LD      L,C
        RET     C               ; String done - Ignore
        POP     HL              ; Return address
        EX      (SP),HL         ; Lowest available string area
        CALL    CPDEHL          ; String within string area?
        EX      (SP),HL         ; Lowest available string area
        PUSH    HL              ; Re-save return address
        LD      H,B             ; Restore variable pointer
        LD      L,C
        RET     NC              ; Outside string area - Ignore
        POP     BC              ; Get return , Throw 2 away
        POP     AF              ; 
        POP     AF              ; 
        PUSH    HL              ; Save variable pointer
        PUSH    DE              ; Save address of current
        PUSH    BC              ; Put back return address
        RET                     ; Go to it

SCNEND: POP     DE              ; Addresses of strings
        POP     HL              ; 
        LD      A,L             ; HL = 0 if no more to do
        OR      H
        RET     Z               ; No more to do - Return
        DEC     HL
        LD      B,(HL)          ; MSB of address of string
        DEC     HL
        LD      C,(HL)          ; LSB of address of string
        PUSH    HL              ; Save variable address
        DEC     HL
        DEC     HL
        LD      L,(HL)          ; HL = Length of string
        LD      H,#0
        ADD     HL,BC           ; Address of end of string+1
        LD      D,B             ; String address to DE
        LD      E,C
        DEC     HL              ; Last byte in string
        LD      B,H             ; Address to BC
        LD      C,L
        LD      HL,(STRBOT)     ; Current bottom of string area
        CALL    MOVSTR          ; Move string to new address
        POP     HL              ; Restore variable address
        LD      (HL),C          ; Save new LSB of address
        INC     HL
        LD      (HL),B          ; Save new MSB of address
        LD      L,C             ; Next string area+1 to HL
        LD      H,B
        DEC     HL              ; Next string area address
        JP      GARBLP          ; Look for more strings

CONCAT: PUSH    BC              ; Save prec' opr & code string
        PUSH    HL              ; 
        LD      HL,(FPREG)      ; Get first string
        EX      (SP),HL         ; Save first string
        CALL    OPRND           ; Get second string
        EX      (SP),HL         ; Restore first string
        CALL    TSTSTR          ; Make sure it's a string
        LD      A,(HL)          ; Get length of second string
        PUSH    HL              ; Save first string
        LD      HL,(FPREG)      ; Get second string
        PUSH    HL              ; Save second string
        ADD     A,(HL)          ; Add length of second string
        LD      E,#LS            ; ?LS Error
        JP      C,ERROR         ; String too long - Error
        CALL    MKTMST          ; Make temporary string
        POP     DE              ; Get second string to DE
        CALL    GSTRDE          ; Move to string pool if needed
        EX      (SP),HL         ; Get first string
        CALL    GSTRHL          ; Move to string pool if needed
        PUSH    HL              ; Save first string
        LD      HL,(TMPSTR+2)   ; Temporary string address
        EX      DE,HL           ; To DE
        CALL    SSTSA           ; First string to string area
        CALL    SSTSA           ; Second string to string area
        LD      HL,#EVAL2        ; Return to evaluation loop
        EX      (SP),HL         ; Save return,get code string
        PUSH    HL              ; Save code string address
        JP      TSTOPL          ; To temporary string to pool

SSTSA:  POP     HL              ; Return address
        EX      (SP),HL         ; Get string block,save return
        LD      A,(HL)          ; Get length of string
        INC     HL
        INC     HL
        LD      C,(HL)          ; Get LSB of string address
        INC     HL
        LD      B,(HL)          ; Get MSB of string address
        LD      L,A             ; Length to L
TOSTRA: INC     L               ; INC - DECed after
TSALP:  DEC     L               ; Count bytes moved
        RET     Z               ; End of string - Return
        LD      A,(BC)          ; Get source
        LD      (DE),A          ; Save destination
        INC     BC              ; Next source
        INC     DE              ; Next destination
        JP      TSALP           ; Loop until string moved

GETSTR: CALL    TSTSTR          ; Make sure it's a string
GSTRCU: LD      HL,(FPREG)      ; Get current string
GSTRHL: EX      DE,HL           ; Save DE
GSTRDE: CALL    BAKTMP          ; Was it last tmp-str?
        EX      DE,HL           ; Restore DE
        RET     NZ              ; No - Return
        PUSH    DE              ; Save string
        LD      D,B             ; String block address to DE
        LD      E,C
        DEC     DE              ; Point to length
        LD      C,(HL)          ; Get string length
        LD      HL,(STRBOT)     ; Current bottom of string area
        CALL    CPDEHL          ; Last one in string area?
        JP      NZ,POPHL        ; No - Return
        LD      B,A             ; Clear B (A=0)
        ADD     HL,BC           ; Remove string from str' area
        LD      (STRBOT),HL     ; Save new bottom of str' area
POPHL:  POP     HL              ; Restore string
        RET

BAKTMP: LD      HL,(TMSTPT)     ; Get temporary string pool top
        DEC     HL              ; Back
        LD      B,(HL)          ; Get MSB of address
        DEC     HL              ; Back
        LD      C,(HL)          ; Get LSB of address
        DEC     HL              ; Back
        DEC     HL              ; Back
        CALL    CPDEHL          ; String last in string pool?
        RET     NZ              ; Yes - Leave it
        LD      (TMSTPT),HL     ; Save new string pool top
        RET

LEN:    LD      BC,#PASSA        ; To return integer A
        PUSH    BC              ; Save address
GETLEN: CALL    GETSTR          ; Get string and its length
        XOR     A
        LD      D,A             ; Clear D
        LD      (TYPE),A        ; Set type to numeric
        LD      A,(HL)          ; Get length of string
        OR      A               ; Set status flags
        RET

ASC:    LD      BC,#PASSA        ; To return integer A
        PUSH    BC              ; Save address
GTFLNM: CALL    GETLEN          ; Get length of string
        JP      Z,FCERR         ; Null string - Error
        INC     HL
        INC     HL
        LD      E,(HL)          ; Get LSB of address
        INC     HL
        LD      D,(HL)          ; Get MSB of address
        LD      A,(DE)          ; Get first byte of string
        RET

CHR:    LD      A,#1             ; One character string
        CALL    MKTMST          ; Make a temporary string
        CALL    MAKINT          ; Make it integer A
        LD      HL,(TMPSTR+2)   ; Get address of string
        LD      (HL),E          ; Save character
TOPOOL: POP     BC              ; Clean up stack
        JP      TSTOPL          ; Temporary string to pool

LEFT:   CALL    LFRGNM          ; Get number and ending ")"
        XOR     A               ; Start at first byte in string
RIGHT1: EX      (SP),HL         ; Save code string,Get string
        LD      C,A             ; Starting position in string
MID1:   PUSH    HL              ; Save string block address
        LD      A,(HL)          ; Get length of string
        CP      B               ; Compare with number given
        JP      C,ALLFOL        ; All following bytes required
        LD      A,B             ; Get new length
        .db      0x11             ; Skip "LD C,0"
ALLFOL: LD      C,#0             ; First byte of string
        PUSH    BC              ; Save position in string
        CALL    TESTR           ; See if enough string space
        POP     BC              ; Get position in string
        POP     HL              ; Restore string block address
        PUSH    HL              ; And re-save it
        INC     HL
        INC     HL
        LD      B,(HL)          ; Get LSB of address
        INC     HL
        LD      H,(HL)          ; Get MSB of address
        LD      L,B             ; HL = address of string
        LD      B,#0             ; BC = starting address
        ADD     HL,BC           ; Point to that byte
        LD      B,H             ; BC = source string
        LD      C,L
        CALL    CRTMST          ; Create a string entry
        LD      L,A             ; Length of new string
        CALL    TOSTRA          ; Move string to string area
        POP     DE              ; Clear stack
        CALL    GSTRDE          ; Move to string pool if needed
        JP      TSTOPL          ; Temporary string to pool

RIGHT:  CALL    LFRGNM          ; Get number and ending ")"
        POP     DE              ; Get string length
        PUSH    DE              ; And re-save
        LD      A,(DE)          ; Get length
        SUB     B               ; Move back N bytes
        JP      RIGHT1          ; Go and get sub-string

MID:    EX      DE,HL           ; Get code string address
        LD      A,(HL)          ; Get next byte "," or ")"
        CALL    MIDNUM          ; Get number supplied
        INC     B               ; Is it character zero?
        DEC     B
        JP      Z,FCERR         ; Yes - Error
        PUSH    BC              ; Save starting position
        LD      E,#255           ; All of string
        CP      #")"             ; Any length given?
        JP      Z,#RSTSTR        ; No - Rest of string
        CALL    CHKSYN          ; Make sure "," follows
        .db     ","
        CALL    GETINT          ; Get integer 0-255
RSTSTR: CALL    CHKSYN          ; Make sure ")" follows
        .db     ")"
        POP     AF              ; Restore starting position
        EX      (SP),HL         ; Get string,8ave code string
        LD      BC,#MID1         ; Continuation of MID$ routine
        PUSH    BC              ; Save for return
        DEC     A               ; Starting position-1
        CP      (HL)            ; Compare with length
        LD      B,#0             ; Zero bytes length
        RET     NC              ; Null string if start past end
        LD      C,A             ; Save starting position-1
        LD      A,(HL)          ; Get length of string
        SUB     C               ; Subtract start
        CP      E               ; Enough string for it?
        LD      B,A             ; Save maximum length available
        RET     C               ; Truncate string if needed
        LD      B,E             ; Set specified length
        RET                     ; Go and create string

VAL:    CALL    GETLEN          ; Get length of string
        JP      Z,RESZER        ; Result zero
        LD      E,A             ; Save length
        INC     HL
        INC     HL
        LD      A,(HL)          ; Get LSB of address
        INC     HL
        LD      H,(HL)          ; Get MSB of address
        LD      L,A             ; HL = String address
        PUSH    HL              ; Save string address
        ADD     HL,DE
        LD      B,(HL)          ; Get end of string+1 byte
        LD      (HL),D          ; Zero it to terminate
        EX      (SP),HL         ; Save string end,get start
        PUSH    BC              ; Save end+1 byte
        LD      A,(HL)          ; Get starting byte
        CALL    ASCTFP          ; Convert ASCII string to FP
        POP     BC              ; Restore end+1 byte
        POP     HL              ; Restore end+1 address
        LD      (HL),B          ; Put back original byte
        RET

LFRGNM: EX      DE,HL           ; Code string address to HL
        CALL    CHKSYN          ; Make sure ")" follows
        .db     ")"
MIDNUM: POP     BC              ; Get return address
        POP     DE              ; Get number supplied
        PUSH    BC              ; Re-save return address
        LD      B,E             ; Number to B
        RET

INP:    CALL    MAKINT          ; Make it integer A
        LD      (INPORT),A      ; Set input port
        CALL    INPSUB          ; Get input from port
        JP      PASSA           ; Return integer A

POUT:   CALL    SETIO           ; Set up port number
        JP      OUTSUB          ; Output data and return

WAIT:   CALL    SETIO           ; Set up port number
        PUSH    AF              ; Save AND mask
        LD      E,#0             ; Assume zero if none given
        DEC     HL              ; DEC 'cos GETCHR INCs
        CALL    GETCHR          ; Get next character
        JP      Z,NOXOR         ; No XOR byte given
        CALL    CHKSYN          ; Make sure "," follows
        .db     ","
        CALL    GETINT          ; Get integer 0-255 to XOR with
NOXOR:  POP     BC              ; Restore AND mask
WAITLP: CALL    INPSUB          ; Get input
        XOR     E               ; Flip selected bits
        AND     B               ; Result non-zero?
        JP      Z,WAITLP        ; No = keep waiting
        RET

SETIO:  CALL    GETINT          ; Get integer 0-255
        LD      (INPORT),A      ; Set input port
        LD      (OTPORT),A      ; Set output port
        CALL    CHKSYN          ; Make sure "," follows
        .db     ","
        JP      GETINT          ; Get integer 0-255 and return

FNDNUM: CALL    GETCHR          ; Get next character
GETINT: CALL    GETNUM          ; Get a number from 0 to 255
MAKINT: CALL    DEPINT          ; Make sure value 0 - 255
        LD      A,D             ; Get MSB of number
        OR      A               ; Zero?
        JP      NZ,FCERR        ; No - Error
        DEC     HL              ; DEC 'cos GETCHR INCs
        CALL    GETCHR          ; Get next character
        LD      A,E             ; Get number to A
        RET

; << NO  REFERENCE  TO  THIS  SECTION  OF  CODE >>
; << Set up another program area (can be in ROM) >>

        LD      HL,(BASTXT)     ; Get start of program text
        LD      (PROGND),HL     ; Set more variable space
        LD      HL,#0x8000        ; Address of new program
        LD      E,(HL)          ; Get LSB of new RAM end
        INC     HL
        LD      D,(HL)          ; Get MSB of new RAM end
        INC     HL
        INC     HL              ; Null at start of program
        LD      (BASTXT),HL     ; New program text area 0x8003
        EX      DE,HL           ; New RAM end to HL
        LD      (LSTRAM),HL     ; Set new RAM end
        LD      (STRSPC),HL     ; Clear string space
        LD      BC,#RUNCNT       ; Execution driver loop
        PUSH    BC              ; Save for return
        JP      RUNFST          ; Clear variables and continue

RUART:  JP      GUART           ; Get a byte from UART

WUART2: CALL    WUART           ; Send 2 Bytes to UART
WUART:  PUSH    AF              ; Save byte
        PUSH    BC              ; Save BC
        LD      C,A             ; Byte to C
        CALL    SUART           ; Send byte to UART
        POP     BC              ; Restore BC
        POP     AF              ; Restore byte
        RET

CSAVE:  LD      B,#1             ; Flag "CSAVE"
        CP      #ZTIMES          ; "*" token? ("CSAVE*")
        JP      Z,ARRSV1        ; Yes - Array save
        CALL    EVAL            ; Evaluate expression
        PUSH    HL              ; Save code string address
        CALL    GTFLNM          ; Get file name
        PUSH    DE              ; Save file name
        CALL    CASFFW          ; Turn on motor and wait
        POP     DE              ; Restore file name
        LD      A,#0b11010011     ; Header byte
        CALL    WUART           ; Send byte to UART
        CALL    WUART2          ; Send byte twice more
        LD      A,(DE)          ; Get file name
        CALL    WUART           ; Send it to UART
        NOP
        NOP
        NOP
        LD      HL,#PROGND       ; Start of program information
        LD      (ARG1),HL       ; Save for monitor save routine
        LD      HL,(PROGND)     ; End of program information
        LD      (ARG2),HL       ; Save for monitor save routine
        CALL    SAVE            ; Save program to tape
        CALL    ARET            ; Not much there!
        POP     HL              ; Restore code string address
        RET

CLOAD:  LD      A,(HL)          ; Get byte after "CLOAD"
        CP      #ZTIMES          ; "*" token? ("CLOAD*")
        JP      Z,ARRLD1        ; Yes - Array load
        CALL    SMOTOR          ; Start motor and get "?"
        SUB     #ZPRINT          ; "?" ("PRINT" token) Verify?
        JP      Z,FLGVER        ; Yes - Flag "verify"
        XOR     A               ; Flag "load"
        .db      0x01             ; Skip "CPL" and "INC HL"
FLGVER: CPL                     ; Flag "verify"
        INC     HL              ; Skip over "?"
        PUSH    AF              ; Save verify flag
        DEC     HL              ; DEC 'cos GETCHR INCs
        CALL    GETCHR          ; Get next character
        LD      A,#0             ; Any file will do
        JP      Z,ANYNAM        ; No name given - Any will do
        CALL    EVAL            ; Evaluate expression
        CALL    GTFLNM          ; Get file name
        LD      A,(DE)          ; Get first byte of name
ANYNAM: LD      L,A             ; Save name to find
        POP     AF              ; Get verify flag
        PUSH    AF              ; And re-save
        OR      A               ; Verify of load?
        LD      H,A
        LD      (FPREG),HL      ; Save nam of file to find
        CALL    Z,CLRPTR        ; Load - Clear pointers
        LD      HL,(FPREG)      ; Get name of program to find
        EX      DE,HL           ; Name to DE
CLOAD1: LD      B,#3             ; 3 Header bytes
CLOAD2: CALL    RUART           ; Get a byte from UART
        SUB     #0b11010011       ; Header byte?
        JP      NZ,CLOAD1       ; Look for header
        DEC     B               ; Count header bytes
        JP      NZ,CLOAD2       ; More to find?
        CALL    RUART           ; Get name of file
        CALL    FILFND          ; Display "file X found"
        INC     E               ; Any file name given?
        DEC     E
        JP      Z,THSFIL        ; No - This file will do
        CP      E               ; Has file been found?
        JP      NZ,CLOAD1       ; No - Look for another
THSFIL: NOP
        NOP
        NOP
        POP     AF              ; Get verify flag
        OR      A               ; Load or verify?
        JP      NZ,CLOADV       ; Verify program
        CALL    MONLD           ; Use monitor to load program
        LD      HL,(PROGND)     ; Get end of program
        CALL    ENFMEM          ; See if enough memory
        JP      CLOADE          ; "Ok" and set up pointers

CLOADV: CALL    MONVE           ; Use monitor to verify program
CLOADE: LD      HL,#OKMSG        ; "Ok" message
        CALL    PRS             ; Output string
        CALL    ARET            ; Not a lot there!
        JP      SETPTR          ; Set up line pointers

OUTBAD: LD      HL,#BAD          ; "Bad" message
        CALL    PRS             ; Output string
        JP      ERRIN           ; In line message

FILFND: PUSH    BC              ; <- Save
        PUSH    HL              ; <- all
        PUSH    DE              ; <- the
        PUSH    AF              ; <- registers
        LD      HL,#FILE         ; "File" message
        CALL    PRS             ; Output string
        POP     AF              ; Get file name
        PUSH    AF              ; And re-save
        CALL    CONMON          ; Output file name to screen
        LD      HL,#FOUND        ; "Found" message
        CALL    PRS             ; Output string
        POP     AF              ; <- Restore
        POP     DE              ; <- all
        POP     HL              ; <- the
        POP     BC              ; <- registers
        RET

FILE:   .ascii      "File "
        .db 0
FOUND:  .ascii      " Found"
        .db CR,LF,0
BAD:    .ascii      "Bad"
        .db 0,0,0

PEEK:   CALL    DEINT           ; Get memory address
        LD      A,(DE)          ; Get byte in memory
        JP      PASSA           ; Return integer A

POKE:   CALL    GETNUM          ; Get memory address
        CALL    DEINT           ; Get integer -32768 to 3276
        PUSH    DE              ; Save memory address
        CALL    CHKSYN          ; Make sure "," follows
        .db      ","
        CALL    GETINT          ; Get integer 0-255
        POP     DE              ; Restore memory address
        LD      (DE),A          ; Load it into memory
        RET

ROUND:  LD      HL,#HALF         ; Add 0.5 to FPREG
ADDPHL: CALL    LOADFP          ; Load FP at (HL) to BCDE
        JP      FPADD           ; Add BCDE to FPREG

SUBPHL: CALL    LOADFP          ; FPREG = -FPREG + number at HL
        .db      0x21             ; Skip "POP BC" and "POP DE"
PSUB:   POP     BC              ; Get FP number from stack
        POP     DE
SUBCDE: CALL    INVSGN          ; Negate FPREG
FPADD:  LD      A,B             ; Get FP exponent
        OR      A               ; Is number zero?
        RET     Z               ; Yes - Nothing to add
        LD      A,(FPEXP)       ; Get FPREG exponent
        OR      A               ; Is this number zero?
        JP      Z,FPBCDE        ; Yes - Move BCDE to FPREG
        SUB     B               ; BCDE number larger?
        JP      NC,NOSWAP       ; No - Don't swap them
        CPL                     ; Two's complement
        INC     A               ;  FP exponent
        EX      DE,HL
        CALL    STAKFP          ; Put FPREG on stack
        EX      DE,HL
        CALL    FPBCDE          ; Move BCDE to FPREG
        POP     BC              ; Restore number from stack
        POP     DE
NOSWAP: CP      #24+1            ; Second number insignificant?
        RET     NC              ; Yes - First number is result
        PUSH    AF              ; Save number of bits to scale
        CALL    SIGNS           ; Set MSBs & sign of result
        LD      H,A             ; Save sign of result
        POP     AF              ; Restore scaling factor
        CALL    SCALE           ; Scale BCDE to same exponent
        OR      H               ; Result to be positive?
        LD      HL,#FPREG        ; Point to FPREG
        JP      P,MINCDE        ; No - Subtract FPREG from CDE
        CALL    PLUCDE          ; Add FPREG to CDE
        JP      NC,RONDUP       ; No overflow - Round it up
        INC     HL              ; Point to exponent
        INC     (HL)            ; Increment it
        JP      Z,OVERR         ; Number overflowed - Error
        LD      L,#1             ; 1 bit to shift right
        CALL    SHRT1           ; Shift result right
        JP      RONDUP          ; Round it up

MINCDE: XOR     A               ; Clear A and carry
        SUB     B               ; Negate exponent
        LD      B,A             ; Re-save exponent
        LD      A,(HL)          ; Get LSB of FPREG
        SBC     A, E            ; Subtract LSB of BCDE
        LD      E,A             ; Save LSB of BCDE
        INC     HL
        LD      A,(HL)          ; Get NMSB of FPREG
        SBC     A,D             ; Subtract NMSB of BCDE
        LD      D,A             ; Save NMSB of BCDE
        INC     HL
        LD      A,(HL)          ; Get MSB of FPREG
        SBC     A,C             ; Subtract MSB of BCDE
        LD      C,A             ; Save MSB of BCDE
CONPOS: CALL    C,COMPL         ; Overflow - Make it positive

BNORM:  LD      L,B             ; L = Exponent
        LD      H,E             ; H = LSB
        XOR     A
BNRMLP: LD      B,A             ; Save bit count
        LD      A,C             ; Get MSB
        OR      A               ; Is it zero?
        JP      NZ,PNORM        ; No - Do it bit at a time
        LD      C,D             ; MSB = NMSB
        LD      D,H             ; NMSB= LSB
        LD      H,L             ; LSB = VLSB
        LD      L,A             ; VLSB= 0
        LD      A,B             ; Get exponent
        SUB     #8               ; Count 8 bits
        CP      #-24-8           ; Was number zero?
        JP      NZ,BNRMLP       ; No - Keep normalising
RESZER: XOR     A               ; Result is zero
SAVEXP: LD      (FPEXP),A       ; Save result as zero
        RET

NORMAL: DEC     B               ; Count bits
        ADD     HL,HL           ; Shift HL left
        LD      A,D             ; Get NMSB
        RLA                     ; Shift left with last bit
        LD      D,A             ; Save NMSB
        LD      A,C             ; Get MSB
        ADC     A,A             ; Shift left with last bit
        LD      C,A             ; Save MSB
PNORM:  JP      P,NORMAL        ; Not done - Keep going
        LD      A,B             ; Number of bits shifted
        LD      E,H             ; Save HL in EB
        LD      B,L
        OR      A               ; Any shifting done?
        JP      Z,RONDUP        ; No - Round it up
        LD      HL,#FPEXP        ; Point to exponent
        ADD     A,(HL)          ; Add shifted bits
        LD      (HL),A          ; Re-save exponent
        JP      NC,RESZER       ; Underflow - Result is zero
        RET     Z               ; Result is zero
RONDUP: LD      A,B             ; Get VLSB of number
RONDB:  LD      HL,#FPEXP        ; Point to exponent
        OR      A               ; Any rounding?
        CALL    M,FPROND        ; Yes - Round number up
        LD      B,(HL)          ; B = Exponent
        INC     HL
        LD      A,(HL)          ; Get sign of result
        AND     #0b10000000       ; Only bit 7 needed
        XOR     C               ; Set correct sign
        LD      C,A             ; Save correct sign in number
        JP      FPBCDE          ; Move BCDE to FPREG

FPROND: INC     E               ; Round LSB
        RET     NZ              ; Return if ok
        INC     D               ; Round NMSB
        RET     NZ              ; Return if ok
        INC     C               ; Round MSB
        RET     NZ              ; Return if ok
        LD      C,#0x80           ; Set normal value
        INC     (HL)            ; Increment exponent
        RET     NZ              ; Return if ok
        JP      OVERR           ; Overflow error

PLUCDE: LD      A,(HL)          ; Get LSB of FPREG
        ADD     A,E             ; Add LSB of BCDE
        LD      E,A             ; Save LSB of BCDE
        INC     HL
        LD      A,(HL)          ; Get NMSB of FPREG
        ADC     A,D             ; Add NMSB of BCDE
        LD      D,A             ; Save NMSB of BCDE
        INC     HL
        LD      A,(HL)          ; Get MSB of FPREG
        ADC     A,C             ; Add MSB of BCDE
        LD      C,A             ; Save MSB of BCDE
        RET

COMPL:  LD      HL,#SGNRES       ; Sign of result
        LD      A,(HL)          ; Get sign of result
        CPL                     ; Negate it
        LD      (HL),A          ; Put it back
        XOR     A
        LD      L,A             ; Set L to zero
        SUB     B               ; Negate exponent,set carry
        LD      B,A             ; Re-save exponent
        LD      A,L             ; Load zero
        SBC     A,E             ; Negate LSB
        LD      E,A             ; Re-save LSB
        LD      A,L             ; Load zero
        SBC     A,D             ; Negate NMSB
        LD      D,A             ; Re-save NMSB
        LD      A,L             ; Load zero
        SBC     A,C             ; Negate MSB
        LD      C,A             ; Re-save MSB
        RET

SCALE:  LD      B,#0             ; Clear underflow
SCALLP: SUB     #8               ; 8 bits (a whole byte)?
        JP      C,SHRITE        ; No - Shift right A bits
        LD      B,E             ; <- Shift
        LD      E,D             ; <- right
        LD      D,C             ; <- eight
        LD      C,#0             ; <- bits
        JP      SCALLP          ; More bits to shift

SHRITE: ADD     A,#8+1           ; Adjust count
        LD      L,A             ; Save bits to shift
SHRLP:  XOR     A               ; Flag for all done
        DEC     L               ; All shifting done?
        RET     Z               ; Yes - Return
        LD      A,C             ; Get MSB
SHRT1:  RRA                     ; Shift it right
        LD      C,A             ; Re-save
        LD      A,D             ; Get NMSB
        RRA                     ; Shift right with last bit
        LD      D,A             ; Re-save it
        LD      A,E             ; Get LSB
        RRA                     ; Shift right with last bit
        LD      E,A             ; Re-save it
        LD      A,B             ; Get underflow
        RRA                     ; Shift right with last bit
        LD      B,A             ; Re-save underflow
        JP      SHRLP           ; More bits to do

UNITY:  .db       0x00,0x00,0x00,0x81    ; 1.00000

LOGTAB: .db      3                       ; Table used by LOG
        .db      0xAA,0x56,0x19,0x80     ; 0.59898
        .db      0xF1,0x22,0x76,0x80     ; 0.96147
        .db      0x45,0xAA,0x38,0x82     ; 2.88539

LOG:    CALL    TSTSGN          ; Test sign of value
        OR      A
        JP      PE,FCERR        ; ?FC Error if <= zero
        LD      HL,#FPEXP        ; Point to exponent
        LD      A,(HL)          ; Get exponent
        LD      BC,#0x8035        ; BCDE = SQR(1/2)
        LD      DE,#0x04F3
        SUB     B               ; Scale value to be < 1
        PUSH    AF              ; Save scale factor
        LD      (HL),B          ; Save new exponent
        PUSH    DE              ; Save SQR(1/2)
        PUSH    BC
        CALL    FPADD           ; Add SQR(1/2) to value
        POP     BC              ; Restore SQR(1/2)
        POP     DE
        INC     B               ; Make it SQR(2)
        CALL    DVBCDE          ; Divide by SQR(2)
        LD      HL,#UNITY        ; Point to 1.
        CALL    SUBPHL          ; Subtract FPREG from 1
        LD      HL,#LOGTAB       ; Coefficient table
        CALL    SUMSER          ; Evaluate sum of series
        LD      BC,#0x8080        ; BCDE = -0.5
        LD      DE,#0x0000
        CALL    FPADD           ; Subtract 0.5 from FPREG
        POP     AF              ; Restore scale factor
        CALL    RSCALE          ; Re-scale number
MULLN2: LD      BC,#0x8031        ; BCDE = Ln(2)
        LD      DE,#0x7218
        .db      0x21             ; Skip "POP BC" and "POP DE"

MULT:   POP     BC              ; Get number from stack
        POP     DE
FPMULT: CALL    TSTSGN          ; Test sign of FPREG
        RET     Z               ; Return zero if zero
        LD      L,#0             ; Flag add exponents
        CALL    ADDEXP          ; Add exponents
        LD      A,C             ; Get MSB of multiplier
        LD      (MULVAL),A      ; Save MSB of multiplier
        EX      DE,HL
        LD      (MULVAL+1),HL   ; Save rest of multiplier
        LD      BC,#0            ; Partial product (BCDE) = zero
        LD      D,B
        LD      E,B
        LD      HL,#BNORM        ; Address of normalise
        PUSH    HL              ; Save for return
        LD      HL,#MULT8        ; Address of 8 bit multiply
        PUSH    HL              ; Save for NMSB,MSB
        PUSH    HL              ; 
        LD      HL,#FPREG        ; Point to number
MULT8:  LD      A,(HL)          ; Get LSB of number
        INC     HL              ; Point to NMSB
        OR      A               ; Test LSB
        JP      Z,BYTSFT        ; Zero - shift to next byte
        PUSH    HL              ; Save address of number
        LD      L,#8             ; 8 bits to multiply by
MUL8LP: RRA                     ; Shift LSB right
        LD      H,A             ; Save LSB
        LD      A,C             ; Get MSB
        JP      NC,NOMADD       ; Bit was zero - Don't add
        PUSH    HL              ; Save LSB and count
        LD      HL,(MULVAL+1)   ; Get LSB and NMSB
        ADD     HL,DE           ; Add NMSB and LSB
        EX      DE,HL           ; Leave sum in DE
        POP     HL              ; Restore MSB and count
        LD      A,(MULVAL)      ; Get MSB of multiplier
        ADC     A,C             ; Add MSB
NOMADD: RRA                     ; Shift MSB right
        LD      C,A             ; Re-save MSB
        LD      A,D             ; Get NMSB
        RRA                     ; Shift NMSB right
        LD      D,A             ; Re-save NMSB
        LD      A,E             ; Get LSB
        RRA                     ; Shift LSB right
        LD      E,A             ; Re-save LSB
        LD      A,B             ; Get VLSB
        RRA                     ; Shift VLSB right
        LD      B,A             ; Re-save VLSB
        DEC     L               ; Count bits multiplied
        LD      A,H             ; Get LSB of multiplier
        JP      NZ,MUL8LP       ; More - Do it
POPHRT: POP     HL              ; Restore address of number
        RET

BYTSFT: LD      B,E             ; Shift partial product left
        LD      E,D
        LD      D,C
        LD      C,A
        RET

DIV10:  CALL    STAKFP          ; Save FPREG on stack
        LD      BC,#0x8420        ; BCDE = 10.
        LD      DE,#0x0000
        CALL    FPBCDE          ; Move 10 to FPREG

DIV:    POP     BC              ; Get number from stack
        POP     DE
DVBCDE: CALL    TSTSGN          ; Test sign of FPREG
        JP      Z,DZERR         ; Error if division by zero
        LD      L,#-1            ; Flag subtract exponents
        CALL    ADDEXP          ; Subtract exponents
        INC     (HL)            ; Add 2 to exponent to adjust
        INC     (HL)
        DEC     HL              ; Point to MSB
        LD      A,(HL)          ; Get MSB of dividend
        LD      (DIV3),A        ; Save for subtraction
        DEC     HL
        LD      A,(HL)          ; Get NMSB of dividend
        LD      (DIV2),A        ; Save for subtraction
        DEC     HL
        LD      A,(HL)          ; Get MSB of dividend
        LD      (DIV1),A        ; Save for subtraction
        LD      B,C             ; Get MSB
        EX      DE,HL           ; NMSB,LSB to HL
        XOR     A
        LD      C,A             ; Clear MSB of quotient
        LD      D,A             ; Clear NMSB of quotient
        LD      E,A             ; Clear LSB of quotient
        LD      (DIV4),A        ; Clear overflow count
DIVLP:  PUSH    HL              ; Save divisor
        PUSH    BC
        LD      A,L             ; Get LSB of number
        CALL    DIVSUP          ; Subt' divisor from dividend
        SBC     A,#0             ; Count for overflows
        CCF
        JP      NC,RESDIV       ; Restore divisor if borrow
        LD      (DIV4),A        ; Re-save overflow count
        POP     AF              ; Scrap divisor
        POP     AF
        SCF                     ; Set carry to
        .db      0x0D2            ; Skip "POP BC" and "POP HL"

RESDIV: POP     BC              ; Restore divisor
        POP     HL
        LD      A,C             ; Get MSB of quotient
        INC     A
        DEC     A
        RRA                     ; Bit 0 to bit 7
        JP      M,RONDB         ; Done - Normalise result
        RLA                     ; Restore carry
        LD      A,E             ; Get LSB of quotient
        RLA                     ; Double it
        LD      E,A             ; Put it back
        LD      A,D             ; Get NMSB of quotient
        RLA                     ; Double it
        LD      D,A             ; Put it back
        LD      A,C             ; Get MSB of quotient
        RLA                     ; Double it
        LD      C,A             ; Put it back
        ADD     HL,HL           ; Double NMSB,LSB of divisor
        LD      A,B             ; Get MSB of divisor
        RLA                     ; Double it
        LD      B,A             ; Put it back
        LD      A,(DIV4)        ; Get VLSB of quotient
        RLA                     ; Double it
        LD      (DIV4),A        ; Put it back
        LD      A,C             ; Get MSB of quotient
        OR      D               ; Merge NMSB
        OR      E               ; Merge LSB
        JP      NZ,DIVLP        ; Not done - Keep dividing
        PUSH    HL              ; Save divisor
        LD      HL,#FPEXP        ; Point to exponent
        DEC     (HL)            ; Divide by 2
        POP     HL              ; Restore divisor
        JP      NZ,DIVLP        ; Ok - Keep going
        JP      OVERR           ; Overflow error

ADDEXP: LD      A,B             ; Get exponent of dividend
        OR      A               ; Test it
        JP      Z,OVTST3        ; Zero - Result zero
        LD      A,L             ; Get add/subtract flag
        LD      HL,#FPEXP        ; Point to exponent
        XOR     (HL)            ; Add or subtract it
        ADD     A,B             ; Add the other exponent
        LD      B,A             ; Save new exponent
        RRA                     ; Test exponent for overflow
        XOR     B
        LD      A,B             ; Get exponent
        JP      P,OVTST2        ; Positive - Test for overflow
        ADD     A,#0x80           ; Add excess 128
        LD      (HL),A          ; Save new exponent
        JP      Z,POPHRT        ; Zero - Result zero
        CALL    SIGNS           ; Set MSBs and sign of result
        LD      (HL),A          ; Save new exponent
        DEC     HL              ; Point to MSB
        RET

OVTST1: CALL    TSTSGN          ; Test sign of FPREG
        CPL                     ; Invert sign
        POP     HL              ; Clean up stack
OVTST2: OR      A               ; Test if new exponent zero
OVTST3: POP     HL              ; Clear off return address
        JP      P,RESZER        ; Result zero
        JP      OVERR           ; Overflow error

MLSP10: CALL    BCDEFP          ; Move FPREG to BCDE
        LD      A,B             ; Get exponent
        OR      A               ; Is it zero?
        RET     Z               ; Yes - Result is zero
        ADD     A,#2             ; Multiply by 4
        JP      C,OVERR         ; Overflow - ?OV Error
        LD      B,A             ; Re-save exponent
        CALL    FPADD           ; Add BCDE to FPREG (Times 5)
        LD      HL,#FPEXP        ; Point to exponent
        INC     (HL)            ; Double number (Times 10)
        RET     NZ              ; Ok - Return
        JP      OVERR           ; Overflow error

TSTSGN: LD      A,(FPEXP)       ; Get sign of FPREG
        OR      A
        RET     Z               ; RETurn if number is zero
        LD      A,(FPREG+2)     ; Get MSB of FPREG
        .db      0x0FE            ; Test sign
RETREL: CPL                     ; Invert sign
        RLA                     ; Sign bit to carry
FLGDIF: SBC     A,A             ; Carry to all bits of A
        RET     NZ              ; Return -1 if negative
        INC     A               ; Bump to +1
        RET                     ; Positive - Return +1

SGN:    CALL    TSTSGN          ; Test sign of FPREG
FLGREL: LD      B,#0x80+8         ; 8 bit integer in exponent
        LD      DE,#0            ; Zero NMSB and LSB
RETINT: LD      HL,#FPEXP        ; Point to exponent
        LD      C,A             ; CDE = MSB,NMSB and LSB
        LD      (HL),B          ; Save exponent
        LD      B,#0             ; CDE = integer to normalise
        INC     HL              ; Point to sign of result
        LD      (HL),#0x80        ; Set sign of result
        RLA                     ; Carry = sign of integer
        JP      CONPOS          ; Set sign of result

ABS:    CALL    TSTSGN          ; Test sign of FPREG
        RET     P               ; Return if positive
INVSGN: LD      HL,#FPREG+2      ; Point to MSB
        LD      A,(HL)          ; Get sign of mantissa
        XOR     #0x80             ; Invert sign of mantissa
        LD      (HL),A          ; Re-save sign of mantissa
        RET

STAKFP: EX      DE,HL           ; Save code string address
        LD      HL,(FPREG)      ; LSB,NLSB of FPREG
        EX      (SP),HL         ; Stack them,get return
        PUSH    HL              ; Re-save return
        LD      HL,(FPREG+2)    ; MSB and exponent of FPREG
        EX      (SP),HL         ; Stack them,get return
        PUSH    HL              ; Re-save return
        EX      DE,HL           ; Restore code string address
        RET

PHLTFP: CALL    LOADFP          ; Number at HL to BCDE
FPBCDE: EX      DE,HL           ; Save code string address
        LD      (FPREG),HL      ; Save LSB,NLSB of number
        LD      H,B             ; Exponent of number
        LD      L,C             ; MSB of number
        LD      (FPREG+2),HL    ; Save MSB and exponent
        EX      DE,HL           ; Restore code string address
        RET

BCDEFP: LD      HL,#FPREG        ; Point to FPREG
LOADFP: LD      E,(HL)          ; Get LSB of number
        INC     HL
        LD      D,(HL)          ; Get NMSB of number
        INC     HL
        LD      C,(HL)          ; Get MSB of number
        INC     HL
        LD      B,(HL)          ; Get exponent of number
INCHL:  INC     HL              ; Used for conditional "INC HL"
        RET

FPTHL:  LD      DE,#FPREG        ; Point to FPREG
DETHL4: LD      B,#4             ; 4 bytes to move
DETHLB: LD      A,(DE)          ; Get source
        LD      (HL),A          ; Save destination
        INC     DE              ; Next source
        INC     HL              ; Next destination
        DEC     B               ; Count bytes
        JP      NZ,DETHLB       ; Loop if more
        RET

SIGNS:  LD      HL,#FPREG+2      ; Point to MSB of FPREG
        LD      A,(HL)          ; Get MSB
        RLCA                    ; Old sign to carry
        SCF                     ; Set MSBit
        RRA                     ; Set MSBit of MSB
        LD      (HL),A          ; Save new MSB
        CCF                     ; Complement sign
        RRA                     ; Old sign to carry
        INC     HL
        INC     HL
        LD      (HL),A          ; Set sign of result
        LD      A,C             ; Get MSB
        RLCA                    ; Old sign to carry
        SCF                     ; Set MSBit
        RRA                     ; Set MSBit of MSB
        LD      C,A             ; Save MSB
        RRA
        XOR     (HL)            ; New sign of result
        RET

CMPNUM: LD      A,B             ; Get exponent of number
        OR      A
        JP      Z,TSTSGN        ; Zero - Test sign of FPREG
        LD      HL,#RETREL       ; Return relation routine
        PUSH    HL              ; Save for return
        CALL    TSTSGN          ; Test sign of FPREG
        LD      A,C             ; Get MSB of number
        RET     Z               ; FPREG zero - Number's MSB
        LD      HL,#FPREG+2      ; MSB of FPREG
        XOR     (HL)            ; Combine signs
        LD      A,C             ; Get MSB of number
        RET     M               ; Exit if signs different
        CALL    CMPFP           ; Compare FP numbers
        RRA                     ; Get carry to sign
        XOR     C               ; Combine with MSB of number
        RET

CMPFP:  INC     HL              ; Point to exponent
        LD      A,B             ; Get exponent
        CP      (HL)            ; Compare exponents
        RET     NZ              ; Different
        DEC     HL              ; Point to MBS
        LD      A,C             ; Get MSB
        CP      (HL)            ; Compare MSBs
        RET     NZ              ; Different
        DEC     HL              ; Point to NMSB
        LD      A,D             ; Get NMSB
        CP      (HL)            ; Compare NMSBs
        RET     NZ              ; Different
        DEC     HL              ; Point to LSB
        LD      A,E             ; Get LSB
        SUB     (HL)            ; Compare LSBs
        RET     NZ              ; Different
        POP     HL              ; Drop RETurn
        POP     HL              ; Drop another RETurn
        RET

FPINT:  LD      B,A             ; <- Move
        LD      C,A             ; <- exponent
        LD      D,A             ; <- to all
        LD      E,A             ; <- bits
        OR      A               ; Test exponent
        RET     Z               ; Zero - Return zero
        PUSH    HL              ; Save pointer to number
        CALL    BCDEFP          ; Move FPREG to BCDE
        CALL    SIGNS           ; Set MSBs & sign of result
        XOR     (HL)            ; Combine with sign of FPREG
        LD      H,A             ; Save combined signs
        CALL    M,DCBCDE        ; Negative - Decrement BCDE
        LD      A,#0x80+24        ; 24 bits
        SUB     B               ; Bits to shift
        CALL    SCALE           ; Shift BCDE
        LD      A,H             ; Get combined sign
        RLA                     ; Sign to carry
        CALL    C,FPROND        ; Negative - Round number up
        LD      B,#0             ; Zero exponent
        CALL    C,COMPL         ; If negative make positive
        POP     HL              ; Restore pointer to number
        RET

DCBCDE: DEC     DE              ; Decrement BCDE
        LD      A,D             ; Test LSBs
        AND     E
        INC     A
        RET     NZ              ; Exit if LSBs not FFFF
        DEC     BC              ; Decrement MSBs
        RET

INT:    LD      HL,#FPEXP        ; Point to exponent
        LD      A,(HL)          ; Get exponent
        CP      #0x80+24          ; Integer accuracy only?
        LD      A,(FPREG)       ; Get LSB
        RET     NC              ; Yes - Already integer
        LD      A,(HL)          ; Get exponent
        CALL    FPINT           ; F.P to integer
        LD      (HL),#0x80+24     ; Save 24 bit integer
        LD      A,E             ; Get LSB of number
        PUSH    AF              ; Save LSB
        LD      A,C             ; Get MSB of number
        RLA                     ; Sign to carry
        CALL    CONPOS          ; Set sign of result
        POP     AF              ; Restore LSB of number
        RET

MLDEBC: LD      HL,#0            ; Clear partial product
        LD      A,B             ; Test multiplier
        OR      C
        RET     Z               ; Return zero if zero
        LD      A,#16            ; 16 bits
MLDBLP: ADD     HL,HL           ; Shift P.P left
        JP      C,BSERR         ; ?BS Error if overflow
        EX      DE,HL
        ADD     HL,HL           ; Shift multiplier left
        EX      DE,HL
        JP      NC,NOMLAD       ; Bit was zero - No add
        ADD     HL,BC           ; Add multiplicand
        JP      C,BSERR         ; ?BS Error if overflow
NOMLAD: DEC     A               ; Count bits
        JP      NZ,MLDBLP       ; More
        RET

ASCTFP: CP      #"-"             ; Negative?
        PUSH    AF              ; Save it and flags
        JP      Z,CNVNUM        ; Yes - Convert number
        CP      #"+"             ; Positive?
        JP      Z,CNVNUM        ; Yes - Convert number
        DEC     HL              ; DEC 'cos GETCHR INCs
CNVNUM: CALL    RESZER          ; Set result to zero
        LD      B,A             ; Digits after point counter
        LD      D,A             ; Sign of exponent
        LD      E,A             ; Exponent of ten
        CPL
        LD      C,A             ; Before or after point flag
MANLP:  CALL    GETCHR          ; Get next character
        JP      C,ADDIG         ; Digit - Add to number
        CP      #"."
        JP      Z,DPOINT        ; "." - Flag point
        CP      #"E"
        JP      NZ,CONEXP       ; Not "E" - Scale number
        CALL    GETCHR          ; Get next character
        CALL    SGNEXP          ; Get sign of exponent
EXPLP:  CALL    GETCHR          ; Get next character
        JP      C,EDIGIT        ; Digit - Add to exponent
        INC     D               ; Is sign negative?
        JP      NZ,CONEXP       ; No - Scale number
        XOR     A
        SUB     E               ; Negate exponent
        LD      E,A             ; And re-save it
        INC     C               ; Flag end of number
DPOINT: INC     C               ; Flag point passed
        JP      Z,MANLP         ; Zero - Get another digit
CONEXP: PUSH    HL              ; Save code string address
        LD      A,E             ; Get exponent
        SUB     B               ; Subtract digits after point
SCALMI: CALL    P,SCALPL        ; Positive - Multiply number
        JP      P,ENDCON        ; Positive - All done
        PUSH    AF              ; Save number of times to /10
        CALL    DIV10           ; Divide by 10
        POP     AF              ; Restore count
        INC     A               ; Count divides

ENDCON: JP      NZ,SCALMI       ; More to do
        POP     DE              ; Restore code string address
        POP     AF              ; Restore sign of number
        CALL    Z,INVSGN        ; Negative - Negate number
        EX      DE,HL           ; Code string address to HL
        RET

SCALPL: RET     Z               ; Exit if no scaling needed
MULTEN: PUSH    AF              ; Save count
        CALL    MLSP10          ; Multiply number by 10
        POP     AF              ; Restore count
        DEC     A               ; Count multiplies
        RET

ADDIG:  PUSH    DE              ; Save sign of exponent
        LD      D,A             ; Save digit
        LD      A,B             ; Get digits after point
        ADC     A,C             ; Add one if after point
        LD      B,A             ; Re-save counter
        PUSH    BC              ; Save point flags
        PUSH    HL              ; Save code string address
        PUSH    DE              ; Save digit
        CALL    MLSP10          ; Multiply number by 10
        POP     AF              ; Restore digit
        SUB     #"0"             ; Make it absolute
        CALL    RSCALE          ; Re-scale number
        POP     HL              ; Restore code string address
        POP     BC              ; Restore point flags
        POP     DE              ; Restore sign of exponent
        JP      MANLP           ; Get another digit

RSCALE: CALL    STAKFP          ; Put number on stack
        CALL    FLGREL          ; Digit to add to FPREG
PADD:   POP     BC              ; Restore number
        POP     DE
        JP      FPADD           ; Add BCDE to FPREG and return

EDIGIT: LD      A,E             ; Get digit
        RLCA                    ; Times 2
        RLCA                    ; Times 4
        ADD     A,E             ; Times 5
        RLCA                    ; Times 10
        ADD     A,(HL)          ; Add next digit
        SUB     #"0"             ; Make it absolute
        LD      E,A             ; Save new digit
        JP      EXPLP           ; Look for another digit

LINEIN: PUSH    HL              ; Save code string address
        LD      HL,#INMSG        ; Output " in "
        CALL    PRS             ; Output string at HL
        POP     HL              ; Restore code string address
PRNTHL: EX      DE,HL           ; Code string address to DE
        XOR     A
        LD      B,#0x80+24        ; 24 bits
        CALL    RETINT          ; Return the integer
        LD      HL,#PRNUMS       ; Print number string
        PUSH    HL              ; Save for return
NUMASC: LD      HL,#PBUFF        ; Convert number to ASCII
        PUSH    HL              ; Save for return
        CALL    TSTSGN          ; Test sign of FPREG
        LD      (HL),#" "        ; Space at start
        JP      P,SPCFST        ; Positive - Space to start
        LD      (HL),#"-"        ; "-" sign at start
SPCFST: INC     HL              ; First byte of number
        LD      (HL),#"0"        ; "0" if zero
        JP      Z,JSTZER        ; Return "0" if zero
        PUSH    HL              ; Save buffer address
        CALL    M,INVSGN        ; Negate FPREG if negative
        XOR     A               ; Zero A
        PUSH    AF              ; Save it
        CALL    RNGTST          ; Test number is in range
SIXDIG: LD      BC,#0x9143        ; BCDE - 99999.9
        LD      DE,#0x4FF8
        CALL    CMPNUM          ; Compare numbers
        OR      A
        JP      PO,INRNG        ; > 99999.9 - Sort it out
        POP     AF              ; Restore count
        CALL    MULTEN          ; Multiply by ten
        PUSH    AF              ; Re-save count
        JP      SIXDIG          ; Test it again

GTSIXD: CALL    DIV10           ; Divide by 10
        POP     AF              ; Get count
        INC     A               ; Count divides
        PUSH    AF              ; Re-save count
        CALL    RNGTST          ; Test number is in range
INRNG:  CALL    ROUND           ; Add 0.5 to FPREG
        INC     A
        CALL    FPINT           ; F.P to integer
        CALL    FPBCDE          ; Move BCDE to FPREG
        LD      BC,#0x0306        ; 1E+06 to 1E-03 range
        POP     AF              ; Restore count
        ADD     A,C             ; 6 digits before point
        INC     A               ; Add one
        JP      M,MAKNUM        ; Do it in "E" form if < 1E-02
        CP      #6+1+1           ; More than 999999 ?
        JP      NC,MAKNUM       ; Yes - Do it in "E" form
        INC     A               ; Adjust for exponent
        LD      B,A             ; Exponent of number
        LD      A,#2             ; Make it zero after

MAKNUM: DEC     A               ; Adjust for digits to do
        DEC     A
        POP     HL              ; Restore buffer address
        PUSH    AF              ; Save count
        LD      DE,#POWERS       ; Powers of ten
        DEC     B               ; Count digits before point
        JP      NZ,DIGTXT       ; Not zero - Do number
        LD      (HL),#"."        ; Save point
        INC     HL              ; Move on
        LD      (HL),#"0"        ; Save zero
        INC     HL              ; Move on
DIGTXT: DEC     B               ; Count digits before point
        LD      (HL),#"."        ; Save point in case
        CALL    Z,INCHL         ; Last digit - move on
        PUSH    BC              ; Save digits before point
        PUSH    HL              ; Save buffer address
        PUSH    DE              ; Save powers of ten
        CALL    BCDEFP          ; Move FPREG to BCDE
        POP     HL              ; Powers of ten table
        LD      B, #"0"-1        ; ASCII "0" - 1
TRYAGN: INC     B               ; Count subtractions
        LD      A,E             ; Get LSB
        SUB     (HL)            ; Subtract LSB
        LD      E,A             ; Save LSB
        INC     HL
        LD      A,D             ; Get NMSB
        SBC     A,(HL)          ; Subtract NMSB
        LD      D,A             ; Save NMSB
        INC     HL
        LD      A,C             ; Get MSB
        SBC     A,(HL)          ; Subtract MSB
        LD      C,A             ; Save MSB
        DEC     HL              ; Point back to start
        DEC     HL
        JP      NC,TRYAGN       ; No overflow - Try again
        CALL    PLUCDE          ; Restore number
        INC     HL              ; Start of next number
        CALL    FPBCDE          ; Move BCDE to FPREG
        EX      DE,HL           ; Save point in table
        POP     HL              ; Restore buffer address
        LD      (HL),B          ; Save digit in buffer
        INC     HL              ; And move on
        POP     BC              ; Restore digit count
        DEC     C               ; Count digits
        JP      NZ,DIGTXT       ; More - Do them
        DEC     B               ; Any decimal part?
        JP      Z,DOEBIT        ; No - Do "E" bit
SUPTLZ: DEC     HL              ; Move back through buffer
        LD      A,(HL)          ; Get character
        CP      #"0"             ; "0" character?
        JP      Z,SUPTLZ        ; Yes - Look back for more
        CP      #"."             ; A decimal point?
        CALL    NZ,INCHL        ; Move back over digit

DOEBIT: POP     AF              ; Get "E" flag
        JP      Z,NOENED        ; No "E" needed - End buffer
        LD      (HL),#"E"        ; Put "E" in buffer
        INC     HL              ; And move on
        LD      (HL),#"+"        ; Put '+' in buffer
        JP      P,OUTEXP        ; Positive - Output exponent
        LD      (HL),#"-"        ; Put "-" in buffer
        CPL                     ; Negate exponent
        INC     A
OUTEXP: LD      B,#"0"-1         ; ASCII "0" - 1
EXPTEN: INC     B               ; Count subtractions
        SUB     #10              ; Tens digit
        JP      NC,EXPTEN       ; More to do
        ADD     A,#"0"+10        ; Restore and make ASCII
        INC     HL              ; Move on
        LD      (HL),B          ; Save MSB of exponent
JSTZER: INC     HL              ;
        LD      (HL),A          ; Save LSB of exponent
        INC     HL
NOENED: LD      (HL),C          ; Mark end of buffer
        POP     HL              ; Restore code string address
        RET

RNGTST: LD      BC,#0x9474        ; BCDE = 999999.
        LD      DE,#0x23F7
        CALL    CMPNUM          ; Compare numbers
        OR      A
        POP     HL              ; Return address to HL
        JP      PO,GTSIXD       ; Too big - Divide by ten
        JP      (HL)            ; Otherwise return to caller

HALF:   .db      0x00,0x00,0x00,0x80 ; 0.5

POWERS: .db      0xA0,0x86,0x01  ; 100000
        .db      0x10,0x27,0x00  ;  10000
        .db      0xE8,0x03,0x00  ;   1000
        .db      0x64,0x00,0x00  ;    100
        .db      0x0A,0x00,0x00  ;     10
        .db      0x01,0x00,0x00  ;      1

NEGAFT: LD  HL,#INVSGN           ; Negate result
        EX      (SP),HL         ; To be done after caller
        JP      (HL)            ; Return to caller

SQR:    CALL    STAKFP          ; Put value on stack
        LD      HL,#HALF         ; Set power to 1/2
        CALL    PHLTFP          ; Move 1/2 to FPREG

POWER:  POP     BC              ; Get base
        POP     DE
        CALL    TSTSGN          ; Test sign of power
        LD      A,B             ; Get exponent of base
        JP      Z,EXP           ; Make result 1 if zero
        JP      P,POWER1        ; Positive base - Ok
        OR      A               ; Zero to negative power?
        JP      Z,DZERR         ; Yes - ?/0 Error
POWER1: OR      A               ; Base zero?
        JP      Z,SAVEXP        ; Yes - Return zero
        PUSH    DE              ; Save base
        PUSH    BC
        LD      A,C             ; Get MSB of base
        OR      #0b01111111       ; Get sign status
        CALL    BCDEFP          ; Move power to BCDE
        JP      P,POWER2        ; Positive base - Ok
        PUSH    DE              ; Save power
        PUSH    BC
        CALL    INT             ; Get integer of power
        POP     BC              ; Restore power
        POP     DE
        PUSH    AF              ; MSB of base
        CALL    CMPNUM          ; Power an integer?
        POP     HL              ; Restore MSB of base
        LD      A,H             ; but don't affect flags
        RRA                     ; Exponent odd or even?
POWER2: POP     HL              ; Restore MSB and exponent
        LD      (FPREG+2),HL    ; Save base in FPREG
        POP     HL              ; LSBs of base
        LD      (FPREG),HL      ; Save in FPREG
        CALL    C,NEGAFT        ; Odd power - Negate result
        CALL    Z,INVSGN        ; Negative base - Negate it
        PUSH    DE              ; Save power
        PUSH    BC
        CALL    LOG             ; Get LOG of base
        POP     BC              ; Restore power
        POP     DE
        CALL    FPMULT          ; Multiply LOG by power

EXP:    CALL    STAKFP          ; Put value on stack
        LD      BC,#0x08138       ; BCDE = 1/Ln(2)
        LD      DE,#0x0AA3B
        CALL    FPMULT          ; Multiply value by 1/LN(2)
        LD      A,(FPEXP)       ; Get exponent
        CP      #0x80+8           ; Is it in range?
        JP      NC,OVTST1       ; No - Test for overflow
        CALL    INT             ; Get INT of FPREG
        ADD     A,#0x80           ; For excess 128
        ADD     A,#2             ; Exponent > 126?
        JP      C,OVTST1        ; Yes - Test for overflow
        PUSH    AF              ; Save scaling factor
        LD      HL,#UNITY        ; Point to 1.
        CALL    ADDPHL          ; Add 1 to FPREG
        CALL    MULLN2          ; Multiply by LN(2)
        POP     AF              ; Restore scaling factor
        POP     BC              ; Restore exponent
        POP     DE
        PUSH    AF              ; Save scaling factor
        CALL    SUBCDE          ; Subtract exponent from FPREG
        CALL    INVSGN          ; Negate result
        LD      HL,#EXPTAB       ; Coefficient table
        CALL    SMSER1          ; Sum the series
        LD      DE,#0            ; Zero LSBs
        POP     BC              ; Scaling factor
        LD      C,D             ; Zero MSB
        JP      FPMULT          ; Scale result to correct value

EXPTAB: .db      8                       ; Table used by EXP
        .db      0x40,0x2E,0x94,0x74     ; -1/7! (-1/5040)
        .db      0x70,0x4F,0x2E,0x77     ;  1/6! ( 1/720)
        .db      0x6E,0x02,0x88,0x7A     ; -1/5! (-1/120)
        .db      0xE6,0xA0,0x2A,0x7C     ;  1/4! ( 1/24)
        .db      0x50,0xAA,0xAA,0x7E     ; -1/3! (-1/6)
        .db      0xFF,0xFF,0x7F,0x7F     ;  1/2! ( 1/2)
        .db      0x00,0x00,0x80,0x81     ; -1/1! (-1/1)
        .db      0x00,0x00,0x00,0x81     ;  1/0! ( 1/1)

SUMSER: CALL    STAKFP          ; Put FPREG on stack
        LD      DE,#MULT         ; Multiply by "X"
        PUSH    DE              ; To be done after
        PUSH    HL              ; Save address of table
        CALL    BCDEFP          ; Move FPREG to BCDE
        CALL    FPMULT          ; Square the value
        POP     HL              ; Restore address of table
SMSER1: CALL    STAKFP          ; Put value on stack
        LD      A,(HL)          ; Get number of coefficients
        INC     HL              ; Point to start of table
        CALL    PHLTFP          ; Move coefficient to FPREG
        .db      0x06             ; Skip "POP AF"
SUMLP:  POP     AF              ; Restore count
        POP     BC              ; Restore number
        POP     DE
        DEC     A               ; Cont coefficients
        RET     Z               ; All done
        PUSH    DE              ; Save number
        PUSH    BC
        PUSH    AF              ; Save count
        PUSH    HL              ; Save address in table
        CALL    FPMULT          ; Multiply FPREG by BCDE
        POP     HL              ; Restore address in table
        CALL    LOADFP          ; Number at HL to BCDE
        PUSH    HL              ; Save address in table
        CALL    FPADD           ; Add coefficient to FPREG
        POP     HL              ; Restore address in table
        JP      SUMLP           ; More coefficients

RND:    CALL    TSTSGN          ; Test sign of FPREG
        LD      HL,#SEED+2       ; Random number seed
        JP      M,RESEED        ; Negative - Re-seed
        LD      HL,#LSTRND       ; Last random number
        CALL    PHLTFP          ; Move last RND to FPREG
        LD      HL,#SEED+2       ; Random number seed
        RET     Z               ; Return if RND(0)
        ADD     A,(HL)          ; Add (SEED)+2)
        AND     #0b00000111       ; 0 to 7
        LD      B,#0
        LD      (HL),A          ; Re-save seed
        INC     HL              ; Move to coefficient table
        ADD     A,A             ; 4 bytes
        ADD     A,A             ; per entry
        LD      C,A             ; BC = Offset into table
        ADD     HL,BC           ; Point to coefficient
        CALL    LOADFP          ; Coefficient to BCDE
        CALL    FPMULT  ;       ; Multiply FPREG by coefficient
        LD      A,(SEED+1)      ; Get (SEED+1)
        INC     A               ; Add 1
        AND     #0b00000011       ; 0 to 3
        LD      B,#0
        CP      #1               ; Is it zero?
        ADC     A,B             ; Yes - Make it 1
        LD      (SEED+1),A      ; Re-save seed
        LD      HL,#RNDTAB-4     ; Addition table
        ADD     A,A             ; 4 bytes
        ADD     A,A             ; per entry
        LD      C,A             ; BC = Offset into table
        ADD     HL,BC           ; Point to value
        CALL    ADDPHL          ; Add value to FPREG
RND1:   CALL    BCDEFP          ; Move FPREG to BCDE
        LD      A,E             ; Get LSB
        LD      E,C             ; LSB = MSB
        XOR     #0b01001111       ; Fiddle around
        LD      C,A             ; New MSB
        LD      (HL),#0x80        ; Set exponent
        DEC     HL              ; Point to MSB
        LD      B,(HL)          ; Get MSB
        LD      (HL),#0x80        ; Make value -0.5
        LD      HL,#SEED         ; Random number seed
        INC     (HL)            ; Count seed
        LD      A,(HL)          ; Get seed
        SUB     #171             ; Do it modulo 171
        JP      NZ,RND2         ; Non-zero - Ok
        LD      (HL),A          ; Zero seed
        INC     C               ; Fillde about
        DEC     D               ; with the
        INC     E               ; number
RND2:   CALL    BNORM           ; Normalise number
        LD      HL,#LSTRND       ; Save random number
        JP      FPTHL           ; Move FPREG to last and return

RESEED: LD      (HL),A          ; Re-seed random numbers
        DEC     HL
        LD      (HL),A
        DEC     HL
        LD      (HL),A
        JP      RND1            ; Return RND seed

RNDTAB: .db      0x68,0xB1,0x46,0x68     ; Table used by RND
        .db      0x99,0xE9,0x92,0x69
        .db      0x10,0xD1,0x75,0x68

COS:    LD      HL,#HALFPI       ; Point to PI/2
        CALL    ADDPHL          ; Add it to PPREG
SIN:    CALL    STAKFP          ; Put angle on stack
        LD      BC,#0x8349        ; BCDE = 2 PI
        LD      DE,#0x0FDB
        CALL    FPBCDE          ; Move 2 PI to FPREG
        POP     BC              ; Restore angle
        POP     DE
        CALL    DVBCDE          ; Divide angle by 2 PI
        CALL    STAKFP          ; Put it on stack
        CALL    INT             ; Get INT of result
        POP     BC              ; Restore number
        POP     DE
        CALL    SUBCDE          ; Make it 0 <= value < 1
        LD      HL,#QUARTR       ; Point to 0.25
        CALL    SUBPHL          ; Subtract value from 0.25
        CALL    TSTSGN          ; Test sign of value
        SCF                     ; Flag positive
        JP      P,SIN1          ; Positive - Ok
        CALL    ROUND           ; Add 0.5 to value
        CALL    TSTSGN          ; Test sign of value
        OR      A               ; Flag negative
SIN1:   PUSH    AF              ; Save sign
        CALL    P,INVSGN        ; Negate value if positive
        LD      HL,#QUARTR       ; Point to 0.25
        CALL    ADDPHL          ; Add 0.25 to value
        POP     AF              ; Restore sign
        CALL    NC,INVSGN       ; Negative - Make positive
        LD      HL,#SINTAB       ; Coefficient table
        JP      SUMSER          ; Evaluate sum of series

HALFPI: .db      0xDB,0x0F,0x49,0x81     ; 1.5708 (PI/2)

QUARTR: .db      0x00,0x00,0x00,0x7F     ; 0.25

SINTAB: .db      5                       ; Table used by SIN
        .db      0xBA,0xD7,0x1E,0x86     ; 39.711
        .db      0x64,0x26,0x99,0x87     ;-76.575
        .db      0x58,0x34,0x23,0x87     ; 81.602
        .db      0xE0,0x5D,0xA5,0x86     ;-41.342
        .db      0xDA,0x0F,0x49,0x83     ;  6.2832

TAN:    CALL    STAKFP          ; Put angle on stack
        CALL    SIN             ; Get SIN of angle
        POP     BC              ; Restore angle
        POP     HL
        CALL    STAKFP          ; Save SIN of angle
        EX      DE,HL           ; BCDE = Angle
        CALL    FPBCDE          ; Angle to FPREG
        CALL    COS             ; Get COS of angle
        JP      DIV             ; TAN = SIN / COS

ATN:    CALL    TSTSGN          ; Test sign of value
        CALL    M,NEGAFT        ; Negate result after if -ve
        CALL    M,INVSGN        ; Negate value if -ve
        LD      A,(FPEXP)       ; Get exponent
        CP      #0x81             ; Number less than 1?
        JP      C,ATN1          ; Yes - Get arc tangnt
        LD      BC,#0x8100        ; BCDE = 1
        LD      D,C
        LD      E,C
        CALL    DVBCDE          ; Get reciprocal of number
        LD      HL,#SUBPHL       ; Sub angle from PI/2
        PUSH    HL              ; Save for angle > 1
ATN1:   LD      HL,#ATNTAB       ; Coefficient table
        CALL    SUMSER          ; Evaluate sum of series
        LD      HL,#HALFPI       ; PI/2 - angle in case > 1
        RET                     ; Number > 1 - Sub from PI/2

ATNTAB: .db      9                       ; Table used by ATN
        .db      0x4A,0xD7,0x3B,0x78     ; 1/17
        .db      0x02,0x6E,0x84,0x7B     ;-1/15
        .db      0xFE,0xC1,0x2F,0x7C     ; 1/13
        .db      0x74,0x31,0x9A,0x7D     ;-1/11
        .db      0x84,0x3D,0x5A,0x7D     ; 1/9
        .db      0xC8,0x7F,0x91,0x7E     ;-1/7
        .db      0xE4,0xBB,0x4C,0x7E     ; 1/5
        .db      0x6C,0xAA,0xAA,0x7F     ;-1/3
        .db      0x00,0x00,0x00,0x81     ; 1/1

CASFFW: CALL    FLPLED          ; Turn on cassette
        LD      B,#0             ; Set 1 second delay
DELAYB: CALL    DELAY           ; Wait a bit
        DEC     B               ; Count
        JP      NZ,DELAYB       ; More delay needed
        RET

CASFF:  JP      FLPLED          ; Flip tape LED

ARET:   RET                     ; A RETurn instruction

CONMON: PUSH    HL              ; Output character to screen
        PUSH    BC              ; 
        PUSH    DE              ; 
        PUSH    AF              ; 
        CALL    MONTST          ; See if NAS-SYS
        JP      NZ,NASOUT       ; NAS-SYS - Output ASCII
        POP     AF              ; Get character
        PUSH    AF              ; And re-save
        CP      #LF              ; ASCII Line feed?
        JP      Z,IGCHR         ; Yes - Ignore it
        CP      #BKSP            ; ASCII back space?
        JP      NZ,CONOT1       ; No - Test for CR
        LD      A,#TBS           ; NASBUG back space
CONOT1: CP      #CR              ; ASCII CR?
        JP      NZ,OUTCHR       ; No - Output character
        LD      A,#TCR           ; NASBUG CR
        JP      OUTCHR          ; Output it

NASOUT: POP     AF              ; Get character
        PUSH    AF              ; And re-save
OUTCHR: CALL    MONOUT          ; Output it
IGCHR:  POP     AF              ; Restore character
        POP     DE              ;
        POP     BC              ;
        POP     HL              ;
        RET

GETINP: PUSH    HL              ; Get an input character
        PUSH    BC              ;
        PUSH    DE              ;
        CALL    MONTST          ; See if NAS-SYS
        JP      Z,GETTIN        ; "T" monitor - Get input
        .dw      _BLNK
        JP      CONVIN          ; Convert to ASCII

GETTIN: CALL    TIN             ; "T" input a character
        JP      NC,GETTIN       ; No input - wait
CONVIN: CP      #TBS             ; NASBUG back space?
        JP      NZ,CNVIN1       ; No - Test for break
        LD      A,#BKSP          ; ASCII back space
CNVIN1: CP      #TBRK            ; NASBUG break?
        JP      NZ,CNVIN2       ; No - Test for control Z
        LD      A,#CTRLC         ; Control C
CNVIN2: CP      #CTRLZ           ; ^Z?
        JP      NZ,CNVIN3       ; No - Test for escape
        LD      A,#DEL           ; Delete
CNVIN3: CP      #ESC             ; "ESC" ?
        JP      NZ,CNVIN4       ; No - Test for CR
        LD      A,#CTRLC         ; Control C
CNVIN4: CP      #TCR             ; NASBUG CR?
        JP      NZ,CNVIN5       ; No - Return character
        LD      A,#CR            ; ASCII CR
CNVIN5: POP     DE
        POP     BC
        POP     HL
        RET

CHKBRK: XOR     A               ; Check for break
        CALL    SFTENT          ; Test for shift/enter
        JP      Z,TBRK2         ; Yes - Test for second break
        LD      A,(BRKFLG)      ; Get break flag
        OR      A               ; Break flag set?
        JP      NZ,TBRK2        ; Yes - Test for second break
        XOR     A               ; Flag no break
        RET

TBRK2:  CALL    BREAK2          ; Second break?
        LD      A,#-1            ; Flag break
        RET

GUART:  IN      A,(UARTS)       ; Get UART status
        RLA                     ; Any data ready?
        JP      NC,GUART        ; No - wait until there is
        IN      A,(UARTD)       ; Get data from UART
        RET

UARTOT: OUT     (UARTD),A       ; Send data to UART
URTOLP: IN      A,(UARTS)       ; Get status
        ADD     A,A             ; Byte sent?
        RET     M               ; Yes - Return
        JP      URTOLP          ; Keep waiting

SUART:  PUSH    AF              ; Save A
        CALL    UARTOT          ; Send it to UART
        POP     AF              ; Restore A
        RET

        NOP
        NOP

SFTENT: PUSH    HL              ; Test for Shift Enter from KBD
        LD      A,#0b00000010   ; Reset KBD counter mask
        LD      HL,#PORT0        ; Get old contents
        XOR     (HL)            ; Toggle bit
        OUT     (0),A           ; Reset KBD counter
        XOR     #0b00000001       ; Toggle bit
        OUT     (0),A           ; Next row
        XOR     #0b00000010
        OUT     (0),A           ; Clear "clear" strobe
        LD      A,(HL)          ; Get old value
        OUT     (0),A           ; Original contents
        ADD     HL,DE           ; ?? WHAT ??
        POP     HL              ; Restore HL
        IN      A,(0)           ; Read in row
        AND     #0b00010010       ; Mask SHIFT and ENTER
        RET

CLS:    CALL    MONTST          ; See if NAS-SYS
        JP      Z,TCLS          ; "T" CLS
        LD      A,#CS            ; ASCII Clear screen
        JP      CONMON          ; Output character

TCLS:   LD      A,#TCS           ; NASBUG Clear screen
        JP      CONMON          ; Output character

DELAY:  XOR     A               ; Delay routine
DELAY1: PUSH    AF              ; PUSHes and POPs delay
        POP     AF
        PUSH    AF
        POP     AF
        DEC     A               ; Count delays
        JP      NZ,DELAY1       ; More delay
        RET

WIDTH:  CALL    GETINT          ; Get integer 0-255
        LD      A,E             ; Width to A
        LD      (LWIDTH),A      ; Set width
        RET

LINES:  CALL    GETNUM          ; Get a number
        CALL    DEINT           ; Get integer -32768 to 32767
        LD      (LINESC),DE     ; Set lines counter
        LD      (LINESN),DE     ; Set lines number
        RET

DEEK:   CALL    DEINT           ; Get integer -32768 to 32767
        PUSH    DE              ; Save number
        POP     HL              ; Number to HL
        LD      B,(HL)          ; Get LSB of contents
        INC     HL
        LD      A,(HL)          ; Get MSB of contents
        JP      ABPASS          ; Return integer AB

DOKE:   CALL    GETNUM          ; Get a number
        CALL    DEINT           ; Get integer -32768 to 32767
        PUSH    DE              ; Save address
        CALL    CHKSYN          ; Make sure "," follows
        .db      ","
        CALL    GETNUM          ; Get a number
        CALL    DEINT           ; Get integer -32768 to 32767
        EX      (SP),HL         ; Save value,get address
        LD      (HL),E          ; Save LSB of value
        INC     HL
        LD      (HL),D          ; Save MSB of value
        POP     HL              ; Restore code string address
        RET

JJUMP1: DI                      ; Disable interrupts
        LD      IX,#-1           ; Flag cold start
        JP      CSTART          ; Go and initialise

SCREEN: CALL    GETINT          ; Get integer 0 to 255
        PUSH    AF              ; Save column
        CALL    CHKSYN          ; Make sure "," follows
        .db      ","
        CALL    GETINT          ; Get integer 0 to 255
        POP     BC              ; Column to B
        PUSH    HL              ; Save code string address
        PUSH    BC              ; Save column
        CALL    SCRADR          ; Calculate screen address
        PUSH    HL              ; Save screen address
        CALL    MONTST          ; See if NAS-SYS
        JP      Z,TMNCUR        ; "T" monitor - "T" cursor
        POP     HL              ; Restore screen address
        LD      (CURSOR),HL     ; Set new cursor position
        POP     HL              ; Rstore code string address
        RET

TMNCUR: LD      HL,(TCUR)       ; Get address or cursor
        LD      (HL),#" "        ; Remove cursor
        POP     HL              ; Get new cursor address
        LD      (TCUR),HL       ; Set new cursor
        LD      (HL),#"_"        ; Put it on screen
        POP     HL              ; Restore code string address
        RET

SCRADR: LD      HL,#VDU+10-65    ; SCREEN VDU address (0,0)
        LD      B,#0
        LD      C,A             ; Line to BC
        OR      A               ; Test it
        JP      Z,FCERR         ; Zero - ?FC Error
        CP      #16+1            ; 16 lines
        JP      P,FCERR         ; > 16 - ?FC Error
        POP     DE              ; RETurn address
        POP     AF              ; Get column
        PUSH    DE              ; Re-save RETurn
        LD      D,#0
        LD      E,A             ; Column to DE
        OR      A               ; Test it
        JP      Z,FCERR         ; Zero - ?FC Error
        CP      #48+1            ; 48 characters per line
        JP      P,FCERR         ; > 48 - ?FC Error
        ADD     HL,DE           ; Add column to address
        LD      D,#0
        LD      E,C             ; Line to DE
        LD      B,#64            ; 64 Bytes per line
ADD64X: ADD     HL,DE           ; Add line
        DJNZ    ADD64X          ; SIXTY FOUR TIMES!!!
        RET

FLPLED: CALL    MONTST          ; See if NAS-SYS
        JP      Z,TMFLP         ; "T" MFLP
        .dw      _MFLP
        RET

TMFLP:  JP      MFLP            ; Flip drive LED

MONOUT: PUSH    AF              ; Save character
        CALL    MONTST          ; See if NAS-SYS
        JP      Z,TMNOUT        ; "T" output
        POP     AF              ; Restore character
        .db      _ROUT           ; Output it
        RET

TMNOUT: POP     AF              ; Restore character
        JP      TOUT            ; "T" output

BREAK2: LD      A,(BRKFLG)      ; Break flag set?
        JP      NZ,RETCTC       ; Yes - Return ^C
        CALL    MONTST          ; See if NAS-SYS
        JP      Z,T0xCINP        ; Get "T" character input
        .dw      _RIN            ; Scan for a character
        RET

T0xCINP: JP      TIN             ; "T" input a character

RETCTC: LD      A,#0             ; Clear Break flag
        LD      (BRKFLG),A
        LD      A,#CTRLC         ; Return ^C
        RET

MONTST: LD      A,(MONSTT+1)    ; "T" monitor or NAS-SYS?
        CP      #0x33             ; 31 00 10 / 31 33 0C
        RET

SAVE:   CALL    FLPLED          ; Flip tape LED
        CALL    MONTST          ; See if NAS-SYS
        JP      Z,TSAVE         ; "T" save
        .dw      _WRIT           ; Save program
        RET

TSAVE:  LD      A,(MONTYP)      ; "T2" or "T4" (FLAGS!!!)
        JP      Z,T4WR          ; T4 Write
        JP      T2DUMP          ; T2 Dump

MONLD:  CALL    FLPLED          ; Flip tape LED
        CALL    MONTST          ; See if NAS-SYS
        JP      Z,TLOAD         ; "T" load
        LD      A,#"R"           ; Set READ
        LD      (ARGN),A
        .dw      _READ           ; Load program
        RET

TLOAD:  LD      A,(MONTYP)      ; "T2" or "T4" (FLAGS!!!)
        JP      Z,T4READ        ; T4 Read
        JP      T2DUMP          ; T2 Dump ??????????

MONITR: CALL    MONTST          ; See if NAS-SYS
        JP      Z,MONSTT        ; Jump to zero if "T"
        .dw      _MRET           ; Return to NAS-SYS

MONVE:  CALL    FLPLED          ; Flip tape LED
        CALL    MONTST          ; See if NAS-SYS
        JP      Z,FCERR         ; Verify not available on "T"
        LD      A,#"V"           ; Set VERIFY
        LD      (ARGN),A
        .dw      _VRFY           ; Verify tape
        RET

INITST: LD      A,#0             ; Clear break flag
        LD      (BRKFLG),A
        CALL    MONTST          ; See if NAS-SYS
        JP      Z,INIT          ; "T" - No NMI vector
        LD      HL,#BREAK        ; Set NMI gives break
        LD      (NMI),HL
        PUSH    IX              ; Get start up condition
        POP     AF              ; "Z" set if cold , Else clear
        OR      A               ; "Cold" or "Cool" start?
        JP      NZ,INIT         ; "Cool" don't init NAS-SYS
        LD      B,#15            ; Delay for keyboard clear
        CALL    DELAYB          ; Allow time for key release
        CALL    STMON           ; Initialise NAS-SYS
        JP      INIT            ; Initialise BASIC

BREAK:  PUSH    AF              ; Save character
        LD      A,#-1
        LD      (BRKFLG),A      ; Flag break
        POP     AF              ; Restore character
ARETN:  RETN                    ; Return from NMI

        NOP

INLINE: .dw      _INLN           ; Get an input line
        PUSH    DE              ; Save cursor address
        PUSH    DE              ; Cursor address to HL
        POP     HL
        LD      DE,#48-1         ; Length of line-1
        ADD     HL,DE           ; Point to end of line
ENDLIN: LD      A,(HL)          ; Get end of line
        CP      #" "             ; Space?
        JP      NZ,LINTBF       ; No - Copy to buffer
        DEC     E               ; Back 1 character
        LD      A,#0             ; Wasteful test on E
        OR      E
        JP      Z,LINTBF        ; Start of line - Copy it
        DEC     HL              ; Back 1 character
        JP      ENDLIN          ; Keep looking for end

LINTBF: PUSH    DE              ; Line length to BC
        POP     BC
        INC     BC              ; Length +1
        LD      DE,#BUFFER       ; Input buffer
        POP     HL              ; Line start
        PUSH    BC              ; Save length
        LDIR                    ; Move line to buffer
        LD      A,#0
        LD      (DE),A          ; Mark end of buffer with 00
        POP     BC              ; Restore buffer length
        LD      B,C             ; Length returned in B
        LD      HL,#BUFFER-1     ; Point to start of buffer-1
        RET

GETXYA: CALL    CHKSYN          ; Make sure "(" follows
        .db      "("
        CALL    GETNUM          ; Get a number
        CALL    DEINT           ; Get integer -32768 to 32767
        PUSH    DE              ; Save "X"
        CALL    CHKSYN          ; Make sure "," follows
        .db      ","
        CALL    GETNUM          ; Get a number
        CALL    CHKSYN          ; Make sure ")" follows
        .db      ")"
        CALL    DEINT           ; Get integer -32768 to 32767
        PUSH    HL              ; Save code string address
        POP     IY              ; In IY
        CALL    XYPOS           ; Address and bit mask
        PUSH    AF              ; Save mask
        CALL    ADJCOL          ; Adjust column
        CALL    SCRADR          ; Get VDU address
        POP     AF              ; Restore bit mask
        LD      B,#0b11000000     ; Block graphics base
        OR      B               ; Set bits 7 & 6
        RET

SETB:   CALL    GETXYA          ; Get co-ords and VDU address
        PUSH    AF              ; Save bit mask
        LD      A,(HL)          ; Get character from screen
        CP      #0b11000000       ; Is it a block graphic?
        JP      NC,#SETOR        ; Yes - OR new bit
        POP     AF              ; Restore bit mask
PUTBIT: LD      (HL),A          ; Put character on screen
RESCSA: PUSH    IY              ; Restore code string address
        POP     HL              ; From IY
        RET

SETOR:  POP     BC              ; Restore bit mask
        OR      B               ; Merge the bits
        JP      PUTBIT          ; Save on screen

RESETB: CALL    GETXYA          ; Get co-ords and VDU address
        PUSH    AF              ; Save bit mask
        LD      A,(HL)          ; Get byte from screen
        CP      #0b11000000       ; Is it a block graphic?
        JP      C,NORES         ; No - Leave it
        LD      B,#0b00111111     ; Six bits per block
        AND     B               ; Clear bits 7 & 6
        POP     BC              ; Get bit mask
        AND     B               ; Test for common bit
        JP      Z,RESCSA        ; None - Leave it
        LD      A,(HL)          ; Get byte from screen
        AND     #0b00111111       ; Isolate bit
        XOR     B               ; Clear that bit
        CP      #0b11000000       ; Is it a graphic blank?
        JP      NZ,PUTBIT       ; No - Save character
        LD      A,#" "           ; Put a space there
        JP      PUTBIT          ; Save the space

NORES:  POP     BC              ; Drop bit mask
        JP      RESCSA          ; Restore code string address

POINTB: CALL    GETXYA          ; Get co-ords and VDU address
        LD      B,(HL)          ; Get character from screen
        CALL    TSTBIT          ; Test if bit is set
        JP      NZ,POINT0       ; Different - Return zero
        LD      A,#0
        LD      B,#1             ; Integer AB = 1
POINTX: POP     HL              ; Drop return
        PUSH    IY              ; PUSH code string address
        LD      DE,#RETNUM       ; To return a number
        PUSH    DE              ; Save for return
        JP      ABPASS          ; Return integer AB

POINT0: LD      B,#0             ; Set zero
        JP      POINTX          ; Return value

XYPOS:  POP     BC              ; Get return address
        POP     HL              ; Get column
        PUSH    HL              ; And re-save
        PUSH    BC              ; Put back return address
        LD      A,L             ; Get column
        LD      B,#0b00000001     ; 2 bits per character
        AND     B               ; Odd or even bit
        PUSH    AF              ; Save it
        PUSH    DE              ; Get row
        POP     HL              ; to HL
        LD      DE,#0            ; Zero line count
        LD      BC,#3            ; 3 blocks per line
        INC     HL
DIV3LP: SBC     HL,BC           ; Subtract 3
        INC     DE              ; Count the subtractions
        JP      Z,DIV3EX        ; Exactly - Exit
        JP      P,DIV3LP        ; More to do

DIV3EX: ADD     HL,BC           ; Restore number
        POP     AF              ; Restore column and odd/even
        OR      A               ; Set flags (NZ or Z)
        LD      A,L             ; Get remainder from /3
        JP      Z,NOREMD        ; No remainder
        ADD     A,#3             ; Adjust remainder
NOREMD: LD      B,A             ; Bit number+1 to B
        LD      A,#0b00000001     ; Bit to rotate
SHFTBT: RLCA                    ; Shift bit left
        DJNZ    SHFTBT          ; Count shifts
        RRA                     ; Restore correct place
        RET

ADJCOL: POP     BC              ; Restore return address
        POP     AF              ; Get bit mask
        POP     HL              ; Get column
        PUSH    AF              ; Re-save but mask
        LD      A,L             ; Get column
        RRA                     ; Divide by 2
        ADD     A,#1             ; Start at column 1
        AND     #0b00111111       ; 0 to 63
        LD      H,A             ; Save column in H
        PUSH    HL              ; Re-save column
        PUSH    BC              ; Put back return
        LD      A,E             ; Get row
        RET

SMOTOR: CALL    CASFF           ; Flip tape drive
        LD      A,(HL)          ; Get byte
        RET

JPLDSV: LD      A,(BRKLIN)      ; CLOAD or CSAVE?
        CP      #-1
        JP      NZ,SNDHDR       ; CSAVE - Send header
        JP      GETHDR          ; CLOAD - Get header

CRLIN1: CALL    PRNTCR          ; Output CRLF
        JP      GETLIN          ; Get an input line

CRLIN:  CALL    PRNTCR          ; Output CRLF
        JP      GETLIN          ; Get an input line

TSTBIT: PUSH    AF              ; Save bit mask
        AND     B               ; Get common bits
        POP     BC              ; Restore bit mask
        CP      B               ; Same bit set?
        LD      A,#0             ; Return 0 in A
        RET

OUTNCR: CALL    OUTC            ; Output character in A
        JP      PRNTCR          ; Output CRLF

JJUMP:  JP      JJUMP1          ; "Cool" start

ZJUMP:  JP      BRKRET          ; Warm start
        
