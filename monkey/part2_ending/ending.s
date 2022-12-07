.include "../zp.inc"
.include "../../vcs.inc"

	;==========================
	; Ending
	;==========================
	; potentially arrive here with an unknown number of cycles/scanlines
	; ideally VBLANK=2 (beam off)

do_ending:

.include "trials.s"
.include "cart.s"

	; =========================
        ; Initialize music.
        ; Set tt_cur_pat_index_c0/1 to the indexes of the first patterns from
        ; tt_SequenceTable for each channel.
        ; Set tt_timer and tt_cur_note_index_c0/1 to 0.
        ; All other variables can start with any value.
        ; =========================

        lda     #0
        sta     tt_cur_pat_index_c0
        lda     #3
        sta     tt_cur_pat_index_c1


        ;=======================
        ; more init

;.include "monkey_intro_variables.s"



;.include "handle_music.s"

.include "../common_addresses.inc"

;.include "monkey_intro_trackdata.s"

.align $100
.include "trials.inc"
.include "cart_message.inc"
.include "lookout.inc"
.include "lookout_over.inc"

