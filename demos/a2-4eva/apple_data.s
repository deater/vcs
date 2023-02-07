.align $100

; multiples of 3 except very last

colors:
	.byte $CE	;$CE,$CE,$CE
	.byte $CC	;$CC,$CC,$CC
	.byte $CA	;$CA,$CA,$CA
	.byte $C8	;$C8,$C8,$C8
	.byte $C6	;$C6,$C6,$C6
	.byte $C4	;$C4,$C4,$C4
	.byte $C2	;$C2,$C2,$C2
	.byte $C4	;$C4,$C4,$C4
	.byte $C6	;$C6,$C6,$C6
	.byte $C8	;$C8,$C8,$C8
	.byte $CA	;$CA,$CA,$CA
	.byte $CC	;$CC,$CC,$CC
	.byte $CE	;$CE,$CE,$CE
	.byte $CE	;$CE,$CE,$CE
	.byte $CC	;$CC,$CC,$CC
	.byte $CA	;$CA,$CA,$CA
	.byte $C8	;$C8,$C8,$C8
	.byte $C6	;$C6,$C6,$C6
	.byte $C4	;$C4,$C4,$C4
	.byte $C2	;$C2,$C2,$C2
	.byte $1E	;$1E,$1E,$1E
	.byte $1C	;$1C,$1C,$1C
	.byte $1A	;$1A,$1A,$1A
	.byte $18	;$18,$18,$18
	.byte $16	;$16,$16,$16
	.byte $14	;$14,$14,$14
	.byte $12	;$12,$12,$12
	.byte $2E	;$12,$2E,$2E
	.byte $2C	;$2E,$2C,$2C
	.byte $2A	;$2C,$2A,$2A
	.byte $28	;$2A,$28,$28
	.byte $26	;$28,$26,$26
	.byte $24	;$26,$24,$24
	.byte $22	;$24,$22,$22
	.byte $4E	;$22,$4E,$4E
	.byte $4C	;$4E,$4C,$4C
	.byte $4A	;$4C,$4A,$4A
	.byte $48	;$4A,$48,$48
	.byte $46	;$48,$46,$46
	.byte $44	;$46,$44,$44
	.byte $42	;$44,$42,$42
	.byte $42	;$42,$42,$5E
	.byte $5E	;$5E,$5E,$5C
	.byte $5C	;$5C,$5C,$5A
	.byte $5A	;$5A,$5A,$58
	.byte $58	;$58,$58,$56
	.byte $56	;$56,$56,$54
	.byte $54	;$54,$54,$52
	.byte $52	;$52,$52,$AE
	.byte $AE	;$AE,$AE,$AC
	.byte $AC	;$AC,$AC,$AA
	.byte $AA	;$AA,$AA,$A8
	.byte $A8	;$A8,$A8,$A6
	.byte $A6	;$A6,$A6,$A4
	.byte $A4	;$A4,$A4,$A2
	.byte $A2	;$A2,$A2,$A2
	.byte $00	;$00,$00,$00




playfield1_left:
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$01,$01,$03,$03
	.byte $03,$03,$01
playfield2_left:
	.byte $00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00
;	.byte $00,$00,$00,$00,$00,$00,$00,$00
;	.byte $00,$00,
	.byte $18,$3C,$3C,$7C,$7E,$FE
	.byte $FE,$FE,$FF,$FF,$FF,$FF,$FF,$FF
	.byte $FF,$FF,$FF,$FE,$FC,$FC,$FC,$7C
	.byte $78,$38,$38,$38,$10
playfield0_right:
	.byte $00,$00,$80,$C0,$E0,$E0,$F0,$70
	.byte $30,$10,$10,$00,$80,$80,$C0,$C0
	.byte $E0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	.byte $F0,$F0,$F0,$F0,$F0,$F0,$C0,$C0
	.byte $80,$80,$80,$00
playfield1_right:
	.byte $00

;	.byte $00,
	.byte $80,$80,$80,$80,$00,$00,$00
	.byte $00,$00,$E0,$E0,$F0,$F0,$F0,$F0
	.byte $F8,$F8,$F8,$FC,$FC,$F8,$F8,$F0
	.byte $E0,$FC,$FE,$F0,$F0,$E0,$E0,$E0
	.byte $E0,$E0,$C0,$C0,$C0

row_lookup:
;.byte	0,0,0,0,0,0,0,0,0,0,0,0,
;171 total?  upside down
.byte  0, 0, 0,36,35,34,33,32,31
.byte 30,29,28,28,28,28,27,27,27
.byte 27,17,17,17,17,17,18,18,18
.byte 18,18,19,19,19,19,19,19,20
.byte 20,20,20,20,20,26,26,26,26
.byte 26,26,26,26,26,25,25,25,25
.byte 22,22,22,22,22,22,22,23,23
.byte 23,23,23,23,23,23,23,23,23
.byte 23,23,23,23,23,23,24,24,24
.byte 24,24,24,24,24,24,24,23,23
.byte 23,23,23,23,23,23,23,23,23
.byte 23,23,23,23,23,23,22,22,21
.byte 21,21,21,21,20,20,20,20,20
.byte 19,19,19,19,18,18,18,17,16
.byte 15,14,13,12,11,10, 9, 8, 8
.byte  8, 7, 7, 7, 7, 7, 7, 6, 6
.byte  6, 6, 6, 6, 6, 6, 6, 5, 4
.byte  4, 4, 4, 4, 4, 4, 4, 3, 3
.byte  3, 3, 3, 3, 2, 2, 2, 1, 1
;.byte 0,0,0,0,0,0,0,0,0


;.align	$100

; Sprites (upside down)

sprite_bitmap0:		; AP
	.byte	$00
	.byte	$8A
	.byte	$8A
	.byte	$FA
	.byte	$8B
	.byte	$8A
	.byte	$52
	.byte	$23

sprite_bitmap1:
	.byte	$00	; PP
	.byte	$08
	.byte	$08
	.byte	$08
	.byte	$cf
	.byte	$28
	.byte	$28
	.byte	$cf

sprite_bitmap2:		; L
	.byte	$00
	.byte	$3E
	.byte	$20
	.byte	$20
	.byte	$20
	.byte	$A0
	.byte	$A0
	.byte	$20

sprite_bitmap3:		; E
	.byte	$00
	.byte	$F8
	.byte	$80
	.byte	$80
	.byte	$F0
	.byte	$80
	.byte	$80
	.byte	$F8

sprite_bitmap4:		; ]
	.byte	$00
	.byte	$0F
	.byte	$01
	.byte	$01
	.byte	$01
	.byte	$01
	.byte	$01
	.byte	$0F

sprite_bitmap5:		; [
	.byte	$00
	.byte	$BE
	.byte	$B0
	.byte	$B0
	.byte	$B0
	.byte	$B0
	.byte	$B0
	.byte	$BE


