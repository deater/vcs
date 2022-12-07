LINKER_SCRIPT = ../../linker_script

all:	main.bin

###

main.bin:	main.o
	ld65 -o main.bin main.o -C $(LINKER_SCRIPT)/atari2600_fc00.inc

main.o:	main.s ../zp.inc common_routines.s
	ca65 -o main.o main.s -l main.lst

###

clean:	
	rm -f *~ *.o *.lst main.bin


