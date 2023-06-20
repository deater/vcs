LINKER_SCRIPT = ../../linker_script

all:	vcs_desire_pal.bin vcs_desire_ntsc.bin

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
	zip -r vcs_desire.zip demosplash2022_vcs_desire


###

vcs_desire_pal.bin:	vcs_desire_pal.o
	ld65 -o vcs_desire_pal.bin vcs_desire_pal.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

vcs_desire_pal.o:	vcs_desire.s \
	zp.inc \
	main_kernel.s adjust_sprites.s \
	logo_kernel.s desire_logo.inc credits.inc \
	raster_kernel.s firework_kernel.s parallax_kernel.s \
	bitmap_kernel.s bitmap.inc \
	deetia2_player.s deetia2_trackdata.s
	ca65 -o vcs_desire_pal.o vcs_desire.s -l vcs_desire_pal.lst

###

vcs_desire_ntsc.bin:	vcs_desire_ntsc.o
	ld65 -o vcs_desire_ntsc.bin vcs_desire_ntsc.o -C $(LINKER_SCRIPT)/atari2600_f000.inc

vcs_desire_ntsc.o:	vcs_desire.s \
	zp.inc \
	main_kernel.s adjust_sprites.s \
	logo_kernel.s desire_logo.inc credits.inc \
	raster_kernel.s firework_kernel.s parallax_kernel.s \
	bitmap_kernel.s bitmap.inc \
	deetia2_player.s deetia2_trackdata.s
	ca65 -o vcs_desire_ntsc.o vcs_desire.s -DVCS_NTSC=1 -l vcs_desire_ntsc.lst

###

clean:	
	rm -f *~ *.o *.lst vcs_desire_pal.bin vcs_desire_ntsc.bin


