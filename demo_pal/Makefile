LINKER_SCRIPT = ../linker_script

all:	vcs_desire.bin

###

vcs_desire.bin:	vcs_desire.o
	ld65 -o vcs_desire.bin vcs_desire.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

vcs_desire.o:	vcs_desire.s \
	zp.inc \
	main_kernel.s \
	logo_kernel.s desire_logo.inc \
	raster_kernel.s \
	bitmap_kernel.s bitmap.inc \
	tia_spirit_player.s tia_spirit_trackdata.s
	ca65 -o vcs_desire.o vcs_desire.s -l vcs_desire.lst


###

clean:	
	rm -f *~ *.o *.lst vcs_desire.bin


