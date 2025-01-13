;=========================================
; sound effects
; doesn't need to be aligned?


sfx_f:
sfx_start:
	.byte	0, 26	; punch_hit
sfx_punch_hit:
	.byte	0, 12, 12, 12, 12, 12, 12, 12, 12	; snake_attack
sfx_snake_attack:
	.byte	0,22,22,23,23,24,24,25,25,26,26,27,28,29,30,31 ; collect
sfx_collect:
	.byte	0, 0, 0, 1, 1, 2, 2, 3, 3 ; speed
sfx_speed:
	.byte	0, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19 ; bell
sfx_bell:
	.byte	0,24,24,24,24,24,24,24,24,24,24,24,24,24,24 ; game over
sfx_game_over:

sfx_cv:
	.byte	0,$8F	; collide
	.byte	0,$3F,$3F,$3F,$3F,$3F,$3f,$3f,$3f	; zap
	.byte	0,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byte	  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f ; collect
	.byte	0,$6f,$6f,$6f,$6f,$6f,$6f,$6f,$6f ; speed
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

SFX_PUNCH_HIT		=	sfx_punch_hit-sfx_start-1
SFX_SNAKE_ATTACK	=	sfx_snake_attack-sfx_start-1
SFX_COLLECT	=	sfx_collect-sfx_start-1
SFX_SPEED	=	sfx_speed-sfx_start-1
SFX_BELL	=	sfx_bell-sfx_start-1
SFX_GAMEOVER	=	sfx_game_over-sfx_start-1
