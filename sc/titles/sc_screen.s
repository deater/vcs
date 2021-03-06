; Test the secret collect

; by Vince `deater` Weaver <vince@deater.net>

; Draws an asymmetric playfield

.include "../../vcs.inc"

; zero page addresses

FRAME	=	$80
TEMP1	=	$90

start:
	sei		; disable interrupts
	cld		; clear decimal bit
	ldx	#$ff
	txs		; point stack to top of zero page

	; clear out the Zero Page (RAM and TIA registers)

	ldx	#0
	stx	FRAME
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


;.repeat 34
;	sta	WSYNC
;.endrepeat

	ldx	#35
vbsc_loop:
	sta	WSYNC
	dex
	bne	vbsc_loop

; in scanline 35?

	sta	WSYNC

; in scanline 36

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

	ldy	#0
	ldx	#0
	stx	GRP0

	sta	WSYNC


	;=============================================
	;=============================================
	;=============================================
	;=============================================

	; draw 152 lines
	; need to race beam to draw other half of playfield

colorful_loop:
	lda	colors,X		;				; 4+
	sta	COLUPF			; set playfield color		; 3
; 7
	lda	sc_overlay_colors,X					; 4+
	sta	COLUP0							; 3

; 14
	lda	#0			; always zero			; 2
	sta	PF0			;				; 3
	; must write by CPU 22 [GPU 68]
; 19
	sta	PF1			;				; 3
	; must write by CPU 28 [GPU 84]
; 22
	lda	playfield2_left,X	;				; 4+
	sta	PF2			;				; 3
	; must write by CPU 38 [GPU 116]
; 29
	; at this point we're at 29 cycles

	lda	sc_overlay,X						; 4
	sta	GRP0							; 3
; 36
;	lda	$80	; nop3						; 3
; 39

	lda	playfield0_right,X	;				; 4+
	sta	PF0			;				; 3
	; must write by CPU 49 [GPU 148]
; 46
	lda	playfield1_right,X	;				; 4+
	sta	PF1			;				; 3
	; must write by CPU 54 [GPU 164]

; 53
	lda	#$0							; 2
	sta	PF2			;				; 3
	; must write by CPU 65 [GPU 196]

; 58
	; make secret yellow
	lda	#$1C							; 2
	sta	COLUPF							; 3
; 63

	iny								; 2
	tya								; 2
	and	#$3							; 2
	beq	yes_inx							; 2/3
	.byte	$A5	; begin of LDA ZP				; 3
yes_inx:
	inx		; $E8 should be harmless to load		; 2
done_inx:
								;===========
								; 11/11

; 71
	cpy	#(152)							; 2
	bne	colorful_loop						; 2/3
; 76




done_loop:

	;===================
	; prep for text

	inc	FRAME
	lda	FRAME
	and	#$40
	bne	collect
	ldx	#0
	beq	done_which
collect:
	ldx	#10
done_which:
	ldy	#0

	lda	#$80	; always blue
	sta	COLUPF

	sta	WSYNC


	;==========================================
	;==========================================
	; Bottom text
	;==========================================
	;==========================================


	; draw 40 lines
	; need to race beam to draw other half of playfield

sctext_loop:
	lda	$80	; nop 3 					; 3
	inc	TEMP1	; nop 5						; 5
	nop								; 2
	nop								; 2
	nop								; 2
; 14
	lda	#0							; 2
	sta	PF0			;				; 3
	; must write by CPU 22 [GPU 68]
; 19
	lda	secret_playfield1_left,X	;			; 4+
	sta	PF1			;				; 3
	; must write by CPU 28 [GPU 84]
; 26
	lda	secret_playfield2_left,X	;			; 4+
	sta	PF2			;				; 3
	; must write by CPU 38 [GPU 116]
; 33

	nop				;				; 2
	lda	secret_playfield0_right,X				; 4+
	sta	PF0			;				; 3
	; must write by CPU 49 [GPU 148]
; 42
	nop				;				; 2
	lda	secret_playfield1_right,X				; 4+
	sta	PF1			;				; 3
	; must write by CPU 54 [GPU 164]
; 51
	nop								; 2
	lda	#0			;				; 2
	sta	PF2			;				; 3
	; must write by CPU 65 [GPU 196]
	nop								; 2

; 60

	iny								; 2
	tya								; 2
	and	#$3							; 2
	beq	yes_inx2						; 2/3
	.byte	$A5	; begin of LDA ZP				; 3
yes_inx2:
	inx		; $E8 should be harmless to load		; 2
done_inx2:
								;===========
								; 11/11

; 71
	cpy	#36							; 2
	bne	sctext_loop						; 2/3
; 76


done_sctext_loop:
	sta	WSYNC
	sta	WSYNC


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
