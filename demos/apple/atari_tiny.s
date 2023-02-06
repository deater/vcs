; Atari Logo

; by Vince `deater` Weaver <vince@deater.net>


; $239 -- first attempt
; $200 -- auto-gen colors
; $1E0 -- mirror playfield

; TODO: Music?
;	Animated sine wave down sides?

.include "../../vcs.inc"

; zero page addresses

TEXT_COLOR		=	$80
TEMP1			=	$90
TEMP2			=	$91
DIV3			=	$92
XSAVE			=	$93

atari_tiny_start:

	;=======================
	; clear registers/ZP/TIA
	;=======================

	sei			; disable interrupts
	cld			; clear decimal mode
	ldx	#0
	txa
clear_loop:
	dex
	txs
	pha
	bne	clear_loop

	; S = $FF, A=$0, x=$0, Y=??

start_frame:

	;=========================
	; Start Vertical Blank
	;=========================

	lda	#2			; reset beam to top of screen
	sta	VSYNC

	; wait for 3 scanlines of VSYNC

	sta	WSYNC			; wait until end of scanline
	sta	WSYNC

	inc	TEXT_COLOR		; update text color

	sta	WSYNC

	lda	#0			; done beam reset
	sta	VSYNC

	; 37 lines of vertical blank

	ldx	#36
	jsr	scanline_wait
; 10
	sta	WSYNC

	lda	#0			; turn on beam
	sta	VBLANK

	;===========================
	;===========================
	; playfield
	;===========================
	;===========================
	; draw 192 lines



	;===========================
	; first 9 lines black
	;===========================

	lda	#0
	sta	COLUPF
	ldx	#8
	jsr	scanline_wait

	; FIXME: X already 0 here?
; 10

	tsx
	stx	XSAVE		; save stack as we corrupt it

	ldy	#0		; clear div3 count
	sty	PF0		; also clear leftmost playfield

	ldx	#171		; we count down 171

	lda	#CTRLPF_REF
	sta	CTRLPF

	sta	WSYNC



colorful_loop:
; 3
	txs				; save X in stack		; 2
	lda	TEXT_COLOR		; get color			; 3
	sta	COLUPF			; set playfield color		; 3
	lda	row_lookup,X		; get which playfield lookup	; 4+
	tax				; put in X			; 2
; 18/19

	; PF0 set in previous scanline
	lda	playfield1_left,X	;				; 4+
	sta	PF1			;				; 3
	; has to happen by 28
; 25/26
	lda	playfield2_left,X	;				; 4+
	sta	PF2			;				; 3
	; has to happen by 38
; 32/33
;	lda	playfield0_right,X	;				; 4+
;	sta	PF0			;				; 3
	; has to happen 28-49
; 39/40
;	lda	playfield1_right,X	;				; 4+
;	sta	PF1			;				; 3
	; has to happen 38-56
; 46/47
;	lda	#0			; always 0			; 2
;	sta	PF2			;				; 3
;	sta	PF0							; 3
	; has to happen 49-67
; 54/55

;	dec	DIV3			; dec div3 count		; 5
;	bpl	not3							; 2/3

;	lda	#2			; reset div3 count		; 2
;	sta	DIV3							; 3
;	iny				; inc div3 color ptr		; 2
;not3:
; 68/69 worst case

	tsx				; restore X from stack ptr	; 2
	dex				; dec X				; 2

; 72/73

	sta	WSYNC			;				; 3
; 75/76
	bne	colorful_loop		;				; 2/3

	;=================
	; done!

	ldx	XSAVE			; restore stack			; 3
	txs								; 2

	;================
	; scanline 180
	;	set things up

	ldx	#16
oog_loop:
	sta	WSYNC
	dex
	bne	oog_loop


	;============================
	; overscan
	;============================

	lda	#$2		; turn off beam
	sta	VBLANK

	; wait 30 scanlines

	ldx	#30
	jsr	scanline_wait

	jmp	start_frame


	;====================
	; scanline wait
	;====================
	; scanlines to wait in X

scanline_wait:
	sta	WSYNC
	dex						; 2
	bne	scanline_wait				; 2/3
	rts						; 6


.align $100

row_lookup:
.byte	0,0,0,0,0,0,0,0
.byte	0,0,0,0,0,0,0,0
.byte	0,0,0,0,0,0,0,0
.byte	0,0,0,0,0,0,0,0
.byte	 0, 0, 0, 0, 0,15,15,15
.byte	14,14,13,13,13,12,12,12
.byte	12,12,12,12,12,12,11,11
.byte	11,11,11,10,10, 9, 9, 9
.byte	 8, 8, 8, 7, 7, 7, 7, 7
.byte	 6, 6, 5, 5, 5, 5, 5, 5
.byte	 4, 4, 4, 4, 4, 4, 4, 4
.byte	 4, 4, 4, 4, 3, 2, 2, 2
.byte	 2, 2, 2, 2, 2, 2, 2, 2
.byte	 2, 2, 2, 2, 2, 2, 2, 2
.byte	 1, 1, 1, 1, 1, 1, 1, 1
.byte	 1, 1, 1, 1, 1, 1, 1, 1
.byte	 1, 1, 1, 1, 1, 1, 1, 1
.byte	 1, 1, 1, 1, 1, 1, 1, 1
.byte	 1, 1, 1, 1, 1, 1, 1, 1
.byte	 1, 1, 1, 1, 1, 1, 1, 1
.byte	 1, 1, 1, 1, 1, 1, 1, 1
.byte	 1, 1, 1, 1, 1, 1, 1, 1
.byte	 1, 1, 1, 1, 1, 1, 1, 1
.byte	 0, 0, 0, 0, 0, 0, 0, 0

playfield1_left:
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$01,$03,$07,$07,$07,$07,$06

playfield2_left:
	.byte $00,$A0,$B0,$B8,$98,$9C,$9E,$8E
	.byte $8F,$8F,$87,$87,$83,$81,$80,$80

;playfield0_right:
;	.byte $00,$50,$D0,$D0,$90,$90,$90,$10
;	.byte $10,$10,$10,$10,$10,$10,$10,$10

;playfield1_right:
;	.byte $00,$00,$00,$80,$80,$C0,$E0,$E0
;	.byte $F0,$F8,$7C,$7E,$3E,$1E,$0E,$06


.segment "IRQ_VECTORS"
	.word atari_tiny_start	; NMI
	.word atari_tiny_start	; RESET
	.word atari_tiny_start	; IRQ
