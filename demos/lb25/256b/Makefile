LINKER_SCRIPT = ../../../linker_script
UTILS	= ../../../utils/

all:	parallax.bin parallax_padded.bin

###

submit:	parallax.zip

parallax.zip:	parallax.bin parallax_padded.bin
	mkdir -p lovebyte2025_parallax
	cp parallax.bin ./lovebyte2025_parallax
	cp parallax_padded.bin ./lovebyte2025_parallax
	cp file_id.diz ./lovebyte2025_parallax
	cp parallax_thumb.png ./lovebyte2025_parallax
	cp parallax.s ./lovebyte2025_parallax
	cp parallax_720p.mp4 ./lovebyte2025_parallax
	zip -r parallax.zip lovebyte2025_parallax

###

pouet_submit:	parallax_pouet.zip

parallax_pouet.zip:	parallax.bin parallax_padded.bin
	mkdir -p lovebyte2025_parallax
	cp parallax.bin ./lovebyte2025_parallax
	cp parallax_padded.bin ./lovebyte2025_parallax
	cp file_id.diz ./lovebyte2025_parallax
	cp parallax_thumb.png ./lovebyte2025_parallax
	cp parallax.s ./lovebyte2025_parallax
	zip -r parallax_pouet.zip lovebyte2025_parallax



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


