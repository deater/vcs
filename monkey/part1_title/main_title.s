.include "../zp.inc"
.include "../../vcs.inc"

	;==========================
	; Main Title
	;==========================
	; potentially arrive here with an unknown number of cycles/scanlines
	; ideally VBLANK=2 (beam off)

do_main_title:

	; =========================
        ; Initialize music.
        ; Set tt_cur_pat_index_c0/1 to the indexes of the first patterns from
        ; tt_SequenceTable for each channel.
        ; Set tt_timer and tt_cur_note_index_c0/1 to 0.
        ; All other variables can start with any value.
        ; =========================

        lda     #0
        sta     tt_cur_pat_index_c0
        lda     #15
        sta     tt_cur_pat_index_c1


        ;=======================
        ; more init

.include "monkey_variables.s"

	jsr	do_title



.include "title.s"
.include "handle_music.s"

.include "../common_routines.s"

.include "monkey_trackdata.s"

.align $100

.include "title.inc"
