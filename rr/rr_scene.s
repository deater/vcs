
; =====================================================================
; Initialize music.
; Set tt_cur_pat_index_c0/1 to the indexes of the first patterns from
; tt_SequenceTable for each channel.
; Set tt_timer and tt_cur_note_index_c0/1 to 0.
; All other variables can start with any value.
; =====================================================================

	lda	#0
	sta	tt_cur_pat_index_c0
	lda	#12
	sta	tt_cur_pat_index_c1

	; the rest should be 0 already from startup code. If not,
	; set the following variables to 0 manually:
	; - tt_timer
	; - tt_cur_pat_index_c0
	; - tt_cur_pat_index_c1
	; - tt_cur_note_index_c0
	; - tt_cur_note_index_c1

;======================================================================
; MAIN LOOP
;======================================================================

rr_frame:

	;========================
	; start VBLANK
	;========================
	; in scanline 0

	jsr	common_vblank


	;=======================
	; 37 lines of VBLANK
	;=======================


	;========================
	; update music player
	;========================
	; worst case for this particular song seems to be
	;	around 9 * 64 = 576 cycles = 8 scanlines
	;	make it 12 * 64 = 11 scanlines to be safe

	; Original is 43 * 64 cycles = 2752/76 = 36.2 scanlines

	lda	#12		; TIM_VBLANK
	sta	TIM64T


	;=======================
	; run the music player
	;=======================

.include "rr_player.s"

	; Measure player worst case timing
	lda	#12		; TIM_VBLANK
	sec
	sbc	INTIM
	cmp	player_time_max
	bcc	no_new_max
	sta	player_time_max
no_new_max:


wait_for_vblank:
        lda	INTIM
        bne	wait_for_vblank

	; in theory we are 10 scanlines in, need to delay 27 more

	ldx	#27
le_vblank_loop:
	sta     WSYNC
	dex
	bne	le_vblank_loop


	; one extra, for luck?  Not sure where my math is off
	sta	WSYNC


	;=========================
	;=========================
	; kernel
	;=========================
	;=========================
	; 192 cycles

	ldx	#192
kernel_loop:
	sta	WSYNC
	dex
	bne	kernel_loop



	;===========================
	;===========================
	; overscan (30 cycles)
	;===========================
	;===========================

	ldx     #30
	jsr	common_overscan

	jmp	rr_frame

