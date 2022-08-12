ZX02 = ~/research/6502_compression/zx02.git/build/zx02
LINKER_SCRIPT = ../../linker_script/
PNG2PF = ../../utils/png2pf
PNG2OVERLAY = ../../utils/png2overlay

CFLAGS = -Wall -O2 -g
LFLAGS =

all:	level_locations.inc

level_locations.inc:	rom_bank0.bin rom_bank1.bin rom_bank2.bin generate_locations
	./generate_locations -a 0x1000 -s arrival_n_data_zx02 rom_bank0.lst > level_locations.inc
	./generate_locations -a 0x1000 -s arrival_e_data_zx02 rom_bank0.lst >> level_locations.inc
	./generate_locations -a 0x1000 -s clock_s_data_zx02 rom_bank0.lst >> level_locations.inc
	./generate_locations -a 0x1000 -s clock_n_data_zx02 rom_bank0.lst >> level_locations.inc
	./generate_locations -a 0x1000 -s hilltop_n_data_zx02 rom_bank0.lst >> level_locations.inc
	./generate_locations -a 0x1000 -s hilltop_e_data_zx02 rom_bank0.lst >> level_locations.inc
	./generate_locations -a 0x1000 -s hilltop_s_data_zx02 rom_bank0.lst >> level_locations.inc
	./generate_locations -a 0x1000 -s hilltop_w_data_zx02 rom_bank0.lst >> level_locations.inc
	./generate_locations -a 0x1000 -s imager_w_data_zx02 rom_bank0.lst >> level_locations.inc
	./generate_locations -a 0x1000 -s rocket_n_data_zx02 rom_bank0.lst >> level_locations.inc
	./generate_locations -a 0x1000 -s shortsteps_w_data_zx02 rom_bank1.lst >> level_locations.inc
	./generate_locations -a 0x1000 -s dock_n_data_zx02 rom_bank1.lst >> level_locations.inc
	./generate_locations -a 0x1000 -s library_n_data_zx02 rom_bank1.lst >> level_locations.inc
	./generate_locations -a 0x1000 -s gear_n_data_zx02 rom_bank1.lst >> level_locations.inc
	./generate_locations -a 0x1000 -s gear_s_data_zx02 rom_bank1.lst >> level_locations.inc
	./generate_locations -a 0x1000 -s library_s_data_zx02 rom_bank1.lst >> level_locations.inc
	./generate_locations -a 0x1000 -s arrival_s_data_zx02 rom_bank1.lst >> level_locations.inc
	./generate_locations -a 0x1000 -s arrival_w_data_zx02 rom_bank1.lst >> level_locations.inc
	./generate_locations -a 0x1000 -s hill_w_data_zx02 rom_bank1.lst >> level_locations.inc
	./generate_locations -a 0x1000 -s dentist_n_data_zx02 rom_bank1.lst >> level_locations.inc
	./generate_locations -a 0x1000 -s library_w_data_zx02 rom_bank2.lst >> level_locations.inc
	./generate_locations -a 0x1000 -s library_e_data_zx02 rom_bank2.lst >> level_locations.inc


###

generate_locations:	generate_locations.o
	$(CC) -o generate_locations generate_locations.o $(LFLAGS)

generate_locations.o:	generate_locations.c
	$(CC) $(CFLAGS) -c generate_locations.c

###

rom_bank0.bin:	rom_bank0.o
	ld65 -o rom_bank0.bin rom_bank0.o -C $(LINKER_SCRIPT)/atari2600_1000.inc

rom_bank0.o:	rom_bank0.s \
	clock_s_data.zx02 clock_n_data.zx02 \
	rocket_n_data.zx02 \
	arrival_e_data.zx02 arrival_n_data.zx02 \
	hilltop_n_data.zx02 hilltop_s_data.zx02 \
	hilltop_e_data.zx02 hilltop_w_data.zx02 imager_w_data.zx02
	ca65 -o rom_bank0.o rom_bank0.s -l rom_bank0.lst
###

rom_bank1.bin:	rom_bank1.o
	ld65 -o rom_bank1.bin rom_bank1.o -C $(LINKER_SCRIPT)/atari2600_1000.inc

