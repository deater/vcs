LINKER_SCRIPT = ../../linker_script

all:	snake_boxer5.rom


###

snake_boxer5.rom:	snake_boxer5.o
	ld65 -o snake_boxer5.rom snake_boxer5.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

snake_boxer5.o:	snake_boxer5.s game_over.inc game_overlay.inc
	ca65 -o snake_boxer5.o snake_boxer5.s -l snake_boxer5.lst



###

clean:	
	rm -f *~ *.o *.lst snake_boxer5.rom


