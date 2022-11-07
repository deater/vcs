
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

	sta	WSYNC

	;=================================
	; VBLANK scanline 12 -- handle frame
	;=================================

	inc	FRAMEL                                                  ; 5
	bne	no_frame_oflo						; 2/3
frame_oflo:
        inc	FRAMEH                                                  ; 5
no_frame_oflo:

	; switch effects

	lda	FRAMEL							; 3
	bne	same_effect						; 2/3
	lda	FRAMEH							; 3
check3:
	cmp	#2
	beq	next_effect
	cmp	#4
	beq	next_effect
	cmp	#6
	bne	same_effect
next_effect:
	inc	WHICH_EFFECT
same_effect:


	;=======================
	; wait the rest
	;=======================

	ldx	#26							; 2
le_vblank_loop:
	sta     WSYNC							; 3
	dex								; 2
	bne	le_vblank_loop						; 2/3

	;============================
	; choose which effect to run
	;============================

;	ldx	WHICH_EFFECT
	ldx	#2
	lda	jmp_table_low,X
	sta	INL
	lda	jmp_table_high,X
	sta	INH
	jmp	(INL)


jmp_table_low:
	.byte <logo_effect
	.byte <bitmap_effect
	.byte <raster_effect
jmp_table_high:
	.byte >logo_effect
	.byte >bitmap_effect
	.byte >raster_effect



	;============================
	; handle overscan
	;============================
effect_done:
	ldx     #37							; 2
	jsr	common_overscan						; 6

	jmp	tia_frame


