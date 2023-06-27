LINKER_SCRIPT = ../../linker_script
CALC_ADDRESS = ./utils/calc_address

all:	myst.e7

###

myst.e7:	myst.o
	ld65 -o myst.e7 myst.o -C $(LINKER_SCRIPT)/atari2600_e7.inc

myst.o:	myst.s main.bin \
	locations/rom_bank0.bin \
	locations/rom_bank1.bin \
	locations/rom_bank2.bin \
	locations/rom_bank3.bin \
	locations/rom_bank4.bin \
	locations/rom_bank5.bin \
	bank6_intro/rom_bank6.bin \
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

main.o:	main.s zp.inc \
	load_level.s level_engine.s \
	hand_motion.s hand_copy.s adjust_sprite.s common_routines.s \
	sound_update.s zx02_optim.s \
	locations/level_locations.inc
	echo "book_common = 0 " > rom_bank6_routines.inc
	echo "do_intro = 0 " >> rom_bank6_routines.inc
	ca65 -o main.o main.s -l main.lst
	$(CALC_ADDRESS) -a 0x1A00 -s common_overscan main.lst > common_routines.inc
	$(CALC_ADDRESS) -a 0x1A00 -s common_delay_scanlines main.lst >> common_routines.inc
	$(CALC_ADDRESS) -a 0x1A00 -s common_vblank main.lst >> common_routines.inc
	$(CALC_ADDRESS) -a 0x1A00 -s hand_copy main.lst >> common_routines.inc
	$(CALC_ADDRESS) -a 0x1A00 -s hand_motion main.lst >> common_routines.inc
	$(CALC_ADDRESS) -a 0x1A00 -s pointer_moved_horizontally main.lst >> common_routines.inc
	$(CALC_ADDRESS) -a 0x1A00 -s do_book main.lst >> common_routines.inc
	$(CALC_ADDRESS) -a 0x1A00 -s zx02_full_decomp main.lst >> common_routines.inc
	cd bank6_intro && make
	$(CALC_ADDRESS) -a 0x1000 -s book_common bank6_intro/rom_bank6.lst > rom_bank6_routines.inc
	$(CALC_ADDRESS) -a 0x1000 -s do_intro bank6_intro/rom_bank6.lst >> rom_bank6_routines.inc
	ca65 -o main.o main.s -l main.lst

###

#rom_bank6_routines.inc:	intro/rom_bank6.bin
#	echo "book_common = 0 " > rom_bank6_routines.inc
#	echo "do_intro = 0 " >> rom_bank6_routines.inc



#intro/rom_bank6.bin:
#	cd intro && make


####

clean:	
	rm -f *~ *.o *.lst myst.rom common_routines.inc
	cd bank6_intro && make clean


