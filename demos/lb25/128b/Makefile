LINKER_SCRIPT = ../../../linker_script
UTILS	= ../../../utils/

all:	purple_beat.bin purple_beat_padded.bin

###

submit:	purple_beat.zip

purple_beat.zip:	purple_beat.bin purple_beat_padded.bin
	mkdir -p lovebyte2025_purple_beat
	cp purple_beat.bin ./lovebyte2025_purple_beat
	cp purple_beat_padded.bin ./lovebyte2025_purple_beat
	cp file_id.diz ./lovebyte2025_purple_beat
	cp purple_beat_thumb.png ./lovebyte2025_purple_beat
	cp purple_beat.s ./lovebyte2025_purple_beat
	zip -r purple_beat.zip lovebyte2025_purple_beat

###

purple_beat_padded.bin:	purple_beat.bin
	$(UTILS)/pad_rom -m ./purple_beat.bin  purple_beat_padded.bin

purple_beat.bin:	purple_beat.o
	ld65 -o purple_beat.bin purple_beat.o -C $(LINKER_SCRIPT)/atari2600_ff00_raw.inc

purple_beat.o:	purple_beat.s
	ca65 -o purple_beat.o purple_beat.s -l purple_beat.lst

###

clean:	
	rm -f *~ *.o *.lst purple_beat.bin


