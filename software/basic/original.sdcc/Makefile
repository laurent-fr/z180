8kbasic.bin: 8kbasic.ihx
	objcopy -Iihex -Obinary 8kbasic.ihx 8kbasic.bin

8kbasic.ihx: 8kbasic.rel
	sdldz80  -i 8kbasic.ihx 8kbasic.rel

8kbasic.rel: 8kbasic.asm
	sdasz80 -x -l -o 8kbasic.rel 8kbasic.asm

clean:
	rm -f *.bin *.ihx *.hex *.rel *.nas
