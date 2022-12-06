handle_music:
	;========================
	; update music player
	;========================
	; worst case for this particular song seems to be
	;       around 9 * 64 = 576 cycles = 8 scanlines
	;       make it 12 * 64 = 11 scanlines to be safe

	; Original is 43 * 64 cycles = 2752/76 = 36.2 scanlines

	lda     #12             ; TIM_VBLANK
	sta     TIM64T

	;=======================
	; run the music player
	;=======================

.include "monkey_intro_player.s"

	; Measure player worst case timing
	lda     #12             ; TIM_VBLANK
	sec
	sbc     INTIM
	cmp     player_time_max
	bcc     no_new_max
	sta     player_time_max
no_new_max:


wait_for_vblank:
	lda     INTIM
	bne     wait_for_vblank

	; in theory we are 10 scanlines in, need to delay 27 more

	sta     WSYNC




        ldx     #(33-12)
vbsc_loop:
        sta     WSYNC
        dex
        bne     vbsc_loop

	rts
