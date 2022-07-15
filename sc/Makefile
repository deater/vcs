LINKER_SCRIPT = ../linker_script

all:	sc.rom

###

sc.rom:	sc.o
	ld65 -o sc.rom sc.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

sc.o:	sc.s init_game.s init_level.s timer_bar.s game_data.s vid_logo.s \
	mans.s score.s level1_playfield.s update_score.s adjust_sprite.s \
	sound_update.s sound_trigger.s title_screen.s level_engine.s \
	sc_screen.s game_over_screen.s
	ca65 -o sc.o sc.s -l sc.lst

###

clean:	
	rm -f *~ *.o *.lst sc.rom


