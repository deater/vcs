; Using background color $00
desire_colors:
	.byte $00,$00
        .byte $A2,$A2,$A2,$A2
	.byte $D0,$D0,$D0,$D0
	.byte $D4,$D4,$D4,$D4
	.byte $C6,$C6,$C6,$C6
	.byte $1E,$1E,$1E,$1E
	.byte $1E,$1E,$1E,$1E
	.byte $1E,$1E,$1E,$1E

desire_playfield0_left:
	.byte $00,$00
	.byte $E0,$E0,$E0,$E0
	.byte $F0,$F0,$F0,$F0
	.byte $30,$30,$30,$30
	.byte $30,$30,$30,$30
	.byte $30,$30,$30,$30
	.byte $00,$00,$00,$00
	.byte $F0,$F0,$F0,$F0

desire_playfield1_left:
	.byte $00,$00
	.byte $C7,$C7,$C7,$C7
	.byte $EF,$EF,$EF,$EF
	.byte $6C,$6C,$6C,$6C
	.byte $6C,$6C,$6C,$6C
	.byte $6F,$6F,$6F,$6F
	.byte $6C,$6C,$6C,$6C
	.byte $C7,$C7,$C7,$C7

desire_playfield2_left:
	.byte $00,$00
	.byte $F3,$F3,$F3,$F3
	.byte $FB,$FB,$FB,$FB
	.byte $98,$98,$98,$98
	.byte $80,$80,$80,$80
	.byte $7B,$7B,$7B,$7B
	.byte $18,$18,$18,$18
	.byte $F3,$F3,$F3,$F3

desire_playfield0_right:
	.byte $00,$00
	.byte $C0,$C0,$C0,$C0
	.byte $90,$90,$90,$90
	.byte $90,$90,$90,$90
	.byte $90,$90,$90,$90
	.byte $80,$80,$80,$80
	.byte $90,$90,$90,$90
	.byte $D0,$D0,$D0,$D0

desire_playfield1_right:
	.byte $00,$00
	.byte $B1,$B1,$B1,$B1
	.byte $31,$31,$31,$31
	.byte $37,$37,$37,$37
	.byte $3F,$3F,$3F,$3F
	.byte $33,$33,$33,$33
	.byte $33,$33,$33,$33
	.byte $BF,$BF,$BF,$BF

desire_playfield2_right:
	.byte $00,$00
	.byte $F9,$F9,$F9,$F9
	.byte $FD,$FD,$FD,$FD
	.byte $0D,$0D,$0D,$0D
	.byte $0D,$0D,$0D,$0D
	.byte $FC,$FC,$FC,$FC
	.byte $0C,$0C,$0C,$0C
	.byte $F8,$F8,$F8,$F8



.if 0
; Using background color $00
desire_colors:
        .byte $1E,$1E,$1E,$C6,$D4,$D0,$A2,$00

desire_playfield0_left:
	.byte $F0,$00,$30,$30,$30,$F0,$E0,$00

desire_playfield1_left:
	.byte $C7,$6C,$6F,$6C,$6C,$EF,$C7,$00

desire_playfield2_left:
	.byte $F3,$18,$7B,$80,$98,$FB,$F3,$00

desire_playfield0_right:
	.byte $D0,$90,$80,$90,$90,$90,$C0,$00

desire_playfield1_right:
	.byte $BF,$33,$33,$3F,$37,$31,$B1,$00

desire_playfield2_right:
	.byte $F8,$0C,$FC,$0D,$0D,$FD,$F9,$00
.endif
