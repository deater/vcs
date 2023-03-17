; the cheat?

; o/~ F o/~
; that's not F

; by Vince `deater` Weaver <vince@deater.net>

.include "../../vcs.inc"


; zero page addresses

TEXT_COLOR		=	$80
MAIN_COLOR              =       $81
LINE_COLOR              =       $82
FRAME                   =       $83
FRAMEH                  =       $84
FRAME2                  =       $85
MUSIC_POINTER		=	$86
MUSIC_COUNTDOWN		=	$87
MUSIC_PTR_L		=	$88
MUSIC_PTR_H		=	$89

TEMP1			=	$90
TEMP2			=	$91
DIV3			=	$92
XSAVE			=	$93
TITLE_COUNTDOWN		=	$9C
DONE_TITLE		=	$9E

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

the_cheat_start:

	;=======================
	; clear registers/ZP/TIA
	;=======================

	sei			; disable interrupts
	cld			; clear decimal mode
	ldx	#0
	txa
clear_loop:
	dex
	txs
	pha
	bne	clear_loop

	; S = $FF, A=$0, x=$0, Y=??

	lda	#$E			; setup debounce
	sta	TITLE_COUNTDOWN

; =====================================================================
; Initialize music.
; Set tt_cur_pat_index_c0/1 to the indexes of the first patterns from
; tt_SequenceTable for each channel.
; Set tt_timer and tt_cur_note_index_c0/1 to 0.
; All other variables can start with any value.
; =====================================================================
        lda #0
        sta tt_cur_pat_index_c0
        lda #11
        sta tt_cur_pat_index_c1
        ; the rest should be 0 already from startup code. If not,
        ; set the following variables to 0 manually:
        ; - tt_timer
        ; - tt_cur_pat_index_c0
        ; - tt_cur_pat_index_c1
        ; - tt_cur_note_index_c0
        ; - tt_cur_note_index_c1


	;=========================
	; title
	;=========================

	.include "title.s"

	;=========================
	; gameplay
	;=========================


	.include "strongbadia.s"

.include "title_pf.inc"
.align $100
.include "title_sprites.inc"
.include "strongbadia.inc"

.include "cheat2_trackdata.s"
.include "cheat2_player.s"

	;====================
	; scanline wait
	;====================
	; scanlines to wait in X

scanline_wait:
	sta	WSYNC
	dex						; 2
	bne	scanline_wait				; 2/3
	rts						; 6

	;==================
	; increment frame
	;==================
	; worst case 18
inc_frame:
	inc	FRAME					; 5
	bne	no_inc_high				; 2/3
	inc	FRAMEH					; 5
no_inc_high:
	rts						; 6


.segment "IRQ_VECTORS"
	.word the_cheat_start	; NMI
	.word the_cheat_start	; RESET
	.word the_cheat_start	; IRQ
