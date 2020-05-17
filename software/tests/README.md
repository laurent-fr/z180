# Test software

*Here we have small softwares to test each feature of the computer*

## CPU

By default RS-232 (ASCI0 and ASCI1) are set up as 9600 bauds, N81.

* test_cpu_hello : displays the classic "Hello, World !" message on ASCI1
* test_cpu_echo : echoes what you type on a terminal connected to ASCI1 

## VDU

The VGA display is 640x480.

* test_vdu : *TODO* test display on the VGA screen

## MIO

* test_mio_cf : *TODO* Write and read a test pattern on sector 0. Output on ASCI1. **Warning, this test will destroy the data on the CF card !** 
* test_mio_kbd : echoes what you type on the PS/2 keyboard to the terminal connected on ASCI1.
* test_mio_rtc : display the current time on ASCI1.
* test_mio_snd_wav : plays on the speaker a famous quote from your favorite dark knight. 
* test_mio_snd_beep : *TODO* plays a beep ...
