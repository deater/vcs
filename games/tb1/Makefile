LINKER_SCRIPT = ../../linker_script

all:	tb1.bin

###

tb1.bin:	tb1.o
	ld65 -o tb1.bin tb1.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

tb1.o:	tb1.s \
	zp.inc
	ca65 -o tb1.o tb1.s -l tb1.lst

###

clean:	
	rm -f *~ *.o *.lst tb1.bin
