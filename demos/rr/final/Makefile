ZX02 = ~/research/6502_compression/zx02.git/build/zx02
LINKER_SCRIPT = ../../linker_script/
PNG2PF = ../../utils/png2pf
PNG2OVERLAY = ../../utils/png2overlay
CALC_ADDRESS = ../utils/calc_address

all:	rr_graphics3.inc rr_graphics4.inc rr_graphics5.inc rr_graphics6.inc

rr_graphics3.inc:	rr_frame3_bg.png rr_frame3_overlay.png rr_frame3_overlay2.png
	$(PNG2PF) -n frame3 -b 0x6 rr_frame3_bg.png - > rr_graphics3.inc
	$(PNG2OVERLAY) -o -n frame3_1 rr_frame3_overlay.png - >> rr_graphics3.inc
	$(PNG2OVERLAY) -o -n frame3_2 rr_frame3_overlay2.png - >> rr_graphics3.inc

rr_graphics4.inc:	rr_frame4_bg.png rr_frame4_overlay.png rr_frame4_overlay2.png
	$(PNG2PF) -n frame4 -b 0x6 rr_frame4_bg.png - > rr_graphics4.inc
	$(PNG2OVERLAY) -o -n frame4_1 rr_frame4_overlay.png - >> rr_graphics4.inc
	$(PNG2OVERLAY) -o -n frame4_2 rr_frame4_overlay2.png - >> rr_graphics4.inc

rr_graphics5.inc:	rr_frame5_bg.png rr_frame5_overlay.png rr_frame5_overlay2.png
	$(PNG2PF) -n frame5 -b 0x6 rr_frame5_bg.png - > rr_graphics5.inc
	$(PNG2OVERLAY) -o -n frame5_1 rr_frame5_overlay.png - >> rr_graphics5.inc
	$(PNG2OVERLAY) -o -n frame5_2 rr_frame5_overlay2.png - >> rr_graphics5.inc

rr_graphics6.inc:	rr_frame6_bg.png rr_frame6_overlay.png rr_frame6_overlay2.png
	$(PNG2PF) -n frame6 -b 0x6 rr_frame6_bg.png - > rr_graphics6.inc
	$(PNG2OVERLAY) -o -n frame6_1 rr_frame6_overlay.png - >> rr_graphics6.inc
	$(PNG2OVERLAY) -o -n frame6_2 rr_frame6_overlay2.png - >> rr_graphics6.inc




####

clean:	
	rm -f *~ *.zx02 *.lst *.inc *.bin
