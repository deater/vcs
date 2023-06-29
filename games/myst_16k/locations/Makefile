ZX02 = ~/research/6502_compression/zx02.git/build/zx02
LINKER_SCRIPT = ../../../linker_script/
PNG2PF = ../../../utils/png2pf
PNG2OVERLAY = ../../../utils/png2overlay
CALC_ADDRESS = ../utils/calc_address

all:	level_locations.inc

level_locations.inc:	\
	rom_bank0.bin rom_bank1.bin rom_bank2.bin \
	rom_bank3.bin rom_bank4.bin rom_bank5.bin $(CALC_ADDRESS)
	$(CALC_ADDRESS) -a 0x1000 -s arrival_n_data_zx02 rom_bank0.lst > level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s arrival_e_data_zx02 rom_bank0.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s clock_s_data_zx02 rom_bank0.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s clock_n_data_zx02 rom_bank0.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s hilltop_n_data_zx02 rom_bank0.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s hilltop_e_data_zx02 rom_bank0.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s hilltop_s_data_zx02 rom_bank0.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s hilltop_w_data_zx02 rom_bank0.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s imager_w_data_zx02 rom_bank0.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s rocket_n_data_zx02 rom_bank0.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s shortsteps_w_data_zx02 rom_bank1.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s dock_n_data_zx02 rom_bank1.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s library_n_data_zx02 rom_bank1.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s gear_n_data_zx02 rom_bank1.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s gear_s_data_zx02 rom_bank1.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s library_s_data_zx02 rom_bank1.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s arrival_s_data_zx02 rom_bank1.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s arrival_w_data_zx02 rom_bank1.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s hill_w_data_zx02 rom_bank1.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s dentist_n_data_zx02 rom_bank1.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s library_w_data_zx02 rom_bank2.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s library_e_data_zx02 rom_bank2.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s red_book_close_data_zx02 rom_bank2.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s blue_book_close_data_zx02 rom_bank2.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s steps_s_data_zx02 rom_bank2.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s clock_close_s_data_zx02 rom_bank2.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s rocket_close_n_data_zx02 rom_bank2.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s cabin_e_data_zx02 rom_bank2.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s shack_w_data_zx02 rom_bank2.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s pool_n_data_zx02 rom_bank2.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s shack_s_data_zx02 rom_bank3.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s cabin_path_s_data_zx02 rom_bank3.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s cabin_path_n_data_zx02 rom_bank3.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s library_se_data_zx02 rom_bank3.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s library_sw_data_zx02 rom_bank3.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s burnt_book_data_zx02 rom_bank3.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s imager_e_data_zx02 rom_bank3.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s behind_fireplace_data_zx02 rom_bank3.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s inside_fireplace_data_zx02 rom_bank3.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s dni_n_data_zx02 rom_bank4.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s dni_e_data_zx02 rom_bank4.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s atrus_e_data_zx02 rom_bank4.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s trapped_data_zx02 rom_bank4.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s dock_s_data_zx02 rom_bank4.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s dentist_e_data_zx02 rom_bank4.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s rocket_s_data_zx02 rom_bank4.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s pool_s_data_zx02 rom_bank4.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s you_win_data_zx02 rom_bank4.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s steps_e_data_zx02 rom_bank5.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s shack_n_data_zx02 rom_bank5.lst >> level_locations.inc
	$(CALC_ADDRESS) -a 0x1000 -s library_up_data_zx02 rom_bank5.lst >> level_locations.inc

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
	library_w_data.zx02 library_e_data.zx02 \
	red_book_close_data.zx02 blue_book_close_data.zx02 \
	steps_s_data.zx02 clock_close_s_data.zx02 \
	rocket_close_n_data.zx02 cabin_e_data.zx02 \
	shack_w_data.zx02 pool_n_data.zx02
	ca65 -o rom_bank2.o rom_bank2.s -l rom_bank2.lst

###

rom_bank3.bin:	rom_bank3.o
	ld65 -o rom_bank3.bin rom_bank3.o -C $(LINKER_SCRIPT)/atari2600_1000.inc

rom_bank3.o:	rom_bank3.s \
	shack_s_data.zx02 \
	cabin_path_s_data.zx02 cabin_path_n_data.zx02 \
	library_se_data.zx02 library_sw_data.zx02 \
	burnt_book_data.zx02 imager_e_data.zx02 \
	behind_fireplace_data.zx02 inside_fireplace_data.zx02
	ca65 -o rom_bank3.o rom_bank3.s -l rom_bank3.lst

###

