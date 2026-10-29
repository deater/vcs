LINKER_SCRIPT = ../../../linker_script
CALC_ADDRESS = ../../../utils/calc_address

all:	bank4_plasma.bin

###

bank4_plasma.bin:	bank4_plasma.o
	ld65 -o bank4_plasma.bin bank4_plasma.o -C $(LINKER_SCRIPT)/atari2600_1000.inc

bank4_plasma.o:	bank4_plasma.s ../zp.inc
	ca65 -o bank4_plasma.o bank4_plasma.s -l bank4_plasma.lst

###

###

clean:	
	rm -f *~ *.o *.lst bank4_plasma.bin

