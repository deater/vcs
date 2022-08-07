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
	clock_s_data.zx02 clock_n_data.zx02 \
	rocket_data.zx02 \
	arrival_e_data.zx02 arrival_n_data.zx02 \
	hilltop_n_data.zx02 hilltop_s_data.zx02 \
	hilltop_e_data.zx02 hilltop_w_data.zx02 pool_data.zx02
	ca65 -o rom_bank0.o rom_bank0.s -l rom_bank0.lst

###

clock_s_data.inc:	clock_s_bg.png clock_s_overlay.png
	$(PNG2PF) -4 -n clock -b 0xe0 clock_s_bg.png - > clock_s_data.inc
	$(PNG2OVERLAY) -4 -n clock clock_s_overlay.png - >> clock_s_data.inc

###

clock_n_data.inc:	clock_n_bg.png clock_n_overlay.png
	$(PNG2PF) -4 -n clock -b 0x00 clock_n_bg.png - > clock_n_data.inc
	$(PNG2OVERLAY) -4 -n clock clock_n_overlay.png - >> clock_n_data.inc

###

rocket_data.inc:	rocket_bg.png rocket_overlay.png
	$(PNG2PF) -4 -n rocket -b 0xf4 rocket_bg.png - > rocket_data.inc
	$(PNG2OVERLAY) -4 -n rocket rocket_overlay.png - >> rocket_data.inc

###

arrival_n_data.inc:	arrival_n_bg.png arrival_n_overlay.png
	$(PNG2PF) -4 -n arrival -b 0x00 arrival_n_bg.png - > arrival_n_data.inc
	$(PNG2OVERLAY) -4 -n arrival arrival_n_overlay.png - >> arrival_n_data.inc

###

arrival_e_data.inc:	arrival_e_bg.png arrival_e_overlay.png
	$(PNG2PF) -4 -n arrival -b 0x00 arrival_e_bg.png - > arrival_e_data.inc
	$(PNG2OVERLAY) -4 -n arrival arrival_e_overlay.png - >> arrival_e_data.inc


###

hilltop_w_data.inc:	hilltop_w_bg.png hilltop_w_overlay.png
	$(PNG2PF) -4 -n hilltop_w -b 0x00 hilltop_w_bg.png - > hilltop_w_data.inc
	$(PNG2OVERLAY) -4 -n hilltop_w hilltop_w_overlay.png - >> hilltop_w_data.inc

###

hilltop_e_data.inc:	hilltop_e_bg.png hilltop_e_overlay.png
	$(PNG2PF) -4 -n hilltop_e -b 0xe0 hilltop_e_bg.png - > hilltop_e_data.inc
	$(PNG2OVERLAY) -4 -n hilltop_e hilltop_e_overlay.png - >> hilltop_e_data.inc


###

hilltop_s_data.inc:	hilltop_s_bg.png hilltop_s_overlay.png
	$(PNG2PF) -4 -n hilltop_s -b 0xE0 hilltop_s_bg.png - > hilltop_s_data.inc
	$(PNG2OVERLAY) -4 -n hilltop_s hilltop_s_overlay.png - >> hilltop_s_data.inc

###

hilltop_n_data.inc:	hilltop_n_bg.png hilltop_n_overlay.png
	$(PNG2PF) -4 -n hilltop_n -b 0x02 hilltop_n_bg.png - > hilltop_n_data.inc
	$(PNG2OVERLAY) -4 -n hilltop_n hilltop_n_overlay.png - >> hilltop_n_data.inc



###

pool_data.inc:	pool_bg.png pool_overlay.png
	$(PNG2PF) -4 -n pool -b 0x00 pool_bg.png - > pool_data.inc
	$(PNG2OVERLAY) -4 -n pool pool_overlay.png - >> pool_data.inc




###

clock_s_data.zx02:	clock_s_data.bin
	$(ZX02) -f clock_s_data.bin clock_s_data.zx02

clock_s_data.bin:	clock_s_data.o
	ld65 -o clock_s_data.bin clock_s_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

