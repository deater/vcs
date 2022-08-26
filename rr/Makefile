LINKER_SCRIPT = ../linker_script

all:	rr.bin

###

rr.bin:	rr.o
	ld65 -o rr.bin rr.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

rr.o:	rr.s \
	game_data.inc zp.inc \
	title_screen.s common_routines.s rr_scene.s \
	rr3_graphics.inc rr4_graphics.inc \
	rr5_graphics.inc \
	rr_player.s rr_trackdata.s
	ca65 -o rr.o rr.s -l rr.lst

###

clean:	
	rm -f *~ *.o *.lst rr.bin


