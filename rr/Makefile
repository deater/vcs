LINKER_SCRIPT = ../linker_script

all:	rr.bin

###

rr.bin:	rr.o
	ld65 -o rr.bin rr.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

rr.o:	rr.s title_screen.s common_routines.s rr_player_framework.s
	ca65 -o rr.o rr.s -l rr.lst

###

clean:	
	rm -f *~ *.o *.lst rr.bin


