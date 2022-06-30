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

VSYNC	=	$00	; reset beam to top (2 to start, 0 done after 3 lines)
VBLANK	=	$01	; turn off beam (write 2 to turn off, 0 to turn on)
WSYNC	=	$02	; sleep until beginning of next scanline
RSYNC	=	$03
NUSIZ0	=	$04
NUSIZ1	=	$05
COLUP0	=	$06
COLUP1	=	$07
COLUPF	=	$08
COLUBK	=	$09	; color/luminosity/background
CTRLPF	=	$0A
REFP0	=	$0B
REFP1	=	$0C
PF0	=	$0D
PF1	=	$0E
PF2	=	$0F
RESP0	=	$10
RESP1	=	$11
RESM0	=	$12
RESM1	=	$13
RESBL	=	$14	; reset ball
AUDC0	=	$15
AUDC1	=	$16
AUDF0	=	$17
AUDF1	=	$18
AUDV0	=	$19
AUDV1	=	$1A
GRP0	=	$1B
GRP1	=	$1C
ENAM0	=	$1D
ENAM1	=	$1E
ENABL	=	$1F

