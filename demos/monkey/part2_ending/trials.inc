; Using background color $00
trials_colors:
	.byte $00,$00,$00,$00,$00,$80,$80,$80
	.byte $80,$80,$80,$80,$80,$80,$80,$80
	.byte $80,$80,$80,$80,$80,$84,$00,$00
	.byte $00,$00,$00,$80,$80,$80,$80,$80
	.byte $80,$84,$00,$00,$00,$80,$80,$80
	.byte $80,$80,$80,$84,$00,$00,$00,$00


trials_playfield0_left:
	.byte $00,$00,$00,$00,$00,$F0,$E0,$60
	.byte $60,$60,$60,$60,$60,$E0,$60,$60
	.byte $60,$60,$60,$60,$F0,$F0,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00

trials_playfield1_left:
	.byte $00,$00,$00,$00,$00,$80,$C0,$C0
	.byte $40,$40,$40,$5D,$D4,$B4,$0C,$1C
	.byte $14,$34,$24,$3E,$3E,$36,$00,$00
	.byte $00,$00,$00,$E8,$48,$4C,$4A,$4A
	.byte $4A,$4A,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00

trials_playfield2_left:
	.byte $00,$00,$00,$00,$00,$00,$00,$40
	.byte $40,$60,$72,$E7,$6F,$6F,$63,$63
	.byte $63,$63,$63,$E3,$C7,$C7,$00,$00
	.byte $00,$00,$00,$C0,$82,$85,$87,$81
	.byte $86,$86,$00,$00,$00,$07,$42,$1A
	.byte $4A,$4A,$4A,$4A,$00,$00,$00,$00

trials_playfield0_right:
	.byte $00,$00,$00,$00,$00,$00,$80,$80
	.byte $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
	.byte $C0,$C0,$80,$80,$00,$00,$00,$00
	.byte $00,$00,$00,$50,$40,$C0,$40,$40
	.byte $40,$40,$00,$00,$00,$00,$30,$40
	.byte $70,$50,$60,$60,$00,$00,$00,$00

.align $100

trials_playfield1_right:
	.byte $00,$00,$00,$00,$00,$E0,$F0,$B0
	.byte $18,$18,$18,$1B,$1F,$1A,$1A,$1A
	.byte $1A,$1A,$12,$B2,$E7,$E7,$00,$00
	.byte $00,$00,$00,$00,$02,$35,$A7,$A4
	.byte $A3,$A3,$00,$00,$00,$80,$80,$B0
	.byte $A0,$90,$B0,$B0,$00,$00,$00,$00

trials_playfield2_right:
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$01,$73,$53,$5A,$DA,$FA
	.byte $1A,$9A,$9A,$F2,$76,$76,$00,$00
	.byte $00,$00,$00,$00,$04,$0A,$0E,$02
	.byte $0C,$0C,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
