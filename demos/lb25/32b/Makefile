LINKER_SCRIPT = ../../../linker_script
UTILS = ../../../utils

all:	tiny5_32_padded.rom

###

tiny5_32_padded.rom:	tiny5_32.bin
	$(UTILS)/pad_rom -m tiny5_32.bin tiny5_32_padded.rom

tiny5_32.bin:	tiny5_32.o
	ld65 -o tiny5_32.bin tiny5_32.o -C $(LINKER_SCRIPT)/atari2600_f800_32_rep.inc

tiny5_32.o:	tiny5_32.s
	ca65 -o tiny5_32.o tiny5_32.s -l tiny5_32.lst




###

clean:	
	rm -f *~ *.o *.lst \
		tiny5_32.bin tiny5_32_padded.rom


