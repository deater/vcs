LINKER_SCRIPT = ../linker_script

all:	joystick.rom

###

joystick.rom:	joystick.o
	ld65 -o joystick.rom joystick.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

joystick.o:	joystick.s
	ca65 -o joystick.o joystick.s -l joystick.lst

###

clean:	
	rm -f *~ *.o *.lst joystick.rom


