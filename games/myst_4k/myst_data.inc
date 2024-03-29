	; note, upside down
	; hand sprite point
hand_sprite:
	.byte	$00,$00,$0E,$0E,$1F,$1F,$3F,$2F
	.byte	$6D,$4C,$08,$08,$08,$08,$08,$08

	; hand sprite grab
hand_sprite_grab:
	.byte	$00,$00,$3C,$3C,$7E,$7E,$7F,$FF
	.byte	$FF,$BF,$35,$55,$55,$54,$54,$10

hand_sprite_left:
	.byte	$00,$00,$1C,$0F,$1F,$0F,$1F,$0F
	.byte	$FF,$FF,$06,$0C,$18,$00,$00,$00

hand_sprite_right:
	.byte	$00,$00,$38,$F0,$F8,$F0,$F8,$F0
	.byte	$FF,$FF,$60,$30,$18,$00,$00,$00


falling_sprite:
	.byte	$E0,$31,$1A,$1E,$FE,$1E,$0F,$05,$00
;	.byte	$00,$05,$0F,$1E,$FE,$1E,$1A,$31,$E0

; values for adjusting sprite offsets
fine_adjust_table:
        ; left
        .byte $70,$60,$50,$40,$30,$20,$10,$00
        ; right -1 ... -8
        .byte $F0,$E0,$D0,$C0,$B0,$A0,$90,$80

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

;===========================
; clock data
;===========================

clock_colors:
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0C
	.byte $08
	.byte $06
	.byte $D8
	.byte $D8
	.byte $D6
	.byte $D8
	.byte $D6
	.byte $D6
	.byte $D6
	.byte $D6
	.byte $D6
	.byte $D6
	.byte $D6
	.byte $D6
	.byte $D6
	.byte $D6
	.byte $D6
	.byte $D6
	.byte $D6
	.byte $D6
	.byte $D6
	.byte $D6
	.byte $D6
	.byte $D6
	.byte $D6



clock_playfield0_left:
	.byte $40
	.byte $40
	.byte $40
	.byte $00
	.byte $00
	.byte $00
	.byte $40
	.byte $00
	.byte $00
	.byte $40
	.byte $40
	.byte $40
	.byte $00
	.byte $00
	.byte $40
	.byte $40
	.byte $40
	.byte $40
	.byte $40
	.byte $40
	.byte $40
	.byte $40
	.byte $40
	.byte $40
	.byte $40
	.byte $40
	.byte $40
	.byte $40
	.byte $40
	.byte $40
	.byte $40
	.byte $40
	.byte $40
	.byte $40
	.byte $40
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
	.byte $00
	.byte $00

.align $100

clock_playfield1_left:
	.byte $58
	.byte $C8
	.byte $58
	.byte $88
	.byte $00
	.byte $00
	.byte $00
	.byte $30
	.byte $38
	.byte $FC
	.byte $FF
	.byte $FF
	.byte $7F
	.byte $7F
	.byte $5F
	.byte $9F
	.byte $9F
	.byte $1F
	.byte $7F
	.byte $FF
	.byte $7F
	.byte $7F
	.byte $7F
	.byte $7F
	.byte $7F
	.byte $7F
	.byte $7F
	.byte $7F
	.byte $7F
	.byte $7F
	.byte $7F
	.byte $7F
	.byte $7F
	.byte $7F
	.byte $7F
	.byte $7F
	.byte $7E
	.byte $78
	.byte $7C
	.byte $7B
	.byte $78
	.byte $08
	.byte $30
	.byte $15
	.byte $2A
	.byte $55
	.byte $02
	.byte $55

clock_playfield2_left:
	.byte $FE
	.byte $FC
	.byte $FC
	.byte $FC
	.byte $FC
	.byte $FC
	.byte $FD
	.byte $FC
	.byte $FC
	.byte $FE
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
	.byte $FF
	.byte $FF
	.byte $F8
	.byte $FD
	.byte $F0
	.byte $E8
	.byte $E4
	.byte $E5
	.byte $E2
	.byte $E0
	.byte $F0
	.byte $CE
	.byte $15
	.byte $AA
	.byte $55
	.byte $AA

clock_playfield0_right:
	.byte $F0
	.byte $30
	.byte $10
	.byte $10
	.byte $10
	.byte $30
	.byte $30
	.byte $30
	.byte $30
	.byte $30
	.byte $30
	.byte $30
	.byte $30
	.byte $30
	.byte $30
	.byte $30
	.byte $30
	.byte $30
	.byte $30
	.byte $30
	.byte $30
	.byte $30
	.byte $30
	.byte $30
	.byte $30
	.byte $30
	.byte $10
	.byte $10
	.byte $10
	.byte $00
	.byte $00
	.byte $00
	.byte $10
	.byte $10
	.byte $90
	.byte $70
	.byte $90
	.byte $50
	.byte $B0
	.byte $50
	.byte $B0
	.byte $50
	.byte $B0
	.byte $70
	.byte $60
	.byte $C0
	.byte $10
	.byte $A0

