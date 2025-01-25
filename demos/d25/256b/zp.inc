; tt music player
.if 0
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
.endif

FRAMEL			= $8C
FRAMEH			= $8D
FRAMEL_DIV4		= $8E

;TEMP1			=	$A0
TEMP2			=	$A1
;SPRITE0_YADD		=	$A2
INL			=	$A3
INH			=	$A4

MUSIC_HIT		=	$B3
SOUND_POINTER		=	$B4
SOUND_COUNTDOWN		=	$B5
ZIGZAG_OFFSET		=	$B6

ZIGZAG0			=	$B8
ZIGZAG1			=	$B9
ZIGZAG2			=	$BA
ZIGZAG3			=	$BB
ZIGZAG4			=	$BC
ZIGZAG5			=	$BD
ZIGZAG6			=	$BE
ZIGZAG7			=	$BF


