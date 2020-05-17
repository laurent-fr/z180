# Hardware

## Software needed

A few softwares are needed for reading/using the files in this folder :

* Kicad for reading the schematics and board layouts  https://kicad-pcb.org/ 
* Quartus 2 web edition for programming the Altera CPLDs https://fpgasoftware.intel.com/13.1/?edition=web
* WinCUPL for programming the GAL of the VDU board https://www.microchip.com/design-centers/fpgas-and-plds/splds-cplds/pld-design-resources

Optional :

* LTSPice, if you want to look at the few simulation files https://www.analog.com/en/design-center/design-tools-and-calculators/ltspice-simulator.html

## Hardware needed for running the computer

* An EPROM programmer. I use a Minipro TL866.
* A JTAG programmer for the CPLDs. I use the super cheap USB Blaster.

## Hardware for debugging the computer

It is not strictly needed to build the computer from the blueprints, but if something goes wrong the following could help :

* An EPROM simulator. The fastest way to test a new firmware ! Mine is a MemSIM2 from http://www.momik.pl/ and it works very well.
* A logic analyzer. Pick your favourite. Mine is a DSLogic.
* A good old oscilloscope is useful, too !
