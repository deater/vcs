
; Various game data
; we need to align this carefully so it doesn't cross a page boundary
; otherwise it can take an extra cycle to load which will throw
; off all of our calculations

.align	$100

; Level 1 Playfield data

playfield0_left:
	.byte	$F0,$10,$10,$10,$10,$10,$10,$10
	.byte	$10,$10,$10,$10,$10,$10,$10,$10
	.byte	$10,$10,$10,$10,$10,$10,$10,$10
	.byte	$10,$10,$10,$10,$10,$10,$10,$10
	.byte	$10,$10,$10,$10,$10,$F0
playfield1_left:
	.byte	$FF,$00,$00,$00,$00,$7f,$7f,$7f
	.byte	$7f,$18,$18,$18,$18,$18,$18,$18
	.byte	$18,$18,$18,$18,$18,$18,$18,$18
	.byte	$18,$18,$18,$18,$18,$7f,$7f,$7f
	.byte	$7f,$00,$00,$00,$00,$FF
playfield2_left:
	.byte	$FF,$00,$00,$00,$00,$1f,$1f,$1f
	.byte	$1f,$00,$00,$00,$00,$00,$fe,$fe
	.byte	$1e,$02,$02,$02,$02,$1e,$fe,$fe
	.byte	$00,$00,$00,$00,$00,$1f,$1f,$1f
	.byte	$1f,$00,$00,$00,$00,$FF


;===================
; videlectrix logo
.if 0
vid_bitmap0:	.byte	$18,$24,$24,$5A,$DB,$A5,$42,$C3
vid_bitmap1:	.byte	$00,$4e,$52,$4e,$02,$42,$80,$80
vid_bitmap2:	.byte	$00,$74,$a5,$95,$74,$04,$00,$00
vid_bitmap3:	.byte	$00,$e7,$48,$28,$e6,$00,$00,$00
vid_bitmap4:	.byte	$00,$34,$44,$44,$f7,$40,$00,$00
vid_bitmap5:	.byte	$00,$29,$26,$A6,$09,$20,$00,$00
.endif

fine_adjust_table:
	; left
	.byte $70
	.byte $60
	.byte $50
	.byte $40
	.byte $30
	.byte $20
	.byte $10
	.byte $00

	; right
	.byte $F0	; -1
	.byte $E0	; -2
	.byte $D0	; -3
	.byte $C0	; -4
	.byte $B0	; -5
	.byte $A0	; -6
	.byte $90	; -7
	.byte $80	; -8 (?)

.if 0
bargraph_lookup_p0:
	.byte $f0,$e0,$c0,$80,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00

bargraph_lookup_p1:
	.byte $ff,$ff,$ff,$ff,$7f,$3f,$1f,$0f
	.byte $07,$03,$01,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00

bargraph_lookup_p2:
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$fe,$fc,$f8,$f0
	.byte $e0,$c0,$80,$00
.endif


bargraph_lookup_p0:
	.byte $f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0
	.byte $f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0
	.byte $f0,$70,$30,$10,$00

bargraph_lookup_p1:
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$fe,$fc,$f8,$f0,$e0,$c0,$80
	.byte $00,$00,$00,$00,$00

bargraph_lookup_p2:
	.byte $ff,$7f,$3f,$1f,$0f,$07,$03,$01
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00


score_bitmap0:
	.byte $22,$55,$55,$55,$55,$55,$22
score_bitmap1:
;	.byte $AA,$55,$AA,$55,$AA,$55,$AA
	.byte $22,$55,$55,$55,$55,$55,$22
score_bitmap2:
	.byte $22,$55,$55,$55,$55,$55,$22
;	.byte $AA,$AA,$AA,$AA,$55,$55,$55
score_bitmap3:
	.byte $22,$55,$55,$55,$55,$55,$22
;	.byte $F0,$0F,$F0,$0F,$F0,$0F,$F0

; remember, we draw bottom to top
mans_bitmap0:
	.byte $8A,$8A,$8B,$AA,$AA,$D9,$88
mans_bitmap1:
	.byte $28,$28,$E8,$29,$2A,$4C,$88
mans_bitmap2:
	.byte $BC,$82,$82,$9C,$A0,$A0,$9E
mans_bitmap3:
	.byte $07,$82,$82,$02,$82,$86,$02

.align $100

; ----**-- ----**-- ----**-- ----**-- --**--**
; --**--** --****-- --**--** --**--** --**--**
; --**--** ----**-- ------** ------** --**--**
; --**--** ----**-- ----**-- ----**-- --******
; --**--** ----**-- --**---- ------** ------**
; --**--** ----**-- --**---- --**--** ------**
; ----**-- --****** --****** ----**-- ------**

; padded to 8 wide as it makes math easier
score_zeros:	.byte $22,$55,$55,$55,$55,$55,$22,$00
score_ones:	.byte $22,$66,$22,$22,$22,$22,$77,$00
score_twos:	.byte $22,$55,$11,$22,$44,$44,$77,$00
score_threes:	.byte $22,$55,$11,$22,$11,$55,$22,$00
score_fours:	.byte $55,$55,$55,$77,$11,$11,$11,$00

