LINKER_SCRIPT = ../../linker_script
CALC_ADDRESS = ./utils/calc_address

CC = gcc
CFLAGS = -Wall -O2
LFLAGS =


all:	e7_test.e7 e7_test_rom1.bin e7_test_rom2.bin

###

e7_test_rom1.bin:	e7_test.e7
	dd if=e7_test.e7 of=e7_test_rom1.bin bs=1k count=8 skip=8

e7_test_rom2.bin:	e7_test.e7
	dd if=e7_test.e7 of=e7_test_rom2.bin bs=1k count=8




###

e7_test.e7:	e7_test.o
	ld65 -o e7_test.e7 e7_test.o -C $(LINKER_SCRIPT)/atari2600_e7.inc

e7_test.o:	e7_test.s main.bin \
	rom_bank0.bin \
	rom_bank1.bin \
	rom_bank2.bin \
	rom_bank3.bin \
	rom_bank4.bin \
	rom_bank5.bin \
	rom_bank6.bin \
	zero_2k.bin \
	zero_512.bin
	ca65 -o e7_test.o e7_test.s

###

rom_bank0.bin:	rom_tool
	./rom_tool 0 > rom_bank0.bin

rom_bank1.bin:	rom_tool
	./rom_tool 1 > rom_bank1.bin

rom_bank2.bin:	rom_tool
	./rom_tool 2 > rom_bank2.bin

rom_bank3.bin:	rom_tool
	./rom_tool 3 > rom_bank3.bin

rom_bank4.bin:	rom_tool
	./rom_tool 4 > rom_bank4.bin

rom_bank5.bin:	rom_tool
	./rom_tool 5 > rom_bank5.bin

rom_bank6.bin:	rom_tool
	./rom_tool 6 > rom_bank6.bin




###

zero_2k.bin:	
	dd if=/dev/zero of=zero_2k.bin bs=1k count=2

###

zero_512.bin:	
	dd if=/dev/zero of=zero_512.bin bs=256 count=2

###

rom_tool:	rom_tool.o
	$(CC) $(LFLAGS) -o rom_tool rom_tool.o

rom_tool.o:	rom_tool.c
	$(CC) $(CFLAGS) -c rom_tool.c


###

main.bin:	main.o
	ld65 -o main.bin main.o -C $(LINKER_SCRIPT)/atari2600_1a00_e7.inc

main.o:	main.s zp.inc
	ca65 -o main.o main.s -l main.lst

###

clean:	
	rm -f *~ *.o *.lst e7_test.e7 rom_tool rom_bank?.bin
