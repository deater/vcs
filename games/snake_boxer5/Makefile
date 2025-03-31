LINKER_SCRIPT = ../../linker_script

all:	snake_boxer5.bin

###

snake_boxer5.bin:	title/vid_title.bin gameplay/gameplay.bin
	cat title/vid_title.bin > snake_boxer5.bin
	cat gameplay/gameplay.bin >> snake_boxer5.bin


###

title/vid_title.bin:
	cd title && make

gameplay/gameplay.bin:
	cd gameplay && make

###

clean:	
	rm -f *~ *.o *.lst snake_boxer5.bin gameplay.bin
	cd title && make clean
	cd gameplay && make clean
