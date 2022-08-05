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
	clock_data.zx02 rocket_data.zx02 arrival_data.zx02 \
	hilltop_s_data.zx02 hilltop_w_data.zx02 pool_data.zx02
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
	echo ".byte \$$22,\$$E0,\$$E0,    5" >> clock_data.inc
	echo ".byte \$$F0,    4,\$$00,\$$00" >> clock_data.inc
	echo ".byte \$$00,\$$00,\$$00,\$$00" >> clock_data.inc
	echo ".byte \$$00,\$$00,\$$00,\$$00" >> clock_data.inc
	$(PNG2PF) -4 -n clock -b 0xe0 clock_bg.png - >> clock_data.inc
	$(PNG2OVERLAY) -4 -n clock clock_overlay.png - >> clock_data.inc

###

rocket_data.inc:	rocket_bg.png rocket_overlay.png
	echo "; Rocket data" > rocket_data.inc
	echo ".byte \$$22,\$$F4,\$$F4,\$$04" >> rocket_data.inc
	echo ".byte \$$30,\$$00,\$$00,\$$00" >> rocket_data.inc
	echo ".byte \$$00,\$$00,\$$00,\$$00" >> rocket_data.inc
	echo ".byte \$$00,\$$00,\$$00,\$$00" >> rocket_data.inc
	$(PNG2PF) -4 -n rocket -b 0xf4 rocket_bg.png - >> rocket_data.inc
	$(PNG2OVERLAY) -4 -n rocket rocket_overlay.png - >> rocket_data.inc

###

arrival_data.inc:	arrival_bg.png arrival_overlay.png
	echo "; Arrival data" > arrival_data.inc
	echo ".byte \$$22,\$$F0,\$$F0,\$$04" >> arrival_data.inc
	echo ".byte \$$30,\$$00,\$$00,\$$00" >> arrival_data.inc
	echo ".byte \$$00,\$$00,\$$00,\$$00" >> arrival_data.inc
	echo ".byte \$$00,\$$00,\$$00,\$$00" >> arrival_data.inc
	$(PNG2PF) -4 -n arrival -b 0x00 arrival_bg.png - >> arrival_data.inc
	$(PNG2OVERLAY) -4 -n arrival arrival_overlay.png - >> arrival_data.inc

###

hilltop_w_data.inc:	hilltop_w_bg.png hilltop_w_overlay.png
	echo "; Hilltop W data" > hilltop_w_data.inc
	echo ".byte \$$22,\$$00,\$$00,\$$08" >> hilltop_w_data.inc
	echo ".byte \$$70,\$$00,\$$00,\$$00" >> hilltop_w_data.inc
	echo ".byte \$$00,\$$00,\$$00,\$$00" >> hilltop_w_data.inc
	echo ".byte \$$00,\$$00,\$$00,\$$00" >> hilltop_w_data.inc
	$(PNG2PF) -4 -n hilltop_w -b 0x00 hilltop_w_bg.png - >> hilltop_w_data.inc
	$(PNG2OVERLAY) -4 -n hilltop_w hilltop_w_overlay.png - >> hilltop_w_data.inc

###

hilltop_s_data.inc:	hilltop_s_bg.png hilltop_s_overlay.png
	echo "; Hilltop S data" > hilltop_s_data.inc
	echo ".byte \$$22,\$$E0,\$$E0,\$$04" >> hilltop_s_data.inc
	echo ".byte \$$70,\$$00,\$$00,\$$00" >> hilltop_s_data.inc
	echo ".byte \$$00,\$$00,\$$00,\$$00" >> hilltop_s_data.inc
	echo ".byte \$$00,\$$00,\$$00,\$$00" >> hilltop_s_data.inc
	$(PNG2PF) -4 -n hilltop_s -b 0xE0 hilltop_s_bg.png - >> hilltop_s_data.inc
	$(PNG2OVERLAY) -4 -n hilltop_s hilltop_s_overlay.png - >> hilltop_s_data.inc


###

pool_data.inc:	pool_bg.png pool_overlay.png
	echo "; Pool data" > pool_data.inc
	echo ".byte \$$22,\$$00,\$$00,\$$04" >> pool_data.inc
	echo ".byte \$$30,\$$00,\$$00,\$$00" >> pool_data.inc
	echo ".byte \$$00,\$$00,\$$00,\$$00" >> pool_data.inc
	echo ".byte \$$00,\$$00,\$$00,\$$00" >> pool_data.inc
	$(PNG2PF) -4 -n pool -b 0x00 pool_bg.png - >> pool_data.inc
	$(PNG2OVERLAY) -4 -n pool pool_overlay.png - >> pool_data.inc




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

###

arrival_data.zx02:	arrival_data.bin
	$(ZX02) -f arrival_data.bin arrival_data.zx02

arrival_data.bin:	arrival_data.o
	ld65 -o arrival_data.bin arrival_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

arrival_data.o:	arrival_data.inc
	ca65 -o arrival_data.o arrival_data.inc -l arrival_data.lst

###

hilltop_w_data.zx02:	hilltop_w_data.bin
	$(ZX02) -f hilltop_w_data.bin hilltop_w_data.zx02

hilltop_w_data.bin:	hilltop_w_data.o
	ld65 -o hilltop_w_data.bin hilltop_w_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

hilltop_w_data.o:	hilltop_w_data.inc
	ca65 -o hilltop_w_data.o hilltop_w_data.inc -l hilltop_w_data.lst

###

hilltop_s_data.zx02:	hilltop_s_data.bin
	$(ZX02) -f hilltop_s_data.bin hilltop_s_data.zx02

hilltop_s_data.bin:	hilltop_s_data.o
	ld65 -o hilltop_s_data.bin hilltop_s_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

hilltop_s_data.o:	hilltop_s_data.inc
	ca65 -o hilltop_s_data.o hilltop_s_data.inc -l hilltop_s_data.lst

###

pool_data.zx02:	pool_data.bin
	$(ZX02) -f pool_data.bin pool_data.zx02

pool_data.bin:	pool_data.o
	ld65 -o pool_data.bin pool_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

pool_data.o:	pool_data.inc
	ca65 -o pool_data.o pool_data.inc -l pool_data.lst


####

clean:	
	rm -f *~ *.zx02 *.lst *.inc *.o *.bin

