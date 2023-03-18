bushes_bg_colors:
	.byte $AE,$AE,$AE,$AE,$AE,$AE,$0E,$0E
	.byte $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
	.byte $0E,$AE,$AE,$AE,$AE,$AE,$AE,$AE
	.byte $AE,$AE,$AE,$AE,$C2,$C2,$C2,$C2
	.byte $C2,$C2,$C2,$C2,$C2,$C2,$C2,$C2
	.byte $C2,$C2,$C2,$C2,$C2,$C2,$C2,$C2
	.byte $C2,$C2,$C2,$C2,$D0,$D0,$D0,$D0
	.byte $D0,$D0,$D0,$C2
strongbadia_bg_colors:
;	.byte $D4,$D4,$D4,$D4
;	.byte $D4,$D4,$D4,$D4,$D4,$D4,$D4,$D4
;	.byte $D4,$D4,$D4,$D4,$D4,$D4,$D4,$D4
;	.byte $D4,$D4,$D4,$D4,$D4,$D4,$D4,$D4
;	.byte $D4,$D4,$D4,$D4,$D4,$D4,$D4,$D4
;	.byte $D4,$D4,$D4,$D4,$D4,$D4,$D4,$D4
;	.byte $D4,$D4,$D4,$D4,$D4,$D4,$D4,$D4

bushes_colors:
	.byte $0E,$0E,$0E,$0E,$0E,$0E,$AE,$AE
	.byte $AE,$AE,$AE,$AE,$AE,$AE,$AE,$AE
	.byte $AE,$0E,$00,$00,$00,$00,$00,$00
	.byte $C2,$C2,$C2,$C2,$AE,$AE,$AE,$AE
	.byte $AE,$AE,$AE,$AE,$AE,$AE,$AE,$AE
	.byte $AE,$AE,$AE,$AE,$00,$D0,$D0,$D0
	.byte $D0,$D0,$D0,$D0,$00,$00,$00,$C2
	.byte $C2,$C2,$C2,$00

strongbadia_colors:
	.byte $0E,$0E,$0E,$0E
	.byte $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
	.byte $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
	.byte $0E,$0E,$00,$F0,$F0,$F0,$F0,$F0
	.byte $F0,$00,$20,$20,$20,$20,$20,$20
	.byte $20,$00,$30,$30,$30,$30,$30,$30
	.byte $30,$30,$00,$00


bushes_playfield0_left:
	.byte $80,$80,$C0,$C0,$E0,$E0,$00,$00
	.byte $00,$80,$80,$80,$C0,$C0,$C0,$E0
	.byte $E0,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$E0,$E0,$E0,$E0
	.byte $C0,$C0,$C0,$C0,$C0,$C0,$40,$40
	.byte $40,$00,$00,$00,$00,$00,$00,$40
	.byte $40,$40,$40,$E0,$00,$00,$00,$80
	.byte $C0,$C0,$E0,$00

strongbadia_playfield0_left:
;	.byte $00,$00,$00,$00
;	.byte $00,$00,$00,$00,$00,$00,$00,$00
;	.byte $00,$00,$00,$00,$00,$00,$00,$00
;	.byte $00,$00,$00,$00,$00,$00,$00,$00
;	.byte $00,$00,$00,$00,$00,$00,$00,$00
;	.byte $00,$00,$00,$00,$00,$00,$00,$00
;	.byte $00,$00,$00,$00,$00,$00,$00,$00

bushes_playfield1_left:
	.byte $F9,$FF,$FF,$FF,$FF,$BF,$F0,$F0
	.byte $F8,$F9,$F9,$F9,$FF,$FF,$FF,$FF
	.byte $FF,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$DF,$DF,$8F,$8E
	.byte $8E,$8C,$84,$84,$84,$84,$84,$84
	.byte $04,$04,$04,$04,$00,$01,$01,$09
	.byte $89,$89,$8F,$9F,$00,$00,$00,$8F
	.byte $DF,$FF,$FF,$00

strongbadia_playfield1_left:
	.byte $00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$03,$03,$03,$03,$03,$03
	.byte $03,$07,$07,$07,$07,$07,$07,$07
	.byte $07,$0F,$0F,$0F,$0F,$0F,$0F,$0F
	.byte $0F,$0F,$00,$00 ;,$00,$00,$00,$00

bushes_playfield2_left:
	.byte $0F,$1F,$1F,$3F,$3F,$7F,$86,$0F
	.byte $0F,$1F,$1F,$1F,$3F,$3F,$3F,$7F
	.byte $7F,$80,$00,$00,$00,$00,$00,$00
	.byte $C0,$C0,$C0,$C0,$3F,$1E,$1E,$0C
	.byte $0C,$0C,$0C,$0C,$0C,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$02,$42
	.byte $42,$CB,$CB,$EB,$00,$00,$00,$01
	.byte $03,$FF,$FF,$00

strongbadia_playfield2_left:
	.byte $F8,$F8,$F8,$F8
	.byte $F8,$F8,$F8,$F8,$F8,$F8,$F8,$F8
	.byte $F8,$F8,$F8,$F8,$F8,$F8,$F8,$F8
	.byte $F8,$F8,$FF,$FF,$FF,$FF,$FF,$FF
	.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	.byte $FF,$FF,$00,$00;,$00,$00,$00,$00


sbadia_overlay_colors:
	.byte $00
	.byte $40,$40,$0E,$0E,$f0,$f0,$12,$12
	.byte $12,$12,$12,$12,$12,$12,$12,$12
	.byte $12,$12,$12

below_fence_colors:
	.byte $00
	.byte $00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$0E,$0A,$08,$08,$06,$06,$06
	.byte $00,$00,$00

sbadia_overlay_sprite:
	.byte $00
	.byte $FF,$FF,$E7,$E7,$FB,$FF,$80,$80
	.byte $80,$40,$40,$40,$40,$40,$80,$80
	.byte $80,$80,$80

below_fence_sprite:
	.byte $00
	.byte $00,$00,$00,$3C,$7E
	.byte $77,$E7,$EF,$FE,$7E,$3C,$00,$00
	.byte $00,$1E,$21,$41,$99,$81,$42,$7D
	.byte $00,$00,$00
