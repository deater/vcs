; Using background color $00
;bearshark_colors:
;	.byte $06,$06,$06,$06,$06,$06,$06,$06
;	.byte $06,$06,$06,$06,$06,$06,$06,$06
;	.byte $06,$06,$06,$06,$06,$06,$06,$06
;	.byte $06,$06,$06,$24,$24,$24,$24,$24
;	.byte $24,$24,$24,$24,$24,$24,$24,$24
;	.byte $00,$00,$C8,$C8,$C8,$C8,$C8,$00

;bearshark_playfield0_left:
;	.byte $00,$00,$00,$00,$00,$00,$00,$00
;	.byte $00,$00,$00,$00,$00,$00,$00,$00
;	.byte $00,$00,$00,$00,$00,$00,$00,$00
;	.byte $00,$00,$00,$00,$00,$00,$00,$00
;	.byte $00,$00,$00,$00,$00,$00,$00,$00
;	.byte $00,$00

game_over_playfield0_left:
.byte	$80,$40,$40,$40,$C0,$00

bearshark_playfield1_left:
	.byte $00,$00,$00,$00,$00,$00,$00,$80
	.byte $C0,$C0,$66,$7F,$7F,$3E,$3E,$3E
	.byte $3C,$31,$31,$31,$31,$31,$21,$21
	.byte $21,$21,$21,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00

game_over_playfield1_left:
.byte $92,$2B,$3A,$AA,$AA,$00

bearshark_playfield2_left:
	.byte $40,$40,$60,$60,$60,$60,$E0,$F0
	.byte $F0,$F0,$F0,$FF,$FB,$FB,$FD,$FD
	.byte $03,$03,$03,$DB,$EB,$FB,$F3,$DB
	.byte $DB,$3B,$5B,$5B,$47,$57,$A7,$B7
	.byte $AE,$1E,$FC,$FC,$F8,$F8,$F8,$F8
	.byte $00,$00

game_over_playfield2_left:
.byte	$74,$16,$35,$14,$74,$00

bearshark_playfield0_right:
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	.byte $00,$00,$60,$40,$70,$30,$60,$60
	.byte $70,$40,$50,$50,$50,$50,$A0,$A0
	.byte $C0,$E0,$F0,$F0,$F0,$F0,$F0,$F0
	.byte $00,$00

game_over_playfield0_right:
	.byte $00,$80,$80,$80,$00,$00

.align $100

bearshark_playfield1_right:
	.byte $00,$00,$00,$00,$00,$00,$42,$42
	.byte $24,$DB,$CB,$DF,$F8,$DF,$1F,$00
	.byte $60,$70,$70,$70,$70,$F0,$F0,$F0
	.byte $F0,$F0,$F0,$F0,$F0,$E0,$E0,$E0
	.byte $C0,$80,$80,$80,$80,$80,$80,$80
	.byte $00,$00


game_over_playfield1_right:
	.byte $95,$55,$55,$49,$89,$00

bearshark_playfield2_right:

	.byte $00,$00,$00,$00,$00,$00,$00,$30
	.byte $2F,$2B,$2A,$0A,$15,$15,$1F,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00

game_over_playfield2_right:
	.byte $1B,$28,$19,$28,$2B,$00
