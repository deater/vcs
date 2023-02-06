; Atari Logo

; by Vince `deater` Weaver <vince@deater.net>


; $239 -- first attempt
; $200 -- auto-gen colors
; $1E0 -- mirror playfield
; $149 -- re-write kernel a bit
; $121 -- more re-write
; $D7  -- only draw every-other line

.include "../../vcs.inc"

; zero page addresses

TEXT_COLOR		=	$80
TEMP1			=	$90
TEMP2			=	$91

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
	; first 20 lines black
	;===========================

	lda	#0
	sta	COLUPF
	ldx	#19
	jsr	scanline_wait

	; FIXME: X already 0 here?
; 10

	ldy	#0		; clear div3 count
	sty	PF0		; also clear leftmost playfield

	ldx	#74		; we count down 148

	lda	#CTRLPF_REF
	sta	CTRLPF

	sta	WSYNC



colorful_loop:
; 3
	lda	TEXT_COLOR		; get color			; 3
	sta	COLUPF			; set playfield color		; 3
	ldy	row_lookup,X		; get which playfield lookup	; 4+
;	tay				; put in Y			; 2
; 10
	lda	playfield1_left,Y	;				; 4+
	sta	PF1			;				; 3
	; has to happen by 28
; 17
	lda	playfield2_left,Y	;				; 4+
	sta	PF2			;				; 3
	; has to happen by 38
; 24
	dex				; dec X				; 2

; 26

	sta	WSYNC			;				; 3
	sta	WSYNC			;				; 3
; 75/76
	bne	colorful_loop		;				; 2/3

	;=================
	; done!

	;================
	; scanline 168
	;	set things up

	ldx	#24
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


;.align $100

row_lookup:
.byte	 0, 0,15,15
.byte	14,13,12,12
.byte	12,12,12,11
.byte	11,10, 9, 9
.byte	 8, 7, 7, 7
.byte	 6, 5, 5, 5
.byte	 4, 4, 4, 4
.byte	 4, 3, 2, 2
.byte	 2, 2, 2, 2
.byte	 2, 2, 2, 2
.byte	 1, 1, 1, 1
.byte	 1, 1, 1, 1
.byte	 1, 1, 1, 1
.byte	 1, 1, 1, 1
.byte	 1, 1, 1, 1
.byte	 1, 1, 1, 1
.byte	 1, 1, 1, 1
.byte	 1, 1, 1, 1
.byte	 1, 1, 1, 1



playfield1_left:
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$01,$03,$07,$07,$07,$07,$06

playfield2_left:
	.byte $00,$A0,$B0,$B8,$98,$9C,$9E,$8E
	.byte $8F,$8F,$87,$87,$83,$81,$80,$80

.segment "IRQ_VECTORS"
	.word atari_tiny_start	; NMI
	.word atari_tiny_start	; RESET
	.word atari_tiny_start	; IRQ
