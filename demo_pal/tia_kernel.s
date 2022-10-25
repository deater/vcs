
; =====================================================================
; Initialize music.
; Set tt_cur_pat_index_c0/1 to the indexes of the first patterns from
; tt_SequenceTable for each channel.
; Set tt_timer and tt_cur_note_index_c0/1 to 0.
; All other variables can start with any value.
; =====================================================================

	lda	#0
	sta	tt_cur_pat_index_c0
	lda	#$4a
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

tia_frame:

	;========================
	; start VBLANK
	;========================
	; in scanline 0

	jsr	common_vblank


	;================================
	; 45 lines of VBLANK (37 on NTSC)
	;================================


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

.include "tia_spirit_player.s"

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

	;=======================
	; wait the rest
	;=======================

	ldx	#27							; 2
le_vblank_loop:
	sta     WSYNC							; 3
	dex								; 2
	bne	le_vblank_loop						; 2/3


	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC

	;=================================
	; VBLANK scanline 45
	;=================================
; 3
	lda	#0							; 2
	sta	VBLANK                  ; turn on beam			; 3
; 8

        lda	#6			; bg, light grey		; 2
        sta	COLUBK							; 3
; 13
	lda	#0							; 2
	sta	VDELP0							; 3
	sta	VDELP1		; turn off delay			; 3
; 21

	lda	#NUSIZ_QUAD_SIZE|NUSIZ_MISSILE_WIDTH_8			; 2
	sta	NUSIZ0							; 3
	lda	#NUSIZ_QUAD_SIZE|NUSIZ_MISSILE_WIDTH_8			; 2
	sta	NUSIZ1							; 3
; 31

	lda	#2							; 2
	sta	COLUPF			; fg, dark grey			; 3

; 36

	sta	WSYNC							; 3



	;=========================
	;=========================
	; kernel
	;=========================
	;=========================
	; 228 scanlines (192 on NTSC)

	ldy	#228
kernel_loop:
	sta	WSYNC
	dey
	bne	kernel_loop

done_kernel:


	;===========================
	;===========================
	; overscan (36 cycles) (30 on NTSC)
	;===========================
	;===========================

	; turn off everything
	lda	#0							; 2
	sta	GRP0							; 3
; 1
	lda	#2		; we do this in common
	sta	VBLANK		; but want it to happen in hblank


	lda	#0
	sta	GRP1							; 3
	sta	PF0							; 3
	sta	PF1							; 3
	sta	PF2							; 3
; 13

	ldx     #36							; 2
	jsr	common_overscan						; 6

	jmp	tia_frame
