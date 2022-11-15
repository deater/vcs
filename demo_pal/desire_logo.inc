; png2pf -g -y 34 -p -n desire desire3_flipped.png out.inc


; Using background color $00
desire_bg_colors:
	.byte $10,$10,$C0,$C0,$C0,$C2,$C2,$A0
	.byte $C2,$A0,$26,$66,$26,$26,$28,$26
	.byte $28,$28,$28,$28,$26,$28,$26,$26
	.byte $80,$A4,$A4,$C2,$A4,$C2,$C2,$C0
	.byte $C0,$C0
desire_colors:
	.byte $10,$10,$62,$62,$64,$64,$44,$44
	.byte $66,$66,$A0,$80,$A0,$80,$80,$60
	.byte $80,$60,$60,$60,$80,$80,$80,$A4
	.byte $66,$26,$66,$66,$44,$44,$64,$64
	.byte $60,$60

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
	.byte $FF,$F8,$AF,$AE,$FC,$F8,$F0,$60
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
