	;=====================
	; VBLANK/VSYNC
	;=====================

common_vblank:

	;============================
	; Start Vertical Blank
	;============================

	lda	#2
	sta	VSYNC

	;=================================
	; wait for 3 scanlines of VSYNC
	;=================================

	sta	WSYNC		; wait until end of scanline
	sta	WSYNC
	lda	#0		; done beam reset			; 2
	sta	WSYNC

	; now in VSYNC scanline 3

	sta	VSYNC							; 3

	rts

; 9 cycles in
