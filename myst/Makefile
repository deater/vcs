LINKER_SCRIPT = ../linker_script

all:	myst.rom

###

myst.rom:	myst.o
	ld65 -o myst.rom myst.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

myst.o:	myst.s myst_data.inc \
	title.s cleft.s book.s clock.s \
	hand_motion.s adjust_sprite.s common_routines.s
	ca65 -o myst.o myst.s -l myst.lst

###

clean:	
	rm -f *~ *.o *.lst myst.rom


