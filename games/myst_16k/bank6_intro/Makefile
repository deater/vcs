ZX02 = ~/research/6502_compression/zx02.git/build/zx02
LINKER_SCRIPT = ../../../linker_script/
PNG2PF = ../../../utils/png2pf
PNG2OVERLAY = ../../../utils/png2overlay
CALC_ADDRESS = ../utils/calc_address

all:	rom_bank6.bin

###

rom_bank6.bin:	rom_bank6.o
	ld65 -o rom_bank6.bin rom_bank6.o -C $(LINKER_SCRIPT)/atari2600_1000.inc

###

rom_bank6.o:	rom_bank6.s \
	title.s cleft.s book.s \
	../sound_update.s \
	../pointer_update.s \
	myst_book_data.zx02 \
	red_book_data.zx02 \
	red_book_data2.zx02 \
	green_book_data.zx02 \
	blue_book_data.zx02 \
	blue_book_data2.zx02 \
	intro_data.inc ../zp.inc ../../../vcs.inc
	ca65 -o rom_bank6.o rom_bank6.s -l rom_bank6.lst

###

myst_book_data.zx02:	myst_book_data.bin
	$(ZX02) -f myst_book_data.bin myst_book_data.zx02

myst_book_data.bin:	myst_book_data.o
	ld65 -o myst_book_data.bin myst_book_data.o -C $(LINKER_SCRIPT)/atari2600_f000_noirq.inc

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
	ld65 -o red_book_data.bin red_book_data.o -C $(LINKER_SCRIPT)/atari2600_f000_noirq.inc

red_book_data.o:	red_book_data.inc
	ca65 -o red_book_data.o red_book_data.inc

red_book_data.inc:	red_book_edge.png \
	red_book_overlay1.png \
	red_book_overlay3.png
	$(PNG2OVERLAY) -4 -c -n red red_book_edge.png - > red_book_data.inc
	$(PNG2OVERLAY) -4 -n red_overlay1 red_book_overlay1.png - >> red_book_data.inc
	$(PNG2OVERLAY) -4 -n red_overlay3 red_book_overlay3.png - >> red_book_data.inc

####

red_book_data2.zx02:	red_book_data2.bin
	$(ZX02) -f red_book_data2.bin red_book_data2.zx02

red_book_data2.bin:	red_book_data2.o
	ld65 -o red_book_data2.bin red_book_data2.o -C $(LINKER_SCRIPT)/atari2600_f000_noirq.inc

red_book_data2.o:	red_book_data2.inc
	ca65 -o red_book_data2.o red_book_data2.inc

red_book_data2.inc:	red_book_edge.png \
	red_book_overlay1.png \
	red_book_overlay4.png
	$(PNG2OVERLAY) -4 -c -n red red_book_edge.png - > red_book_data2.inc
	$(PNG2OVERLAY) -4 -n red_overlay1 red_book_overlay1.png - >> red_book_data2.inc
	$(PNG2OVERLAY) -4 -n red_overlay4 red_book_overlay4.png - >> red_book_data2.inc



###

green_book_data.zx02:	green_book_data.bin
	$(ZX02) -f green_book_data.bin green_book_data.zx02

green_book_data.bin:	green_book_data.o
	ld65 -o green_book_data.bin green_book_data.o -C $(LINKER_SCRIPT)/atari2600_f000_noirq.inc

green_book_data.o:	green_book_data.inc
	ca65 -o green_book_data.o green_book_data.inc

green_book_data.inc:	green_book_edge.png green_book_overlay1.png green_book_overlay2.png
	$(PNG2OVERLAY) -4 -c -n green green_book_edge.png - > green_book_data.inc
	$(PNG2OVERLAY) -4 -n green_overlay1 green_book_overlay1.png - >> green_book_data.inc
	$(PNG2OVERLAY) -4 -n green_overlay2 green_book_overlay2.png - >> green_book_data.inc

###

blue_book_data.zx02:	blue_book_data.bin
	$(ZX02) -f blue_book_data.bin blue_book_data.zx02

blue_book_data.bin:	blue_book_data.o
	ld65 -o blue_book_data.bin blue_book_data.o -C $(LINKER_SCRIPT)/atari2600_f000_noirq.inc

blue_book_data.o:	blue_book_data.inc
	ca65 -o blue_book_data.o blue_book_data.inc

blue_book_data.inc:	blue_book_edge.png \
	blue_book_overlay1.png \
	blue_book_overlay3.png
	$(PNG2OVERLAY) -4 -c -n blue blue_book_edge.png - > blue_book_data.inc
	$(PNG2OVERLAY) -4 -n blue_overlay1 blue_book_overlay1.png - >> blue_book_data.inc
	$(PNG2OVERLAY) -4 -n blue_overlay3 blue_book_overlay3.png - >> blue_book_data.inc

###

blue_book_data2.zx02:	blue_book_data2.bin
	$(ZX02) -f blue_book_data2.bin blue_book_data2.zx02

blue_book_data2.bin:	blue_book_data2.o
	ld65 -o blue_book_data2.bin blue_book_data2.o -C $(LINKER_SCRIPT)/atari2600_f000_noirq.inc

blue_book_data2.o:	blue_book_data2.inc
	ca65 -o blue_book_data2.o blue_book_data2.inc

blue_book_data2.inc:	blue_book_edge.png \
	blue_book_overlay1.png \
	blue_book_overlay4.png
	$(PNG2OVERLAY) -4 -c -n blue blue_book_edge.png - > blue_book_data2.inc
	$(PNG2OVERLAY) -4 -n blue_overlay1 blue_book_overlay1.png - >> blue_book_data2.inc
	$(PNG2OVERLAY) -4 -n blue_overlay4 blue_book_overlay4.png - >> blue_book_data2.inc



###

clean:	
	rm -f *~ *.zx02 *.lst rom_bank6_routines.inc *.o *.bin \
		red_book_data.inc blue_book_data.inc \
		red_book_data2.inc blue_book_data2.inc \
		green_book_data.inc myst_book_data.inc

