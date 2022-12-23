.include "../../vcs.inc"

; zero page addresses

PATTERN	= $80

start:
	;==========================
	; initialize the 6507
	;       and clear RAM
	;==========================

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
	; S = $FF, A=$0, x=$0, Y=??             ;       8+(256*10)-1=2567 / 10B


	; init

	lda	#$10
	sta	NUSIZ0
	sta	NUSIZ1
	sta	CTRLPF

	lda	#2
	sta	ENAM0
	sta	ENAM1
	sta	ENABL



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

	;================================
	; 37 lines of vertical blank
	;================================


	; 35 WSYNCS

	ldx	#35
vblank_loop:
	dex
	sta	WSYNC
	bne	vblank_loop


	;======================
	; set up starfield
	;======================

	lda	#$ff
	sta	COLUP0

	lda	#$ff
	sta	HMM0
	lda	#$c0
	sta	WSYNC
	sta	HMOVE
	; sleep 5
	nop
	nop
	nop
;	lda	$80
	sta	HMM0


;	sta	WSYNC

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



	;============================================
	; visible area: 192 lines (NTSC) / 228 (PAL)
	;============================================


	ldx	#0

colorful_loop:
	sta	WSYNC
	inx
	cpx	#192
	bne	colorful_loop

	;=================================
	; overscan
	;=================================

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


