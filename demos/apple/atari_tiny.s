; Atari Logo

; by Vince `deater` Weaver <vince@deater.net>


; $239 -- first attempt
; $200 -- auto-gen colors
; $1E0 -- mirror playfield
; $149 -- re-write kernel a bit
; $121 -- more re-write
; $D7  (215) -- only draw every-other line
; $D6  (214) -- animate colors, but also optimize more
; $B8  (184) -- skip some long strings of 1s in shape lookup

.include "../../vcs.inc"

; zero page addresses

MAIN_COLOR		=	$80
LINE_COLOR		=	$81
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

	dec	MAIN_COLOR		; rotate colors
	lda	MAIN_COLOR		; copy over main color
	sta	LINE_COLOR

	sta	WSYNC

	lda	#0			; done beam reset
	sta	VSYNC

	; 37 lines of vertical blank

	ldx	#36
	jsr	scanline_wait		; Leaves X zero

; 10
	sta	WSYNC

	stx	VBLANK			; turn on beam (X=0)

	;===========================
	;===========================
	; playfield
	;===========================
	;===========================
	; draw 192 lines


	;===========================
	; first 20 lines black
	;===========================

;	stx	COLUPF			; set playfield color black (needed?)
	ldx	#19
	jsr	scanline_wait		; leaves X 0


; 10

	;=====================
	; final init

	; X is 0 here
	stx	PF0		; clear leftmost playfield

	ldx	#74		; we count down 148

	lda	#CTRLPF_REF	; mirror playfield
	sta	CTRLPF

	sta	WSYNC



colorful_loop:
; 3
	lda	LINE_COLOR		; get color			; 3
	sta	COLUPF			; set playfield color		; 3
; 9
	ldy	#1
	cpx	#36
	bcs	its1
	ldy	row_lookup,X		; get which playfield lookup	; 4+
its1:

; 13
	lda	playfield1_left,Y	;				; 4+
	sta	PF1			;				; 3
	; has to happen by 28
; 20
	lda	playfield2_left,Y	;				; 4+
	sta	PF2			;				; 3
	; has to happen by 38
; 27

	inc	LINE_COLOR						; 5
	inc	LINE_COLOR						; 5
; 37

	dex				; dec X				; 2

; 39

	sta	WSYNC			;				; 3
	sta	WSYNC			;				; 3
; 75/76
	bne	colorful_loop		;				; 2/3

	;=================
	; done!

	;================
	; scanline 168
	;	do nothing until end

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

	beq	start_frame	; bra
;	jmp	start_frame


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
.if 0
.byte	 1, 1, 1, 1
.byte	 1, 1, 1, 1
.byte	 1, 1, 1, 1
.byte	 1, 1, 1, 1
.byte	 1, 1, 1, 1
.byte	 1, 1, 1, 1
.byte	 1, 1, 1, 1
.byte	 1, 1, 1, 1
.byte	 1, 1, 1, 1
.endif


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
