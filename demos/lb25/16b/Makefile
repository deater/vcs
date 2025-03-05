LINKER_SCRIPT = ../../../linker_script
UTILS = ../../../utils

all:	cbars16_padded.bin

###

submit:	cbars16.zip

cbars16.zip:	cbars16.bin cbars16_padded.bin
	mkdir -p lovebyte2025_cbars16
	cp cbars16.bin ./lovebyte2025_cbars16
	cp cbars16_padded.bin ./lovebyte2025_cbars16
	cp file_id.diz ./lovebyte2025_cbars16
	cp cbars16_thumb.png ./lovebyte2025_cbars16
	cp cbars16.s ./lovebyte2025_cbars16
	cp cbars16_720p.mp4 ./lovebyte2025_cbars16
	zip -r cbars16.zip lovebyte2025_cbars16

###

cbars16_padded.bin:	cbars16.bin
	$(UTILS)/pad_rom -m cbars16.bin cbars16_padded.bin

cbars16.bin:	cbars16.o
	ld65 -o cbars16.bin cbars16.o -C $(LINKER_SCRIPT)/atari2600_f800_16_rep.inc

cbars16.o:	cbars16.s
	ca65 -o cbars16.o cbars16.s -l cbars16.lst




###

clean:	
	rm -f *~ *.o *.lst \
		cbars16.bin cbars16_padded.bin


