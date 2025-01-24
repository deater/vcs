LINKER_SCRIPT = ../../../linker_script

all:	cometsong.bin

###

submit:	parallax.zip

parallax.zip:	parallax.bin
	mkdir -p lovebyte2025_parallax
	mkdir -p lovebyte2025_parallax/src
	cp parallax.bin ./lovebyte2025_parallax
	cp file_id.diz ./lovebyte2025_parallax
	cp dsr_vcs_thumb.png ./lovebyte2025_parallax
	cp *.s ./lovebyte2025_parallax/src
	cp *.inc ./lovebyte2025_parallax/src
	zip -r parallax.zip lovebyte2025_parallax


###

cometsong.bin:	cometsong.o
	ld65 -o cometsong.bin cometsong.o -C $(LINKER_SCRIPT)/atari2600_f000_1k.inc

cometsong.o:	cometsong.s \
	zp.inc
	ca65 -o cometsong.o cometsong.s -l cometsong.lst

###

clean:	
	rm -f *~ *.o *.lst cometsong.bin text_to_tiny
