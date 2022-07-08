LINKER_SCRIPT = ../linker_script

all:	sprite48.rom

###

sprite48.rom:	sprite48.o
	ld65 -o sprite48.rom sprite48.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

sprite48.o:	sprite48.s
	ca65 -o sprite48.o sprite48.s -l sprite48.lst

###

clean:	
	rm -f *~ *.o *.lst sprite48.rom


