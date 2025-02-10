LINKER_SCRIPT = ../../../linker_script

all:	lb25.bin

###

submit:	lb25.zip

lb25.zip:	lb25.bin
	mkdir -p lb25_lb25
	mkdir -p lb25_lb25/src
	cp lb25.bin ./lb25_lb25
	cp file_id.diz ./lb25_lb25
	cp dsr_vcs_thumb.png ./lb25_lb25
	cp *.s ./lb25_lb25/src
	cp *.inc ./lb25_lb25/src
	zip -r lb25.zip lb25_lb25

###

lb25.bin:	lb25.o
	ld65 -o lb25.bin lb25.o -C $(LINKER_SCRIPT)/atari2600_f800_2k.inc

lb25.o:	lb25.s \
	zp.inc \
	adjust_sprites.s \
	lovebyte_logo.inc \
	deetia2_player.s deetia2_trackdata.s
	ca65 -o lb25.o lb25.s -l lb25.lst

###

clean:	
	rm -f *~ *.o *.lst lb25.bin


