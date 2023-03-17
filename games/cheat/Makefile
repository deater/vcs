LINKER_SCRIPT = ../../linker_script

all:	the_cheat.bin


####

the_cheat.bin:	the_cheat.o
	ld65 -o the_cheat.bin the_cheat.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

the_cheat.o:	the_cheat.s \
	title.s title_pf.inc title_sprites.inc
	ca65 -o the_cheat.o the_cheat.s -l the_cheat.lst

####

clean:	
	rm -f *~ *.o *.lst the_cheat.bin



