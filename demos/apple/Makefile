LINKER_SCRIPT = ../../linker_script

all:	apple.rom apple_fancy.rom apple_tiny.rom

###

apple.rom:	apple.o
	ld65 -o apple.rom apple.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

apple.o:	apple.s playfield.inc
	ca65 -o apple.o apple.s -l apple.lst

###

apple_fancy.rom:	apple_fancy.o
	ld65 -o apple_fancy.rom apple_fancy.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

apple_fancy.o:	apple_fancy.s playfield.inc
	ca65 -o apple_fancy.o apple_fancy.s -l apple_fancy.lst

###

apple_tiny.rom:	apple_tiny.o
	ld65 -o apple_tiny.rom apple_tiny.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

apple_tiny.o:	apple_tiny.s playfield.inc
	ca65 -o apple_tiny.o apple_tiny.s -l apple_tiny.lst


###

clean:	
	rm -f *~ *.o *.lst apple.rom apple_fancy.rom apple_tiny.rom


