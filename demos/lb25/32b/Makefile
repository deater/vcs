LINKER_SCRIPT = ../../../linker_script
UTILS = ../../../utils

all:	sideways_32_padded.bin

###

submit:	sideways_32.zip

sideways_32.zip:	sideways_32.bin sideways_32_padded.bin
	mkdir -p lovebyte2025_sideways_32
	cp sideways_32.bin ./lovebyte2025_sideways_32
	cp sideways_32_padded.bin ./lovebyte2025_sideways_32
	cp file_id.diz ./lovebyte2025_sideways_32
	cp sideways_32_thumb.png ./lovebyte2025_sideways_32
	cp sideways_32.s ./lovebyte2025_sideways_32
	cp sideways_32_720p.mp4 ./lovebyte2025_sideways_32
	zip -r sideways_32.zip lovebyte2025_sideways_32

###

sideways_32_padded.bin:	sideways_32.bin
	$(UTILS)/pad_rom -m sideways_32.bin sideways_32_padded.bin

sideways_32.bin:	sideways_32.o
	ld65 -o sideways_32.bin sideways_32.o -C $(LINKER_SCRIPT)/atari2600_f800_32_rep.inc

sideways_32.o:	sideways_32.s
	ca65 -o sideways_32.o sideways_32.s -l sideways_32.lst

###

clean:	
	rm -f *~ *.o *.lst \
		sideways_32.bin sideways_32_padded.bin


