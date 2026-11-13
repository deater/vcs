LINKER_SCRIPT = ../../../linker_script
CALC_ADDRESS = ../../../utils/calc_address
PNG2PF = ../../../../utils/png2pf
PNG2SPRITE = ../../../../utils/png2sprite
PNG2OVERLAY = ../../../../utils/png2overlay

all:	desire_pf1.inc desire_pf2.inc desire_pf3.inc


###

desire_pf1.inc:	desire1.png
	$(PNG2PF) -a -g -b 0x00 -n desire1 desire1.png desire_pf1.inc

desire_pf2.inc:	desire2.png
	$(PNG2PF) -a -g -n desire2 desire2.png desire_pf2.inc

desire_pf3.inc:	desire3.png
	$(PNG2PF) -a -g -n desire3 desire3.png desire_pf3.inc


###

clean:	
	rm -f *~ *.o *.lst *.inc

