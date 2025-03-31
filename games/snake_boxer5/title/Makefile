LINKER_SCRIPT = ../../../linker_script

all:	vid_title.bin

###

vid_title.bin:	vid_title.o
	ld65 -o vid_title.bin vid_title.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

vid_title.o:	vid_title.s \
	../zp.inc ../common_routines.s ../delay.s ../position.s \
	videlectrix.s  title_screen.s \
	title_data.inc \
	title_music_player.s title_music_trackdata.s \
	sound_notes.s
	ca65 -o vid_title.o vid_title.s -l vid_title.lst

###


clean:	
	rm -f *~ *.o *.lst vid_title.bin


