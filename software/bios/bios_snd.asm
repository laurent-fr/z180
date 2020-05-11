; SND
; ----------------------------------------------------------------------------

SND_REG       .equ $82

_snd_init:
  
    ; init sound variables
    xor a 
    ld (snd_value),a
    ld (snd_length),a
    ld (snd_length+1),a
    ret

_int_snd:
    push af 
    push de 
    
    in0 a,(TCR)         ; clear TIFE0
    in0 a,(TMDR1L)

    ld de,(snd_length)
    ld a,d
    or e
    jr NZ,_int_snd_pitch

     ; disable PRT1 interrupt
    ;in0 a,(TCR) 
    ;and  $FF!TCR_TIE1!TCR_TDE1
    ;out0 (TCR),a 

_int_snd_pitch:
    dec de 
    ld (snd_length),de
    
    ld a,(snd_value)
    xor 255
    ld (snd_value),a
    out (SND_REG),a

    ld a,'X' ; TMP !!
    ld de,$F002 ; TMP !!
    ld (de),a : ; TMP !!

    pop de 
    pop af 
    ei  
    ret


_snd_beep:  
    push af 
    push hl 
    
    ld a,200
    ld (snd_length+1),a
    ld a,200
    ld (snd_length),a

    ; set PRT1 interrupt speed
    ld hl,$038D
    out0 (RLDR1H),h
    out0 (RLDR1L),l

    ; enable PRT1 interrupt
    in0 a,(TCR) 
    or TCR_TIE1|TCR_TDE1
    out0 (TCR),a 

    pop hl
    pop af
    ret


; RAM

snd_length  .bs 2
snd_value   .bs 1