; Using background color $00
lookout_colors:
	.byte $02,$00,$02,$7E,$02,$7E,$02,$00
	.byte $02,$7E,$02,$00,$02,$A0,$02,$A0
	.byte $02,$A0,$0E,$A0,$02,$A0,$02,$A0
	.byte $0E,$A0,$02,$92,$02,$92,$02,$92
	.byte $02,$92,$00,$90,$A0,$84,$A0,$84
	.byte $A0,$84,$A0,$84,$A0,$84,$A0,$84
	.byte $A0,$84,$A0,$84,$A0,$84,$A0,$84
	.byte $A0,$84,$A0,$86,$A0,$86,$A0,$96
	.byte $A0,$98,$A0,$A6,$A0,$A6,$A0,$A8


lookout_playfield0_left:
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$F0,$00,$F0
	.byte $00,$F0,$40,$F0,$00,$F0,$00,$F0
	.byte $00,$F0,$00,$F0,$00,$F0,$00,$F0
	.byte $00,$F0,$00,$F0,$00,$F0,$00,$F0
	.byte $00,$F0,$00,$F0,$00,$F0,$00,$F0
	.byte $00,$F0,$00,$F0,$00,$F0,$80,$70
	.byte $C0,$30,$80,$30,$A0,$10,$A0,$10
	.byte $20,$10,$A0,$10,$A0,$10,$A0,$10

lookout_playfield1_left:
	.byte $00,$00,$00,$02,$00,$40,$00,$00
	.byte $00,$10,$00,$00,$00,$FF,$00,$FF
	.byte $00,$FF,$00,$FF,$00,$FF,$00,$FF
	.byte $10,$FE,$00,$FE,$00,$FE,$00,$FC
	.byte $00,$FE,$00,$FC,$00,$FE,$00,$F8
	.byte $04,$F0,$00,$E0,$0C,$E3,$0C,$C0
	.byte $1A,$C0,$37,$80,$BE,$00,$B1,$00
	.byte $AF,$00,$AB,$00,$D2,$00,$1A,$00
	.byte $05,$00,$05,$00,$0A,$00,$0A,$00

.align $100

lookout_playfield2_left:
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$FF,$00,$FF
	.byte $00,$FF,$02,$FF,$00,$FF,$01,$FE
	.byte $20,$FC,$02,$FC,$02,$FC,$00,$FC
	.byte $00,$EC,$00,$EC,$EC,$00,$C8,$00
	.byte $C8,$00,$C8,$00,$00,$C8,$00,$FF
	.byte $FE,$00,$10,$00,$2A,$80,$29,$80
	.byte $C7,$00,$97,$00,$FC,$00,$FD,$00
	.byte $56,$00,$52,$00,$4A,$00,$4B,$00

lookout_playfield0_right:
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$F0,$00,$F0
	.byte $00,$F0,$00,$F0,$00,$F0,$00,$F0
	.byte $00,$F0,$00,$F0,$00,$F0,$00,$F0
	.byte $00,$10,$00,$F0,$F0,$00,$F0,$00
	.byte $C0,$10,$80,$30,$A0,$10,$C0,$10
	.byte $90,$00,$D0,$00,$00,$10,$00,$F0
	.byte $C0,$00,$40,$00,$B0,$00,$30,$00
	.byte $E0,$00,$30,$00,$20,$00,$60,$00

lookout_playfield1_right:
	.byte $1D,$00,$24,$00,$1B,$00,$2B,$00
	.byte $6B,$00,$50,$00,$60,$8F,$00,$8F
	.byte $E0,$0F,$00,$8F,$E0,$0F,$00,$8F
	.byte $04,$0F,$F0,$0F,$00,$8E,$E0,$00
	.byte $F0,$0E,$00,$8F,$0F,$F0,$8F,$00
	.byte $01,$EE,$0E,$E1,$F0,$0F,$E7,$18
	.byte $F0,$0F,$F9,$06,$F0,$0F,$7F,$80
	.byte $FF,$00,$F7,$08,$77,$08,$D3,$0C
	.byte $73,$0C,$F3,$0C,$70,$0A,$85,$0A

.align $100

lookout_playfield2_right:
	.byte $0D,$00,$17,$00,$3C,$00,$72,$00
	.byte $8A,$00,$F8,$00,$28,$07,$D0,$0F
	.byte $E0,$0F,$01,$0F,$40,$03,$E0,$03
	.byte $00,$01,$40,$01,$60,$02,$00,$04
	.byte $E0,$06,$00,$1F,$1F,$00,$1F,$E0
	.byte $1F,$E0,$1E,$01,$1E,$E1,$1F,$E0
	.byte $1C,$03,$1F,$60,$1F,$E0,$3F,$C0
	.byte $FF,$00,$FB,$04,$FB,$04,$F3,$0C
	.byte $73,$0C,$8B,$14,$80,$14,$0B,$14

