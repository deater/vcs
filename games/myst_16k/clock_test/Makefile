LINKER_SCRIPT = ../../../linker_script

all:	clock.e7

###

clock.bin:	clock.o
	ld65 -o clock.bin clock.o -C $(LINKER_SCRIPT)/atari2600_1a00.inc

clock.o:	clock.s level_engine.s load_level.s ../zp.inc
	ca65 -o clock.o clock.s -l clock.lst

###

clock_bank6.bin:	clock_bank6.o
	ld65 -o clock_bank6.bin clock_bank6.o -C $(LINKER_SCRIPT)/atari2600_1000.inc

clock_bank6.o:	clock_bank6.s clock_update.s ../zp.inc
	ca65 -o clock_bank6.o clock_bank6.s -l clock_bank6.lst



###

clock.e7:	clock_e7.o
	ld65 -o clock.e7 clock_e7.o -C $(LINKER_SCRIPT)/atari2600_e7.inc

clock_e7.o: clock_e7.s clock.bin clock_bank6.bin \
	zero.bin zero2.bin
	ca65 -o clock_e7.o clock_e7.s


###

zero.bin:	
	dd if=/dev/zero of=zero.bin bs=1k count=2

zero2.bin:	
	dd if=/dev/zero of=zero2.bin bs=256 count=2



###

clean:	
	rm -f *~ *.o *.lst *.bin *.e7


