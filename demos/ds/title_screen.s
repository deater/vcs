; Draw a title screen

; playfield only, skip every 4 lines

title_screen:

start_frame:

	;=============================
	; Start Vertical Blank

	lda	#2
	sta	VBLANK

	jsr	common_vblank

	; now 9 cycles in

	;=============================
	; 37 lines of vertical blank
	;=============================


.repeat 34
	sta	WSYNC
.endrepeat

	;=======================
	; scanline 36 -- ???

	sta	WSYNC

	;=======================
	; scanline 37 -- config

	lda	#178	; playfield color (dark green)
	sta	COLUPF



	ldy	#0
	sty	VBLANK

	ldx	#192		; lines
	sta	WSYNC


	;=============================================
	;=============================================
	;=============================================
	;=============================================

	; draw 192 lines
	; need to race beam to draw other half of playfield

checker_loop:

;  PF0   PF1       PF2
; |4567|76543210|01234567
;  1010 10101010 10101010


	txa
	and	#$4
	bne	checker_odd
checker_even:
	lda	#$55
	ldy	#$aa
	bne	checker_common		; bra
checker_odd:
	lda	#$aa
	ldy	#$55
checker_common:

	sta	PF0
	sta	PF2

	sty	PF1

;	lda	#NUSIZ_QUAD_SIZE
;	sta	NUSIZ0


;	lda	#14
;	sta	COLUP0

;	lda	#$AA
;	sta	GRP0


	dex
	beq	done_checker

	sta	WSYNC
	jmp	checker_loop

done_checker:
	sta	WSYNC

.if 0
	lda	$80		; nop3

	; enter here 3 cycles in?

colorful_loop:
; 3
	lda	colors,X		;				4+
	sta	COLUPF			; set playfield color		3
; 10
	lda	playfield0_left,X	;				4+
	sta	PF0			;				3
	; must write by CPU 22 [GPU 68]
; 17
	lda	playfield1_left,X	;				4+
	sta	PF1			;				3
	; must write by CPU 28 [GPU 84]
; 24
	lda	playfield2_left,X	;				4+
	sta	PF2			;				3
	; must write by CPU 38 [GPU 116]
; 31

	; at this point we're at 31 cycles
	; need to wait until ?? before we can over-write PF0

	nop				;				2
	lda	playfield0_right,X	;				4+
	sta	PF0			;				3
	; must write by CPU 49 [GPU 148]
; 40
	nop				;				2
	lda	playfield1_right,X	;				4+
	sta	PF1			;				3
	; must write by CPU 54 [GPU 164]
; 49

	lda	$80			; nop3				3
	lda	playfield2_right,X	;				4+
	sta	PF2			;				3
	; must write by CPU 65 [GPU 196]

; 59
	dey				;				2
; 61
	bne	next_row		;				2/3
; 63
	ldy	#4							; 2
	inx								; 2
; 67
	cpx	#(192/4)						; 2
; 69
	beq	done_loop						; 2/3

; 64 / 71
next_row:
	sta	WSYNC		; end row 2
; 74/0
	jmp	colorful_loop						; 3

; 72

done_loop:

	sta	WSYNC		; last row
.endif

	;==========================
	;==========================
	; overscan
	;==========================
	;==========================

	ldx	#29
	jsr	common_overscan


	;==========================
	; overscan 29
	;==========================
	sta	WSYNC

	;================================
	; once again

	jmp	start_frame

done_title_screen:


;	sta	WSYNC
