; Make the Apple II logo on an Atari 2600

; by Vince `deater` Weaver <vince@deater.net>

; Draws an asymmetric playfield

;=============================================
;                         00000111111111112222222220000001111111111112222222222
;           1         2  |      3         4        |5         6         7
; 01234567890123456789012345678901234567890123456789012345678901234567890123456
; CCCCccc000000011111112222222NN0000000NNNN1111111NN2222222LLLLLLLLL
;

; PF0,PF1,PF2 \_ 192*6=1152
; PF0,PF1,PF2 /

.include "../vcs.inc"

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

	;============================
	; Start Vertical Blank
	;============================

	lda	#0			; turn on beam
	sta	VBLANK

	lda	#2			; reset beam to top of screen
	sta	VSYNC

	;==================================
	; wait for 3 scanlines of VSYNC
	;==================================

	sta	WSYNC			; wait until end of scanline
	sta	WSYNC
	sta	WSYNC

	lda	#0			; done beam reset
	sta	VSYNC

	;==================================
	; 37 lines of vertical blank
	;==================================

	ldx	#0
vblank_loop:
	sta	WSYNC
	inx
	cpx	#37
	bne	vblank_loop

;	lda	#0			; turn on beam
;	sta	VBLANK

	; draw 192 lines
	; need to race beam to draw other playfield

	ldx	#0
colorful_loop:
	lda	colors,X		;				4+
	sta	COLUPF			; set playfield color		3

	lda	playfield0_left,X	;				4+
	sta	PF0			;				3
	lda	playfield1_left,X	;				4+
	sta	PF1			;				3
	lda	playfield2_left,X	;				4+
	sta	PF2			;				3

	; at this point we're at 28 cycles

	nop				;				2
	lda	playfield0_right,X	;				4+
	sta	PF0			;				3

	; now at 37
	nop				;				2
	nop				;				2
	lda	playfield1_right,X	;				4+
	sta	PF1			;				3

	; now at 48

	nop				;				2
	lda	playfield2_right,X	;				4+
	sta	PF2			;				3

	; now at 57

	inx				;				2
	cpx	#192			;				2

	sta	WSYNC			;				3
	bne	colorful_loop		;				2/3

	;===========================
	; overscan
	;===========================

	lda	#$2		; turn off beam
	sta	VBLANK

	ldx	#0
overscan_loop:
	sta	WSYNC
	inx
	cpx	#30
	bne	overscan_loop

	jmp	start_frame

.include "playfield.inc"

.segment "IRQ_VECTORS"
	.word start	; NMI
	.word start	; RESET
	.word start	; IRQ


