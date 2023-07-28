ZX02 = ~/research/6502_compression/zx02.git/build/zx02
LINKER_SCRIPT = ../../../linker_script/
PNG2PF = ../../../utils/png2pf
PNG2OVERLAY = ../../../utils/png2overlay
CALC_ADDRESS = ../utils/calc_address

all:	rom_bank5.bin

#all:	rom5_locations.inc

###

#rom5_locations.inc:	rom_bank5.bin $(CALC_ADDRESS)
#	$(CALC_ADDRESS) -a 0x1000 -s steps_e_data_zx02 rom_bank5.lst > rom5_locations.inc
#	$(CALC_ADDRESS) -a 0x1000 -s shack_n_data_zx02 rom_bank5.lst >> rom5_locations.inc
#	$(CALC_ADDRESS) -a 0x1000 -s library_up_data_zx02 rom_bank5.lst >> rom5_locations.inc
#	$(CALC_ADDRESS) -a 0x1000 -s library_nw_data_zx02 rom_bank5.lst >> rom5_locations.inc
#	$(CALC_ADDRESS) -a 0x1000 -s library_ne_data_zx02 rom_bank5.lst >> rom5_locations.inc
#	$(CALC_ADDRESS) -a 0x1000 -s clock_puzzle_data_zx02 rom_bank5.lst >> rom5_locations.inc
#	$(CALC_ADDRESS) -a 0x1000 -s clock_update rom_bank5.lst >> rom5_locations.inc
#	$(CALC_ADDRESS) -a 0x1000 -s hint_data_zx02 rom_bank5.lst >> rom5_locations.inc
#	$(CALC_ADDRESS) -a 0x1000 -s elevator_s_data_zx02 rom_bank5.lst >> rom5_locations.inc
#	$(CALC_ADDRESS) -a 0x1000 -s elevator_n_data_zx02 rom_bank5.lst >> rom5_locations.inc


###


rom_bank5.bin:	rom_bank5.o
	ld65 -o rom_bank5.bin rom_bank5.o -C $(LINKER_SCRIPT)/atari2600_1000.inc

###

rom_bank5.o:	rom_bank5.s \
	../zp.inc ../../../vcs.inc \
	steps_e_data.zx02 library_up_data.zx02 \
	library_nw_data.zx02 library_ne_data.zx02 clock_puzzle_data.zx02 \
	elevator_s_data.zx02 \
	clock_update.s ../fireplace_update.s
	ca65 -o rom_bank5.o rom_bank5.s -l rom_bank5.lst


###

clock_puzzle_data.inc:	clock_puzzle_bg.png clock_puzzle_overlay.png
	$(PNG2PF) -4 -n clock_puzzle -b 0x02 clock_puzzle_bg.png - > clock_puzzle_data.inc
	$(PNG2OVERLAY) -4 -o -n clock_puzzle clock_puzzle_overlay.png - >> clock_puzzle_data.inc

###

elevator_n_data.inc:	elevator_n_bg.png elevator_n_overlay.png
	$(PNG2PF) -4 -n elevator_n -b 0x00 elevator_n_bg.png - > elevator_n_data.inc
	$(PNG2OVERLAY) -4 -o -n elevator_n elevator_n_overlay.png - >> elevator_n_data.inc

###

elevator_s_data.inc:	elevator_s_bg.png elevator_s_overlay.png
	$(PNG2PF) -4 -n elevator_s -b 0x00 elevator_s_bg.png - > elevator_s_data.inc
	$(PNG2OVERLAY) -4 -o -n elevator_s elevator_s_overlay.png - >> elevator_s_data.inc


###

hint_data.inc:	hint_bg.png hint_overlay.png
	$(PNG2PF) -4 -n hint -b 0x00 hint_bg.png - > hint_data.inc
	$(PNG2OVERLAY) -4 -o -n hint hint_overlay.png - >> hint_data.inc


###

library_ne_data.inc:	library_ne_bg.png library_ne_overlay.png
	$(PNG2PF) -4 -n library_ne -b 0x00 library_ne_bg.png - > library_ne_data.inc
	$(PNG2OVERLAY) -4 -o -n library_ne library_ne_overlay.png - >> library_ne_data.inc

###


library_nw_data.inc:	library_nw_bg.png library_nw_overlay.png
	$(PNG2PF) -4 -n library_nw -b 0x00 library_nw_bg.png - > library_nw_data.inc
	$(PNG2OVERLAY) -4 -o -n library_nw library_nw_overlay.png - >> library_nw_data.inc

###

library_up_data.inc:	library_up_bg.png library_up_overlay.png
	$(PNG2PF) -4 -n library_up -b 0xFE library_up_bg.png - > library_up_data.inc
	$(PNG2OVERLAY) -4 -o -n library_up library_up_overlay.png - >> library_up_data.inc