rom_bank4.bin:	rom_bank4.o
	ld65 -o rom_bank4.bin rom_bank4.o -C $(LINKER_SCRIPT)/atari2600_1000.inc

rom_bank4.o:	rom_bank4.s \
	dni_n_data.zx02 dni_e_data.zx02 atrus_e_data.zx02 \
	trapped_data.zx02 dock_s_data.zx02 dentist_e_data.zx02 \
	rocket_s_data.zx02 pool_s_data.zx02 you_win_data.zx02
	ca65 -o rom_bank4.o rom_bank4.s -l rom_bank4.lst

###

rom_bank5.bin:	rom_bank5.o
	ld65 -o rom_bank5.bin rom_bank5.o -C $(LINKER_SCRIPT)/atari2600_1000.inc

rom_bank5.o:	rom_bank5.s \
	steps_e_data.zx02 shack_n_data.zx02 library_up_data.zx02
	ca65 -o rom_bank5.o rom_bank5.s -l rom_bank5.lst



###

cabin_e_data.inc:	cabin_e_bg.png cabin_e_overlay.png
	$(PNG2PF) -4 -n cabin_e -b 0x0 cabin_e_bg.png - > cabin_e_data.inc
	$(PNG2OVERLAY) -4 -o -n cabin_e cabin_e_overlay.png - >> cabin_e_data.inc

###

cabin_path_s_data.inc:	cabin_path_s_bg.png cabin_path_s_overlay.png
	$(PNG2PF) -4 -n cabin_path_s -b 0x0 cabin_path_s_bg.png - > cabin_path_s_data.inc
	$(PNG2OVERLAY) -4 -o -n cabin_path_s cabin_path_s_overlay.png - >> cabin_path_s_data.inc

###

cabin_path_n_data.inc:	cabin_path_n_bg.png cabin_path_n_overlay.png
	$(PNG2PF) -4 -n cabin_path_n -b 0xe2 cabin_path_n_bg.png - > cabin_path_n_data.inc
	$(PNG2OVERLAY) -4 -o -n cabin_path_n cabin_path_n_overlay.png - >> cabin_path_n_data.inc



###

clock_s_data.inc:	clock_s_bg.png clock_s_overlay.png
	$(PNG2PF) -4 -n clock_s -b 0xe0 clock_s_bg.png - > clock_s_data.inc
	$(PNG2OVERLAY) -4 -o -n clock_s clock_s_overlay.png - >> clock_s_data.inc

###

clock_n_data.inc:	clock_n_bg.png clock_n_overlay.png
	$(PNG2PF) -4 -n clock_n -b 0x00 clock_n_bg.png - > clock_n_data.inc
	$(PNG2OVERLAY) -4 -o -n clock_n clock_n_overlay.png - >> clock_n_data.inc

###

clock_close_s_data.inc:	clock_close_s_bg.png clock_close_s_overlay.png
	$(PNG2PF) -4 -n clock_close_s -b 0x02 clock_close_s_bg.png - > clock_close_s_data.inc
	$(PNG2OVERLAY) -4 -o -n clock_close_s clock_close_s_overlay.png - >> clock_close_s_data.inc

###

rocket_n_data.inc:	rocket_n_bg.png rocket_n_overlay.png
	$(PNG2PF) -4 -n rocket_n -b 0xf4 rocket_n_bg.png - > rocket_n_data.inc
	$(PNG2OVERLAY) -4 -o -n rocket_n rocket_n_overlay.png - >> rocket_n_data.inc

###

rocket_s_data.inc:	rocket_s_bg.png rocket_s_overlay.png
	$(PNG2PF) -4 -n rocket_s -b 0x02 rocket_s_bg.png - > rocket_s_data.inc
	$(PNG2OVERLAY) -4 -o -n rocket_s rocket_s_overlay.png - >> rocket_s_data.inc


###

rocket_close_n_data.inc:	rocket_close_n_bg.png rocket_close_n_overlay.png
	$(PNG2PF) -4 -n rocket_close_n -b 0x02 rocket_close_n_bg.png - > rocket_close_n_data.inc
	$(PNG2OVERLAY) -4 -o -n rocket_close_n rocket_close_n_overlay.png - >> rocket_close_n_data.inc


###

arrival_n_data.inc:	arrival_n_bg.png arrival_n_overlay.png
	$(PNG2PF) -4 -n arrival_n -b 0x00 arrival_n_bg.png - > arrival_n_data.inc
	$(PNG2OVERLAY) -4 -o -n arrival_n arrival_n_overlay.png - >> arrival_n_data.inc

