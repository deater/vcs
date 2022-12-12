LINKER_SCRIPT = ../../linker_script

all:	book.rom

###

book.rom:	book.o
	ld65 -o book.rom book.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

book.o:	book.s playfield.inc
	ca65 -o book.o book.s -l book.lst

###

clean:	
	rm -f *~ *.o *.lst book.rom