rom_bank1.o:	rom_bank1.s \
	shortsteps_w_data.zx02 \
	dock_n_data.zx02 \
	library_n_data.zx02 library_s_data.zx02 \
	gear_n_data.zx02 gear_s_data.zx02 \
	arrival_s_data.zx02 arrival_w_data.zx02 \
	hill_w_data.zx02 dentist_n_data.zx02
	ca65 -o rom_bank1.o rom_bank1.s -l rom_bank1.lst

###

rom_bank2.bin:	rom_bank2.o
	ld65 -o rom_bank2.bin rom_bank2.o -C $(LINKER_SCRIPT)/atari2600_1000.inc

rom_bank2.o:	rom_bank2.s \
	library_w_data.zx02 library_e_data.zx02
	ca65 -o rom_bank2.o rom_bank2.s -l rom_bank2.lst


###

clock_s_data.inc:	clock_s_bg.png clock_s_overlay.png
	$(PNG2PF) -4 -n clock_s -b 0xe0 clock_s_bg.png - > clock_s_data.inc
	$(PNG2OVERLAY) -4 -n clock_s clock_s_overlay.png - >> clock_s_data.inc

###

clock_n_data.inc:	clock_n_bg.png clock_n_overlay.png
	$(PNG2PF) -4 -n clock_n -b 0x00 clock_n_bg.png - > clock_n_data.inc
	$(PNG2OVERLAY) -4 -n clock_n clock_n_overlay.png - >> clock_n_data.inc

###

rocket_n_data.inc:	rocket_n_bg.png rocket_n_overlay.png
	$(PNG2PF) -4 -n rocket_n -b 0xf4 rocket_n_bg.png - > rocket_n_data.inc
	$(PNG2OVERLAY) -4 -n rocket_n rocket_n_overlay.png - >> rocket_n_data.inc

###

arrival_n_data.inc:	arrival_n_bg.png arrival_n_overlay.png
	$(PNG2PF) -4 -n arrival_n -b 0x00 arrival_n_bg.png - > arrival_n_data.inc
	$(PNG2OVERLAY) -4 -n arrival_n arrival_n_overlay.png - >> arrival_n_data.inc

###

arrival_s_data.inc:	arrival_s_bg.png arrival_s_overlay.png
	$(PNG2PF) -4 -n arrival_s -b 0x02 arrival_s_bg.png - > arrival_s_data.inc
	$(PNG2OVERLAY) -4 -n arrival_s arrival_s_overlay.png - >> arrival_s_data.inc

###

arrival_e_data.inc:	arrival_e_bg.png arrival_e_overlay.png
	$(PNG2PF) -4 -n arrival -b 0x00 arrival_e_bg.png - > arrival_e_data.inc
	$(PNG2OVERLAY) -4 -n arrival_e arrival_e_overlay.png - >> arrival_e_data.inc

###

arrival_w_data.inc:	arrival_w_bg.png arrival_w_overlay.png
	$(PNG2PF) -4 -n arrival -b 0x02 arrival_w_bg.png - > arrival_w_data.inc
	$(PNG2OVERLAY) -4 -n arrival_w arrival_w_overlay.png - >> arrival_w_data.inc

###

dentist_n_data.inc:	dentist_n_bg.png dentist_n_overlay.png
	$(PNG2PF) -4 -n arrival -b 0x02 dentist_n_bg.png - > dentist_n_data.inc
	$(PNG2OVERLAY) -4 -n dentist_n dentist_n_overlay.png - >> dentist_n_data.inc



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

hill_w_data.inc:	hill_w_bg.png hill_w_overlay.png
	$(PNG2PF) -4 -n hill_w -b 0x02 hill_w_bg.png - > hill_w_data.inc
	$(PNG2OVERLAY) -4 -n hill_w hill_w_overlay.png - >> hill_w_data.inc


###

imager_w_data.inc:	imager_w_bg.png imager_w_overlay.png
	$(PNG2PF) -4 -n imager_w -b 0x00 imager_w_bg.png - > imager_w_data.inc
	$(PNG2OVERLAY) -4 -n imager_w imager_w_overlay.png - >> imager_w_data.inc

###

shortsteps_w_data.inc:	shortsteps_w_bg.png shortsteps_w_overlay.png
	$(PNG2PF) -4 -n shortsteps_w -b 0x00 shortsteps_w_bg.png - > shortsteps_w_data.inc
	$(PNG2OVERLAY) -4 -n shortsteps_w shortsteps_w_overlay.png - >> shortsteps_w_data.inc

###