###

arrival_s_data.inc:	arrival_s_bg.png arrival_s_overlay.png
	$(PNG2PF) -4 -n arrival_s -b 0x02 arrival_s_bg.png - > arrival_s_data.inc
	$(PNG2OVERLAY) -4 -o -n arrival_s arrival_s_overlay.png - >> arrival_s_data.inc

###

arrival_e_data.inc:	arrival_e_bg.png arrival_e_overlay.png
	$(PNG2PF) -4 -n arrival -b 0x00 arrival_e_bg.png - > arrival_e_data.inc
	$(PNG2OVERLAY) -4 -o -n arrival_e arrival_e_overlay.png - >> arrival_e_data.inc

###

arrival_w_data.inc:	arrival_w_bg.png arrival_w_overlay.png
	$(PNG2PF) -4 -n arrival -b 0x02 arrival_w_bg.png - > arrival_w_data.inc
	$(PNG2OVERLAY) -4 -o -n arrival_w arrival_w_overlay.png - >> arrival_w_data.inc

###

dentist_n_data.inc:	dentist_n_bg.png dentist_n_overlay.png
	$(PNG2PF) -4 -n dentist_n -b 0x02 dentist_n_bg.png - > dentist_n_data.inc
	$(PNG2OVERLAY) -4 -o -n dentist_n dentist_n_overlay.png - >> dentist_n_data.inc

###

dentist_e_data.inc:	dentist_e_bg.png dentist_e_overlay.png
	$(PNG2PF) -4 -n dentist_e -b 0x02 dentist_e_bg.png - > dentist_e_data.inc
	$(PNG2OVERLAY) -4 -o -n dentist_e dentist_e_overlay.png - >> dentist_e_data.inc

###

hilltop_w_data.inc:	hilltop_w_bg.png hilltop_w_overlay.png
	$(PNG2PF) -4 -n hilltop_w -b 0x00 hilltop_w_bg.png - > hilltop_w_data.inc
	$(PNG2OVERLAY) -4 -o -n hilltop_w hilltop_w_overlay.png - >> hilltop_w_data.inc

###

hilltop_e_data.inc:	hilltop_e_bg.png hilltop_e_overlay.png
	$(PNG2PF) -4 -n hilltop_e -b 0xe0 hilltop_e_bg.png - > hilltop_e_data.inc
	$(PNG2OVERLAY) -4 -o -n hilltop_e hilltop_e_overlay.png - >> hilltop_e_data.inc


###

hilltop_s_data.inc:	hilltop_s_bg.png hilltop_s_overlay.png
	$(PNG2PF) -4 -n hilltop_s -b 0xE0 hilltop_s_bg.png - > hilltop_s_data.inc
	$(PNG2OVERLAY) -4 -o -n hilltop_s hilltop_s_overlay.png - >> hilltop_s_data.inc

###

hilltop_n_data.inc:	hilltop_n_bg.png hilltop_n_overlay.png
	$(PNG2PF) -4 -n hilltop_n -b 0x02 hilltop_n_bg.png - > hilltop_n_data.inc
	$(PNG2OVERLAY) -4 -o -n hilltop_n hilltop_n_overlay.png - >> hilltop_n_data.inc

###

hill_w_data.inc:	hill_w_bg.png hill_w_overlay.png
	$(PNG2PF) -4 -n hill_w -b 0x02 hill_w_bg.png - > hill_w_data.inc
	$(PNG2OVERLAY) -4 -o -n hill_w hill_w_overlay.png - >> hill_w_data.inc


###

imager_w_data.inc:	imager_w_bg.png imager_w_overlay.png
	$(PNG2PF) -4 -n imager_w -b 0x00 imager_w_bg.png - > imager_w_data.inc
	$(PNG2OVERLAY) -4 -o -n imager_w imager_w_overlay.png - >> imager_w_data.inc

###

imager_e_data.inc:	imager_e_bg.png imager_e_overlay.png
	$(PNG2PF) -n imager_e -b 0x00 imager_e_bg.png - > imager_e_data.inc
	$(PNG2OVERLAY) -o -n imager_e imager_e_overlay.png - >> imager_e_data.inc

###

shortsteps_w_data.inc:	shortsteps_w_bg.png shortsteps_w_overlay.png
	$(PNG2PF) -4 -n shortsteps_w -b 0x00 shortsteps_w_bg.png - > shortsteps_w_data.inc
	$(PNG2OVERLAY) -4 -o -n shortsteps_w shortsteps_w_overlay.png - >> shortsteps_w_data.inc

