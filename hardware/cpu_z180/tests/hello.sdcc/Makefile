hello_world.bin: hello_world.ihx
	objcopy -Iihex -Obinary hello_world.ihx hello_world.bin

hello_world.ihx: hello_world.rel
	sdldz80  -i hello_world.ihx hello_world.rel

hello_world.rel: hello_world.asm
	sdasz80 -x -l -o hello_world.rel hello_world.asm

clean:
	rm -f hello_world.bin hello_world.ihx hello_world.rel