clock_playfield1_right:
	.byte $01
	.byte $01
	.byte $01
	.byte $01
	.byte $01
	.byte $01
	.byte $01
	.byte $01
	.byte $63
	.byte $E3
	.byte $F3
	.byte $B3
	.byte $B3
	.byte $F3
	.byte $E3
	.byte $43
	.byte $03
	.byte $03
	.byte $03
	.byte $03
	.byte $03
	.byte $63
	.byte $93
	.byte $93
	.byte $93
	.byte $03
	.byte $03
	.byte $03
	.byte $03
	.byte $01
	.byte $01
	.byte $02
	.byte $80
	.byte $84
	.byte $57
	.byte $AF
	.byte $57
	.byte $AF
	.byte $57
	.byte $AF
	.byte $57
	.byte $AF
	.byte $57
	.byte $AF
	.byte $57
	.byte $2F
	.byte $03
	.byte $54


clock_overlay_colors:
	.byte $04
	.byte $04
	.byte $04
	.byte $04
	.byte $04
	.byte $04
	.byte $00
	.byte $14
	.byte $14
	.byte $14
	.byte $14
	.byte $14
	.byte $14
	.byte $14
	.byte $14
	.byte $14
	.byte $14
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $22
	.byte $22
	.byte $22
	.byte $22
	.byte $22
	.byte $22
	.byte $22
	.byte $22
	.byte $00
	.byte $04
	.byte $C2
	.byte $C2
	.byte $C2
	.byte $C2
	.byte $C2
	.byte $C2
	.byte $C2
	.byte $C2
	.byte $C2
	.byte $C2
	.byte $C2
	.byte $C2
	.byte $C2
	.byte $C2
	.byte $00
	.byte $E8

.align $100

clock_overlay_sprite:
	.byte $03
	.byte $1C
	.byte $60
	.byte $01
	.byte $0E
	.byte $70
	.byte $00
	.byte $0C
	.byte $12
	.byte $22
	.byte $21
	.byte $21
	.byte $21
	.byte $21
	.byte $22
	.byte $14
	.byte $08
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $0C
	.byte $0C
	.byte $0C
	.byte $1E
	.byte $9E
	.byte $9E
	.byte $9E
	.byte $9E
	.byte $00
	.byte $7F
	.byte $08
	.byte $EC
	.byte $D5
	.byte $2A
	.byte $D5
	.byte $AA
	.byte $55
	.byte $AA
	.byte $55
	.byte $AA
	.byte $55
	.byte $2A
	.byte $35
	.byte $1A
	.byte $00
	.byte $AA


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

	;============================
	; rocket
	;============================

rocket_bg_colors:
;	.byte $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
;	.byte $0E,$0E,$0E,$0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E	; F4
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0E
	.byte $0A
	.byte $08
	.byte $C8
	.byte $C8
	.byte $C8
	.byte $C8
	.byte $C8
	.byte $C6
	.byte $C6
	.byte $C6
	.byte $C6
	.byte $C6
	.byte $C4
	.byte $C4
	.byte $C4
	.byte $C4
	.byte $C4

rocket_playfield1_left:
;	.byte $00,$00,$00,$00,$00,$00,$00,$00
;	.byte $00,$00,$00,$00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $0F
	.byte $1F
	.byte $7F
	.byte $FF
	.byte $FF
	.byte $FF
	.byte $7F
	.byte $1F
	.byte $07
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
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00

;.align $100

rocket_playfield2_left:
;	.byte $00,$00,$00,$00,$00,$00,$00,$00
;	.byte $00,$00,$00,$00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $FE
	.byte $FF
	.byte $FF
	.byte $0F
	.byte $FF
	.byte $0F	;
	.byte $FF
	.byte $FF
	.byte $FF
	.byte $FF
	.byte $FF
	.byte $F4
	.byte $F2
	.byte $FF
	.byte $3F
	.byte $3D
	.byte $3B
	.byte $3F
	.byte $3D
	.byte $1B
	.byte $1F
	.byte $1D
	.byte $1B
	.byte $1F
	.byte $0D
	.byte $0B
	.byte $0F
	.byte $0D
	.byte $0B
	.byte $0F

rocket_playfield0_right:
;	.byte $00,$00,$00,$00,$00,$00,$00,$00
;	.byte $00,$00,$00,$00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $F0
	.byte $F0
	.byte $F0
	.byte $F0
	.byte $90
	.byte $FF	;
	.byte $90
	.byte $F0
	.byte $F0
	.byte $F0
	.byte $F0
	.byte $F0
	.byte $F0
	.byte $F0
	.byte $C0
	.byte $C0
	.byte $C0
	.byte $C0
	.byte $C0
	.byte $C0
	.byte $80
	.byte $80
	.byte $80
	.byte $80
	.byte $80
	.byte $80
	.byte $00
	.byte $00
	.byte $00
	.byte $00

