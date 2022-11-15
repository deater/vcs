; testing tia music player

.include "../vcs.inc"

; zero page addresses

.include "zp.inc"

	;=============================
	; clear out mem / init things
	;=============================

tia_spirit:
;	sei								; 2
;	cld		; clear decimal mode				; 2
;
;	ldx	#0							; 2
;	txa								; 2
;clear_loop:
;	sta	$0,X							; 4
;	inx								; 2
;	bne	clear_loop						; 2/3
;	dex								; 2
;	txs	; point stack to $1FF (mirrored at top of zero page)	; 2
;							;	=============
;							; 8+256*9+3 = 2315 /12B

	; TODO: can we move txs outside loop?

	sei			; disable interrupts			; 2
	cld			; clear decimal mode			; 2
	ldx	#0							; 2
	txa								; 2
clear_loop:
	dex								; 2
	txs								; 2
	pha								; 3
	bne	clear_loop						; 2/3
						;============================
	; S = $FF, A=$0, x=$0, Y=??		;	8+(256*10)-1=2567 / 10B


	; =========================
	; Initialize music.
	; Set tt_cur_pat_index_c0/1 to the indexes of the first patterns from
	; tt_SequenceTable for each channel.
	; Set tt_timer and tt_cur_note_index_c0/1 to 0.
	; All other variables can start with any value.
	; =========================

	lda	#0
	sta	tt_cur_pat_index_c0
	lda	#72
	sta	tt_cur_pat_index_c1

;======================================================================
; MAIN LOOP
;======================================================================


	; init rasterbars
	ldy	#90
	sty	RASTER_G_Y
	ldy	#122
	sty	RASTER_R_Y
	ldy	#154
	sty	RASTER_B_Y
	inc	RASTER_R_YADD
	inc	RASTER_B_YADD
	inc	RASTER_G_YADD
	ldy	#10
	sty	LOGO_Y
	ldy	#100
	sty	SPRITE0_X
	sty	SPRITE0_Y
	sty	SPRITE1_X
	dec	SPRITE0_XADD
	inc	SPRITE0_YADD
	inc	SPRITE0_YADD
	inc	SPRITE1_XADD
;	inc	LOGO_YADD

.include "tia_kernel.s"

.include "logo_kernel.s"
.include "bitmap_kernel.s"
.include "raster_kernel.s"

.align $100

.include "desire_logo.inc"
.include "fine_adjust.inc"

	;=====================
	; other includes


.include "common_routines.s"


.include "tia_spirit_trackdata.s"

.segment "IRQ_VECTORS"
	.word tia_spirit	; NMI
	.word tia_spirit	; RESET
	.word tia_spirit	; IRQ
