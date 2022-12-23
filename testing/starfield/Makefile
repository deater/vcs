LINKER_SCRIPT = ../../linker_script

all:	starfield.bin

###

starfield.bin:	starfield.o
	ld65 -o starfield.bin starfield.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

starfield.o:	starfield.s
	ca65 -o starfield.o starfield.s -l starfield.lst

###

clean:	
	rm -f *~ *.o *.lst starfield.bin