###

dock_n_data.inc:	dock_n_bg.png dock_n_overlay.png
	$(PNG2PF) -4 -n dock_n -b 0x00 dock_n_bg.png - > dock_n_data.inc
	$(PNG2OVERLAY) -4 -o -n dock_n dock_n_overlay.png - >> dock_n_data.inc

###

dock_s_data.inc:	dock_s_bg.png dock_s_overlay.png
	$(PNG2PF) -4 -n dock_s -b 0x02 dock_s_bg.png - > dock_s_data.inc
	$(PNG2OVERLAY) -4 -o -n dock_s dock_s_overlay.png - >> dock_s_data.inc


###

shack_w_data.inc:	shack_w_bg.png shack_w_overlay.png
	$(PNG2PF) -4 -n shack_w -b 0xe0 shack_w_bg.png - > shack_w_data.inc
	$(PNG2OVERLAY) -4 -o -n shack_w shack_w_overlay.png - >> shack_w_data.inc

###

shack_s_data.inc:	shack_s_bg.png shack_s_overlay.png
	$(PNG2PF) -4 -n shack_s -b 0xd0 shack_s_bg.png - > shack_s_data.inc
	$(PNG2OVERLAY) -4 -o -n shack_s shack_s_overlay.png - >> shack_s_data.inc

###

shack_n_data.inc:	shack_n_bg.png shack_n_overlay.png
	$(PNG2PF) -4 -n shack_n -b 0x02 shack_n_bg.png - > shack_n_data.inc
	$(PNG2OVERLAY) -4 -o -n shack_n shack_n_overlay.png - >> shack_n_data.inc



###

burnt_book_data.inc:	burnt_book_bg.png blank_overlay.png
	$(PNG2PF) -n burnt_book -b 0x00 burnt_book_bg.png - > burnt_book_data.inc
	$(PNG2OVERLAY) -o -n burnt_book blank_overlay.png - >> burnt_book_data.inc

###

trapped_data.inc:	trapped_bg.png blank_overlay.png
	$(PNG2PF) -n trapped -b 0x00 trapped_bg.png - > trapped_data.inc
	$(PNG2OVERLAY) -o -n trapped blank_overlay.png - >> trapped_data.inc

###

you_win_data.inc:	you_win_bg.png blank_overlay.png
	$(PNG2PF) -n you_win -b 0x00 you_win_bg.png - > you_win_data.inc
	$(PNG2OVERLAY) -o -n you_win blank_overlay.png - >> you_win_data.inc

###

library_n_data.inc:	library_n_bg.png library_n_overlay.png
	$(PNG2PF) -4 -n library_n -b 0x00 library_n_bg.png - > library_n_data.inc
	$(PNG2OVERLAY) -4 -o -n library_n library_n_overlay.png - >> library_n_data.inc

###

library_up_data.inc:	library_up_bg.png library_up_overlay.png
	$(PNG2PF) -4 -n library_up -b 0xFE library_up_bg.png - > library_up_data.inc
	$(PNG2OVERLAY) -4 -o -n library_up library_up_overlay.png - >> library_up_data.inc


###

library_s_data.inc:	library_s_bg.png library_s_overlay.png
	$(PNG2PF) -4 -n library_s -b 0x00 library_s_bg.png - > library_s_data.inc
	$(PNG2OVERLAY) -4 -o -n library_s library_s_overlay.png - >> library_s_data.inc

###

library_sw_data.inc:	library_sw_bg.png library_sw_overlay.png
	$(PNG2PF) -4 -n library_sw -b 0x00 library_sw_bg.png - > library_sw_data.inc
	$(PNG2OVERLAY) -4 -o -n library_sw library_sw_overlay.png - >> library_sw_data.inc

###

library_se_data.inc:	library_se_bg.png library_se_overlay.png
	$(PNG2PF) -4 -n library_se -b 0x00 library_se_bg.png - > library_se_data.inc
	$(PNG2OVERLAY) -4 -o -n library_se library_se_overlay.png - >> library_se_data.inc

###

library_w_data.inc:	library_w_bg.png library_w_overlay.png
	$(PNG2PF) -4 -n library_w -b 0x00 library_w_bg.png - > library_w_data.inc
	$(PNG2OVERLAY) -4 -o -n library_w library_w_overlay.png - >> library_w_data.inc

###

library_e_data.inc:	library_e_bg.png library_e_overlay.png
	$(PNG2PF) -4 -n library_e -b 0x00 library_e_bg.png - > library_e_data.inc
	$(PNG2OVERLAY) -4 -o -n library_e library_e_overlay.png - >> library_e_data.inc

