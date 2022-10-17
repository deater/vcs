LINKER_SCRIPT = ../linker_script

all:	monkey.bin

###

monkey.bin:	monkey.o
	ld65 -o monkey.bin monkey.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

monkey.o:	monkey.s \
	zp.inc common_routines.s \
	opening.s lucas.inc \
	trials.s trials.inc \
	cart.s cart_message.inc
	ca65 -o monkey.o monkey.s -l monkey.lst

###

clean:	
	rm -f *~ *.o *.lst monkey.bin


