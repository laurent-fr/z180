; UTIL
; ----------------------------------------------------------------------------

; convert a byte to ASCII hex
; input : a = number to conver
; output : bc = 2 ascii bytes
_util_byte_to_ascii_hex:
    push af 
 
    ld b,a
    and $0F                     ; get lower 4 bits

    add '0'                        ; convert to ascii hex
    cp ':'
    jp C,_util_btah_1_AF
    add 'A'-':'
_util_btah_1_AF:

    ld c,a                  ; c <- ascii hex of lower 4 bits

    ld a,b              ; get upper 4 bits
    rrca
    rrca
    rrca
    rrca
    and $0F

    add '0'                   ; convert to ascii hex
    cp ':'
    jp C,_util_btah_2_AF
    add 'A'-':'
_util_btah_2_af:

    ld b,a              ; b <- asci hex of upper 4 bits

    pop af
    ret 


_util_init_cpu:

    .DO CLOCK>8
    ; CMR_X2 : clock * 2 => xtal 16Mhz ---> 32Mhz, phi 8Mhz --> 16Mhz
    ld a,CMR_X2
    out0 (CMR),a
    .FI 

    .DO CLOCK>16
    ; CCR_CD : phi = XTAL/1 => phi 16Mhz ---> 32Mhz !!!
    ld a,CCR_CD
    out0 (CCR),a
    .FI 

    xor a
    out0 (RCR),a    ; Refresh disable

    ; setup interrupts
    im 1    ; interrupt mode 1
    ld a,INT_BASE>>8  ; interrupts high order byte : 00H
    ld i,a
    ld a,INT_BASE&$FF ; interrupts low order byte : 80H
    out0 (IL),a


    ret 