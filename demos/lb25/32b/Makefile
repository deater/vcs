LINKER_SCRIPT = ../../../linker_script
UTILS = ../../../utils

all:	sideways_32_padded.rom

###

sideways_32_padded.rom:	sideways_32.bin
	$(UTILS)/pad_rom -m sideways_32.bin sideways_32_padded.rom

sideways_32.bin:	sideways_32.o
	ld65 -o sideways_32.bin sideways_32.o -C $(LINKER_SCRIPT)/atari2600_f800_32_rep.inc

sideways_32.o:	sideways_32.s
	ca65 -o sideways_32.o sideways_32.s -l sideways_32.lst

###

clean:	
	rm -f *~ *.o *.lst \
		sideways_32.bin sideways_32_padded.rom


