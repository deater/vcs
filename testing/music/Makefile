LINKER_SCRIPT = ../../linker_script

all:	music.rom

###

music.rom:	music.o
	ld65 -o music.rom music.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

music.o:	music.s
	ca65 -o music.o music.s -l music.lst

###

clean:	
	rm -f *~ *.o *.lst music.rom


