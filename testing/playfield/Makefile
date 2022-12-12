LINKER_SCRIPT = ../../linker_script

all:	playfield.rom

###

playfield.rom:	playfield.o
	ld65 -o playfield.rom playfield.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

playfield.o:	playfield.s
	ca65 -o playfield.o playfield.s -l playfield.lst

###

clean:	
	rm -f *~ *.o *.lst playfield.rom


