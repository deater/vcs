; Test game_over screen

; by Vince `deater` Weaver <vince@deater.net>

; Draws an asymmetric playfield

.include "../../vcs.inc"

; zero page addresses

TEMP1	=	$90
TEMP2	=	$91

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

	lda	#$B0		; fine adjust				; 2
	sta	HMP0

	sta	WSYNC
	sta	HMOVE

	;=======================
	; scanline 37 -- config

	lda	#NUSIZ_QUAD_SIZE
	sta	NUSIZ0

	lda	#$1C		; yellow		; set color
	sta	COLUP0

	ldy	#0
	ldx	#0
	stx	GRP0

	sta	WSYNC


	;=============================================
	;=============================================
	;=============================================
	;=============================================

	; draw 192 lines
	; need to race beam to draw other half of playfield

game_over_loop:
	lda	colors,X		;				; 4+
	sta	COLUPF			; set playfield color		; 3
; 7
	lda	playfield0_left,X	;				; 4+
	sta	PF0			;				; 3
	; must write by CPU 22 [GPU 68]
; 14
	lda	playfield1_left,X	;				; 4+
	sta	PF1			;				; 3
	; must write by CPU 28 [GPU 84]

; 21

	lda	playfield2_left,X	;				; 4+
	sta	PF2			;				; 3
	; must write by CPU 38 [GPU 116]

; 28
	lda	game_overlay,X						; 4
	sta	GRP0							; 3
; 35

	; at this point we're at 28 cycles
	lda	playfield0_right,X	;				; 4+
	sta	PF0			;				; 3
	; must write by CPU 49 [GPU 148]
; 42
	nop								; 2
	lda	playfield1_right,X	;				; 4+
	sta	PF1			;				; 3
	; must write by CPU 54 [GPU 164]
; 51
	nop								; 2
	lda	playfield2_right,X	;				; 4+
	sta	PF2			;				; 3
	; must write by CPU 65 [GPU 196]

; 60
	iny                                                             ; 2
	tya                                                             ; 2
	and	#$3                                                     ; 2
	beq	yes_inx                                                 ; 2/3
	.byte	$A5     ; begin of LDA ZP                               ; 3
yes_inx:
	inx		; $E8 should be harmless to load                ; 2
done_inx:
                                                                ;===========
                                                                ; 11/11

; 71
	cpy	#192							; 2
	bne	game_over_loop						; 2/3


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

.include "game_over.inc"
.include "game_overlay.inc"

.segment "IRQ_VECTORS"
	.word start	; NMI
	.word start	; RESET
	.word start	; IRQ
