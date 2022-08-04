LINKER_SCRIPT = ../linker_script

all:	myst.e7

###

myst.e7:	myst.o
	ld65 -o myst.e7 myst.o -C $(LINKER_SCRIPT)/atari2600_e7.inc

myst.o:	main.bin
	ca65 -o myst.o myst.s


###

main.bin:	main.o
	ld65 -o main.bin main.o -C $(LINKER_SCRIPT)/atari2600_1a00.inc

main.o:	main.s myst_data.inc \
	title.s cleft.s book.s arrival.s clock.s rocket.s \
	hand_motion.s hand_copy.s adjust_sprite.s common_routines.s \
	sound_update.s
	ca65 -o main.o main.s -l main.lst

###

clean:	
	rm -f *~ *.o *.lst myst.rom


