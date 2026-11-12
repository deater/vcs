LINKER_SCRIPT = ../../../../linker_script
CALC_ADDRESS = ../../../utils/calc_address
PNG2PF = ../../../../utils/png2pf
PNG2SPRITE = ../../../../utils/png2sprite
ZX02 = ~/research/6502_compression/zx02.git/build/zx02

all:	irix_pf.inc \
	teapot0.inc teapot1.inc teapot2.inc teapot3.inc \
	teapot4.inc teapot5.inc teapot6.inc teapot7.inc \
	teapot_big.zx02 teapot_low.zx02 teapot_high.zx02 \
	teapot_half.zx02

#####

teapot_big.zx02:	teapot_big.bin
	$(ZX02) -f teapot_big.bin teapot_big.zx02


teapot_big.bin:	teapot_big.o
	ld65 -o teapot_big.bin teapot_big.o -C $(LINKER_SCRIPT)/atari2600_1000.inc


teapot_big.o: teapot_big.s \
	teapot0.inc teapot1.inc teapot2.inc teapot3.inc \
	teapot4.inc teapot5.inc teapot6.inc teapot7.inc
	ca65 -o teapot_big.o teapot_big.s -l teapot_big.lst

#####

teapot_low.zx02:	teapot_low.bin
	$(ZX02) -f teapot_low.bin teapot_low.zx02

teapot_low.bin:	teapot_low.o
	ld65 -o teapot_low.bin teapot_low.o -C $(LINKER_SCRIPT)/atari2600_1000.inc


teapot_low.o: teapot_low.s \
	teapot0.inc teapot1.inc teapot2.inc teapot3.inc
	ca65 -o teapot_low.o teapot_low.s -l teapot_low.lst

#####

teapot_high.zx02:	teapot_high.bin
	$(ZX02) -f teapot_high.bin teapot_high.zx02

teapot_high.bin:	teapot_high.o
	ld65 -o teapot_high.bin teapot_high.o -C $(LINKER_SCRIPT)/atari2600_f000_noirq.inc


teapot_high.o: teapot_high.s \
	teapot4.inc teapot5.inc teapot6.inc teapot7.inc
	ca65 -o teapot_high.o teapot_high.s -l teapot_high.lst

#####

teapot_half.zx02:	teapot_half.bin
	$(ZX02) -f teapot_half.bin teapot_half.zx02

teapot_half.bin:	teapot_half.o
	ld65 -o teapot_half.bin teapot_half.o -C $(LINKER_SCRIPT)/atari2600_1000.inc


teapot_half.o: teapot_half.s \
	teapot4.inc teapot5.inc teapot6.inc teapot7.inc
	ca65 -o teapot_half.o teapot_half.s -l teapot_half.lst


###

teapot0.inc:	teapot0.png
	$(PNG2SPRITE) -f -n teapot_sprite0 -s 0 -l 72 -w 2 -r 2 teapot0.png teapot0.inc

teapot1.inc:	teapot1.png
	$(PNG2SPRITE) -f -n teapot_sprite1 -s 0 -l 72 -w 2 -r 2 teapot1.png teapot1.inc

teapot2.inc:	teapot2.png
	$(PNG2SPRITE) -f -n teapot_sprite2 -s 0 -l 72 -w 2 -r 2 teapot2.png teapot2.inc

teapot3.inc:	teapot3.png
	$(PNG2SPRITE) -f -n teapot_sprite3 -s 0 -l 72 -w 2 -r 2 teapot3.png teapot3.inc

teapot4.inc:	teapot4.png
	$(PNG2SPRITE) -f -n teapot_sprite4 -s 0 -l 72 -w 2 -r 2 teapot4.png teapot4.inc

teapot5.inc:	teapot5.png
	$(PNG2SPRITE) -f -n teapot_sprite5 -s 0 -l 72 -w 2 -r 2 teapot5.png teapot5.inc

teapot6.inc:	teapot6.png
	$(PNG2SPRITE) -f -n teapot_sprite6 -s 0 -l 72 -w 2 -r 2 teapot6.png teapot6.inc

teapot7.inc:	teapot7.png
	$(PNG2SPRITE) -f -n teapot_sprite7 -s 0 -l 72 -w 2 -r 2 teapot7.png teapot7.inc


###

irix_pf.inc:	irix_2600_pf.png
	$(PNG2PF) -a -y 128 -b 0xa8 -n irix irix_2600_pf.png irix_pf.inc

###

clean:	
	rm -f *~ *.o *.lst irix_pf.inc teapot0.inc

