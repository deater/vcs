LINKER_SCRIPT = ../linker_script

all:	secret_collect.rom

###

secret_collect.rom:	sc.o
	ld65 -o secret_collect.rom sc.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

sc.o:	sc.s init_level.s timer_bar.s vid_logo.s \
	mans.s score.s level_playfield.s update_score.s \
	sound_update.s sound_trigger.s title_screen.s level_engine.s \
	sc_screen.s game_over_screen.s common_routines.s \
	game_data.inc level_data.inc level_playfields.inc
	ca65 -o sc.o sc.s -l sc.lst

###

clean:	
	rm -f *~ *.o *.lst secret_collect.rom
