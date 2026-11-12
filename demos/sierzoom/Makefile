LINKER_SCRIPT = ../../linker_script
CALC_ADDRESS = ../../utils/calc_address
ROM_TOOL = ../../utils/rom_tool

all:	sierzoom.e7

###


sierzoom.e7:	sierzoom.o
	ld65 -o sierzoom.e7 sierzoom.o -C $(LINKER_SCRIPT)/atari2600_e7.inc

sierzoom.o:	sierzoom.s main.bin \
	rom_bank0.bin \
	rom_bank1.bin \
	rom_bank2.bin \
	rom_bank3.bin \
	rom_bank4.bin \
	rom_bank5.bin \
	rom_bank6.bin \
	zero_512.bin
	ca65 -o sierzoom.o sierzoom.s


#####

roms:	sierzoom_rom1.bin sierzoom_rom2.bin

sierzoom_rom1.bin:      sierzoom.e7
	dd if=sierzoom.e7 of=sierzoom_rom1.bin bs=1k count=8 skip=8

sierzoom_rom2.bin:	sierzoom.e7
	dd if=sierzoom.e7 of=sierzoom_rom2.bin bs=1k count=8

###

submit:	sierzoom.zip

sierzoom.zip: sierzoom.e7
	mkdir -p demosplash2026_sierzoom
	mkdir -p demosplash2026_sierzoom/src
	cp sierzoom.e7 ./demosplash2026_sierzoom
	cp file_id.diz ./demosplash2026_sierzoom
	cp sierzoom_thumb.png ./demosplash2026_sierzoom
	cp *.s ./demosplash2026_sierzoom/src
	cp *.inc ./demosplash2026_sierzoom/src
	zip -r sierzoom.zip demosplash2026_sierzoom





###

###

rom_bank0.bin:	$(ROM_TOOL)
	$(ROM_TOOL) 0 > rom_bank0.bin

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

rom_bank6.bin:	$(ROM_TOOL)
	$(ROM_TOOL) 6 > rom_bank6.bin

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


main.o:	zp.inc framebuffer.s sierzoom_effect.s \
	common_routines.s
	ca65 -o main.o main.s -l main.lst

###

clean:	
	rm -f *~ *.o *.lst sierzoom.e7 zero_512.bin rom_bank?.bin main.bin
