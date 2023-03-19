LINKER_SCRIPT = ../../linker_script

all:	the_cheat.bin


####

the_cheat.bin:	title.bin game.bin
	cat title.bin > the_cheat.bin
	cat game.bin >> the_cheat.bin

####

title.bin:	title.o
	ld65 -o title.bin title.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

title.o:	zp.inc \
	title.s title_pf.inc title_sprites.inc \
	cheat2_trackdata.s cheat2_player.s
	ca65 -o title.o title.s -l title.lst

####

game.bin:	the_cheat.o
	ld65 -o game.bin the_cheat.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

the_cheat.o:	the_cheat.s \
	zp.inc \
	position.s \
	common_movement.s level_data.s \
	strongbadia.s strongbadia.inc \
	draw_score.s update_score.s \
	blue.s blue.inc
	ca65 -o the_cheat.o the_cheat.s -l the_cheat.lst
####

clean:	
	rm -f *~ *.o *.lst the_cheat.bin title.bin game.bin



