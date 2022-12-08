LINKER_SCRIPT = ../../linker_script

all:	opener.bin

###

opener.bin:	opener.o
	ld65 -o opener.bin opener.o -C atari2600_f000.inc

opener.o:	opener.s \
	opening.s \
	handle_music.s \
	monkey_intro_variables.s \
	monkey_intro_trackdata.s \
	monkey_intro_player.s \
	../zp.inc ../common_addresses.inc \
	lucas.inc \
	title.s title.inc \
	text.s
	ca65 -o opener.o opener.s -l opener.lst

###

clean:	
	rm -f *~ *.o *.lst opener.bin


