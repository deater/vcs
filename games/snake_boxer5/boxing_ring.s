	;===========================
	; do some Snake Boxing!
	;===========================
	; ideally called with VBLANK disabled


	lda	#CTRLPF_REF|CTRLPF_BALL_SIZE4				; 2
							; reflect playfield
	sta	CTRLPF                                                  ; 3

level_frame:

	; comes in with 3 cycles from loop


	;============================
	; Start Vertical Blank
	;============================
	; actually takes 4 scanlines, clears out current then three more

	jsr	common_vblank

; 9



	;=================================
	;=================================
	; 37 lines of vertical blank
	;=================================
	;=================================

	ldx	#35
	jsr	common_delay_scanlines


	;==============================
	; now VBLANK scanline 36
	;==============================

	lda	#$FF
	sta	PF1
	sta	PF2
	sta	COLUPF

	lda	#0
	sta	PF0
	sta	COLUBK
	sta	VBLANK	; enable beam


	sta	WSYNC

	;==============================
	; now VBLANK scanline 37
	;==============================

	;===============================
	;===============================
	;===============================
	; visible area: 192 lines (NTSC)
	;===============================
	;===============================
	;===============================


	;===============================
	; 12 lines of score
	;===============================

	lda	#$E
	sta	COLUPF

	ldx	#11
	jsr	common_delay_scanlines

	lda	#$0
	sta	COLUPF

	sta	WSYNC


	;===============================
	; 12 lines of rope
	;===============================

	lda	#$e			; white
	sta	COLUPF

	lda	#$BF
	sta	PF1

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC

	lda	#$40
	sta	PF1
	lda	#$00
	sta	PF2

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC

	;===============================
	; 128 lines of middle
	;===============================

	lda	#$BF
	sta	PF1
	lda	#$FF
	sta	PF2

	lda	#$6			; medium grey
	sta	COLUPF

	ldx	#128
	jsr	common_delay_scanlines


	;===============================
	; 12 lines of rope (bottom)
	;===============================

	lda	#$e			; white
	sta	COLUPF

	lda	#$40
	sta	PF1
	lda	#$00
	sta	PF2

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC

	lda	#$BF
	sta	PF1
	lda	#$FF
	sta	PF2

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC




	;===============================
	; 28 lines of health
	;===============================

	lda	#134		; blue
	sta	COLUPF

	lda	#$FF
	sta	PF1
	sta	PF2

	ldx	#28
	jsr	common_delay_scanlines


	;==================================
	;==================================
	;==================================
	; overscan 30, handle end
	;==================================
	;==================================
	;==================================
	;==================================

	ldx	#30
	jsr	common_overscan

	;==================================
	; overscan 30, handle end
	;==================================

	jmp	level_frame
