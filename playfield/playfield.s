.include "../vcs.inc"

; zero page addresses

PATTERN	= $80

start:

	; clear out the Zero Page (RAM and TIA registers)

	ldx	#0
	txa
clear_loop:
	sta	$0,X
	inx
	bne	clear_loop


	; initialize

	lda	#0
	sta	PATTERN		; set playfield pattern

	lda	#$45
	sta	COLUPF		; set playfield color

	ldy	#0

start_frame:

	; Start Vertical Blank

	lda	#2			; reset beam to top of screen
	sta	VSYNC

	; wait for 3 scanlines of VSYNC

	sta	WSYNC			; wait until end of scanline
	sta	WSYNC
	sta	WSYNC

	lda	#0			; done beam reset
	sta	VSYNC

	; 37 lines of vertical blank

	ldx	#0
vblank_loop:
	sta	WSYNC
	inx
	cpx	#36
	bne	vblank_loop


	iny
	cpy	#20
	bne	no_change

	ldy	#0		; reset count

	inc	PATTERN

no_change:

	lda	PATTERN
	sta	PF1

	sta	WSYNC

	lda	#0			; turn on beam
	sta	VBLANK



	; visible area: 192 lines (NTSC) / 228 (PAL)
	; change background color each line

	ldx	#0

colorful_loop:
	stx	COLUBK
	sta	WSYNC
	inx
	cpx	#192
	bne	colorful_loop

	; overscan

	lda	#$2		; turn off beam
	sta	VBLANK

	ldx	#0
overscan_loop:
	sta	WSYNC
	inx
	cpx	#30
	bne	overscan_loop

	jmp	start_frame

.segment "IRQ_VECTORS"
	.word start	; NMI
	.word start	; RESET
	.word start	; IRQ