dock_n_data.inc:	dock_n_bg.png dock_n_overlay.png
	$(PNG2PF) -4 -n dock_n -b 0x00 dock_n_bg.png - > dock_n_data.inc
	$(PNG2OVERLAY) -4 -n dock_n dock_n_overlay.png - >> dock_n_data.inc

###

library_n_data.inc:	library_n_bg.png library_n_overlay.png
	$(PNG2PF) -4 -n library_n -b 0x00 library_n_bg.png - > library_n_data.inc
	$(PNG2OVERLAY) -4 -n library_n library_n_overlay.png - >> library_n_data.inc

###

library_s_data.inc:	library_s_bg.png library_s_overlay.png
	$(PNG2PF) -4 -n library_s -b 0x00 library_s_bg.png - > library_s_data.inc
	$(PNG2OVERLAY) -4 -n library_s library_s_overlay.png - >> library_s_data.inc

###

library_w_data.inc:	library_w_bg.png library_w_overlay.png
	$(PNG2PF) -4 -n library_w -b 0x00 library_w_bg.png - > library_w_data.inc
	$(PNG2OVERLAY) -4 -n library_w library_w_overlay.png - >> library_w_data.inc

###

library_e_data.inc:	library_e_bg.png library_e_overlay.png
	$(PNG2PF) -4 -n library_e -b 0x00 library_e_bg.png - > library_e_data.inc
	$(PNG2OVERLAY) -4 -n library_e library_e_overlay.png - >> library_e_data.inc




###

gear_n_data.inc:	gear_n_bg.png gear_n_overlay.png
	$(PNG2PF) -4 -n gear_n -b 0x02 gear_n_bg.png - > gear_n_data.inc
	$(PNG2OVERLAY) -4 -n gear_n gear_n_overlay.png - >> gear_n_data.inc

###

gear_s_data.inc:	gear_s_bg.png gear_s_overlay.png
	$(PNG2PF) -4 -n gear_s -b 0x02 gear_s_bg.png - > gear_s_data.inc
	$(PNG2OVERLAY) -4 -n gear_s gear_s_overlay.png - >> gear_s_data.inc





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

rocket_n_data.zx02:	rocket_n_data.bin
	$(ZX02) -f rocket_n_data.bin rocket_n_data.zx02

rocket_n_data.bin:	rocket_n_data.o
	ld65 -o rocket_n_data.bin rocket_n_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

rocket_n_data.o:	rocket_n_data.s rocket_n_data.inc
	ca65 -o rocket_n_data.o rocket_n_data.s -l rocket_n_data.lst

###

arrival_n_data.zx02:	arrival_n_data.bin
	$(ZX02) -f arrival_n_data.bin arrival_n_data.zx02

arrival_n_data.bin:	arrival_n_data.o
	ld65 -o arrival_n_data.bin arrival_n_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

arrival_n_data.o:	arrival_n_data.s arrival_n_data.inc
	ca65 -o arrival_n_data.o arrival_n_data.s -l arrival_n_data.lst

###

arrival_s_data.zx02:	arrival_s_data.bin
	$(ZX02) -f arrival_s_data.bin arrival_s_data.zx02

arrival_s_data.bin:	arrival_s_data.o
	ld65 -o arrival_s_data.bin arrival_s_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

arrival_s_data.o:	arrival_s_data.s arrival_s_data.inc
	ca65 -o arrival_s_data.o arrival_s_data.s -l arrival_s_data.lst


###

arrival_e_data.zx02:	arrival_e_data.bin
	$(ZX02) -f arrival_e_data.bin arrival_e_data.zx02

arrival_e_data.bin:	arrival_e_data.o
	ld65 -o arrival_e_data.bin arrival_e_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

arrival_e_data.o:	arrival_e_data.s arrival_e_data.inc
	ca65 -o arrival_e_data.o arrival_e_data.s -l arrival_e_data.lst

###

arrival_w_data.zx02:	arrival_w_data.bin
	$(ZX02) -f arrival_w_data.bin arrival_w_data.zx02

arrival_w_data.bin:	arrival_w_data.o
	ld65 -o arrival_w_data.bin arrival_w_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

arrival_w_data.o:	arrival_w_data.s arrival_w_data.inc
	ca65 -o arrival_w_data.o arrival_w_data.s -l arrival_w_data.lst

###

dentist_n_data.zx02:	dentist_n_data.bin
	$(ZX02) -f dentist_n_data.bin dentist_n_data.zx02

