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