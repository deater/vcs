;=========================================
; sound effects
; doesn't need to be aligned?


sfx_f:
sfx_start:
	.byte	0,26,26,26,26,26,26,26,26	; punch_hit
sfx_punch_hit:
	.byte	0,12,12,12,12,12,12,12,12	; punch_miss
sfx_punch_miss:
	.byte	0,12,12,12,12,12,12,12,12	; snake_hit
sfx_snake_hit:
	.byte	0,22,22,23,23,24,24,25,25,26,26,27,28,29,30,31 ; snake_ko
sfx_snake_ko:
	.byte	0, 0, 0, 1, 1, 2, 2, 3, 3 ; snake_miss
sfx_snake_miss:
	.byte	0,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19 ; bell
sfx_bell:
	.byte	0,24,24,24,24,24,24,24,24,24,24,24,24,24,24 ; game over
sfx_game_over:

sfx_cv:
	.byte	0,$8F,$8F,$8F,$8F,$8F,$8F,$8F,$8F	; punch_hit
	.byte	0,$82,$82,$82,$82,$82,$82,$82,$82	; punch_miss
	.byte	0,$3F,$3F,$3F,$3F,$3F,$3f,$3f,$3f	; snake_hit
	.byte	0,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byte	  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f ; snake_ko
	.byte	0,$6f,$6f,$6f,$6f,$6f,$6f,$6f,$6f ; snake_miss
	.byte	0,$41,$42,$43,$44,$45,$46,$47,$48
	.byte	  $49,$4a,$4b,$4c,$4d,$4e,$4f ; bell
	.byte	0,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte	  $ff,$ff,$ff,$ff,$ff,$ff,$ff ; game over

; F, C/V
; collide V=F, C=8, F=31    (8,26)
; zap =   V=F, C=3, F=12
; collect V=F, C=6, F=2		; not really
; die	  V=F, C=8, F=24
; level over V=G,  7/26 1/29

SFX_PUNCH_HIT	=	sfx_punch_hit-sfx_start-1
SFX_PUNCH_MISS	=	sfx_punch_miss-sfx_start-1
SFX_SNAKE_HIT	=	sfx_snake_hit-sfx_start-1
SFX_SNAKE_KO	=	sfx_snake_ko-sfx_start-1
SFX_SNAKE_MISS	=	sfx_snake_miss-sfx_start-1
SFX_BELL	=	sfx_bell-sfx_start-1
SFX_GAMEOVER	=	sfx_game_over-sfx_start-1
