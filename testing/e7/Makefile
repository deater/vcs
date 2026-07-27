LINKER_SCRIPT = ../../linker_script
CALC_ADDRESS = ../../utils/calc_address
ROM_TOOL = ../../utils/rom_tool

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

rom_bank0.bin:	$(ROM_TOOL)
	$(ROM_TOOL) 0 > rom_bank0.bin

rom_bank1.bin:	$(ROM_TOOL)
	$(ROM_TOOL) 1 > rom_bank1.bin

rom_bank2.bin:	$(ROM_TOOL)
	$(ROM_TOOL) 2 > rom_bank2.bin

rom_bank3.bin:	$(ROM_TOOL)
	$(ROM_TOOL) 3 > rom_bank3.bin

rom_bank4.bin:	$(ROM_TOOL)
	$(ROM_TOOL) 4 > rom_bank4.bin

rom_bank5.bin:	$(ROM_TOOL)
	$(ROM_TOOL) 5 > rom_bank5.bin

rom_bank6.bin:	$(ROM_TOOL)
	$(ROM_TOOL) 6 > rom_bank6.bin

###

zero_2k.bin:	
	dd if=/dev/zero of=zero_2k.bin bs=1k count=2

###

zero_512.bin:	
	dd if=/dev/zero of=zero_512.bin bs=256 count=2


###

main.bin:	main.o
	ld65 -o main.bin main.o -C $(LINKER_SCRIPT)/atari2600_1a00_e7.inc

main.o:	main.s zp.inc e7_title.inc title_screen.s common_routines.s \
	update_numbers.s print_numbers.s number_font.inc rom_tests.s \
	ram_tests.s write_ram.s
	ca65 -o main.o main.s -l main.lst

###

clean:	
	rm -f *~ *.o *.lst e7_test.e7 rom_bank?.bin
