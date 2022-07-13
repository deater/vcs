; Test the images for sc

; by Vince `deater` Weaver <vince@deater.net>

; Draws an asymmetric playfield

.include "../../vcs.inc"

; zero page addresses


start:
	sei		; disable interrupts
	cld		; clear decimal bit
	ldx	#$ff
	txs		; point stack to top of zero page

	; clear out the Zero Page (RAM and TIA registers)

	ldx	#0
	txa
clear_loop:
	sta	$0,X
	inx
	bne	clear_loop


start_frame:

	; Start Vertical Blank

	lda	#0			; turn on beam
	sta	VBLANK

	lda	#2			; reset beam to top of screen
	sta	VSYNC

	; wait for 3 scanlines of VSYNC

	sta	WSYNC			; wait until end of scanline
	sta	WSYNC
	sta	WSYNC

	lda	#0			; done beam reset
	sta	VSYNC

	;=============================
	; 37 lines of vertical blank
	;=============================


.repeat 35
	sta	WSYNC
.endrepeat

	;=======================
	; scanline 36 -- align sprite

	ldx	#7		;					; 2
scad_x:
	dex			;					; 2
	bne	scad_x		;					; 2/3

	; 2+1 + 5*X each time through
	;       so 18+7+9=38

	nop
	nop

	; beam is at proper place
	sta	RESP0

	lda	#$F0		; fine adjust				; 2
	sta	HMP0

	sta	WSYNC
	sta	HMOVE

	;=======================
	; scanline 37 -- config

	lda	#NUSIZ_QUAD_SIZE
	sta	NUSIZ0

	lda	#$80		; set color
	sta	COLUP0

	ldx	#0
	stx	GRP0

	sta	WSYNC


	;=============================================
	;=============================================
	;=============================================
	;=============================================

	; draw 192 lines
	; need to race beam to draw other half of playfield

colorful_loop:
	lda	colors,X		;				4+
	sta	COLUPF			; set playfield color		3
; 7
	lda	sc_overlay_colors,X					; 4+
	sta	COLUP0							; 3

; 14
	lda	playfield0_left,X	;				4+
	sta	PF0			;				3
	; must write by CPU 22 [GPU 68]
; 21
	lda	playfield1_left,X	;				4+
	sta	PF1			;				3
	; must write by CPU 28 [GPU 84]
; 28
	lda	playfield2_left,X	;				4+
	sta	PF2			;				3
	; must write by CPU 38 [GPU 116]
; 35

	; at this point we're at 28 cycles

	nop				;				2
	lda	playfield0_right,X	;				4+
	sta	PF0			;				3
	; must write by CPU 49 [GPU 148]
; 44
	nop				;				2
	lda	playfield1_right,X	;				4+
	sta	PF1			;				3
	; must write by CPU 54 [GPU 164]
; 53

	lda	$80			; nop3				3
	lda	playfield2_right,X	;				4+
	sta	PF2			;				3
	; must write by CPU 65 [GPU 196]

; 63
	; now at 58

	sta	WSYNC
; 76

	;=========
	; step 2

	lda	colors,X		;				4+
	sta	COLUPF			; set playfield color		3
;	lda	sc_overlay_colors,X
;	sta	COLUP0

; 7
	lda	playfield0_left,X	;				4+
	sta	PF0			;				3
	; must write by CPU 22 [GPU 68]
; 14
	lda	playfield1_left,X	;				4+
	sta	PF1			;				3
	; must write by CPU 28 [GPU 84]
; 21
	lda	playfield2_left,X	;				4+
	sta	PF2			;				3
	; must write by CPU 38 [GPU 116]
; 28

	; at this point we're at 28 cycles

	nop				;				2
	lda	playfield0_right,X	;				4+
	sta	PF0			;				3
	; must write by CPU 49 [GPU 148]
; 37
	nop				;				2
	nop				;				2
	lda	playfield1_right,X	;				4+
	sta	PF1			;				3
	; must write by CPU 54 [GPU 164]
; 48

	lda	$80			; nop3				3
	lda	playfield2_right,X	;				4+
	sta	PF2			;				3
	; must write by CPU 65 [GPU 196]

; 58
	sta	WSYNC

; 76

	lda	colors,X		;				4+
	sta	COLUPF			; set playfield color		3
;	lda	sc_overlay_colors,X
;	sta	COLUP0

; 7
	lda	playfield0_left,X	;				4+
	sta	PF0			;				3
	; must write by CPU 22 [GPU 68]
; 14
	lda	playfield1_left,X	;				4+
	sta	PF1			;				3
	; must write by CPU 28 [GPU 84]
; 21
	lda	playfield2_left,X	;				4+
	sta	PF2			;				3
	; must write by CPU 38 [GPU 116]
; 28

	; at this point we're at 28 cycles

	nop				;				2
	lda	playfield0_right,X	;				4+
	sta	PF0			;				3
	; must write by CPU 49 [GPU 148]
; 37
	nop				;				2
	nop				;				2
	lda	playfield1_right,X	;				4+
	sta	PF1			;				3
	; must write by CPU 54 [GPU 164]
; 48

	lda	$80			; nop3				3
	lda	playfield2_right,X	;				4+
	sta	PF2			;				3
	; must write by CPU 65 [GPU 196]

; 58
	sta	WSYNC

; 76

	lda	colors,X		;				4+
	sta	COLUPF			; set playfield color		3
;	lda	sc_overlay_colors,X
;	sta	COLUP0

; 7
	lda	playfield0_left,X	;				4+
	sta	PF0			;				3
	; must write by CPU 22 [GPU 68]
; 14
	lda	playfield1_left,X	;				4+
	sta	PF1			;				3
	; must write by CPU 28 [GPU 84]
; 21
	lda	playfield2_left,X	;				4+
	sta	PF2			;				3
	; must write by CPU 38 [GPU 116]
; 28

	; at this point we're at 28 cycles

	nop				;				2
	lda	playfield0_right,X	;				4+
	sta	PF0			;				3
	; must write by CPU 49 [GPU 148]
; 37
	nop				;				2
	nop				;				2
	lda	playfield1_right,X	;				4+
	sta	PF1			;				3
	; must write by CPU 54 [GPU 164]
; 48

	nop								; 2
	nop								; 2
	lda	playfield2_right,X	;				; 4+
	sta	PF2			;				; 3
	; must write by CPU 65 [GPU 196]

; 59
	inx								; 2
	lda	sc_overlay,X						; 4
	sta	GRP0							; 3

; 68



	cpx	#(192/4)						; 2
	beq	done_loop						; 2/3
	jmp	colorful_loop						; 3

; 76

done_loop:



	;==========================
	; overscan
	;==========================

	lda	#$2		; turn off beam
	sta	VBLANK

	ldx	#0
overscan_loop:
	sta	WSYNC
	inx
	cpx	#30
	bne	overscan_loop

	jmp	start_frame

.align $100

.include "sc_graphic.inc"
.include "sc_overlay.inc"

.segment "IRQ_VECTORS"
	.word start	; NMI
	.word start	; RESET
	.word start	; IRQ
