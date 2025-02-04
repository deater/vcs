LINKER_SCRIPT = ../../../linker_script
UTILS = ../../../utils

all:	tiny1.rom


###

tiny1.rom:	tiny1.bin
	$(UTILS)/pad_rom -m tiny1.bin tiny1.rom

tiny1.bin:	tiny1.o
	ld65 -o tiny1.bin tiny1.o -C $(LINKER_SCRIPT)/atari2600_f800_64_rep.inc

tiny1.o:	tiny1.s
	ca65 -o tiny1.o tiny1.s -l tiny1.lst

###

clean:	
	rm -f *~ *.o *.lst \
		tiny1.bin tiny1.rom


