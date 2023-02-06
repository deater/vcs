LINKER_SCRIPT = ../../linker_script

all:	diagonal.rom

###

diagonal.rom:	diagonal.o
	ld65 -o diagonal.rom diagonal.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

diagonal.o:	diagonal.s
	ca65 -o diagonal.o diagonal.s -l diagonal.lst

###

clean:	
	rm -f *~ *.o *.lst diagonal.rom