dentist_n_data.bin:	dentist_n_data.o
	ld65 -o dentist_n_data.bin dentist_n_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

dentist_n_data.o:	dentist_n_data.s dentist_n_data.inc
	ca65 -o dentist_n_data.o dentist_n_data.s -l dentist_n_data.lst




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

hill_w_data.zx02:	hill_w_data.bin
	$(ZX02) -f hill_w_data.bin hill_w_data.zx02

hill_w_data.bin:	hill_w_data.o
	ld65 -o hill_w_data.bin hill_w_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

hill_w_data.o:	hill_w_data.s hill_w_data.inc
	ca65 -o hill_w_data.o hill_w_data.s -l hill_w_data.lst

###

imager_w_data.zx02:	imager_w_data.bin
	$(ZX02) -f imager_w_data.bin imager_w_data.zx02

imager_w_data.bin:	imager_w_data.o
	ld65 -o imager_w_data.bin imager_w_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

imager_w_data.o:	imager_w_data.s imager_w_data.inc
	ca65 -o imager_w_data.o imager_w_data.s -l imager_w_data.lst


###

shortsteps_w_data.zx02:	shortsteps_w_data.bin
	$(ZX02) -f shortsteps_w_data.bin shortsteps_w_data.zx02

shortsteps_w_data.bin:	shortsteps_w_data.o
	ld65 -o shortsteps_w_data.bin shortsteps_w_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

shortsteps_w_data.o:	shortsteps_w_data.s shortsteps_w_data.inc
	ca65 -o shortsteps_w_data.o shortsteps_w_data.s -l shortsteps_w_data.lst

###

dock_n_data.zx02:	dock_n_data.bin
	$(ZX02) -f dock_n_data.bin dock_n_data.zx02

dock_n_data.bin:	dock_n_data.o
	ld65 -o dock_n_data.bin dock_n_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

dock_n_data.o:	dock_n_data.s dock_n_data.inc
	ca65 -o dock_n_data.o dock_n_data.s -l dock_n_data.lst

###

library_n_data.zx02:	library_n_data.bin
	$(ZX02) -f library_n_data.bin library_n_data.zx02

library_n_data.bin:	library_n_data.o
	ld65 -o library_n_data.bin library_n_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

library_n_data.o:	library_n_data.s library_n_data.inc
	ca65 -o library_n_data.o library_n_data.s -l library_n_data.lst

###

library_s_data.zx02:	library_s_data.bin
	$(ZX02) -f library_s_data.bin library_s_data.zx02

library_s_data.bin:	library_s_data.o
	ld65 -o library_s_data.bin library_s_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

library_s_data.o:	library_s_data.s library_s_data.inc
	ca65 -o library_s_data.o library_s_data.s -l library_s_data.lst

###

library_w_data.zx02:	library_w_data.bin
	$(ZX02) -f library_w_data.bin library_w_data.zx02

library_w_data.bin:	library_w_data.o
	ld65 -o library_w_data.bin library_w_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

library_w_data.o:	library_w_data.s library_w_data.inc
	ca65 -o library_w_data.o library_w_data.s -l library_w_data.lst

###

library_e_data.zx02:	library_e_data.bin
	$(ZX02) -f library_e_data.bin library_e_data.zx02

library_e_data.bin:	library_e_data.o
	ld65 -o library_e_data.bin library_e_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

library_e_data.o:	library_e_data.s library_e_data.inc
	ca65 -o library_e_data.o library_e_data.s -l library_e_data.lst




###

gear_n_data.zx02:	gear_n_data.bin
	$(ZX02) -f gear_n_data.bin gear_n_data.zx02

gear_n_data.bin:	gear_n_data.o
	ld65 -o gear_n_data.bin gear_n_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

gear_n_data.o:	gear_n_data.s gear_n_data.inc
	ca65 -o gear_n_data.o gear_n_data.s -l gear_n_data.lst

###

gear_s_data.zx02:	gear_s_data.bin
	$(ZX02) -f gear_s_data.bin gear_s_data.zx02

gear_s_data.bin:	gear_s_data.o
	ld65 -o gear_s_data.bin gear_s_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

gear_s_data.o:	gear_s_data.s gear_s_data.inc
	ca65 -o gear_s_data.o gear_s_data.s -l gear_s_data.lst




####

clean:	
	rm -f *~ *.zx02 *.lst *.inc *.o *.bin generate_locations

