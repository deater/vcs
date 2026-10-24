; music player

.include "../../../vcs.inc"

; zero page addresses

.include "../zp.inc"

	;=======================
        ; run the music player
        ;=======================
play_music:

	;========================
	; update music player
	;========================
	; worst case for this particular song seems to be
	;       around 9 * 64 = 576 cycles = 8 scanlines
	;       make it 12 * 64 = 11 scanlines to be safe

	; Original is 43 * 64 cycles = 2752/76 = 36.2 scanlines

	lda	#12             ; TIM_VBLANK
	sta	TIM64T

.include "trial00e4_player.s"

        ; Measure player worst case timing
;       lda     #12             ; TIM_VBLANK
;       sec
;       sbc     INTIM
;       cmp     player_time_max
;       bcc     no_new_max
;       sta     player_time_max
;no_new_max:


wait_for_vblank:
        lda     INTIM
        bne     wait_for_vblank

	rts

	;=====================
	; other includes

.include "trial00e4_trackdata.s"




