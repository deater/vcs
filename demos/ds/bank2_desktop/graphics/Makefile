LINKER_SCRIPT = ../../../linker_script
CALC_ADDRESS = ../../../utils/calc_address
PNG2PF = ../../../../utils/png2pf
PNG2SPRITE = ../../../../utils/png2sprite

all:	irix_pf.inc \
	teapot0.inc teapot1.inc teapot2.inc teapot3.inc \
	teapot4.inc teapot5.inc teapot6.inc teapot7.inc


###

teapot0.inc:	teapot0.png
	$(PNG2SPRITE) -f -n teapot_sprite0 -s 0 -l 72 -w 2 -r 2 teapot0.png teapot0.inc

teapot1.inc:	teapot1.png
	$(PNG2SPRITE) -f -n teapot_sprite1 -s 0 -l 72 -w 2 -r 2 teapot1.png teapot1.inc

teapot2.inc:	teapot2.png
	$(PNG2SPRITE) -f -n teapot_sprite2 -s 0 -l 72 -w 2 -r 2 teapot2.png teapot2.inc

teapot3.inc:	teapot3.png
	$(PNG2SPRITE) -f -n teapot_sprite3 -s 0 -l 72 -w 2 -r 2 teapot3.png teapot3.inc

teapot4.inc:	teapot4.png
	$(PNG2SPRITE) -f -n teapot_sprite4 -s 0 -l 72 -w 2 -r 2 teapot4.png teapot4.inc

teapot5.inc:	teapot5.png
	$(PNG2SPRITE) -f -n teapot_sprite5 -s 0 -l 72 -w 2 -r 2 teapot5.png teapot5.inc

teapot6.inc:	teapot6.png
	$(PNG2SPRITE) -f -n teapot_sprite6 -s 0 -l 72 -w 2 -r 2 teapot6.png teapot6.inc

teapot7.inc:	teapot7.png
	$(PNG2SPRITE) -f -n teapot_sprite7 -s 0 -l 72 -w 2 -r 2 teapot7.png teapot7.inc


###

irix_pf.inc:	irix_2600_pf.png
	$(PNG2PF) -a -y 128 -b 0xa8 -n irix irix_2600_pf.png irix_pf.inc

###

clean:	
	rm -f *~ *.o *.lst irix_pf.inc teapot0.inc

