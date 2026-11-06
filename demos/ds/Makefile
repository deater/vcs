LINKER_SCRIPT = ../../linker_script
CALC_ADDRESS = ../../utils/calc_address
ROM_TOOL = ../../utils/rom_tool

all:	ds.e7

###


ds.e7:	ds.o
	ld65 -o ds.e7 ds.o -C $(LINKER_SCRIPT)/atari2600_e7.inc

ds.o:	ds.s main.bin \
	bank0_title/bank0_title.bin \
	bank1_bounce/bank1_bounce.bin \
	bank2_desktop/bank2_desktop.bin \
	bank3_knowthis/bank3_knowthis.bin \
	bank4_plasma/bank4_plasma.bin \
	bank5_credits/bank5_credits.bin \
	bank6_music/bank6_music.bin \
	zero_512.bin
	ca65 -o ds.o ds.s


#####

roms:	ds_rom1.bin ds_rom2.bin

ds_rom1.bin:      ds.e7
	dd if=ds.e7 of=ds_rom1.bin bs=1k count=8 skip=8

ds_rom2.bin:	ds.e7
	dd if=ds.e7 of=ds_rom2.bin bs=1k count=8

###

submit:	ds.zip

ds.zip: ds.e7
	mkdir -p demosplash2026_ds
	mkdir -p demosplash2026_ds/src
	cp ds.e7 ./demosplash2026_ds
	cp file_id.diz ./demosplash2026_ds
	cp ds_thumb.png ./demosplash2026_ds
	cp *.s ./demosplash2026_ds/src
	cp *.inc ./demosplash2026_ds/src
	zip -r ds.zip demosplash2026_ds





###

###

#rom_bank0.bin:	$(ROM_TOOL)
#	$(ROM_TOOL) 0 > rom_bank0.bin

#rom_bank1.bin:	$(ROM_TOOL)
#	$(ROM_TOOL) 1 > rom_bank1.bin

#rom_bank2.bin:	$(ROM_TOOL)
#	$(ROM_TOOL) 2 > rom_bank2.bin

#rom_bank3.bin:	$(ROM_TOOL)
#	$(ROM_TOOL) 3 > rom_bank3.bin

#rom_bank4.bin:	$(ROM_TOOL)
#	$(ROM_TOOL) 4 > rom_bank4.bin

#rom_bank5.bin:	$(ROM_TOOL)
#	$(ROM_TOOL) 5 > rom_bank5.bin

#rom_bank6.bin:	$(ROM_TOOL)
#	$(ROM_TOOL) 6 > rom_bank6.bin

###

bank0_title/bank0_title.bin:	
	cd bank0_title && make

###

bank1_bounce/bank1_bounce.bin:	
	cd bank1_bounce && make

bank2_desktop/bank2_desktop.bin:	
	cd bank2_desktop && make

bank3_knowthis/bank3_knowthis.bin:	
	cd bank3_knowthis && make

bank4_plasma/bank4_plasma.bin:	
	cd bank4_plasma && make

bank5_credits/bank5_credits.bin:	
	cd bank5_credits && make

bank6_music/bank6_music.bin:	
	cd bank6_music && make



###

#zero_2k.bin:	
#	dd if=/dev/zero of=zero_2k.bin bs=1k count=2

###

zero_512.bin:	
	$(ROM_TOOL) -s 512 -a "VMW-dSr-" > zero_512.bin

###


###



main.bin:	main.o
	ld65 -o main.bin main.o -C $(LINKER_SCRIPT)/atari2600_1a00_e7.inc


main.o:	main.s zp.inc \
	common_routines.s title_screen.s zx02_optim.s
	echo "do_title = 0 " > bank0_routines.inc
	echo "do_bounce = 0 " > bank1_routines.inc
	echo "do_desktop = 0 " > bank2_routines.inc
	echo "do_knowthis = 0 " > bank3_routines.inc
	echo "do_plasma = 0 " > bank4_routines.inc
	echo "do_credits = 0 " > bank5_routines.inc
	echo "play_music = 0 " > bank6_routines.inc
	ca65 -o main.o main.s -l main.lst
	$(CALC_ADDRESS) -a 0x1A00 -s common_vblank main.lst > common_routines.inc
	$(CALC_ADDRESS) -a 0x1A00 -s common_overscan main.lst >> common_routines.inc
	$(CALC_ADDRESS) -a 0x1A00 -s zx02_full_decomp main.lst >> common_routines.inc
	$(CALC_ADDRESS) -a 0x1A00 -s repeat_wsync main.lst >> common_routines.inc
	cd bank0_title && make
	cd bank1_bounce && make
	$(CALC_ADDRESS) -a 0x1000 -s do_bounce bank1_bounce/bank1_bounce.lst > bank1_routines.inc
	cd bank2_desktop && make
	$(CALC_ADDRESS) -a 0x1000 -s do_desktop bank2_desktop/bank2_desktop.lst > bank2_routines.inc
	cd bank3_knowthis && make
	$(CALC_ADDRESS) -a 0x1000 -s do_knowthis bank3_knowthis/bank3_knowthis.lst > bank3_routines.inc
	cd bank4_plasma && make
	$(CALC_ADDRESS) -a 0x1000 -s do_plasma bank4_plasma/bank4_plasma.lst > bank4_routines.inc
	cd bank5_credits && make
	$(CALC_ADDRESS) -a 0x1000 -s do_credits bank5_credits/bank5_credits.lst > bank5_routines.inc
	cd bank6_music && make
	$(CALC_ADDRESS) -a 0x1000 -s do_title bank0_title/bank0_title.lst > bank0_routines.inc
	$(CALC_ADDRESS) -a 0x1000 -s play_music bank6_music/bank6_music.lst > bank6_routines.inc
	ca65 -o main.o main.s -l main.lst

###

###

clean:	
	rm -f *~ *.o *.lst ds.e7 zero_512.bin \
	bank0_routines.inc bank1_routines.inc bank2_routines.inc \
	bank3_routines.inc bank4_routines.inc bank5_routines.inc \
	bank6_routines.inc common_routines.inc
	cd bank0_title && make clean
	cd bank1_bounce && make clean
	cd bank2_desktop && make clean
	cd bank3_knowthis && make clean
	cd bank4_plasma && make clean
	cd bank5_credits && make clean
	cd bank6_music && make clean
