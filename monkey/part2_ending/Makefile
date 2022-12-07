LINKER_SCRIPT = ../../linker_script

all:	ending.bin

###

ending.bin:	ending.o
	ld65 -o ending.bin ending.o -C atari2600_f000.inc

ending.o:	ending.s \
	../zp.inc ../common_addresses.inc \
	trials.s trials.inc \
	cart.s
	ca65 -o ending.o ending.s -l ending.lst

###

clean:	
	rm -f *~ *.o *.lst ending.bin


