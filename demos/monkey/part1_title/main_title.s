.include "../zp.inc"
.include "../../../vcs.inc"

.include "monkey_variables.s"

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

; ??? at least 15

        lda     #0						; 2
        sta     tt_cur_pat_index_c0				; 3
	sta	tt_timer					; 3
	sta	tt_cur_note_index_c0				; 3
	sta	tt_cur_note_index_c1				; 3
        lda     #15						; 2
        sta     tt_cur_pat_index_c1				; 3
; 19


	;=======================
	; run the title routine

.include "title.s"

	rts


.include "handle_music.s"

.include "../common_addresses.inc"

.include "monkey_trackdata.s"

;.align $100

.include "title.inc"
