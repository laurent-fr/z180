; BIOS

    .CR z180
    .TF bios.hex,INT,24
    .LF bios.lst
    .SF bios.sym

    .include ../../include/z180_defs.asm



    .org $E000

    ; SYSTEM
.int_noop:      ret

    ; ASCI
.asci0_init:        jp _asci0_init
.int_asci0:         jp _int_asci0

.asci0_getc:        jp _asci0_getc
.asci0_rx_empty:    jp _asci0_rx_empty
.asci0_putc:        jp _asci0_putc
.asci0_puts:        jp _asci0_puts

.asci1_init:        jp _asci1_init
.int_asci1:         jp _int_asci1

.asci1_getc:        jp _asci1_getc
.asci1_rx_empty:    jp _asci1_rx_empty
.asci1_putc:        jp _asci1_putc
.asci1_puts:        jp _asci1_puts   

    ; VDU
.vdu_init:          jp _vdu_init
.int_vdu:           jp _int_vdu

.vdu_set_attr:      jp _vdu_set_attr
.vdu_cls:           jp _vdu_cls
.vdu_scroll_up      jp _vdu_scroll_up
.vdu_putc_term      jp _vdu_putc_term
.vdu_putc           jp _vdu_putc
.vdu_next_line      jp _vdu_next_line
.vdu_puts           jp _vdu_puts

    ; KBD
.kbd_init:          jp _kbd_init
.int_kbd:           jp _int_kbd 
.kbd_is_empty       jp _kbd_is_empty
.kbd_get_key        jp _kbd_get_key

    ; SND

    ; RTC


    .include bios_asci.asm
    .include bios_vdu.asm
    .include bios_kbd.asm