MEMORY {
	ROM: start = $C000, size = $2000, file = %O;
}

SEGMENTS {
CODE: load = ROM, type = ro, align=$100;
#RODATA: load = RAM, type = ro;
#DATA: load = RAM, type = rw;
#BSS: load = RAM, type = bss, define = yes;
#ZEROPAGE: load = ZP, type = zp;
#IRQ_VECTORS: load = ROM, type=ro, offset=$FFA;
}
