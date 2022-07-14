; Test the Title Screen

; by Vince `deater` Weaver <vince@deater.net>

; Draws an asymmetric playfield

.include "../../vcs.inc"

; zero page addresses

TITLE_COLOR	=	$80
TEMP1		=	$90
TEMP2		=	$91

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


	; scanline 120

	sta	WSYNC		; padding
	sta	WSYNC


	; in scanline 122?

	nop

	;=========================================
	;=========================================
	; draw Videlectrix Logo sprite (11 lines)
	;=========================================
	;=========================================

	; assume coming in 2 cycles after WSYNC

	;====================
	; Now scanline 122
	;====================
	; configure 48-pixel sprite code

	; make playfield black
	lda	#$00			; black
	sta	COLUPF			; playfield color
	sta	PF0			; turn off playfield so don't collide
	sta	PF1
	sta	PF2

	sta	GRP0			; turn off sprites
	sta	GRP1

	; set color

	lda	#$0E	; bright white					; 2
	sta	COLUP0	; set sprite color				; 3
	sta	COLUP1	; set sprite color				; 3

	; set to be 48 adjacent pixels

	lda	#NUSIZ_THREE_COPIES_CLOSE				; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1							; 3

	; turn on delay

	lda	#1							; 2
	sta	VDELP0							; 3
	sta	VDELP1							; 3

	; number of lines to draw
	ldx	#48							; 2
	stx	TEMP2							; 3

	sta	WSYNC							; 3
								;===========


	;===================
	; now scanline 183
	;===================
	; center the sprite position
	; needs to be right after a WSYNC

	; to center exactly would want sprite0 at
	;	CPU cycle 41.3
	; and sprite1 at
	;	GPU cycle 44


	ldx	#0		; sprite 0 display nothing		; 2
	stx	GRP0		;					; 3

	ldx	#6		;					; 2
vpad_x:
	dex			;					; 2
	bne	vpad_x		;					; 2/3
	; 3 + 5*X each time through

	; beam is at proper place
	sta	RESP0							; 3
	; 41 (GPU=123, want 124) +1
	sta	RESP1							; 3
	; 44 (GPU=132, want 132) 0

	lda	#$F0		; opposite what you'd think		; 2
	sta	HMP0							; 3
	lda	#$00							; 2
	sta	HMP1							; 3

	sta	WSYNC
	sta	HMOVE		; adjust fine tune, must be after WSYNC


	;===================
	; now scanline 184
	;===================

	ldx	TEMP2		; restore length of sprite

	sta	WSYNC

	;===================
	; now scanline 185
	;===================

spriteloop:
	; 0
	lda	title_bitmap0,X	; load sprite data		; 4+
	sta	GRP0			; 0->[GRP0] [GRP1 (?)]->GRP1	; 3
	; 7
	lda	title_bitmap1,X	; load sprite data		; 4+
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3
	; 14
	lda	title_bitmap2,X	; load sprite data		; 4+
	sta	GRP0			; 2->[GRP0], [GRP1 (1)]-->GRP1	; 3
	; 21

	lda	title_bitmap5,X					; 4+
	sta	TEMP1							; 3
	; 28
	lda	title_bitmap4,X					; 4+
	tay								; 2
	; 34
	lda	title_bitmap3,X	;				; 4+
	ldx	TEMP1							; 3
	; 41

	sta	GRP1			; 3->[GRP1], [GRP0 (2)]-->GRP0	; 3
	; 44 (need this to be 44 .. 46)

	sty	GRP0			; 4->[GRP0], [GRP1 (3)]-->GRP1	; 3
	; 47 (need this to be 47 .. 49)

	stx	GRP1			; 5->[GRP1], [GRP0 (4)]-->GRP0	; 3
	; 50 (need this to be 50 .. 51)

	sty	GRP0			; ?->[GRP0], [GRP1 (5)]-->GRP1 	; 3
	; 53 (need this to be 52 .. 54)

	nop								; 2
	nop								; 2
	nop								; 2
	nop								; 2
	nop								; 2
	nop								; 2

	; 65

	dec	TEMP2							; 5
	ldx	TEMP2							; 3
	bpl	spriteloop						; 2/3
	; 76  (goal is 76)


	;
	; done drawing line
	;

	ldy	#0
	sty	GRP1
	sty	GRP0
	sty	GRP1




	.repeat 18
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
.include "title_data.inc"

.segment "IRQ_VECTORS"
	.word start	; NMI
	.word start	; RESET
	.word start	; IRQ
