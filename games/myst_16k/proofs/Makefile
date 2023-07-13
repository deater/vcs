LINKER_SCRIPT = ../../../linker_script

all:	clock.bin fireplace.e7

###

clock.bin:	clock.o
	ld65 -o clock.bin clock.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

clock.o:	clock.s clock_sprites.inc
	ca65 -o clock.o clock.s -l clock.lst

###

fireplace.bin:	fireplace.o
	ld65 -o fireplace.bin fireplace.o -C $(LINKER_SCRIPT)/atari2600_1a00.inc

fireplace.o:	fireplace.s level_engine.s load_level.s ../zp.inc
	ca65 -o fireplace.o fireplace.s -l fireplace.lst

###

fireplace_bank6.bin:	fireplace_bank6.o
	ld65 -o fireplace_bank6.bin fireplace_bank6.o -C $(LINKER_SCRIPT)/atari2600_1000.inc

fireplace_bank6.o:	fireplace_bank6.s fireplace_update.s ../zp.inc
	ca65 -o fireplace_bank6.o fireplace_bank6.s -l fireplace_bank6.lst



###

fireplace.e7:	fireplace_e7.o
	ld65 -o fireplace.e7 fireplace_e7.o -C $(LINKER_SCRIPT)/atari2600_e7.inc

fireplace_e7.o: fireplace_e7.s fireplace.bin fireplace_bank6.bin \
	zero.bin zero2.bin
	ca65 -o fireplace_e7.o fireplace_e7.s


###

zero.bin:	
	dd if=/dev/zero of=zero.bin bs=1k count=2

zero2.bin:	
	dd if=/dev/zero of=zero2.bin bs=256 count=2



###

clean:	
	rm -f *~ *.o *.lst clock.bin fireplace.bin


