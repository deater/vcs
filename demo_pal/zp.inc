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
FRAMEL			= $8C
FRAMEH			= $8D
LOGO_Y			= $8E
LOGO_LEFT		= $8F

; zero page addresses
WHICH_EFFECT		= $90

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





