; Using background color $06

frame5_playfield2_left:
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $C0,$F0,$F8,$FC,$FC,$FC,$FC,$7C
	.byte $7C,$7C,$7C,$7C,$7C,$7C,$7C,$7C
	.byte $7E,$7E,$7E,$7E,$74,$7C,$7C,$7C

frame5_playfield0_right:
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$C0,$C0
	.byte $F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	.byte $F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	.byte $F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0

frame5_playfield1_right:
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$80
	.byte $C0,$F0,$F8,$F8,$F8,$F8,$F8,$F8
	.byte $F8,$F8,$FC,$FC,$FE,$FE,$FF,$FF
	.byte $FF,$FF,$FF,$FF,$F7,$FF,$FF,$F0

;frame5_playfield2_right:
;	.byte $00,$00,$00,$00,$00,$00,$00,$00
;	.byte $00,$00,$00,$00,$00,$00,$00,$00
;	.byte $00,$00,$00,$00,$00,$00,$00,$00
;	.byte $00,$00,$00,$00,$00,$00,$00,$00
;	.byte $00,$00,$00,$00,$00,$00,$00,$00
;	.byte $00,$00,$00,$00,$00,$00,$00,$00

; Using background color $00
frame5_1_overlay_colors:
	.byte $00,$00,$00,$00,$26,$3A,$F2,$F2
	.byte $F2,$F2,$F2,$F2,$24,$4A,$48,$48
	.byte $48,$46,$48,$48,$24,$48,$48,$48
	.byte $48,$0A,$0A,$0A,$0A,$0A,$0A,$0A
	.byte $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
	.byte $0A,$0A,$0A,$48,$4A,$48,$48,$48

frame5_1_overlay_sprite:
	.byte $00,$00,$00,$00,$08,$18,$15,$19
	.byte $0F,$11,$11,$11,$1B,$25,$39,$3D
	.byte $19,$0C,$18,$18,$18,$18,$1C,$1C
	.byte $00,$24,$24,$24,$20,$24,$00,$0C
	.byte $00,$0C,$00,$08,$00,$08,$00,$08
	.byte $00,$08,$00,$40,$E0,$E0,$E0,$E0
; Using background color $00
frame5_2_overlay_colors:
	.byte $00,$00,$00,$00,$38,$F2,$F0,$F0
	.byte $24,$48,$4A,$4A,$48,$38,$4C,$4A
	.byte $4A,$48,$4A,$4A,$48,$4A,$0A,$0A
	.byte $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
	.byte $0A,$0A,$0A,$0A,$4A,$48,$48,$48
	.byte $48,$48,$48,$0A,$E0,$0A,$E0,$E0

frame5_2_overlay_sprite:
	.byte $00,$00,$00,$00,$10,$18,$28,$18
	.byte $40,$38,$38,$38,$10,$68,$18,$08
	.byte $18,$48,$18,$10,$10,$10,$08,$08
	.byte $78,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$06,$07,$07,$07
	.byte $07,$03,$01,$20,$0F,$20,$1F,$1F