###

shack_n_data.inc:	shack_n_bg.png shack_n_overlay.png
	$(PNG2PF) -4 -n shack_n -b 0x02 shack_n_bg.png - > shack_n_data.inc
	$(PNG2OVERLAY) -4 -o -n shack_n shack_n_overlay.png - >> shack_n_data.inc

###

steps_e_data.inc:	steps_e_bg.png steps_e_overlay.png
	$(PNG2PF) -4 -n steps_e -b 0x28 steps_e_bg.png - > steps_e_data.inc
	$(PNG2OVERLAY) -4 -o -n steps_e steps_e_overlay.png - >> steps_e_data.inc


###

clock_puzzle_data.zx02:	clock_puzzle_data.bin
	$(ZX02) -f clock_puzzle_data.bin clock_puzzle_data.zx02

clock_puzzle_data.bin:	clock_puzzle_data.o
	ld65 -o clock_puzzle_data.bin clock_puzzle_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

clock_puzzle_data.o:	clock_puzzle_data.s clock_puzzle_data.inc
	ca65 -o clock_puzzle_data.o clock_puzzle_data.s -l clock_puzzle_data.lst

###

elevator_n_data.zx02:	elevator_n_data.bin
	$(ZX02) -f elevator_n_data.bin elevator_n_data.zx02

elevator_n_data.bin:	elevator_n_data.o
	ld65 -o elevator_n_data.bin elevator_n_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

elevator_n_data.o:	elevator_n_data.s elevator_n_data.inc
	ca65 -o elevator_n_data.o elevator_n_data.s -l elevator_n_data.lst

###

elevator_s_data.zx02:	elevator_s_data.bin
	$(ZX02) -f elevator_s_data.bin elevator_s_data.zx02

elevator_s_data.bin:	elevator_s_data.o
	ld65 -o elevator_s_data.bin elevator_s_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

elevator_s_data.o:	elevator_s_data.s elevator_s_data.inc
	ca65 -o elevator_s_data.o elevator_s_data.s -l elevator_s_data.lst



###

hint_data.zx02:	hint_data.bin
	$(ZX02) -f hint_data.bin hint_data.zx02

hint_data.bin:	hint_data.o
	ld65 -o hint_data.bin hint_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

hint_data.o:	hint_data.s hint_data.inc
	ca65 -o hint_data.o hint_data.s -l hint_data.lst


###

library_ne_data.zx02:	library_ne_data.bin
	$(ZX02) -f library_ne_data.bin library_ne_data.zx02

library_ne_data.bin:	library_ne_data.o
	ld65 -o library_ne_data.bin library_ne_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

library_ne_data.o:	library_ne_data.s library_ne_data.inc
	ca65 -o library_ne_data.o library_ne_data.s -l library_ne_data.lst

###

library_nw_data.zx02:	library_nw_data.bin
	$(ZX02) -f library_nw_data.bin library_nw_data.zx02

library_nw_data.bin:	library_nw_data.o
	ld65 -o library_nw_data.bin library_nw_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

library_nw_data.o:	library_nw_data.s library_nw_data.inc
	ca65 -o library_nw_data.o library_nw_data.s -l library_nw_data.lst


###

library_up_data.zx02:	library_up_data.bin
	$(ZX02) -f library_up_data.bin library_up_data.zx02

library_up_data.bin:	library_up_data.o
	ld65 -o library_up_data.bin library_up_data.o -C $(LINKER_SCRIPT)/atari2600_f000_noirq.inc

library_up_data.o:	library_up_data.s library_up_data.inc
	ca65 -o library_up_data.o library_up_data.s -l library_up_data.lst



###

shack_n_data.zx02:	shack_n_data.bin
	$(ZX02) -f shack_n_data.bin shack_n_data.zx02

shack_n_data.bin:	shack_n_data.o
	ld65 -o shack_n_data.bin shack_n_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

shack_n_data.o:	shack_n_data.s shack_n_data.inc
	ca65 -o shack_n_data.o shack_n_data.s -l shack_n_data.lst

###

steps_e_data.zx02:	steps_e_data.bin
	$(ZX02) -f steps_e_data.bin steps_e_data.zx02

steps_e_data.bin:	steps_e_data.o
	ld65 -o steps_e_data.bin steps_e_data.o -C $(LINKER_SCRIPT)/atari2600_f000_noirq.inc

steps_e_data.o:	steps_e_data.s steps_e_data.inc
	ca65 -o steps_e_data.o steps_e_data.s -l steps_e_data.lst


###

clean:	
	rm -f *~ *.zx02 *.lst *.o *.bin *.inc

