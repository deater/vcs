; Monkey Island for Atari 2600

; For E0 bank-switched cartridge (8k ROM)
;
; There are 4 1k banks of ROM
;   $1000-$13FF -- acccess $1FE0-$1FE7
;   $1400-$17FF -- acccess $1FE8-$1FEF
;   $1800-$18FF -- acccess $1FF0-$1FF7
;   $1C00-$1FFF -- this is fixed to last 1k ROM bank

; by Vince `deater` Weaver <vince@deater.net>

.incbin	"part0_opener/opener.bin"	; 0k+1k
.incbin "part1_title/title.bin"		; 2k,3k,4k
.incbin "zero.bin"	; 5k
.incbin "zero.bin"	; 6k
.incbin "main.bin"	; 7k
