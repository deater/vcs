; tt music player
tt_timer                = $80    ; current music timer value
tt_cur_pat_index_c0     = $81    ; current pattern index into tt_SequenceTable
tt_cur_pat_index_c1     = $82
tt_cur_note_index_c0    = $83    ; note index into current pattern
tt_cur_note_index_c1    = $84
tt_envelope_index_c0    = $85   ; index into ADSR envelope
tt_envelope_index_c1    = $86
tt_cur_ins_c0           = $87   ; current instrument
tt_cur_ins_c1           = $88
tt_ptr                  = $89	; temporary
tt_ptr2			= $8A
player_time_max         = $8B
FRAME			= $8C

; zero page addresses
LPF2_L			=	$90
LPF2_H			=	$91
RPF0_L			=	$92
RPF0_H			=	$93
RPF1_L			=	$94
RPF1_H			=	$95
RPF2_L			=	$96
RPF2_H			=	$97
OV1SP_L			=	$98
OV1SP_H			=	$99
OV1C_L			=	$9A
OV1C_H			=	$9B
OV2SP_L			=	$9C
OV2SP_H			=	$9D
OV2C_L			=	$9E
OV2C_H			=	$9F


TEMP1			=	$A0
TEMP2			=	$A1

INL			=	$A3
INH			=	$A4

TITLE_COLOR		=	$A5
BACKGROUND_COLOR	=	$A6
TITLE_COUNTDOWN		=	$A7
DONE_TITLE		=	$A8
BASE_TITLE_COLOR	=	$A9
TEXT_COLOR		=	$AA
PF_TEMP			=	$AB	





