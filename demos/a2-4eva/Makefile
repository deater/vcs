LINKER_SCRIPT = ../../linker_script

all:	a2-4eva.bin a2-4eva-2k.bin


####

a2-4eva.bin:	a2-4eva.o
	ld65 -o a2-4eva.bin a2-4eva.o -C $(LINKER_SCRIPT)/atari2600_f000_1k.inc

a2-4eva.o:	a2-4eva.s \
	apple_data.s apple_code.s \
	atari_data.s atari_code.s \
	music_data.s music_code.s music_data2.s
	ca65 -o a2-4eva.o a2-4eva.s -l a2-4eva.lst

a2-4eva-2k.bin:	a2-4eva.bin
	dd if=/dev/zero of=a2-4eva-2k.bin bs=1k count=1
	cat a2-4eva.bin >> a2-4eva-2k.bin

###

submit:	a2-4eva.zip

a2-4eva.zip:    a2-4eva.bin a2-4eva.s file_id.diz a2-4eva-2k.bin
	mkdir -p lovebyte2023_a2-4eva
	mkdir -p lovebyte2023_a2-4eva/src
	cp a2-4eva.bin ./lovebyte2023_a2-4eva
	cp a2-4eva-2k.bin ./lovebyte2023_a2-4eva
	cp *.s ./lovebyte2023_a2-4eva/src
	cp file_id.diz ./lovebyte2023_a2-4eva
	cp README ./lovebyte2023_a2-4eva
	cp a2-4eva_screen.png ./lovebyte2023_a2-4eva
	cp a2-4eva_720p.mp4 ./lovebyte2023_a2-4eva
	zip -r a2-4eva.zip lovebyte2023_a2-4eva

####


###

clean:	
	rm -f *~ *.o *.lst a2-4eva.bin a2-4eva-2k.bin



