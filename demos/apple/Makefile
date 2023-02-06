LINKER_SCRIPT = ../../linker_script

all:	apple.rom apple_fancy.rom apple_tiny.rom atari_tiny.rom atari_fancy.rom

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
	ld65 -o apple_tiny.rom apple_tiny.o -C $(LINKER_SCRIPT)/atari2600_f000_1k.inc

apple_tiny.o:	apple_tiny.s playfield.inc
	ca65 -o apple_tiny.o apple_tiny.s -l apple_tiny.lst

###

atari_tiny.rom:	atari_tiny.o
	ld65 -o atari_tiny.rom atari_tiny.o -C $(LINKER_SCRIPT)/atari2600_f000_1k.inc

atari_tiny.o:	atari_tiny.s playfield.inc
	ca65 -o atari_tiny.o atari_tiny.s -l atari_tiny.lst

###

atari_fancy.rom:	atari_fancy.o
	ld65 -o atari_fancy.rom atari_fancy.o -C $(LINKER_SCRIPT)/atari2600_f000_1k.inc

atari_fancy.o:	atari_fancy.s playfield.inc
	ca65 -o atari_fancy.o atari_fancy.s -l atari_fancy.lst




###

clean:	
	rm -f *~ *.o *.lst apple.rom apple_fancy.rom apple_tiny.rom \
			atari_fancy.rom atari_tiny.rom


