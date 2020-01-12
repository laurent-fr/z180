


VDU_RAM  .equ $F000

VDU_ATTR .equ $FFF0
VDU_X    .equ $FFF1
VDU_Y    .equ $FFF2

vdu_cls:
    ld de,1000     ; number of chars
    ld hl,VDU_RAM    ; pointer to srart of ram
    ld c,(VDU_ATTR)  ; get color attribute   
vdu_cls_loop:
    ld (hl),$20     ; space char.
    inc hl
    ld (hl),c       ; set color attribute
    inc hl
    dec de          ; update chars counter  
    ld a,de         ; check if zero 
    or e
    jp nz,vdu_cls_loop  
    ld a,0          ; home cursor   
    ld (VDU_X),a
    ld (VDU_Y),a
    ret 

; input :   a=char to display 
;           hl=vdu display address
vdu_putc:
    ld  (hl),a
    inc hl
    ld a,(VDU_ATTR)
    ld (hl),a
    inc hl
    ret

; output : hl=cursor addr
vdu_getaddr:
    ld h,0
    ld l,(VDU_Y)
    ld de,vdu_addr_lookup
    add hl,de               ; get column address (/8)
    ld a,(hl)               ; get lookup table content  
    ld l,a
    ld h,0
    add hl,hl
    add hl,hl
    add hl,hl               ; *8
    ld d,0
    ld e,(VDU_X)
    add hl,de               ; add X offset
    add hl,hl               ;*2
    add hl,VDU_RAM          ; add base RAM
    ret

vdu_move_cursor:

    ret


vdu_addr_lookup:
    .dw 0,10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,160,170,180,190,200,210,220,230,240