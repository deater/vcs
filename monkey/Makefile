LINKER_SCRIPT = ../linker_script

all:	monkey.e0

###

submit:	vcs_monkey.zip

vcs_monkey.zip: monkey.e0
	mkdir -p vcs_monkey
	cp monkey.e0 ./vcs_monkey
	cp file_id.diz ./vcs_monkey
	cp README ./vcs_monkey
	cp mi_thumb.png ./vcs_monkey
	zip -r vcs_monkey.zip vcs_monkey

###

monkey.e0:	monkey.o
	ld65 -o monkey.e0 monkey.o -C $(LINKER_SCRIPT)/atari2600_e0.inc

monkey.o:	monkey.s \
	part0_opener/opener.bin \
	part1_title/title.bin \
	part2_ending/ending.bin \
	part3_main/main.bin
	ca65 -o monkey.o monkey.s

###

zero.bin:	
	dd if=/dev/zero of=zero.bin bs=1k count=1

zero2.bin:	
	dd if=/dev/zero of=zero2.bin bs=1k count=2

###

main.bin:	main.o
	ld65 -o main.bin main.o -C $(LINKER_SCRIPT)/atari2600_fc00.inc

main.o:	main.s zp.inc common_routines.s
	ca65 -o main.o main.s -l main.lst



###

#monkey.bin:	monkey.o
#	ld65 -o monkey.bin monkey.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

#monkey.o:	monkey.s \
#	monkey_variables.s monkey_trackdata.s monkey_player.s \
#	zp.inc common_routines.s \
#	handle_music.s \
#	opening.s lucas.inc \
#	title.s title.inc \
#	level_engine.s lookout.inc lookout_over.inc \
#	trials.s trials.inc \
#	cart.s cart_message.inc
#	ca65 -o monkey.o monkey.s -l monkey.lst

###

clean:	
	rm -f *~ *.o *.lst monkey.e0


