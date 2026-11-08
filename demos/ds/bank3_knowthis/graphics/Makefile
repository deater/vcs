LINKER_SCRIPT = ../../../linker_script
CALC_ADDRESS = ../../../utils/calc_address
PNG2PF = ../../../../utils/png2pf
PNG2SPRITE = ../../../../utils/png2sprite

all:	ikt_pf.inc


###

ikt_pf.inc:	ikt_pf.png
	$(PNG2PF) -a -2 -b 0x00 -n ikt ikt_pf.png ikt_pf.inc

###

clean:	
	rm -f *~ *.o *.lst ikt_pf.inc

