LINKER_SCRIPT = ../../../linker_script

all:	gameplay.bin

###

gameplay.bin:	gameplay.o
	ld65 -o gameplay.bin gameplay.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

gameplay.o:	gameplay.s \
	../zp.inc ../common_routines.s ../position.s \
	game_data.inc \
	draw_score.s update_score.s \
	sound_update.s sfx.inc \
	boxing_ring.s
	ca65 -o gameplay.o gameplay.s -l gameplay.lst

###

clean:	
	rm -f *~ *.o *.lst gameplay.bin



