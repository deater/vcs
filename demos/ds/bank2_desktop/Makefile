LINKER_SCRIPT = ../../../linker_script
CALC_ADDRESS = ../../../utils/calc_address

all:	bank2_desktop.bin

###

bank2_desktop.bin:	bank2_desktop.o
	ld65 -o bank2_desktop.bin bank2_desktop.o -C $(LINKER_SCRIPT)/atari2600_1000.inc

bank2_desktop.o:	bank2_desktop.s ../zp.inc ../timing.inc \
	irix_pf.inc teapot0.inc frame1_init.s frame2_init.s frame3_init.s
	ca65 -o bank2_desktop.o bank2_desktop.s -l bank2_desktop.lst

###

###

clean:	
	rm -f *~ *.o *.lst bank2_desktop.bin

