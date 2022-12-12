LINKER_SCRIPT = ../../linker_script

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

part0_opener/opener.bin:	
	cd part0_opener && make

part1_title/title.bin:	
	cd part1_title && make

part2_ending/ending.bin:	
	cd part2_ending && make

part3_main/main.bin:	
	cd part3_main && make



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

clean:	
	cd part0_opener && make clean
	cd part1_title && make clean
	cd part2_ending && make clean
	cd part3_main && make clean
	rm -f *~ *.o *.lst monkey.e0