###

behind_fireplace_data.inc:	behind_fireplace_bg.png behind_fireplace_overlay.png
	$(PNG2PF) -n behind_fireplace -b 0x00 behind_fireplace_bg.png - > behind_fireplace_data.inc
	$(PNG2OVERLAY) -o -n behind_fireplace behind_fireplace_overlay.png - >> behind_fireplace_data.inc

###

dni_n_data.inc:	dni_n_bg.png dni_n_overlay.png
	$(PNG2PF) -n dni_n -b 0x00 dni_n_bg.png - > dni_n_data.inc
	$(PNG2OVERLAY) -o -n dni_n dni_n_overlay.png - >> dni_n_data.inc

###

dni_e_data.inc:	dni_e_bg.png dni_e_overlay.png
	$(PNG2PF) -n dni_e -b 0x00 dni_e_bg.png - > dni_e_data.inc
	$(PNG2OVERLAY) -o -n dni_e dni_e_overlay.png - >> dni_e_data.inc

###

atrus_e_data.inc:	atrus_e_bg.png atrus_e_overlay.png
	$(PNG2PF) -n atrus_e -b 0x00 atrus_e_bg.png - > atrus_e_data.inc
	$(PNG2OVERLAY) -o -n atrus_e atrus_e_overlay.png - >> atrus_e_data.inc



###

inside_fireplace_data.inc:	inside_fireplace_bg.png inside_fireplace_overlay.png
	$(PNG2PF) -n inside_fireplace -b 0x00 inside_fireplace_bg.png - > inside_fireplace_data.inc
	$(PNG2OVERLAY) -o -n inside_fireplace inside_fireplace_overlay.png - >> inside_fireplace_data.inc




###

red_book_close_data.inc:	red_book_close_bg.png red_book_close_overlay.png
	$(PNG2PF) -4 -n red_book_close -b 0x00 red_book_close_bg.png - > red_book_close_data.inc
	$(PNG2OVERLAY) -4 -o -n red_book_close red_book_close_overlay.png - >> red_book_close_data.inc

###

blue_book_close_data.inc:	blue_book_close_bg.png blue_book_close_overlay.png
	$(PNG2PF) -4 -n blue_book_close -b 0x00 blue_book_close_bg.png - > blue_book_close_data.inc
	$(PNG2OVERLAY) -4 -o -n blue_book_close blue_book_close_overlay.png - >> blue_book_close_data.inc

###

gear_n_data.inc:	gear_n_bg.png gear_n_overlay.png
	$(PNG2PF) -4 -n gear_n -b 0x02 gear_n_bg.png - > gear_n_data.inc
	$(PNG2OVERLAY) -4 -o -n gear_n gear_n_overlay.png - >> gear_n_data.inc

###

gear_s_data.inc:	gear_s_bg.png gear_s_overlay.png
	$(PNG2PF) -4 -n gear_s -b 0x02 gear_s_bg.png - > gear_s_data.inc
	$(PNG2OVERLAY) -4 -o -n gear_s gear_s_overlay.png - >> gear_s_data.inc

###

pool_n_data.inc:	pool_n_bg.png pool_n_overlay.png
	$(PNG2PF) -4 -n pool_n -b 0x02 pool_n_bg.png - > pool_n_data.inc
	$(PNG2OVERLAY) -4 -o -n pool_n pool_n_overlay.png - >> pool_n_data.inc

###

pool_s_data.inc:	pool_s_bg.png pool_s_overlay.png
	$(PNG2PF) -4 -n pool_s -b 0x0e pool_s_bg.png - > pool_s_data.inc
	$(PNG2OVERLAY) -4 -o -n pool_s pool_s_overlay.png - >> pool_s_data.inc



###

steps_s_data.inc:	steps_s_bg.png steps_s_overlay.png
	$(PNG2PF) -4 -n steps_s -b 0x02 steps_s_bg.png - > steps_s_data.inc
	$(PNG2OVERLAY) -4 -o -n steps_s steps_s_overlay.png - >> steps_s_data.inc

###

steps_e_data.inc:	steps_e_bg.png steps_e_overlay.png
	$(PNG2PF) -4 -n steps_e -b 0x28 steps_e_bg.png - > steps_e_data.inc
	$(PNG2OVERLAY) -4 -o -n steps_e steps_e_overlay.png - >> steps_e_data.inc






###

cabin_e_data.zx02:	cabin_e_data.bin
	$(ZX02) -f cabin_e_data.bin cabin_e_data.zx02

