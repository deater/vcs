LINKER_SCRIPT = ../../../linker_script
UTILS = ../../../utils

all:	tiny1.rom tiny2.rom tiny3.rom tiny4.rom tiny5.rom


###

tiny1.rom:	tiny1.bin
	$(UTILS)/pad_rom -m tiny1.bin tiny1.rom

tiny1.bin:	tiny1.o
	ld65 -o tiny1.bin tiny1.o -C $(LINKER_SCRIPT)/atari2600_f800_32_rep.inc

tiny1.o:	tiny1.s
	ca65 -o tiny1.o tiny1.s -l tiny1.lst

###

tiny2.rom:	tiny2.bin
	$(UTILS)/pad_rom -m tiny2.bin tiny2.rom

tiny2.bin:	tiny2.o
	ld65 -o tiny2.bin tiny2.o -C $(LINKER_SCRIPT)/atari2600_f800_32_rep.inc

tiny2.o:	tiny2.s
	ca65 -o tiny2.o tiny2.s -l tiny2.lst

###

tiny3.rom:	tiny3.bin
	$(UTILS)/pad_rom -m tiny3.bin tiny3.rom

tiny3.bin:	tiny3.o
	ld65 -o tiny3.bin tiny3.o -C $(LINKER_SCRIPT)/atari2600_f800_32_rep.inc

tiny3.o:	tiny3.s
	ca65 -o tiny3.o tiny3.s -l tiny3.lst

###

tiny4.rom:	tiny4.bin
	$(UTILS)/pad_rom -m tiny4.bin tiny4.rom

tiny4.bin:	tiny4.o
	ld65 -o tiny4.bin tiny4.o -C $(LINKER_SCRIPT)/atari2600_f800_32_rep.inc

tiny4.o:	tiny4.s
	ca65 -o tiny4.o tiny4.s -l tiny4.lst

###

tiny5.rom:	tiny5.bin
	$(UTILS)/pad_rom -m tiny5.bin tiny5.rom

tiny5.bin:	tiny5.o
	ld65 -o tiny5.bin tiny5.o -C $(LINKER_SCRIPT)/atari2600_f800_16_rep.inc

tiny5.o:	tiny5.s
	ca65 -o tiny5.o tiny5.s -l tiny5.lst




###

clean:	
	rm -f *~ *.o *.lst \
		tiny1.bin tiny1.rom \
		tiny2.bin tiny2.rom \
		tiny3.bin tiny3.rom \
		tiny4.bin tiny4.rom \
		tiny5.bin tiny5.rom


