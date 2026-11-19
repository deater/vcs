LINKER_SCRIPT = ../../../linker_script
CALC_ADDRESS = ../../../utils/calc_address

all:	bank4_plasma.bin draw_routine.bin

###

bank4_plasma.bin:	bank4_plasma.o
	ld65 -o bank4_plasma.bin bank4_plasma.o -C $(LINKER_SCRIPT)/atari2600_1000.inc

bank4_plasma.o:	bank4_plasma.s ../zp.inc \
	frame1_init.s draw_routine.bin
	ca65 -o bank4_plasma.o bank4_plasma.s -l bank4_plasma.lst

###

draw_routine.bin:	draw_routine.o
	ld65 -o draw_routine.bin draw_routine.o -C $(LINKER_SCRIPT)/atari2600_1900_raw.inc

draw_routine.o:	draw_routine.s
	ca65 -o draw_routine.o draw_routine.s -l draw_routine.lst


###

###

clean:	
	rm -f *~ *.o *.lst bank4_plasma.bin draw_routine.bin

