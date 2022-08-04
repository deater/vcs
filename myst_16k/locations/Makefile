ZX02 = ~/research/6502_compression/zx02.git/build/zx02
LINKER_SCRIPT = ../../linker_script/
PNG2PF = ../../utils/png2pf
PNG2OVERLAY = ../../utils/png2overlay

all:	rom_bank0.bin

###

rom_bank0.bin:	rom_bank0.o
	ld65 -o rom_bank0.bin rom_bank0.o -C $(LINKER_SCRIPT)/atari2600_1000.inc

###


rom_bank0.o:	rom_bank0.s \
	clock_data.zx02 rocket_data.zx02
	ca65 -o rom_bank0.o rom_bank0.s -l rom_bank0.lst

###

#16 bytes
# 0 = color of sprite 0 (hand)
# 1 = background color
# 2 = background color 2 (if mid-screen switch)
# 3 = coarse location of overlay sprite
# 4 = fine location of overlay sprite
# 5 = coarse location of overlay missile0 (vertical line)
# 6 = fine location of overlay missile0
# 7 = XMIN of grab area
# 8 = XMAX of grab area
# 9 = YMIN of grab area
# 10= YMAX of grab area



###



clock_data.inc:	clock_bg.png clock_overlay.png
	echo "; Clock data" > clock_data.inc
	echo ".byte $00,$00,$00,$00" >> clock_data.inc
	echo ".byte $00,$00,$00,$00" >> clock_data.inc
	echo ".byte $00,$00,$00,$00" >> clock_data.inc
	echo ".byte $00,$00,$00,$00" >> clock_data.inc
	$(PNG2PF) -4 -n clock -b 0xe0 clock_bg.png - >> clock_data.inc
	$(PNG2OVERLAY) -4 -n clock clock_overlay.png - >> clock_data.inc

###


rocket_data.inc:	rocket_bg.png rocket_overlay.png
	echo "; Rocket data" > rocket_data.inc
	echo ".byte $00,$00,$00,$00" >> rocket_data.inc
	echo ".byte $00,$00,$00,$00" >> rocket_data.inc
	echo ".byte $00,$00,$00,$00" >> rocket_data.inc
	echo ".byte $00,$00,$00,$00" >> rocket_data.inc
	$(PNG2PF) -4 -n rocket -b 0xf4 rocket_bg.png - >> rocket_data.inc
	$(PNG2OVERLAY) -4 -n rocket rocket_overlay.png - >> rocket_data.inc



###

clock_data.zx02:	clock_data.bin
	$(ZX02) -f clock_data.bin clock_data.zx02

clock_data.bin:	clock_data.o
	ld65 -o clock_data.bin clock_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

clock_data.o:	clock_data.inc
	ca65 -o clock_data.o clock_data.inc -l clock_data.lst

###

rocket_data.zx02:	rocket_data.bin
	$(ZX02) -f rocket_data.bin rocket_data.zx02

rocket_data.bin:	rocket_data.o
	ld65 -o rocket_data.bin rocket_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

rocket_data.o:	rocket_data.inc
	ca65 -o rocket_data.o rocket_data.inc -l rocket_data.lst


####

clean:	
	rm -f *~ *.zx02 *.lst *.inc *.o *.bin

