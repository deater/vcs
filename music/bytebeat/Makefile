LINKER_SCRIPT = ../../linker_script
UTILS	= ../../utils/

all:	genmusic2.bin genmusic2_padded.bin

###

genmusic2_padded.bin:	genmusic2.bin
	$(UTILS)/pad_rom -m ./genmusic2.bin  genmusic2_padded.bin

genmusic2.bin:	genmusic2.o
	ld65 -o genmusic2.bin genmusic2.o -C $(LINKER_SCRIPT)/atari2600_ff00_raw.inc

genmusic2.o:	genmusic2.s
	ca65 -o genmusic2.o genmusic2.s -l genmusic2.lst

###

clean:	
	rm -f *~ *.o *.lst genmusic2.bin


