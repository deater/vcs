;====================================
; game over data
;====================================

go_playfield0_left:
	.byte $60,$90,$10,$D0,$90,$90,$60,$00,$00

go_playfield1_left:
	.byte $24,$56,$55,$74,$54,$54,$54,$00,$00

go_playfield2_left:
	.byte $3A,$0B,$0A,$3A,$0A,$0A,$3A,$00,$00

go_playfield1_right:
	.byte $4A,$AA,$AA,$AA,$AA,$A4,$44,$00,$00

go_playfield2_right:
	.byte $77,$51,$51,$73,$31,$51,$57,$00,$00

.align $100

; sprite, open mouth
game_overlay_top:
	.byte $01,$01,$02,$02,$64,$64,$F8,$F8
	.byte $D0,$D0,$70,$70,$78,$78,$24,$24
	.byte $22,$22,$71,$71
game_overlay_common:
	.byte $78,$78,$FC,$FC			; note duplicate 28 bytes
	.byte $FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE
	.byte $7C,$7C,$38,$38,$10,$10,$1F,$1F
	.byte $01,$01,$07,$07;,$00,$00,$00,$00

; sprite, close mouth
game_overlay2_top:
	.byte $00,$00,$00,$00,$60,$60,$F0,$F0
	.byte $DF,$DF,$70,$70,$70,$70,$20,$20
	.byte $20,$20,$70,$70
;game_overlay2_common:
;	.byte $78,$78,$FC,$FC
;	.byte $FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE
;	.byte $7C,$7C,$38,$38,$10,$10,$1F,$1F
;	.byte $01,$01,$07,$07,$00,$00,$00,$00


