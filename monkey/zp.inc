; zero page addresses
LPF2_L			=	$80
LPF2_H			=	$81
RPF0_L			=	$82
RPF0_H			=	$83
RPF1_L			=	$84
RPF1_H			=	$85
RPF2_L			=	$86
RPF2_H			=	$87
OV1SP_L			=	$88
OV1SP_H			=	$89
OV1C_L			=	$8A
OV1C_H			=	$8B
OV2SP_L			=	$8C
OV2SP_H			=	$8D
OV2C_L			=	$8E
OV2C_H			=	$8F


TEMP1			=	$90
TEMP2			=	$91

FRAME			=	$92
INL			=	$93
INH			=	$94

TITLE_COLOR		=	$95
BACKGROUND_COLOR	=	$96
DEBOUNCE_COUNTDOWN	=	$97
ALL_DONE		=	$98
BASE_TITLE_COLOR	=	$99
TEXT_COLOR		=	$9A
PF_TEMP			=	$9B	



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
tt_ptr                  = $E9	; temporary
tt_ptr2			= $EA
player_time_max         = $EB

