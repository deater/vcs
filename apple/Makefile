LINKER_SCRIPT = ../linker_script

all:	apple.rom

###

apple.rom:	apple.o
	ld65 -o apple.rom apple.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

apple.o:	apple.s playfield.inc
	ca65 -o apple.o apple.s -l apple.lst

###

clean:	
	rm -f *~ *.o *.lst apple.rom


