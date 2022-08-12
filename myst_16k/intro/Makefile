ZX02 = ~/research/6502_compression/zx02.git/build/zx02
LINKER_SCRIPT = ../../linker_script/
PNG2PF = ../../utils/png2pf
PNG2OVERLAY = ../../utils/png2overlay
CALC_ADDRESS = ../utils/calc_address

all:	rom_bank6.bin

# rom_bank6_routines.inc

###

#rom_bank6_routines.inc:	rom_bank6.bin
#	$(CALC_ADDRESS) -a 0x1000 -s do_intro rom_bank6.lst > rom_bank6_routines.inc
#	$(CALC_ADDRESS) -a 0x1000 -s book_common rom_bank6.lst >> rom_bank6_routines.inc

###

rom_bank6.bin:	rom_bank6.o
	ld65 -o rom_bank6.bin rom_bank6.o -C $(LINKER_SCRIPT)/atari2600_1000.inc

###

rom_bank6.o:	rom_bank6.s \
	title.s cleft.s book.s \
	myst_book_data.zx02 \
	red_book_data.zx02 \
	green_book_data.zx02 \
	blue_book_data.zx02 \
	../zp.inc ../../vcs.inc
	ca65 -o rom_bank6.o rom_bank6.s -l rom_bank6.lst

###

myst_book_data.zx02:	myst_book_data.bin
	$(ZX02) -f myst_book_data.bin myst_book_data.zx02

myst_book_data.bin:	myst_book_data.o
	ld65 -o myst_book_data.bin myst_book_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

myst_book_data.o:	myst_book_data.inc
	ca65 -o myst_book_data.o myst_book_data.inc

myst_book_data.inc:	myst_book_edge.png \
		myst_book_overlay1.png \
		myst_book_overlay2.png
	$(PNG2OVERLAY) -4 -c -n myst myst_book_edge.png - > myst_book_data.inc
	$(PNG2OVERLAY) -4 -n myst_overlay1 myst_book_overlay1.png - >> myst_book_data.inc
	$(PNG2OVERLAY) -4 -n myst_overlay2 myst_book_overlay2.png - >> myst_book_data.inc


###

red_book_data.zx02:	red_book_data.bin
	$(ZX02) -f red_book_data.bin red_book_data.zx02

red_book_data.bin:	red_book_data.o
	ld65 -o red_book_data.bin red_book_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

red_book_data.o:	red_book_data.inc
	ca65 -o red_book_data.o red_book_data.inc

red_book_data.inc:	red_book_edge.png
	$(PNG2OVERLAY) -4 -c -n red red_book_edge.png - > red_book_data.inc

###

green_book_data.zx02:	green_book_data.bin
	$(ZX02) -f green_book_data.bin green_book_data.zx02

green_book_data.bin:	green_book_data.o
	ld65 -o green_book_data.bin green_book_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

green_book_data.o:	green_book_data.inc
	ca65 -o green_book_data.o green_book_data.inc

green_book_data.inc:	green_book_edge.png
	$(PNG2OVERLAY) -4 -c -n green green_book_edge.png - > green_book_data.inc

###

blue_book_data.zx02:	blue_book_data.bin
	$(ZX02) -f blue_book_data.bin blue_book_data.zx02

blue_book_data.bin:	blue_book_data.o
	ld65 -o blue_book_data.bin blue_book_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

blue_book_data.o:	blue_book_data.inc
	ca65 -o blue_book_data.o blue_book_data.inc

blue_book_data.inc:	blue_book_edge.png
	$(PNG2OVERLAY) -4 -c -n blue blue_book_edge.png - > blue_book_data.inc


###

clean:	
	rm -f *~ *.zx02 *.lst rom_bank6_routines.inc *.o *.bin