; --****** ----**-- --****** ----**-- ----**--
; --**---- --**--** ------** --**--** --**--**
; --****-- --**---- ------** --**--** --**--**
; ------** --****-- ----**-- ----**-- ----****
; ------** --**--** --**---- --**--** ------**
; --**--** --**--** --**---- --**--** --**--**
; ----**-- ----**-- --**---- ----**-- ----**--

score_fives:	.byte	$77,$44,$66,$11,$11,$55,$22,$00
score_sixes:	.byte	$33,$44,$44,$66,$55,$55,$22,$00
score_sevens:	.byte	$77,$11,$11,$22,$44,$44,$44,$00
score_eights:	.byte	$22,$55,$55,$22,$55,$55,$22,$00
score_nines:	.byte	$22,$55,$55,$33,$11,$55,$22,$00


mans_zeros:	.byte	$02,$85,$85,$05,$85,$85,$02,$00
mans_ones:	.byte	$02,$86,$82,$02,$82,$82,$07,$00
mans_twos:	.byte	$02,$85,$81,$02,$84,$84,$07,$00
mans_threes:	.byte	$02,$85,$81,$02,$81,$85,$02,$00

;big_level_one:	.byte	$20,$60,$20,$20,$20,$20,$20,$70

;                       frontward at end    middle  backwards at start
big_level_one:	.byte	$20,$20,$70,         $20,  $20,$20,$60,$20
big_level_two:	.byte	$40,$40,$70,         $20,  $20,$50,$10,$20
big_level_three:.byte	$10,$60,$00,         $10,  $60,$10,$10,$60
big_level_four:	.byte	$10,$10,$10,         $70,  $50,$50,$50,$50




zap_colors:
;	.byte	$50,$50,$52,$52,$54,$54,$56,$56
;	.byte	$58,$58,$5A,$5A,$5C,$5C,$5E,$5E
;	.byte	$60,$60,$62,$62,$64,$64,$66,$66
;	.byte	$68,$68,$6A,$6A,$6C,$6C,$6E,$6E
;	.byte	$70,$70,$72,$72,$74,$74,$76,$76
;	.byte	$78,$78,$7A,$7A,$7C,$7C,$7E,$7E
;	.byte	$80,$80,$82,$82,$84,$84,$86,$86
;	.byte	$88,$88,$8A,$8A,$8C,$8C,$8E,$8E
;	.byte	$90,$90,$92,$92,$94,$94,$96,$96
;	.byte	$98,$98,$9A,$9A,$9C,$9C,$9E,$9E

sfx_f:
sfx_start:
	.byte	0, 26	; collide
sfx_collide:
	.byte	0, 12	; zap
sfx_zap:
	.byte	0,22,22,23,23,24,24,25,25,26,26,27,28,29,30,31 ; collect
sfx_collect:
	.byte	0, 0, 0, 1, 1, 2, 2, 3, 3 ; speed
sfx_speed:
	.byte	0, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8 ; ping
sfx_ping:
	.byte	0,23,23,24,24,23,23,24,24,23,23,24,24,23,23 ; game over
sfx_game_over:

sfx_cv:
	.byte	0,$8F	; collide
	.byte	0,$3F	; zap
	.byte	0,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byte	  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f ; collect
	.byte	0,$6f,$6f,$6f,$6f,$6f,$6f,$6f,$6f ; speed
	.byte	0,$41,$42,$43,$44,$45,$46,$47,$48
	.byte	  $49,$4a,$4b,$4c,$4d,$4e,$4f ; ping
	.byte	0,$8f,$8f,$8f,$8f,$8f,$8f,$8f
	.byte	  $8f,$8f,$8f,$8f,$8f,$8f,$8f ; game over

; F, C/V
; collide V=F, C=8, F=31    (8,26)
; zap =   V=F, C=3, F=12
; collect V=F, C=6, F=2		; not really
; die	  V=F, C=8, F=24

SFX_COLLIDE	=	sfx_collide-sfx_start-1
SFX_ZAP		=	sfx_zap-sfx_start-1
SFX_COLLECT	=	sfx_collect-sfx_start-1
SFX_SPEED	=	sfx_collect-sfx_speed-1
SFX_PING	=	sfx_ping-sfx_start-1
SFX_GAMEOVER	=	sfx_game_over-sfx_start-1
;===================
; videlectrix logo

; note, this goes backwards from bottom to top

;.align $100

title_bitmap0:
prod_bitmap0:	.byte	$84,$84,$E4,$97,$E0,$00,$00,$00,$00
vmw_bitmap0:	.byte	$00,$00,$00,$00,$00,$00,$00,$00
		.byte	$00,$00,$00,$00,$00,$00,$00,$00
		.byte	$00,$00,$00
and_bitmap0:	.byte	$00,$00,$00,$00,$00,$00,$00,$00
		.byte	$00,$00,$00,$00,$00
vid_bitmap0:	.byte	$18,$24,$24,$5A,$DB,$A5,$42,$C3

