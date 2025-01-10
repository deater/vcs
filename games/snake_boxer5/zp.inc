; zero page addresses

FRAME		= $80
FRAMEH		= $81

; for title
RUNNER_X	= $82
RUNNER_COUNT	= $84
RUNNER_PTR_L	= $88
RUNNER_PTR_LH	= $89
RUNNER_PTR_R	= $8A
RUNNER_PTR_RH	= $8B
RUNNER_STATE	= $9A

; for actual game

BOXER_X		= $82		; X-position of boxer
RBOXER_X	= $83		; X-position of right boxer sprite (BOXER_X+8)
SNAKE_X		= $84		; X-position of snake
BOXER_X_COARSE	= $85
SNAKE_X_COARSE	= $86
SNAKE_SPEED	= $87

BOXER_PTR_L	= $88
BOXER_PTR_LH	= $89
BOXER_PTR_R	= $8A
BOXER_PTR_RH	= $8B
BOXER_COL_L	= $8C
BOXER_COL_LH	= $8D
BOXER_COL_R	= $8E
BOXER_COL_RH	= $8F





TEMP1	=	$90
TEMP2	=	$91

SNAKE_KOS	= $92
SNAKE_KOS_BCD	= $93
BUTTON_COUNTDOWN= $94
SNAKE_HEALTH	= $95
BOXER_HEALTH	= $96
MANS		= $97
MAN_BAR		= $98
MAX_MANS	= $99	; used when drawing bar

BOXER_STATE	= $9A	; 0=neutral, 1=block, 2=left punch, 3=right punch
SNAKE_STATE	= $9B	;

SNAKE_PTR	= $9C
SNAKE_PTR_H	= $9D
INL		= $9E
INH		= $9F

SCORE_SPRITE_LOW_0      = $A0
SCORE_SPRITE_LOW_1      = $A1
SCORE_SPRITE_LOW_2      = $A2
SCORE_SPRITE_LOW_3      = $A3
SCORE_SPRITE_LOW_4      = $A4
SCORE_SPRITE_LOW_5      = $A5
SCORE_SPRITE_LOW_6      = $A6
SCORE_SPRITE_LOW_7	= $A7
SCORE_SPRITE_LOW_8	= $A8

SFX_RIGHT               =       $B0
SFX_LEFT                =       $B1
NOTE_DURATION		=	$B2
NOTE_POINTER		=	$B3
LEVEL_OVER		=	$B4