rocket_playfield1_right:
;	.byte $00,$00,$00,$00,$00,$00,$00,$00
;	.byte $00,$00,$00,$00
	.byte $00
	.byte $01
	.byte $07
	.byte $1F
	.byte $1F
	.byte $3F
	.byte $BF
	.byte $CF
	.byte $F1
	.byte $FF
	.byte $FF
	.byte $FF	;
	.byte $FA
	.byte $D7
	.byte $FF
	.byte $FF
	.byte $87
	.byte $C0
	.byte $E0
	.byte $F0
	.byte $F0
	.byte $70
	.byte $F0
	.byte $F0
	.byte $70
	.byte $F0
	.byte $F0
	.byte $70
	.byte $F0
	.byte $F0
	.byte $70
	.byte $F0
	.byte $F0
	.byte $70
	.byte $F0
	.byte $F0

.align $100
rocket_playfield2_right:
;	.byte $00,$00,$00,$00,$00,$00,$00,$00
;	.byte $00,$00,$00,$00
	.byte $00,$80,$1F,$3F
	.byte $01,$00,$00,$00,$00,$01,$03,$03	;
	.byte $03,$01,$03,$0F,$FF,$1F,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $41,$63,$F3,$FF,$FF,$FF,$FF,$FF

rocket_overlay_colors:
;	.byte $00,$00,$00,$00,$00,$00,$00,$00
;	.byte $00,$00,$00,$00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $F0
	.byte $A6
	.byte $F0
	.byte $1A
	.byte $F2
	.byte $F2
	.byte $F0
	.byte $00
	.byte $02
	.byte $E6
	.byte $E6
	.byte $06
	.byte $06
	.byte $06
	.byte $06
	.byte $06
	.byte $06
	.byte $06
	.byte $06
	.byte $06
	.byte $06
	.byte $06
	.byte $06
	.byte $06
	.byte $06
	.byte $06
	.byte $06

rocket_overlay_sprite:
;	.byte $00,$00,$00,$00,$00,$00,$00,$00
;	.byte $00,$00,$00,$00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $F0
	.byte $06
	.byte $F6
	.byte $06
	.byte $F6
	.byte $F6
	.byte $F6
	.byte $00
	.byte $FF
	.byte $FF
	.byte $FF
	.byte $3C
	.byte $3C
	.byte $3C
	.byte $3C
	.byte $3C
	.byte $7C
	.byte $7E
	.byte $7E
	.byte $7E
	.byte $7E
	.byte $FE
	.byte $FE
	.byte $FF
	.byte $FF
	.byte $FF
	.byte $FF

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


arrival_playfield1_left:
	.byte $0F
	.byte $0F
	.byte $0F
	.byte $0F
	.byte $2F
	.byte $2F
	.byte $2F
	.byte $2F
	.byte $2F
	.byte $2F
	.byte $0F
	.byte $0F
	.byte $07
	.byte $07
	.byte $03
	.byte $03
	.byte $03
	.byte $03
	.byte $03
	.byte $03
	.byte $03
	.byte $03
	.byte $03
	.byte $03
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
	.byte $01
	.byte $03

.align $100

arrival_playfield2_left:
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
	.byte $3F
	.byte $1F
	.byte $1F
	.byte $07
	.byte $07
	.byte $03
	.byte $01
	.byte $01
	.byte $01
	.byte $01
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
	.byte $C0
	.byte $C0
	.byte $E0
	.byte $E0
	.byte $F0
	.byte $F0
	.byte $F0
	.byte $F8
	.byte $F8
	.byte $FC
	.byte $FC
	.byte $FE
	.byte $FE
	.byte $FE
	.byte $FF
	.byte $FF
	.byte $FF

arrival_overlay_colors:
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
	.byte $04
	.byte $04
	.byte $04
	.byte $C2
	.byte $04
	.byte $04
	.byte $04
	.byte $04
	.byte $04
	.byte $04
	.byte $04
	.byte $04
	.byte $04
	.byte $04
	.byte $04
	.byte $A4
	.byte $18
	.byte $06
	.byte $18
	.byte $06
	.byte $06
	.byte $00
	.byte $02
	.byte $F4
	.byte $F4
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
	.byte $00
	.byte $00

arrival_overlay:
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
	.byte $28
	.byte $42
	.byte $5A
	.byte $F8
	.byte $0A
	.byte $12
	.byte $E6
	.byte $06
	.byte $0E
	.byte $7E
	.byte $78
	.byte $70
	.byte $90
	.byte $88
	.byte $48
	.byte $3A
	.byte $02
	.byte $3C
	.byte $02
	.byte $3E
	.byte $3E
	.byte $00
	.byte $01
	.byte $01
	.byte $01
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
	.byte $00
	.byte $00
