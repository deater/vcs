LINKER_SCRIPT = ../linker_script

all:	vcs_desire.bin

###

submit:	vcs_desire.zip

vcs_desire.zip:	vcs_desire.bin
	mkdir -p demosplash2022_vcs_desire
	mkdir -p demosplash2022_vcs_desire/src
	cp vcs_desire.bin ./demosplash2022_vcs_desire
	cp file_id.diz ./demosplash2022_vcs_desire
	cp dsr_vcs_thumb.png ./demosplash2022_vcs_desire
	cp *.s ./demosplash2022_vcs_desire/src
	cp *.inc ./demosplash2022_vcs_desire/src
#       cp apple_desire_512.dsk ./demosplash2022_vcs_desire
#       cp apple_desire_512.woz ./demosplash2022_vcs_desire
#       cp apple_desire_720p.mp4 ./demosplash2022_vcs_desire
#       cp desire2.png ./demosplash2022_vcs_desire
	zip -r vcs_desire.zip demosplash2022_vcs_desire


###

vcs_desire.bin:	vcs_desire.o
	ld65 -o vcs_desire.bin vcs_desire.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

vcs_desire.o:	vcs_desire.s \
	zp.inc \
	main_kernel.s \
	logo_kernel.s desire_logo.inc \
	raster_kernel.s firework_kernel.s parallax_kernel.s \
	bitmap_kernel.s bitmap.inc \
	deetia2_player.s deetia2_trackdata.s
	ca65 -o vcs_desire.o vcs_desire.s -l vcs_desire.lst


###

clean:	
	rm -f *~ *.o *.lst vcs_desire.bin


