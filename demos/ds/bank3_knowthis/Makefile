LINKER_SCRIPT = ../../../linker_script
CALC_ADDRESS = ../../../utils/calc_address

all:	bank3_knowthis.bin

###

bank3_knowthis.bin:	bank3_knowthis.o
	ld65 -o bank3_knowthis.bin bank3_knowthis.o -C $(LINKER_SCRIPT)/atari2600_1000.inc

bank3_knowthis.o:	bank3_knowthis.s ../zp.inc ../timing.inc \
	knowthis.s knowthis_pf.inc
	ca65 -o bank3_knowthis.o bank3_knowthis.s -l bank3_knowthis.lst

###

###

clean:	
	rm -f *~ *.o *.lst bank3_knowthis.bin

