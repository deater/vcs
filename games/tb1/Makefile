LINKER_SCRIPT = ../../linker_script

all:	tb1.bin

###

tb1.bin:	tb1.o
	ld65 -o tb1.bin tb1.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

tb1.o:	tb1.s \
	zp.inc common_routines.s \
	title_screen.s title.inc \
	init_level.s level_engine.s \
	update_score.s add_score.s timer_bar.s score.s
	ca65 -o tb1.o tb1.s -l tb1.lst

###

clean:	
	rm -f *~ *.o *.lst tb1.bin
