MEMORY {
	ROM: start = $FCE0, size = $20, file = %O;
}

SEGMENTS {
CODE: load = ROM, type = ro, align=$10;
#RODATA: load = RAM, type = ro;
#DATA: load = RAM, type = rw;
#BSS: load = RAM, type = bss, define = yes;
#ZEROPAGE: load = ZP, type = zp;
#IRQ_VECTORS: load = ROM, type=ro, offset=$3FA;
}
