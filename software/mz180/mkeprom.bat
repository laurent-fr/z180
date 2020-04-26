cd ..\bios
python c:\sbasm\sbasm bios.asm
cd ..\basic 
python c:\sbasm\sbasm basic_boot.asm
cd ..\mz180
python c:\sbasm\sbasm mz180.asm
c:\bin\srec_cat.exe  mz180.hex -Intel  ..\basic\basic_boot.hex -Intel -offset 8192 ..\bios\bios.hex -Intel -offset -53248 -o eprom.hex -Intel