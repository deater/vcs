LINKER_SCRIPT = ../../../linker_script

all:	clock.bin fireplace.bin

###

clock.bin:	clock.o
	ld65 -o clock.bin clock.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

clock.o:	clock.s clock_sprites.inc
	ca65 -o clock.o clock.s -l clock.lst

###

fireplace.bin:	fireplace.o
	ld65 -o fireplace.bin fireplace.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

fireplace.o:	fireplace.s
	ca65 -o fireplace.o fireplace.s -l fireplace.lst


###

clean:	
	rm -f *~ *.o *.lst clock.bin fireplace.bin


