MEMORY {
	ROM: start = $F800, size = $40, file = %O;
}

SEGMENTS {
CODE: load = ROM, type = ro, align=$10;
#RODATA: load = RAM, type = ro;
#DATA: load = RAM, type = rw;
#BSS: load = RAM, type = bss, define = yes;
#ZEROPAGE: load = ZP, type = zp;
#IRQ_VECTORS: load = ROM, type=ro, offset=$3FA;
}
