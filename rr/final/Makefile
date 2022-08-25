ZX02 = ~/research/6502_compression/zx02.git/build/zx02
LINKER_SCRIPT = ../../linker_script/
PNG2PF = ../../utils/png2pf
PNG2OVERLAY = ../../utils/png2overlay
CALC_ADDRESS = ../utils/calc_address

all:	rr_graphics.inc

rr_graphics.inc:	rr_frame3_bg.png rr_frame3_overlay1.png rr_frame3_overlay2.png
	$(PNG2PF) -n frame3 -b 0x6 rr_frame3_bg.png - > rr_graphics.inc
	$(PNG2OVERLAY) -o -n frame3_1 rr_frame3_overlay1.png - >> rr_graphics.inc
	$(PNG2OVERLAY) -o -n frame3_2 rr_frame3_overlay2.png - >> rr_graphics.inc


####

clean:	
	rm -f *~ *.zx02 *.lst *.inc *.bin