cabin_e_data.bin:	cabin_e_data.o
	ld65 -o cabin_e_data.bin cabin_e_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

cabin_e_data.o:	cabin_e_data.s cabin_e_data.inc
	ca65 -o cabin_e_data.o cabin_e_data.s -l cabin_e_data.lst

###

cabin_path_s_data.zx02:	cabin_path_s_data.bin
	$(ZX02) -f cabin_path_s_data.bin cabin_path_s_data.zx02

cabin_path_s_data.bin:	cabin_path_s_data.o
	ld65 -o cabin_path_s_data.bin cabin_path_s_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

cabin_path_s_data.o:	cabin_path_s_data.s cabin_path_s_data.inc
	ca65 -o cabin_path_s_data.o cabin_path_s_data.s -l cabin_path_s_data.lst

###

cabin_path_n_data.zx02:	cabin_path_n_data.bin
	$(ZX02) -f cabin_path_n_data.bin cabin_path_n_data.zx02

cabin_path_n_data.bin:	cabin_path_n_data.o
	ld65 -o cabin_path_n_data.bin cabin_path_n_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

cabin_path_n_data.o:	cabin_path_n_data.s cabin_path_n_data.inc
	ca65 -o cabin_path_n_data.o cabin_path_n_data.s -l cabin_path_n_data.lst



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

clock_close_s_data.zx02:	clock_close_s_data.bin
	$(ZX02) -f clock_close_s_data.bin clock_close_s_data.zx02

clock_close_s_data.bin:	clock_close_s_data.o
	ld65 -o clock_close_s_data.bin clock_close_s_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

clock_close_s_data.o:	clock_close_s_data.s clock_close_s_data.inc
	ca65 -o clock_close_s_data.o clock_close_s_data.s -l clock_close_s_data.lst


###

rocket_n_data.zx02:	rocket_n_data.bin
	$(ZX02) -f rocket_n_data.bin rocket_n_data.zx02

rocket_n_data.bin:	rocket_n_data.o
	ld65 -o rocket_n_data.bin rocket_n_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

rocket_n_data.o:	rocket_n_data.s rocket_n_data.inc
	ca65 -o rocket_n_data.o rocket_n_data.s -l rocket_n_data.lst

###

rocket_s_data.zx02:	rocket_s_data.bin
	$(ZX02) -f rocket_s_data.bin rocket_s_data.zx02

rocket_s_data.bin:	rocket_s_data.o
	ld65 -o rocket_s_data.bin rocket_s_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

rocket_s_data.o:	rocket_s_data.s rocket_s_data.inc
	ca65 -o rocket_s_data.o rocket_s_data.s -l rocket_s_data.lst


###

rocket_close_n_data.zx02:	rocket_close_n_data.bin
	$(ZX02) -f rocket_close_n_data.bin rocket_close_n_data.zx02

rocket_close_n_data.bin:	rocket_close_n_data.o
	ld65 -o rocket_close_n_data.bin rocket_close_n_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

rocket_close_n_data.o:	rocket_close_n_data.s rocket_close_n_data.inc
	ca65 -o rocket_close_n_data.o rocket_close_n_data.s -l rocket_close_n_data.lst


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

dentist_e_data.zx02:	dentist_e_data.bin
	$(ZX02) -f dentist_e_data.bin dentist_e_data.zx02

dentist_e_data.bin:	dentist_e_data.o
	ld65 -o dentist_e_data.bin dentist_e_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

dentist_e_data.o:	dentist_e_data.s dentist_e_data.inc
	ca65 -o dentist_e_data.o dentist_e_data.s -l dentist_e_data.lst





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

imager_e_data.zx02:	imager_e_data.bin
	$(ZX02) -f imager_e_data.bin imager_e_data.zx02

imager_e_data.bin:	imager_e_data.o
	ld65 -o imager_e_data.bin imager_e_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

imager_e_data.o:	imager_e_data.s imager_e_data.inc
	ca65 -o imager_e_data.o imager_e_data.s -l imager_e_data.lst



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

dock_s_data.zx02:	dock_s_data.bin
	$(ZX02) -f dock_s_data.bin dock_s_data.zx02

dock_s_data.bin:	dock_s_data.o
	ld65 -o dock_s_data.bin dock_s_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

dock_s_data.o:	dock_s_data.s dock_s_data.inc
	ca65 -o dock_s_data.o dock_s_data.s -l dock_s_data.lst


###

