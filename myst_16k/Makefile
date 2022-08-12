LINKER_SCRIPT = ../linker_script

all:	myst.e7

###

myst.e7:	myst.o
	ld65 -o myst.e7 myst.o -C $(LINKER_SCRIPT)/atari2600_e7.inc

myst.o:	myst.s main.bin \
	locations/rom_bank0.bin \
	locations/rom_bank1.bin \
	locations/rom_bank2.bin \
	intro/rom_bank6.bin \
	zero.bin zero2.bin
	ca65 -o myst.o myst.s


###

zero.bin:	
	dd if=/dev/zero of=zero.bin bs=1k count=2

zero2.bin:	
	dd if=/dev/zero of=zero2.bin bs=256 count=2

###

main.bin:	main.o
	ld65 -o main.bin main.o -C $(LINKER_SCRIPT)/atari2600_1a00.inc

#	title.s cleft.s book.s arrival.s level_engine.s rocket.s

main.o:	main.s zp.inc \
	load_level.s level_engine.s \
	hand_motion.s hand_copy.s adjust_sprite.s common_routines.s \
	sound_update.s zx02_optim.s \
	locations/level_locations.inc
	ca65 -o main.o main.s -l main.lst

###


intro/rom_bank6.bin:
	cd intro && make

####

clean:	
	rm -f *~ *.o *.lst myst.rom


