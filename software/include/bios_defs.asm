


int_noop            .EQU    BIOS_BASE

    ; ASCI
asci0_init          .EQU    BIOS_BASE+1
int_asci0           .EQU    BIOS_BASE+4

asci0_getc          .EQU    BIOS_BASE+7
asci0_rx_empty      .EQU    BIOS_BASE+10
asci0_putc          .EQU    BIOS_BASE+13
asci0_puts          .EQU    BIOS_BASE+16

asci1_init          .EQU    BIOS_BASE+19
int_asci1           .EQU    BIOS_BASE+22

asci1_getc          .EQU    BIOS_BASE+25
asci1_rx_empty      .EQU    BIOS_BASE+28
asci1_putc          .EQU    BIOS_BASE+31
asci1_puts          .EQU    BIOS_BASE+34

    ; VDU
vdu_init            .EQU    BIOS_BASE+37
int_vdu             .EQU    BIOS_BASE+40

vdu_set_attr        .EQU    BIOS_BASE+43
vdu_cls             .EQU    BIOS_BASE+46
vdu_scroll_up       .EQU    BIOS_BASE+49
vdu_putc_term       .EQU    BIOS_BASE+52
vdu_putc            .EQU    BIOS_BASE+55
vdu_next_line       .EQU    BIOS_BASE+58
vdu_puts            .EQU    BIOS_BASE+61

    ; KBD
kbd_init            .EQU    BIOS_BASE+64
int_kbd             .EQU    BIOS_BASE+67
kbd_is_empty        .EQU    BIOS_BASE+70
kbd_get_key         .EQU    BIOS_BASE+73
kbd_wait_get_key    .EQU    BIOS_BASE+76

    ; SND
snd_init            .EQU    BIOS_BASE+79
int_snd             .EQU    BIOS_BASE+82
snd_beep            .EQU    BIOS_BASE+85

    ; CF 
cf_init             .EQU    BIOS_BASE+88
cf_read_sector      .EQU    BIOS_BASE+91
cf_write_sector     .EQU    BIOS_BASE+94