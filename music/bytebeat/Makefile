LINKER_SCRIPT = ../../linker_script
UTILS	= ../../utils/

all:	genmusic2_tjoppen.bin genmusic2_tjoppen_padded.bin

###

genmusic2_tjoppen_padded.bin:	genmusic2_tjoppen.bin
	$(UTILS)/pad_rom -m ./genmusic2_tjoppen.bin  genmusic2_tjoppen_padded.bin

genmusic2_tjoppen.bin:	genmusic2_tjoppen.o
	ld65 -o genmusic2_tjoppen.bin genmusic2_tjoppen.o -C $(LINKER_SCRIPT)/atari2600_ff00_raw.inc

genmusic2_tjoppen.o:	genmusic2_tjoppen.s
	ca65 -o genmusic2_tjoppen.o genmusic2_tjoppen.s -l genmusic2_tjoppen.lst

###

clean:	
	rm -f *~ *.o *.lst genmusic2_tjoppen.bin


