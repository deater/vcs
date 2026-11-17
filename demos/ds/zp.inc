; zero page addresses

data_bytes	= $80 ; FIXME

DONE_TITLE	= $80

FIRST_TIME	= $85
FRAMEL		= $86
FRAMEH		= $87
POS_TEMP	= $88	; position
PAGE_SAVE	= $89	; all
SPRITE_OFFSET	= $8A	; desktop
SPRITE_LENGTH	= $8B	; desktop
INL		= $8C
INH		= $8D
OUTL		= $8E
OUTH		= $8F

char_data_start = $90

BANK_256_DATA_0	= $90
BANK_256_DATA_1	= $91
BANK_256_DATA_2	= $92
BANK_256_DATA_3	= $93
BANK_256_DATA_4	= $94
BANK_256_DATA_5	= $95
BANK_256_DATA_6	= $96
TEMP		= $97

BANK_1K_DATA_0	= $98
BANK_1K_DATA_1	= $99
BANK_1K_DATA_2	= $9A
BANK_1K_DATA_3	= $9B
BANK_1K_DATA_4	= $9C
BANK_1K_DATA_5	= $9D
BANK_1K_DATA_6	= $9E
TEMPY		= $9F

;WHICH_EFFECT            = $90
SPRITE0_YADD            = $A1
RASTER_R_Y              = $A2
RASTER_R_YADD           = $A3
RASTER_B_Y              = $A4
RASTER_B_YADD           = $A5
RASTER_G_Y              = $A6
RASTER_G_YADD           = $A7
SPRITE0_X               = $A8
SPRITE0_Y               = $A9
SPRITE0_X_COARSE        = $AA
SPRITE0_XADD            = $AB
SPRITE1_X               = $AC
SPRITE1_Y               = $AD
SPRITE1_X_COARSE        = $AE
SPRITE1_XADD            = $AF

FONTL			= $B0
FONTH			= $B1
FONT2L			= $B2
FONT2H			= $B3
TEMP1			= $B4
IS_DRUM			= $B5
TEMP2			= $B6
WHICH_ROW		= $B7

ZIGZAG0			= $B8
ZIGZAG1			= $B9
ZIGZAG2			= $BA
ZIGZAG3			= $BB
ZIGZAG4			= $BC
ZIGZAG5			= $BD
ZIGZAG6			= $BE
ZIGZAG7			= $BF


READ_1K_L_DATA_0	= $C0
READ_1K_L_DATA_1	= $C1
READ_1K_L_DATA_2	= $C2
READ_1K_L_DATA_3	= $C3
READ_1K_L_DATA_4	= $C4
READ_1K_L_DATA_5	= $C5
READ_1K_L_DATA_6	= $C6

READ_1K_H_DATA_0	= $C8
READ_1K_H_DATA_1	= $C9
READ_1K_H_DATA_2	= $CA
READ_1K_H_DATA_3	= $CB
READ_1K_H_DATA_4	= $CC
READ_1K_H_DATA_5	= $CD
READ_1K_H_DATA_6	= $CE


; for the zx02 decompression

offset		=	$D0
offset_h	=	$D1
ZX0_src		=	$D2
ZX0_src_h	=	$D3
ZX0_dst		=	$D4
ZX0_dst_h	=	$D5
bitr		=	$D6
pntr		=	$D7
pntr_h		=	$D8
READ_WRITE_OFFSET=	$D9
LOCATION_LOAD_DELAY=	$DA


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

; Reserve $F0+ for the stack?

