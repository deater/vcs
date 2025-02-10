LINKER_SCRIPT = ../../../linker_script
UTILS = ../../../utils

all:	cbars16_padded.rom

###

cbars16_padded.rom:	cbars16.bin
	$(UTILS)/pad_rom -m cbars16.bin cbars16_padded.rom

cbars16.bin:	cbars16.o
	ld65 -o cbars16.bin cbars16.o -C $(LINKER_SCRIPT)/atari2600_f800_16_rep.inc

cbars16.o:	cbars16.s
	ca65 -o cbars16.o cbars16.s -l cbars16.lst




###

clean:	
	rm -f *~ *.o *.lst \
		cbars16.bin cbars16_padded.rom


