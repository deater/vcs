LINKER_SCRIPT = ../../../linker_script
CALC_ADDRESS = ../../../utils/calc_address

all:	bank0_title.bin

###

bank0_title.bin:	bank0_title.o
	ld65 -o bank0_title.bin bank0_title.o -C $(LINKER_SCRIPT)/atari2600_1000.inc

bank0_title.o:	bank0_title.s ../zp.inc
	ca65 -o bank0_title.o bank0_title.s -l bank0_title.lst

###

###

clean:	
	rm -f *~ *.o *.lst bank0_title.bin

