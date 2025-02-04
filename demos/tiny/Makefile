LINKER_SCRIPT = ../../linker_script
UTILS = ../../utils

all:	winter.rom \
	omega1.rom omega2.rom omega3.rom omega4.rom


###

omega1.rom:	omega1.bin
	$(UTILS)/pad_rom -m omega1.bin omega1.rom

omega1.bin:	omega1.o
	ld65 -o omega1.bin omega1.o -C $(LINKER_SCRIPT)/atari2600_f800_32_rep.inc

omega1.o:	omega1.s
	ca65 -o omega1.o omega1.s -l omega1.lst

###

omega2.rom:	omega2.bin
	$(UTILS)/pad_rom -m omega2.bin omega2.rom

omega2.bin:	omega2.o
	ld65 -o omega2.bin omega2.o -C $(LINKER_SCRIPT)/atari2600_f800_32_rep.inc

omega2.o:	omega2.s
	ca65 -o omega2.o omega2.s -l omega2.lst

###

omega3.rom:	omega3.bin
	$(UTILS)/pad_rom -m omega3.bin omega3.rom

omega3.bin:	omega3.o
	ld65 -o omega3.bin omega3.o -C $(LINKER_SCRIPT)/atari2600_f800_32_rep.inc

omega3.o:	omega3.s
	ca65 -o omega3.o omega3.s -l omega3.lst


###

omega4.rom:	omega4.bin
	$(UTILS)/pad_rom -m omega4.bin omega4.rom

omega4.bin:	omega4.o
	ld65 -o omega4.bin omega4.o -C $(LINKER_SCRIPT)/atari2600_f800_32_rep.inc

omega4.o:	omega4.s
	ca65 -o omega4.o omega4.s -l omega4.lst




###

winter.rom:	winter.bin
	$(UTILS)/pad_rom -m winter.bin winter.rom

winter.bin:	winter.o
	ld65 -o winter.bin winter.o -C $(LINKER_SCRIPT)/atari2600_f800_32_rep.inc

winter.o:	winter.s
	ca65 -o winter.o winter.s -l winter.lst

###

clean:	
	rm -f *~ *.o *.lst winter.bin winter.rom \
		omega1.bin omega1.rom \
		omega2.bin omega2.rom \
		omega3.bin omega3.rom \
		omega4.bin omega4.rom


