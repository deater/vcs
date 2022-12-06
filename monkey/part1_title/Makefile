LINKER_SCRIPT = ../../linker_script

all:	title.bin

###

title.bin:	main_title.o
	ld65 -o title.bin main_title.o -C atari2600_f000.inc

main_title.o:	main_title.s \
	handle_music.s \
	monkey_variables.s \
	monkey_trackdata.s \
	monkey_player.s \
	../zp.inc ../common_addresses.inc \
	title.s title.inc
	ca65 -o main_title.o main_title.s -l main_title.lst

###

clean:	
	rm -f *~ *.o *.lst title.bin


