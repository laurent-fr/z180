# Software

To assemble the software, you will need SBASM available here : https://www.sbprojects.net/sbasm/

As it is written in Python, you will also need a Python interpreter ...

## BASIC

* nascom.basic.grant.searle : backup of NASCOM BASIC adapted by Grant Searle on his homebrew computer as found on http://searle.x10host.com/z80/SimpleZ80.html
(it's also the base software for RC2014 project)
* original : for reference NASCOM BASIC without modifications
* basic.asm : Grant Searle's version with small modifications by me (skip memory test, add colors)
* basic_boot.asm : the glue between basic.asm and the computer, with memory

## BIOS

The BIOS of the computer.

## CP/M

Work in progress !

## Include

Contains the constants for the Z180.

## mz180

This folder contains the main software for the computer. It allows to boot all-RAM BASIC and hopefully soon CP/M. 
The file eprom.hex is what you want to burn on the EPROM of the CPU board.

## Tests

All what you need to test the computer !