shack_w_data.zx02:	shack_w_data.bin
	$(ZX02) -f shack_w_data.bin shack_w_data.zx02

shack_w_data.bin:	shack_w_data.o
	ld65 -o shack_w_data.bin shack_w_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

shack_w_data.o:	shack_w_data.s shack_w_data.inc
	ca65 -o shack_w_data.o shack_w_data.s -l shack_w_data.lst

###

shack_s_data.zx02:	shack_s_data.bin
	$(ZX02) -f shack_s_data.bin shack_s_data.zx02

shack_s_data.bin:	shack_s_data.o
	ld65 -o shack_s_data.bin shack_s_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

shack_s_data.o:	shack_s_data.s shack_s_data.inc
	ca65 -o shack_s_data.o shack_s_data.s -l shack_s_data.lst

###

shack_n_data.zx02:	shack_n_data.bin
	$(ZX02) -f shack_n_data.bin shack_n_data.zx02

shack_n_data.bin:	shack_n_data.o
	ld65 -o shack_n_data.bin shack_n_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

shack_n_data.o:	shack_n_data.s shack_n_data.inc
	ca65 -o shack_n_data.o shack_n_data.s -l shack_n_data.lst



###

burnt_book_data.zx02:	burnt_book_data.bin
	$(ZX02) -f burnt_book_data.bin burnt_book_data.zx02

burnt_book_data.bin:	burnt_book_data.o
	ld65 -o burnt_book_data.bin burnt_book_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

burnt_book_data.o:	burnt_book_data.s burnt_book_data.inc
	ca65 -o burnt_book_data.o burnt_book_data.s -l burnt_book_data.lst

###

trapped_data.zx02:	trapped_data.bin
	$(ZX02) -f trapped_data.bin trapped_data.zx02

trapped_data.bin:	trapped_data.o
	ld65 -o trapped_data.bin trapped_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

trapped_data.o:	trapped_data.s trapped_data.inc
	ca65 -o trapped_data.o trapped_data.s -l trapped_data.lst

###

you_win_data.zx02:	you_win_data.bin
	$(ZX02) -f you_win_data.bin you_win_data.zx02

you_win_data.bin:	you_win_data.o
	ld65 -o you_win_data.bin you_win_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

you_win_data.o:	you_win_data.s you_win_data.inc
	ca65 -o you_win_data.o you_win_data.s -l you_win_data.lst



###

library_n_data.zx02:	library_n_data.bin
	$(ZX02) -f library_n_data.bin library_n_data.zx02

library_n_data.bin:	library_n_data.o
	ld65 -o library_n_data.bin library_n_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

library_n_data.o:	library_n_data.s library_n_data.inc
	ca65 -o library_n_data.o library_n_data.s -l library_n_data.lst

###

library_up_data.zx02:	library_up_data.bin
	$(ZX02) -f library_up_data.bin library_up_data.zx02

library_up_data.bin:	library_up_data.o
	ld65 -o library_up_data.bin library_up_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

library_up_data.o:	library_up_data.s library_up_data.inc
	ca65 -o library_up_data.o library_up_data.s -l library_up_data.lst


###

library_s_data.zx02:	library_s_data.bin
	$(ZX02) -f library_s_data.bin library_s_data.zx02

library_s_data.bin:	library_s_data.o
	ld65 -o library_s_data.bin library_s_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

library_s_data.o:	library_s_data.s library_s_data.inc
	ca65 -o library_s_data.o library_s_data.s -l library_s_data.lst

###

library_se_data.zx02:	library_se_data.bin
	$(ZX02) -f library_se_data.bin library_se_data.zx02

library_se_data.bin:	library_se_data.o
	ld65 -o library_se_data.bin library_se_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

library_se_data.o:	library_se_data.s library_se_data.inc
	ca65 -o library_se_data.o library_se_data.s -l library_se_data.lst

###

library_sw_data.zx02:	library_sw_data.bin
	$(ZX02) -f library_sw_data.bin library_sw_data.zx02

library_sw_data.bin:	library_sw_data.o
	ld65 -o library_sw_data.bin library_sw_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

library_sw_data.o:	library_sw_data.s library_sw_data.inc
	ca65 -o library_sw_data.o library_sw_data.s -l library_sw_data.lst


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

behind_fireplace_data.zx02:	behind_fireplace_data.bin
	$(ZX02) -f behind_fireplace_data.bin behind_fireplace_data.zx02

behind_fireplace_data.bin:	behind_fireplace_data.o
	ld65 -o behind_fireplace_data.bin behind_fireplace_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

