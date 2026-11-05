LINKER_SCRIPT = ../../../linker_script
CALC_ADDRESS = ../../../utils/calc_address
PNG2PF = ../../../../utils/png2pf
PNG2SPRITE = ../../../../utils/png2sprite

all:	irix_pf.inc teapot0.inc


###

teapot0.inc:	teapot0.png
	$(PNG2SPRITE) -f -n teapot_sprite -s 0 -l 84 -w 2 -r 2 teapot0.png teapot0.inc

###

irix_pf.inc:	irix_2600_pf.png
	$(PNG2PF) -a -y 128 -b 0xa8 -n irix irix_2600_pf.png irix_pf.inc

###

clean:	
	rm -f *~ *.o *.lst irix_pf.inc teapot0.inc

