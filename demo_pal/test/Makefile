LINKER_SCRIPT = ../../linker_script

all:	tia_spirit.bin

###

tia_spirit.bin:	tia_spirit.o
	ld65 -o tia_spirit.bin tia_spirit.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

tia_spirit.o:	tia_spirit.s \
	zp.inc
	ca65 -o tia_spirit.o tia_spirit.s -l tia_spirit.lst

#	title_screen.s common_routines.s tia_spirit_scene.s \
#	tia_spirit3_graphics.inc tia_spirit4_graphics.inc \
#	tia_spirit5_graphics.inc tia_spirit6_graphics.inc \

###

clean:	
	rm -f *~ *.o *.lst tia_spirit.bin