behind_fireplace_data.o:	behind_fireplace_data.s behind_fireplace_data.inc
	ca65 -o behind_fireplace_data.o behind_fireplace_data.s -l behind_fireplace_data.lst

###

dni_n_data.zx02:	dni_n_data.bin
	$(ZX02) -f dni_n_data.bin dni_n_data.zx02

dni_n_data.bin:	dni_n_data.o
	ld65 -o dni_n_data.bin dni_n_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

dni_n_data.o:	dni_n_data.s dni_n_data.inc
	ca65 -o dni_n_data.o dni_n_data.s -l dni_n_data.lst

###

dni_e_data.zx02:	dni_e_data.bin
	$(ZX02) -f dni_e_data.bin dni_e_data.zx02

dni_e_data.bin:	dni_e_data.o
	ld65 -o dni_e_data.bin dni_e_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

dni_e_data.o:	dni_e_data.s dni_e_data.inc
	ca65 -o dni_e_data.o dni_e_data.s -l dni_e_data.lst

###

atrus_e_data.zx02:	atrus_e_data.bin
	$(ZX02) -f atrus_e_data.bin atrus_e_data.zx02

atrus_e_data.bin:	atrus_e_data.o
	ld65 -o atrus_e_data.bin atrus_e_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

atrus_e_data.o:	atrus_e_data.s atrus_e_data.inc
	ca65 -o atrus_e_data.o atrus_e_data.s -l atrus_e_data.lst




###

inside_fireplace_data.zx02:	inside_fireplace_data.bin
	$(ZX02) -f inside_fireplace_data.bin inside_fireplace_data.zx02

inside_fireplace_data.bin:	inside_fireplace_data.o
	ld65 -o inside_fireplace_data.bin inside_fireplace_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

inside_fireplace_data.o:	inside_fireplace_data.s inside_fireplace_data.inc
	ca65 -o inside_fireplace_data.o inside_fireplace_data.s -l inside_fireplace_data.lst



###

red_book_close_data.zx02:	red_book_close_data.bin
	$(ZX02) -f red_book_close_data.bin red_book_close_data.zx02

red_book_close_data.bin:	red_book_close_data.o
	ld65 -o red_book_close_data.bin red_book_close_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

red_book_close_data.o:	red_book_close_data.s red_book_close_data.inc
	ca65 -o red_book_close_data.o red_book_close_data.s -l red_book_close_data.lst

###

blue_book_close_data.zx02:	blue_book_close_data.bin
	$(ZX02) -f blue_book_close_data.bin blue_book_close_data.zx02

blue_book_close_data.bin:	blue_book_close_data.o
	ld65 -o blue_book_close_data.bin blue_book_close_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

blue_book_close_data.o:	blue_book_close_data.s blue_book_close_data.inc
	ca65 -o blue_book_close_data.o blue_book_close_data.s -l blue_book_close_data.lst


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

###

pool_n_data.zx02:	pool_n_data.bin
	$(ZX02) -f pool_n_data.bin pool_n_data.zx02

pool_n_data.bin:	pool_n_data.o
	ld65 -o pool_n_data.bin pool_n_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

pool_n_data.o:	pool_n_data.s pool_n_data.inc
	ca65 -o pool_n_data.o pool_n_data.s -l pool_n_data.lst

###

pool_s_data.zx02:	pool_s_data.bin
	$(ZX02) -f pool_s_data.bin pool_s_data.zx02

pool_s_data.bin:	pool_s_data.o
	ld65 -o pool_s_data.bin pool_s_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

pool_s_data.o:	pool_s_data.s pool_s_data.inc
	ca65 -o pool_s_data.o pool_s_data.s -l pool_s_data.lst



###

steps_s_data.zx02:	steps_s_data.bin
	$(ZX02) -f steps_s_data.bin steps_s_data.zx02

steps_s_data.bin:	steps_s_data.o
	ld65 -o steps_s_data.bin steps_s_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

steps_s_data.o:	steps_s_data.s steps_s_data.inc
	ca65 -o steps_s_data.o steps_s_data.s -l steps_s_data.lst

###

steps_e_data.zx02:	steps_e_data.bin
	$(ZX02) -f steps_e_data.bin steps_e_data.zx02

steps_e_data.bin:	steps_e_data.o
	ld65 -o steps_e_data.bin steps_e_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

steps_e_data.o:	steps_e_data.s steps_e_data.inc
	ca65 -o steps_e_data.o steps_e_data.s -l steps_e_data.lst






####

clean:	
	rm -f *~ *.zx02 *.lst *.inc *.bin
