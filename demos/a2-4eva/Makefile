LINKER_SCRIPT = ../../linker_script

all:	a2-4eva.rom


####

a2-4eva.rom:	a2-4eva.o
	ld65 -o a2-4eva.rom a2-4eva.o -C $(LINKER_SCRIPT)/atari2600_f000_1k.inc

a2-4eva.o:	a2-4eva.s \
	apple_data.s apple_code.s \
	atari_data.s atari_code.s \
	music_data.s music_code.s
	ca65 -o a2-4eva.o a2-4eva.s -l a2-4eva.lst

###

clean:	
	rm -f *~ *.o *.lst a2-4eva.rom



