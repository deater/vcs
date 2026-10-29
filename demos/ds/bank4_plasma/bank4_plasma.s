; e7 plasma?

.include "../../../vcs.inc"

; zero page addresses

.include "../zp.inc"

.include "../common_routines.inc"


	;=======================
        ; plasma
        ;=======================
do_plasma:

	;==========================
	; title screen
	;==========================
	; potentially arrive here with an unknown number of cycles/scanlines
	; ideally VBLANK=2 (beam off)

; should be zero from initial code

;	lda	#$0
;	sta	DONE_TITLE

start_plasma:


	;=================
	; start VBLANK
	;=================
	; want to come in 1 scanline down
	; as this finishes old then does 3 for VSYNC

	jsr	common_vblank

; 9

	;=============================
	; 37 lines of vertical blank
	;=============================

        ldx     #33
	jsr	repeat_wsync

	;====================
	; now in scanline 34
	;====================
        sta     WSYNC
	;====================
	; now in scanline 35
	;====================
        sta     WSYNC
	;====================
	; now in scanline 36
	;====================

	lda	#$1e
	sta	COLUPF

	lda	#$AA
	sta	PF0
	sta	PF2
	lda	#$55
	sta	PF1


        sta     WSYNC
	;====================
	; now in scanline 37
	;====================

	lda	#0
	sta	VBLANK

        sta     WSYNC


	;======================================
	; playfield
	;======================================

	ldx	#192
	jsr	repeat_wsync


	;==========================
	; overscan for 30 scanlines
	;==========================

	ldx	#29
	jsr	common_overscan

; 10
	lda	DONE_TITLE						; 3
	bne	done_plasma						; 2/3
; 15

	jmp	start_plasma						; 3
; 18

done_plasma:
; 16



	rts

