LINKER_SCRIPT = ../../linker_script

all:	snake_boxer5.bin

###

snake_boxer5.bin:	vid_title.bin gameplay.bin
	cat vid_title.bin > snake_boxer5.bin
	cat gameplay.bin >> snake_boxer5.bin



###

gameplay.bin:	gameplay.o
	ld65 -o gameplay.bin gameplay.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

gameplay.o:	gameplay.s \
	zp.inc \
	title_screen.s game_data.inc \
	draw_score.s update_score.s common_routines.s position.s \
	sound_update.s sfx.inc \
	boxing_ring.s
	ca65 -o gameplay.o gameplay.s -l gameplay.lst

###

vid_title.bin:	vid_title.o
	ld65 -o vid_title.bin vid_title.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

vid_title.o:	vid_title.s \
	zp.inc \
	videlectrix.s  title_screen.s \
	title_data.inc \
	title_music_player.s title_music_trackdata.s \
	position.s sound_notes.s \
	common_routines.s delay.s
	ca65 -o vid_title.o vid_title.s -l vid_title.lst

###


clean:	
	rm -f *~ *.o *.lst snake_boxer5.bin vid_title.bin gameplay.bin


