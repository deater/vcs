LINKER_SCRIPT = ../../../linker_script
CALC_ADDRESS = ../../../utils/calc_address

all:	bank5_credits.bin

###

bank5_credits.bin:	bank5_credits.o
	ld65 -o bank5_credits.bin bank5_credits.o -C $(LINKER_SCRIPT)/atari2600_1000.inc

bank5_credits.o:	bank5_credits.s ../zp.inc ../timing.inc \
	simple_font.inc frame1_init.s frame2_init.s parallax_kernel.s
	ca65 -o bank5_credits.o bank5_credits.s -l bank5_credits.lst

###

###

clean:	
	rm -f *~ *.o *.lst bank5_credits.bin

