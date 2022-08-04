PNG2RLE = ../../../utils/gr-utils/png2rle
PNG2GR = ../../../utils/gr-utils/png2gr
PNG2HGR = ../../../utils/hgr-utils/png2hgr
#LZSA = ~/research/lzsa/lzsa/lzsa
B2D = ../../../utils/bmp2dhr/b2d
ZX02 = ~/research/6502_compression/zx02.git/build/zx02
LINKER_SCRIPT = ../../linker_script/

all:	clock_data.zx02 data1.bin

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

