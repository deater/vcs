; Myst for Atari 2600

; For E7 bank-switched cartridge (16k ROM, 2k RAM)

;	1FE0 - 1FE6 activates that bank of ROM into $1000-$17FF
;	1FE7 activates 1k of RAM instead (1000-13FF is write, 1400-17ff read)
;	1FE8 - 1FEB activates which 256B RAM shows up at $1800/$1900
;	1A00 - 1FDF ROM always visible

; by Vince `deater` Weaver <vince@deater.net>


.incbin	"locations/rom_bank0.bin"
.incbin	"locations/rom_bank1.bin"
.incbin	"zero.bin"
.incbin	"zero.bin"
.incbin	"zero.bin"
.incbin	"zero.bin"
.incbin	"intro/rom_bank6.bin"
.incbin	"zero2.bin"
.incbin	"main.bin"
