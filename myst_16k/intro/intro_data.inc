falling_sprite:
	.byte	$E0,$31,$1A,$1E,$FE,$1E,$0F,$05,$00
;	.byte	$00,$05,$0F,$1E,$FE,$1E,$1A,$31,$E0


title_playfield0_left:
	.byte $30,$20,$60,$60,$60,$A0,$A0,$A0
	.byte $A0,$20,$30
title_playfield1_left:
	.byte $18,$10,$30,$30,$30,$50,$50,$50
	.byte $50,$90,$98
title_playfield2_left:
	.byte $C6,$44,$44,$28,$28,$10,$10,$10
	.byte $10,$10,$38
title_playfield1_right:
	.byte $78,$88,$80,$80,$C0,$60,$30,$18
	.byte $08,$88,$F0
title_playfield2_right:
	.byte $FE,$92,$10,$10,$10,$10,$10,$10
	.byte $10,$10,$38


cleft_colors:
	.byte $00,$00,$00,$00,$00,$02,$02,$02
	.byte $02,$02,$02,$04,$A4,$A4,$A4,$A4
	.byte $A4,$A6,$A6,$A8,$A8,$AC,$AE,$AE
	.byte $AE,$AC,$AC,$AA,$A8,$A6,$A6,$A4
	.byte $A4,$A4,$A4,$A4,$04,$04,$02,$02
	.byte $02,$02,$00,$00,$00,$00,$00,$00

cleft_playfield2_left:
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $80
	.byte $80
	.byte $80
	.byte $80
	.byte $80
	.byte $80
	.byte $80
	.byte $80
	.byte $80
	.byte $80
	.byte $80
	.byte $C0
	.byte $C0
	.byte $C0
	.byte $C0
	.byte $E0
	.byte $E0
	.byte $E0
	.byte $E0
	.byte $E0
	.byte $C0
	.byte $C0
	.byte $C0
	.byte $C0
	.byte $C0
	.byte $C0
	.byte $C0
	.byte $E0
	.byte $C0
	.byte $C0
	.byte $C0
	.byte $C0
	.byte $C0
	.byte $80
	.byte $80
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00

cleft_playfield0_right:
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $30
	.byte $30
	.byte $30
	.byte $30
	.byte $30
	.byte $30
	.byte $30
	.byte $70
	.byte $70
	.byte $70
	.byte $30
	.byte $30
	.byte $70
	.byte $70
	.byte $70
	.byte $F0
	.byte $70
	.byte $70
	.byte $70
	.byte $70
	.byte $30
	.byte $30
	.byte $30
	.byte $30
	.byte $10
	.byte $10
	.byte $10
	.byte $10
	.byte $10
	.byte $10
	.byte $10
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00



page_sprite:
	.byte $18
	.byte $0D
	.byte $0F
	.byte $7F
	.byte $5B
	.byte $1F
	.byte $1D
	.byte $1B
	.byte $00	;
	.byte $FF
	.byte $FF
	.byte $FF
	.byte $FF
	.byte $FF
	.byte $FF
	.byte $FF
	.byte $FF
	.byte $FF
	.byte $FF
	.byte $FF
	.byte $00	;
	.byte $7E
	.byte $3F
	.byte $5F
	.byte $5E
	.byte $3E
	.byte $7F
	.byte $76
	.byte $5F
	.byte $DF
	.byte $6E
	.byte $2E
	.byte $5E
	.byte $DE
	.byte $EE
	.byte $6E
	.byte $6E
	.byte $3E
	.byte $27
	.byte $CF
	.byte $7F
	.byte $4D
	.byte $3F
	.byte $3E


.align $100

book_edge_colors:
	.byte $00
	.byte $F0
	.byte $F0
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $F4
	.byte $30
	.byte $30
	.byte $F0
	.byte $32
	.byte $F0
	.byte $30
	.byte $F4
	.byte $F0
	.byte $F4
	.byte $F0
	.byte $30
	.byte $30
	.byte $28
	.byte $F4
	.byte $32
	.byte $12
	.byte $F0
	.byte $F4
	.byte $F4
	.byte $F4
	.byte $F4
	.byte $30
	.byte $F4
	.byte $F0
	.byte $30
	.byte $30
	.byte $30
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00

;=============================
; sound data
;=============================

;=========================================
; sound effects
; doesn't need to be aligned?

sfx_f:
sfx_start:
	.byte	0, 31, 31
sfx_click:
	.byte   0 ,25,25,25,25
	.byte   25,25,25,25,25,25,25,25
	.byte   25,25,25,25,25 ,04,04,04
	.byte	04,04,04,22,22,22,22,22		; link
sfx_link:

sfx_cv:
	.byte   $00,$C3,$CF
	.byte   $00,$32,$34,$36,$38
	.byte   $3A,$38,$36,$38,$3A,$3C,$3A,$38
	.byte   $3A,$3C,$3E,$3C,$3A, $E4,$E6,$EA
	.byte   $E8,$E6,$E4,$3A,$3c,$3d,$3e,$3e	; link

SFX_CLICK	=       sfx_click-sfx_start-1
SFX_LINK	=       sfx_link-sfx_start-1

