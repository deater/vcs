; e7_test 2 for Atari 2600

; this creates the final ROM image after segments were
;	created separtely

; For E7 bank-switched cartridge (16k ROM, 2k RAM)

;	1FE0 - 1FE6 activates that bank of ROM into $1000-$17FF
;	1FE7 activates 1k of RAM instead (1000-13FF is write, 1400-17ff read)
;	1FE8 - 1FEB activates which of 4 256B RAM banks show up at $1800/$1900
;	1A00 - 1FDF ROM always visible

; by Vince `deater` Weaver <vince@deater.net>


.incbin	"rom_bank0.bin"			; 2k
.incbin	"rom_bank1.bin"			; 2k
.incbin	"rom_bank2.bin"			; 2k
.incbin	"rom_bank3.bin"			; 2k
.incbin	"rom_bank4.bin"			; 2k
.incbin	"rom_bank5.bin"			; 2k
.incbin	"rom_bank6.bin"			; 2k
.incbin	"zero_512.bin"			; 512 bytes
.incbin	"main.bin"			; 1.5k
