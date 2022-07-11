LINKER_SCRIPT = ../linker_script

all:	sc.rom

###

sc.rom:	sc.o
	ld65 -o sc.rom sc.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

sc.o:	sc.s
	ca65 -o sc.o sc.s -l sc.lst

###

clean:	
	rm -f *~ *.o *.lst sc.rom


