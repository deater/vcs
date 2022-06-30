; Notes: for NTSC it's 160x192 pixels?
;	TIA: 160 pixels + 68 retrace
;	6502: 76 cycles per scanline
; 3 vertical sync / 37 VBLANK / 192 drawing / 30 overscan
; TIA: background, playfield, 2 sprites, 2 missiles, ball

; Memory Map
;	$00-$7F = TIA
;	$80-$FF = RAM
;	$180-$1FF (mirrored $80-$FF) can also be used as STACK 
;	$280-$2FF = RIOT
;	$1000-$1FFF = ROM (also mirrored at $F000-$FFFF)

VSYNC	=	$00	; reset to top?
VBLANK	=	$01
WSYNC	=	$02	; sleep until beginning of next scanline
COLUBK	=	$09	; color/luminosity/background
PF0	=	$0D
PF1	=	$0E
PF2	=	$0F
