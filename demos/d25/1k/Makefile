LINKER_SCRIPT = ../../../linker_script

all:	parallax.bin

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

parallax.bin:	parallax.o
	ld65 -o parallax.bin parallax.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

parallax.o:	parallax.s \
	zp.inc
	ca65 -o parallax.o parallax.s -l parallax.lst

###

clean:	
	rm -f *~ *.o *.lst parallax.bin


