ZX02 = ~/research/6502_compression/zx02.git/build/zx02
LINKER_SCRIPT = ../../linker_script/
PNG2PF = ../../utils/png2pf
PNG2OVERLAY = ../../utils/png2overlay
CALC_ADDRESS = ../utils/calc_address

all:	rom_bank6.bin rom_bank6_routines.inc

###

rom_bank6_routines.inc:	rom_bank6.bin
	$(CALC_ADDRESS) -a 0x1000 -s do_intro rom_bank6.lst > rom_bank6_routines.inc

###

rom_bank6.bin:	rom_bank6.o
	ld65 -o rom_bank6.bin rom_bank6.o -C $(LINKER_SCRIPT)/atari2600_1000.inc

###

rom_bank6.o:	rom_bank6.s \
	title.s cleft.s book.s \
	../zp.inc ../../vcs.inc
	ca65 -o rom_bank6.o rom_bank6.s -l rom_bank6.lst

###


clean:	
	rm -f *~ *.zx02 *.lst rom_bank6_routines.inc *.o *.bin