clock_s_data.o:	clock_s_data.s clock_s_data.inc
	ca65 -o clock_s_data.o clock_s_data.s -l clock_s_data.lst

###

clock_n_data.zx02:	clock_n_data.bin
	$(ZX02) -f clock_n_data.bin clock_n_data.zx02

clock_n_data.bin:	clock_n_data.o
	ld65 -o clock_n_data.bin clock_n_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

clock_n_data.o:	clock_n_data.s clock_n_data.inc
	ca65 -o clock_n_data.o clock_n_data.s -l clock_n_data.lst


###

rocket_data.zx02:	rocket_data.bin
	$(ZX02) -f rocket_data.bin rocket_data.zx02

rocket_data.bin:	rocket_data.o
	ld65 -o rocket_data.bin rocket_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

rocket_data.o:	rocket_data.s rocket_data.inc
	ca65 -o rocket_data.o rocket_data.s -l rocket_data.lst

###

arrival_n_data.zx02:	arrival_n_data.bin
	$(ZX02) -f arrival_n_data.bin arrival_n_data.zx02

arrival_n_data.bin:	arrival_n_data.o
	ld65 -o arrival_n_data.bin arrival_n_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

arrival_n_data.o:	arrival_n_data.s arrival_n_data.inc
	ca65 -o arrival_n_data.o arrival_n_data.s -l arrival_n_data.lst

###

arrival_e_data.zx02:	arrival_e_data.bin
	$(ZX02) -f arrival_e_data.bin arrival_e_data.zx02

arrival_e_data.bin:	arrival_e_data.o
	ld65 -o arrival_e_data.bin arrival_e_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

arrival_e_data.o:	arrival_e_data.s arrival_e_data.inc
	ca65 -o arrival_e_data.o arrival_e_data.s -l arrival_e_data.lst


###

hilltop_w_data.zx02:	hilltop_w_data.bin
	$(ZX02) -f hilltop_w_data.bin hilltop_w_data.zx02

hilltop_w_data.bin:	hilltop_w_data.o
	ld65 -o hilltop_w_data.bin hilltop_w_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

hilltop_w_data.o:	hilltop_w_data.s hilltop_w_data.inc
	ca65 -o hilltop_w_data.o hilltop_w_data.s -l hilltop_w_data.lst

###

hilltop_e_data.zx02:	hilltop_e_data.bin
	$(ZX02) -f hilltop_e_data.bin hilltop_e_data.zx02

hilltop_e_data.bin:	hilltop_e_data.o
	ld65 -o hilltop_e_data.bin hilltop_e_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

hilltop_e_data.o:	hilltop_e_data.s hilltop_e_data.inc
	ca65 -o hilltop_e_data.o hilltop_e_data.s -l hilltop_e_data.lst


###

hilltop_s_data.zx02:	hilltop_s_data.bin
	$(ZX02) -f hilltop_s_data.bin hilltop_s_data.zx02

hilltop_s_data.bin:	hilltop_s_data.o
	ld65 -o hilltop_s_data.bin hilltop_s_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

hilltop_s_data.o:	hilltop_s_data.s hilltop_s_data.inc
	ca65 -o hilltop_s_data.o hilltop_s_data.s -l hilltop_s_data.lst

###

hilltop_n_data.zx02:	hilltop_n_data.bin
	$(ZX02) -f hilltop_n_data.bin hilltop_n_data.zx02

hilltop_n_data.bin:	hilltop_n_data.o
	ld65 -o hilltop_n_data.bin hilltop_n_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

hilltop_n_data.o:	hilltop_n_data.s hilltop_n_data.inc
	ca65 -o hilltop_n_data.o hilltop_n_data.s -l hilltop_n_data.lst


###

pool_data.zx02:	pool_data.bin
	$(ZX02) -f pool_data.bin pool_data.zx02

pool_data.bin:	pool_data.o
	ld65 -o pool_data.bin pool_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

pool_data.o:	pool_data.s pool_data.inc
	ca65 -o pool_data.o pool_data.s -l pool_data.lst


####

clean:	
	rm -f *~ *.zx02 *.lst *.inc *.o *.bin

