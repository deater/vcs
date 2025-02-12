LINKER_SCRIPT = ../../../linker_script
UTILS	= ../../../utils/

all:	parallax.bin parallax_padded.bin

###

submit:	parallax.zip

parallax.zip:	parallax.bin parallax_padded.bin
	mkdir -p lovebyte2025_parallax
	mkdir -p lovebyte2025_parallax/src
	cp parallax.bin ./lovebyte2025_parallax
	cp parallax_padded.bin ./lovebyte2025_parallax
	cp file_id.diz ./lovebyte2025_parallax
	cp parallax_thumb.png ./lovebyte2025_parallax
	cp *.s ./lovebyte2025_parallax/src
	cp *.inc ./lovebyte2025_parallax/src
	zip -r parallax.zip lovebyte2025_parallax


###

parallax_padded.bin:	parallax.bin
	$(UTILS)/pad_rom -m ./parallax.bin  parallax_padded.bin

parallax.bin:	parallax.o
	ld65 -o parallax.bin parallax.o -C $(LINKER_SCRIPT)/atari2600_ff00_raw.inc

parallax.o:	parallax.s \
	zp.inc
	ca65 -o parallax.o parallax.s -l parallax.lst

###

clean:	
	rm -f *~ *.o *.lst parallax.bin


