LINKER_SCRIPT = ../../../linker_script
CALC_ADDRESS = ../../../utils/calc_address

all:	bank1_bounce.bin

###

bank1_bounce.bin:	bank1_bounce.o
	ld65 -o bank1_bounce.bin bank1_bounce.o -C $(LINKER_SCRIPT)/atari2600_1000.inc

bank1_bounce.o:	bank1_bounce.s ../zp.inc \
	bounce_kernel.s ../timing.inc
	ca65 -o bank1_bounce.o bank1_bounce.s -l bank1_bounce.lst

###

###

clean:	
	rm -f *~ *.o *.lst bank1_bounce.bin

