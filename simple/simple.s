.include "../vcs.inc"

; zero page

PATTERN	=	$80

start:

start_frame:
	; Start Vertical Blank

	lda	#2				; reset beam to top of screen
	sta	VSYNC

	; wait for 3 scanlines

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC

	lda	#0				; done beam reset
	sta	VSYNC


	; 37 scanlines of vertical blank

	ldx	#37
vblank_loop:
	sta	WSYNC
	dex
	bne	vblank_loop

	lda	#0				; turn on beam
	sta	VBLANK

	; create pattern
	; visible area: 192 lines (NTSC) / 228 (PAL)

	ldx	PATTERN		; increment pattern by 2
	inx
	inx
	stx	PATTERN

	ldy	#192		; 192 lines
draw_screen_loop:
	sta	WSYNC

	stx	PF0		; also draw playfield
	stx	PF1
	stx	PF2

	stx	COLUBK		; background color
	inx			; update pattern and color

	dey
	bne	draw_screen_loop

	; overscan

	lda	#$2
	sta	VBLANK		; turn off beam

	ldx	#30
overscan_loop:
	sta	WSYNC
	dex
	bne	overscan_loop

	jmp	start_frame

.segment "IRQ_VECTORS"
	.word start	; NMI
	.word start	; RESET
	.word start	; IRQ


