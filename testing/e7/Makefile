LINKER_SCRIPT = ../../linker_script
CALC_ADDRESS = ./utils/calc_address

all:	e7_test.e7

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

rom_bank0.bin:	zero_2k.bin
	cp zero_2k.bin rom_bank0.bin

rom_bank1.bin:	zero_2k.bin
	cp zero_2k.bin rom_bank1.bin

rom_bank2.bin:	zero_2k.bin
	cp zero_2k.bin rom_bank2.bin

rom_bank3.bin:	zero_2k.bin
	cp zero_2k.bin rom_bank3.bin

rom_bank4.bin:	zero_2k.bin
	cp zero_2k.bin rom_bank4.bin

rom_bank5.bin:	zero_2k.bin
	cp zero_2k.bin rom_bank5.bin

rom_bank6.bin:	zero_2k.bin
	cp zero_2k.bin rom_bank6.bin



###

zero_2k.bin:	
	dd if=/dev/zero of=zero_2k.bin bs=1k count=2

###

zero_512.bin:	
	dd if=/dev/zero of=zero_512.bin bs=256 count=2

###

main.bin:	main.o
	ld65 -o main.bin main.o -C $(LINKER_SCRIPT)/atari2600_1a00_e7.inc

main.o:	main.s zp.inc
	ca65 -o main.o main.s -l main.lst

###

clean:	
	rm -f *~ *.o *.lst e7_test.e7



