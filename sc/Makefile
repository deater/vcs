LINKER_SCRIPT = ../linker_script

all:	sc.rom test.rom

###

sc.rom:	sc.o
	ld65 -o sc.rom sc.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

sc.o:	sc.s init_game.s init_level.s timer_bar.s game_data.s vid_logo.s \
	mans.s score.s level1_playfield.s update_score.s
	ca65 -o sc.o sc.s -l sc.lst

###

test.rom:	test.o
	ld65 -o test.rom test.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

test.o:	test.s sc_graphic.inc sc_overlay.inc
	ca65 -o test.o test.s -l test.lst


###

clean:	
	rm -f *~ *.o *.lst sc.rom test.rom


