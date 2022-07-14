; Test the Title Screen

; by Vince `deater` Weaver <vince@deater.net>

; Draws an asymmetric playfield

.include "../../vcs.inc"

; zero page addresses

TITLE_COLOR	=	$80

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

	ldy	#0
	ldx	#0
	stx	GRP0
	stx	GRP1

	lda	#$28
	sta	TITLE_COLOR

	sta	WSYNC


	;=============================================
	;=============================================
	; draw title
	;=============================================
	;=============================================
	; draw 192 lines
	; need to race beam to draw other half of playfield

title_loop:
	lda	TITLE_COLOR	; green	;				; 3
	sta	COLUPF			; set playfield color		; 3
	inc	TITLE_COLOR						; 5
	lda	#$80							; 3
; 14
	nop								; 2
	lda	#0	; always black					; 2
	sta	PF0			;				; 3
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

	nop				;				2
	lda	playfield0_right,X	;				4+
	sta	PF0			;				3
	; must write by CPU 49 [GPU 148]
; 44
;	nop				;				2
	lda	playfield1_right,X	;				4+
	sta	PF1			;				3
	; must write by CPU 54 [GPU 164]
; 53

	lda	$80			; nop3				3
	lda	playfield2_right,X	;				4+
	sta	PF2			;				3
	; must write by CPU 65 [GPU 196]

; 63

        iny                                                             ; 2
        tya                                                             ; 2
        and     #$3                                                     ; 2
        beq     yes_inx                                                 ; 2/3
        .byte   $A5     ; begin of LDA ZP                               ; 3
yes_inx:
        inx             ; $E8 should be harmless to load                ; 2
done_inx:
                                                                ;===========
                                                                ; 11/11

; 74
	cpy	#(120)							; 2
	bne	title_loop						; 2/3

; 76

done_loop:

	; in scanline 120?


	.repeat 72
	sta	WSYNC
	.endrepeat


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

.include "title_graphic.inc"

.segment "IRQ_VECTORS"
	.word start	; NMI
	.word start	; RESET
	.word start	; IRQ
