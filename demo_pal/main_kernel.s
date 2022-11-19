
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

.include "deetia2_player.s"

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


	clc
	lda	FRAMEL
	rol
	bne	same_effect
	lda	FRAMEH
	rol

;	lda	FRAMEL							; 3
;	bne	same_effect						; 2/3
;	lda	FRAMEH							; 3
check3:
	cmp	#$6			; $03:00 15s, move on to parallax
	beq	next_effect
	cmp	#$C			; $06:00 ??s, move on to bitmap
	beq	next_effect
	cmp	#$F			; $07:80 ??s, move on to rasterbar
	beq	next_effect
	cmp	#$15			; $0A:80 ??s, move on to fireworks
	beq	next_effect
	cmp	#$25			; $12:80 ??s done?
	bne	same_effect
;	lda	#$ff			; loop
;	sta	WHICH_EFFECT
	jmp	vcs_desire		; restart
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
; 4
	ldx	WHICH_EFFECT						; 3
	lda	jmp_table_low,X						; 4
	sta	INL							; 3
	lda	jmp_table_high,X					; 4
	sta	INH							; 3
	jmp	(INL)							; 5
; 26

jmp_table_low:
	.byte <firework_effect
	.byte <logo_effect
	.byte <parallax_effect
	.byte <bitmap_effect
	.byte <raster_effect


jmp_table_high:
	.byte >firework_effect
	.byte >logo_effect
	.byte >parallax_effect
	.byte >bitmap_effect
	.byte >raster_effect




	;============================
	; handle overscan
	;============================
effect_done:
	ldx     #37							; 2
	jsr	common_overscan						; 6

	jmp	tia_frame


