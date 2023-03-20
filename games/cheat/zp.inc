; zero page addresses

FRAME                   =       $80
FRAMEH                  =       $81
CHEAT_X			=	$82
CHEAT_Y			=	$83
CHEAT_X_COARSE		=	$84
CHEAT_Y_END		=	$85
CHEAT_DIRECTION		=	$86
SHADOW_X		=	$87
SHADOW_X_COARSE		=	$88
SEEDL			=	$89
SEEDH			=	$8A

INL			=	$8C
INH			=	$8D
SCORE_LOW		=	$8E
SCORE_HIGH		=	$8F


TEMP1			=	$90
TEMP2			=	$91

CURRENT_LEVEL		=	$92
	DESTINATION_STRONGBADIA = 0
	DESTINATION_BLUE	= 1
	DESTINATION_PIT		= 2
	DESTINATION_STICK	= 3
	DESTINATION_NONE	= $FF

NEW_LEVEL		=	$93
LAST_LEVEL		=	$94
LAST_X			=	$95

NEW_X			=	$96
SCANLINE		=	$97

CHEATCAKE_COUNT		=	$98
CHEATCAKE_X		=	$99
CHEATCAKE_Y		=	$9A

GRUMBLECAKE_X		=	$9B
GRUMBLECAKE_Y		=	$9C

TITLE_COUNTDOWN		=	$9E
DONE_TITLE		=	$9F

SCORE_SPRITE_LOW_0      =       $A0
SCORE_SPRITE_LOW_1      =       $A1
SCORE_SPRITE_LOW_2      =       $A2
SCORE_SPRITE_LOW_3      =       $A3
SCORE_SPRITE_LOW_4      =       $A4
SCORE_SPRITE_LOW_5      =       $A5
SCORE_SPRITE_LOW_6      =       $A6

SCORE_SPRITE_HIGH_0     =       $A7
SCORE_SPRITE_HIGH_1     =       $A8
SCORE_SPRITE_HIGH_2     =       $A9
SCORE_SPRITE_HIGH_3     =       $AA
SCORE_SPRITE_HIGH_4     =       $AB
SCORE_SPRITE_HIGH_5     =       $AC
SCORE_SPRITE_HIGH_6     =       $AD

SFX_RIGHT		=	$B0
SFX_LEFT		=	$B1


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


