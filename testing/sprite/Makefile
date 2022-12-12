LINKER_SCRIPT = ../../linker_script

all:	sprite.rom

###

sprite.rom:	sprite.o
	ld65 -o sprite.rom sprite.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

sprite.o:	sprite.s
	ca65 -o sprite.o sprite.s -l sprite.lst

###

clean:	
	rm -f *~ *.o *.lst sprite.rom


