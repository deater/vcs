# 1FE0 - 1FEF reserved for bankswitching
MEMORY {
	ROM: start = $1a00, size = $600, file = %O;
}

SEGMENTS {
CODE: load = ROM, type = ro, align=$100;
#RODATA: load = RAM, type = ro;
#DATA: load = RAM, type = rw;
#BSS: load = RAM, type = bss, define = yes;
#ZEROPAGE: load = ZP, type = zp;
BANKSWITCH: load = ROM, type=ro, offset=$5E0;
IRQ_VECTORS: load = ROM, type=ro, offset=$5FA;
}
