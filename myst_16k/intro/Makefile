ZX02 = ~/research/6502_compression/zx02.git/build/zx02
LINKER_SCRIPT = ../../linker_script/
PNG2PF = ../../utils/png2pf
PNG2OVERLAY = ../../utils/png2overlay

all:	rom_bank6.bin

###

rom_bank6.bin:	rom_bank6.o
	ld65 -o rom_bank6.bin rom_bank6.o -C $(LINKER_SCRIPT)/atari2600_1000.inc

###

rom_bank6.o:	rom_bank6.s \
	title.s \
	../zp.inc ../../vcs.inc
	ca65 -o rom_bank6.o rom_bank6.s -l rom_bank6.lst

###


clean:	
	rm -f *~ *.zx02 *.lst *.inc *.o *.bin

