.include "vcs.inc"

start:
	; Start Vertical Blank

	lda	#0
	sta	VBLANK

	lda	#2
	sta	VSYNC

	; wait for 3 scanlines of VSYNC

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC

	lda	#0
	sta	VSYNC

	; vertical blank

	ldx	#45
loop1:
	sta	WSYNC
	dex
	bne	loop1

	; visible area: 192 lines (NTSC) / 228 (PAL)

	ldx	$80
	inx
	inx
	stx	$80

	ldy	#192
loop2:
	sta	WSYNC

	stx	PF0
	stx	PF1
	stx	PF2

	stx	COLUBK
	inx

	dey
	bne	loop2

	; overscan

	lda	#%01000010

	sta	VBLANK

	ldx	#36
loop3:
	sta	WSYNC
	dex
	bne	loop3

	jmp	start

.segment "IRQ_VECTORS"
	.word start	; NMI
	.word start	; RESET
	.word start	; IRQ


