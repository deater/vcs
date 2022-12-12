.include "../zp.inc"
.include "../../../vcs.inc"

	;==========================
	; Opener
	;==========================
	; potentially arrive here with an unknown number of cycles/scanlines
	; ideally VBLANK=2 (beam off)

do_opener:

	; =========================
        ; Initialize music.
        ; Set tt_cur_pat_index_c0/1 to the indexes of the first patterns from
        ; tt_SequenceTable for each channel.
        ; Set tt_timer and tt_cur_note_index_c0/1 to 0.
        ; All other variables can start with any value.
        ; =========================

        lda     #0
        sta     tt_cur_pat_index_c0
	sta	tt_timer
	sta	tt_cur_note_index_c0
	sta	tt_cur_note_index_c1
        lda     #3
        sta     tt_cur_pat_index_c1


        ;=======================
        ; more init

.include "monkey_intro_variables.s"


	jsr	do_opening
	jmp	do_title



.include "opening.s"
.include "title.s"
.include "handle_music.s"

.include "../common_addresses.inc"

.include "monkey_intro_trackdata.s"

;.align $100
.include "lucas.inc"
.include "title.inc"
