LINKER_SCRIPT = ../../linker_script
CALC_ADDRESS = ../../utils/calc_address
ROM_TOOL = ../../utils/rom_tool

all:	ds.e7

###


ds.e7:	ds.o
	ld65 -o ds.e7 ds.o -C $(LINKER_SCRIPT)/atari2600_e7.inc

ds.o:	ds.s main.bin \
	bank0_title/bank0_title.bin \
	rom_bank1.bin \
	rom_bank2.bin \
	rom_bank3.bin \
	rom_bank4.bin \
	rom_bank5.bin \
	bank6_music/bank6_music.bin \
	zero_2k.bin \
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

rom_bank1.bin:	$(ROM_TOOL)
	$(ROM_TOOL) 1 > rom_bank1.bin

rom_bank2.bin:	$(ROM_TOOL)
	$(ROM_TOOL) 2 > rom_bank2.bin

rom_bank3.bin:	$(ROM_TOOL)
	$(ROM_TOOL) 3 > rom_bank3.bin

rom_bank4.bin:	$(ROM_TOOL)
	$(ROM_TOOL) 4 > rom_bank4.bin

rom_bank5.bin:	$(ROM_TOOL)
	$(ROM_TOOL) 5 > rom_bank5.bin

#rom_bank6.bin:	$(ROM_TOOL)
#	$(ROM_TOOL) 6 > rom_bank6.bin

###

bank0_title/bank0_title.bin:	
	cd bank0_title && make

#bank0_routines.inc:	bank0_title/bank0_title.bin
#	$(CALC_ADDRESS) -a 0x1000 -s do_title bank0_title/bank0_title.lst > bank0_routines.inc


bank6_music/bank6_music.bin:	
	cd bank6_music && make

#bank6_routines.inc:	bank6_music/bank6_music.bin
#	$(CALC_ADDRESS) -a 0x1000 -s play_music bank6_music/bank6_music.lst > bank6_routines.inc


###

zero_2k.bin:	
	dd if=/dev/zero of=zero_2k.bin bs=1k count=2

###

zero_512.bin:	
	dd if=/dev/zero of=zero_512.bin bs=256 count=2

###


###



main.bin:	main.o
	ld65 -o main.bin main.o -C $(LINKER_SCRIPT)/atari2600_1a00_e7.inc

#	bank0_routines.inc \
#	bank6_routines.inc

main.o:	main.s zp.inc \
	common_routines.s title_screen.s zx02_optim.s
	echo "do_title = 0 " > bank0_routines.inc
	echo "play_music = 0 " > bank6_routines.inc
	ca65 -o main.o main.s -l main.lst
	$(CALC_ADDRESS) -a 0x1A00 -s common_vblank main.lst > common_routines.inc
	$(CALC_ADDRESS) -a 0x1A00 -s common_overscan main.lst >> common_routines.inc
	$(CALC_ADDRESS) -a 0x1A00 -s zx02_full_decomp main.lst >> common_routines.inc
	$(CALC_ADDRESS) -a 0x1A00 -s repeat_wsync main.lst >> common_routines.inc
	cd bank0_title && make
	cd bank6_music && make
	$(CALC_ADDRESS) -a 0x1000 -s do_title bank0_title/bank0_title.lst > bank0_routines.inc
	$(CALC_ADDRESS) -a 0x1000 -s play_music bank6_music/bank6_music.lst > bank6_routines.inc
	ca65 -o main.o main.s -l main.lst

###

###

clean:	
	rm -f *~ *.o *.lst ds.rom \
	bank0_routines.inc bank6_routines.inc common_routines.inc
	cd bank0_title && make clean
	cd bank6_music && make clean
