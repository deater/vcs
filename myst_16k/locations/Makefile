ZX02 = ~/research/6502_compression/zx02.git/build/zx02
LINKER_SCRIPT = ../../linker_script/
PNG2PF = ../../utils/png2pf
PNG2OVERLAY = ../../utils/png2overlay

all:	clock_data.zx02 data1.bin

###

clock_data.inc:	clock_bg.png clock_overlay.png
	$(PNG2PF) -4 -n clock -b 0xe0 clock_bg.png - > clock_data.inc
	$(PNG2OVERLAY) -4 -n clock clock_overlay.png - >> clock_data.inc

###

data1.bin:	clock_data.o
	ld65 -o data1.bin clock_data.o -C $(LINKER_SCRIPT)/atari2600_1000.inc

###

clock_data.zx02:	clock_data.bin
	$(ZX02) -f clock_data.bin clock_data.zx02

clock_data.bin:	clock_data.o
	ld65 -o clock_data.bin clock_data.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

clock_data.o:	clock_data.inc
	ca65 -o clock_data.o clock_data.inc -l clock_data.lst

####

clean:	
	rm -f *~ *.zx02