title_bitmap1:
prod_bitmap1:	.byte	$18,$25,$A4,$18,$00,$00,$00,$00,$00
vmw_bitmap1:	.byte	$00,$00,$00,$00,$00,$01,$01,$01
		.byte	$00,$00,$00,$00,$00,$00,$00,$00
		.byte	$00,$00,$00
and_bitmap1:	.byte	$00,$00,$00,$00,$00,$00,$00,$00
		.byte	$00,$00,$00,$00,$00
vid_bitmap1:	.byte	$00,$4e,$52,$4e,$02,$42,$80,$80

title_bitmap2:
prod_bitmap2:	.byte	$E6,$29,$E9,$29,$20,$00,$00,$00,$00
vmw_bitmap2:	.byte	$3F,$51,$51,$8A,$8A,$04,$04,$FF
		.byte	$00,$00,$00,$00,$00,$00,$00,$00
		.byte	$00,$00,$00
and_bitmap2:	.byte	$3a,$4a,$5b,$2a,$00,$00,$00,$00
		.byte	$00,$00,$00,$00,$00
vid_bitmap2:	.byte	$00,$74,$a5,$95,$74,$04,$00,$00


title_bitmap3:
prod_bitmap3:	.byte	$39,$42,$42,$37,$02,$00,$00,$00,$00
vmw_bitmap3:	.byte	$FE,$45,$45,$28,$28,$10,$10,$FF
		.byte	$00,$00,$00,$00,$00,$00,$00,$00
		.byte	$00,$00,$00
and_bitmap3:	.byte	$4E,$52,$8E,$02,$02,$00,$00,$00
		.byte	$00,$00,$00,$00,$00
vid_bitmap3:	.byte	$00,$e7,$48,$28,$e6,$00,$00,$00

title_bitmap4:
prod_bitmap4:	.byte	$4C,$52,$52,$0C,$40,$00,$00,$00,$00
vmw_bitmap4:	.byte	$00,$00,$00,$80,$80,$40,$40,$C0
		.byte	$00,$00,$00,$00,$00,$00,$00,$00
		.byte	$00,$00,$00
and_bitmap4:	.byte	$00,$00,$00,$00,$00,$00,$00,$00
		.byte	$00,$00,$00,$00,$00
vid_bitmap4:	.byte	$00,$34,$44,$44,$f7,$40,$00,$00

.align $100

title_bitmap5:
prod_bitmap5:	.byte	$96,$91,$92,$E4,$03,$00,$00,$00,$00
vmw_bitmap5:	.byte	$00,$00,$00,$00,$00,$00,$00,$00
		.byte	$00,$00,$00,$00,$00,$00,$00,$00
		.byte	$00,$00,$00
and_bitmap5:	.byte	$00,$00,$00,$00,$00,$00,$00,$00
		.byte	$00,$00,$00,$00,$00
vid_bitmap5:	.byte	$00,$29,$26,$A6,$09,$20,$00,$00


title_playfield1_left:
	.byte $00
	.byte $01
	.byte $03
	.byte $03
	.byte $03
	.byte $01
	.byte $01
	.byte $01
	.byte $00
	.byte $00
	.byte $03
	.byte $07
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $08
	.byte $0C
	.byte $0C
	.byte $18
	.byte $10
	.byte $10
	.byte $31
	.byte $31
	.byte $21
	.byte $3D
	.byte $1C
	.byte $00
	.byte $00

title_playfield2_left:
	.byte $00
	.byte $8D
	.byte $8D
	.byte $85
	.byte $C4
	.byte $44
	.byte $4C
	.byte $6D
	.byte $65
	.byte $25
	.byte $ED
	.byte $C9
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $22
	.byte $22
	.byte $22
	.byte $27
	.byte $27
	.byte $25
	.byte $2D
	.byte $2D
	.byte $28
	.byte $6F
	.byte $67
	.byte $00

title_playfield0_right:
	.byte $00
	.byte $40
	.byte $50
	.byte $D0
	.byte $C0
	.byte $C0
	.byte $40
	.byte $40
	.byte $C0
	.byte $40
	.byte $50
	.byte $50
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $90
	.byte $90
	.byte $90
	.byte $90
	.byte $90
	.byte $90
	.byte $90
	.byte $90
	.byte $90
	.byte $B0
	.byte $30
	.byte $00

title_playfield1_right:
	.byte $00
	.byte $3E
	.byte $3E
	.byte $24
	.byte $A4
	.byte $A4
	.byte $B4
	.byte $B4
	.byte $24
	.byte $A4
	.byte $B4
	.byte $B4
	.byte $80
	.byte $C0
	.byte $40
	.byte $40
	.byte $00
	.byte $8B
	.byte $8F
	.byte $0D
	.byte $19
	.byte $91
	.byte $91
	.byte $31
	.byte $31
	.byte $21
	.byte $BD
	.byte $9C
	.byte $00
	.byte $00

title_playfield2_right:
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
	.byte $01
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $02
	.byte $02
	.byte $00

