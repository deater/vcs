LINKER_SCRIPT = ../../../linker_script
CALC_ADDRESS = ../../../utils/calc_address

all:	bank6_music.bin

###

bank6_music.bin:	bank6_music.o
	ld65 -o bank6_music.bin bank6_music.o -C $(LINKER_SCRIPT)/atari2600_1000.inc

bank6_music.o:	bank6_music.s ../zp.inc \
	trial00e4_player.s \
	trial00e4_trackdata.s
	ca65 -o bank6_music.o bank6_music.s -l bank6_music.lst

###

###

clean:	
	rm -f *~ *.o *.lst bank6_music.bin

