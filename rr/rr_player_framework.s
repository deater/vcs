
; =====================================================================
; Start of code
; =====================================================================


; =====================================================================
; Initialize music.
; Set tt_cur_pat_index_c0/1 to the indexes of the first patterns from
; tt_SequenceTable for each channel.
; Set tt_timer and tt_cur_note_index_c0/1 to 0.
; All other variables can start with any value.
; =====================================================================
        lda #0
        sta tt_cur_pat_index_c0
        lda #12
        sta tt_cur_pat_index_c1
        ; the rest should be 0 already from startup code. If not,
        ; set the following variables to 0 manually:
        ; - tt_timer
        ; - tt_cur_pat_index_c0
        ; - tt_cur_pat_index_c1
        ; - tt_cur_note_index_c0
        ; - tt_cur_note_index_c1



; =====================================================================
; MAIN LOOP
; =====================================================================

MainLoop:



; ---------------------------------------------------------------------
; VBlank
; ---------------------------------------------------------------------

VBlank:

	lda	#%1110
vsyncLoop:
	sta	WSYNC
	sta	VSYNC
	lsr
	bne vsyncLoop

	lda	#2
	sta	VBLANK
	lda	#TIM_VBLANK
	sta	TIM64T

        ; Do VBlank stuff
.include "rr_player.s"

	; Measure player worst case timing
	lda	#TIM_VBLANK
	sec
	sbc	INTIM
	cmp	player_time_max
	bcc	noNewMax
	sta	player_time_max
noNewMax:


waitForVBlank:
        lda INTIM
        bne waitForVBlank
        sta WSYNC
        sta VBLANK


; ---------------------------------------------------------------------
; Kernel
; ---------------------------------------------------------------------

Kernel:
        lda	#TIM_KERNEL
        sta	T1024T

        ; Do kernel stuff

waitForIntim2:
        lda	INTIM
	bne	waitForIntim2


; ---------------------------------------------------------------------
; Overscan
; ---------------------------------------------------------------------

Overscan: ;        SUBROUTINE

        sta	WSYNC
        lda	#2
        sta	VBLANK
        lda	#TIM_OVERSCAN
        sta	TIM64T

        ; Do overscan stuff

waitForIntim:
        lda	INTIM
        bne	waitForIntim


	jmp	MainLoop

