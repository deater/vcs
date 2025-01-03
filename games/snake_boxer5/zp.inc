; zero page addresses

FRAME		= $80
;
BOXER_X		= $82		; X-position of boxer
RBOXER_X	= $83		; X-position of right boxer sprite (BOXER_X+8)
SNAKE_X		= $84		; X-position of snake
BOXER_X_COARSE	= $85
SNAKE_X_COARSE	= $86
;
BOXER_PTR_L	= $88
BOXER_PTR_L_H	= $89
BOXER_PTR_R	= $8A
BOXER_PTR_R_H	= $8B
SNAKE_PTR	= $8C
SNAKE_PTR_H	= $8D
INL		= $8E
INH		= $8F

TEMP1	=	$90
TEMP2	=	$91

SNAKE_KOS	= $92
SNAKE_KOS_BCD	= $93
BUTTON_COUNTDOWN= $94
SNAKE_HEALTH	= $95
BOXER_HEALTH	= $96
MANS		= $97

BOXER_STATE	= $98	; 0=neutral, 1=block, 2=left punch, 3=right punch
SNAKE_STATE	= $99	;

SCORE_SPRITE_LOW_0      = $A0
SCORE_SPRITE_LOW_1      = $A1
SCORE_SPRITE_LOW_2      = $A2
SCORE_SPRITE_LOW_3      = $A3
SCORE_SPRITE_LOW_4      = $A4
SCORE_SPRITE_LOW_5      = $A5
SCORE_SPRITE_LOW_6      = $A6
SCORE_SPRITE_LOW_7	= $A7
SCORE_SPRITE_LOW_8	= $A8

