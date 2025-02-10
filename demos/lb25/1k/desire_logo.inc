; png2pf -g -y 34 -n desire desire3_flipped_ntsc.png ntsc.out

desire_bg_colors:
	.byte $80,$80,$60,$60,$60,$62,$62,$60
	.byte $62,$60,$F8,$48,$F8,$F8,$FA,$F8
	.byte $FA,$FA,$FA,$FA,$F8,$FA,$F8,$F8
	.byte $50,$64,$64,$62,$64,$62,$62,$60
	.byte $60,$60
desire_colors:
	.byte $00,$00,$44,$44,$46,$46,$24,$24
	.byte $48,$48,$60,$50,$60,$50,$50,$42
	.byte $50,$42,$42,$42,$50,$50,$50,$64
	.byte $48,$F8,$48,$48,$24,$24,$46,$46
	.byte $42,$42

desire_playfield0_left:
	.byte $00,$00,$C0,$C0,$C0,$C0,$E0,$E0
	.byte $E0,$E0,$80,$80,$80,$80,$80,$80
	.byte $80,$80,$80,$80,$80,$80,$80,$00
	.byte $E0,$E0,$E0,$E0,$C0,$C0,$C0,$C0
	.byte $80,$00
desire_playfield1_left:
	.byte $00,$00,$FC,$FD,$FD,$FF,$BF,$1F
	.byte $1F,$1F,$E0,$E0,$E0,$E0,$E0,$E0
	.byte $E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0
	.byte $1F,$1F,$BF,$FF,$FF,$FF,$FD,$FD
	.byte $FD,$DC
desire_playfield2_left:
	.byte $00,$00,$8F,$DF,$DF,$FF,$FF,$F9
	.byte $F8,$F8,$AF,$AE,$FC,$F8,$F0,$60
	.byte $40,$00,$01,$03,$07,$07,$07,$07
	.byte $F8,$F8,$FD,$FF,$DF,$DF,$CF,$CF
	.byte $8F,$87
desire_playfield0_right:
	.byte $00,$00,$70,$F0,$F0,$F0,$F0,$E0
	.byte $C0,$C0,$30,$30,$30,$30,$10,$00
	.byte $00,$00,$00,$80,$80,$E0,$F0,$F0
	.byte $80,$80,$C0,$C0,$D0,$F0,$F0,$F0
	.byte $F0,$70

desire_playfield1_right:
	.byte $00,$00,$F8,$F8,$F8,$F8,$F8,$F8
	.byte $F8,$F8,$06,$06,$06,$06,$06,$06
	.byte $06,$06,$06,$06,$06,$06,$06,$06
	.byte $FD,$FD,$FF,$FF,$FF,$BF,$BF,$3F
	.byte $7B,$FB
desire_playfield2_right:
	.byte $00,$00,$3C,$7E,$7E,$FF,$FF,$E7
	.byte $E3,$63,$BC,$B8,$F0,$E0,$C0,$80
	.byte $00,$00,$04,$0C,$1C,$1C,$1C,$1C
	.byte $E3,$63,$77,$7F,$7F,$7F,$3F,$3F
	.byte $3F,$1C
