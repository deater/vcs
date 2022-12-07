	;=====================
	; VBLANK/VSYNC
	;=====================
	; actually takes 4 scanlines, clears out old one first

common_vblank:

	;============================
	; Start Vertical Blank
	;============================

	lda	#2


	;=================================
	; wait for 3 scanlines of VSYNC
	;=================================

	sta	WSYNC		; wait until end of scanline
	sta	VSYNC

	sta	WSYNC
	sta	WSYNC
	lda	#0		; done beam reset			; 2
	sta	WSYNC

	; now in VSYNC scanline 3

	sta	VSYNC							; 3

	rts								; 6

; 9 cycles in




	;=============================
	; overscan
	;=============================
	; amount of scanlines to wait is in X

common_overscan:
	lda	#$2		; turn off beam
	sta	VBLANK

common_delay_scanlines:
	sta	WSYNC							; 3
	dex								; 2
	bne	common_delay_scanlines					; 2/3
	rts								; 6


