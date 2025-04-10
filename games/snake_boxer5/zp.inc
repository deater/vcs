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
SNAKE_X_LOW	= $85
SNAKE_SPEED	= $86
SNAKE_SPEED_LOW	= $87

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

BOXER_STATE	= $9A	; 0=neutral, 1=BLOCKING, 2=PUNCHING, 3=INJURED, 4=DEAD
	BOXER_NEUTRAL	= 0
	BOXER_BLOCKING	= 1
	BOXER_PUNCHING	= 2
	BOXER_INJURED	= 3
	BOXER_KOED	= 4
	BOXER_DEAD	= 5

SNAKE_STATE	= $9B	; 0=neutral, 1=ATTACKING, 2=INJURED 3=KO
	SNAKE_NEUTRAL   = 0
	SNAKE_ATTACKING = 1
	SNAKE_INJURED   = 2
	SNAKE_KOED	= 3

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

SFX_RIGHT               = $B0
SFX_LEFT                = $B1
NOTE_DURATION		= $B2
NOTE_POINTER		= $B3
LEVEL_OVER		= $B4

RAND_A			= $B5
RAND_B			= $B6
RAND_C			= $B7

SNAKE_WHICH_SPRITE	= $B8	; 0=neutral, 1=coiled, 2=injured, 3=attack
	SNAKE_SPRITE_NEUTRAL = 0
	SNAKE_SPRITE_COILED  = 1
	SNAKE_SPRITE_INJURED = 2
	SNAKE_SPRITE_ATTACK  = 3
	SNAKE_SPRITE_EMPTY   = 4

SNAKE_COUNTDOWN		= $B9

BOXER_WHICH_SPRITE	= $BA	; 0=neutral 1=block 2=left punch 3=right punch
	BOXER_SPRITE_NEUTRAL = 0
	BOXER_SPRITE_BLOCK   = 1
	BOXER_SPRITE_LPUNCH  = 2
	BOXER_SPRITE_RPUNCH  = 3
	BOXER_SPRITE_INJURED = 4
	BOXER_SPRITE_DEAD    = 5
	BOXER_SPRITE_EMPTY   = 6
BOXER_COUNTDOWN		= $BB
SFX_NEW			= $BC
COLLIDING		= $BD
SECRET_UNLOCKED		= $BE
SECRET_PROGRESS		= $BF

; tt music player
tt_timer                = $E0    ; current music timer value
tt_cur_pat_index_c0     = $E1    ; current pattern index into tt_SequenceTable
tt_cur_pat_index_c1     = $E2
tt_cur_note_index_c0    = $E3    ; note index into current pattern
tt_cur_note_index_c1    = $E4
tt_envelope_index_c0    = $E5   ; index into ADSR envelope
tt_envelope_index_c1    = $E6
tt_cur_ins_c0           = $E7   ; current instrument
tt_cur_ins_c1           = $E8
tt_ptr                  = $E9   ; temporary
tt_ptr2                 = $EA
player_time_max         = $EB
