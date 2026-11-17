	;================================================
	; draws parallax effect
	;================================================

parallax_effect:

	;================================================
	; scanline 0 -- init
	;================================================

; 26

	lda	#47							; 2
	sta	SPRITE0_X						; 3
	lda	#79							; 2
	sta	SPRITE1_X						; 3
; 36
	sta	WSYNC

	;=====================================
	; scanline 1/2/3 4/5/6: setup X for sprites
	;====================================
; 0
	lda	SPRITE0_X						; 3
	ldx	#0
	jsr	set_pos_x

	lda	SPRITE1_X						; 3
	ldx	#1
	jsr	set_pos_x

	;=========================================
	; scanline 7/8 : setup zigzag
	;=========================================
; 0

	lda	#8
;	ldx	FRAMEH
;	cpx	#$4		; not start music response until partway in
;	bcc	zigzag_start


	ldx	IS_DRUM
	beq	zigzag_start
	dec	IS_DRUM
	clc
	adc	#$8
zigzag_start:
	ldx	#8
	tay
zigzag_loop:
	lda	zigzag,Y						; 4
	sta	ZIGZAG0,X						; 4
	dey
	dex								; 2
	bne	zigzag_loop						; 2/3

	; 2+ 13*8 -1 = 105

	sta	WSYNC
	sta	HMOVE

	;================================================
	; VBLANK scanline 9 -- init
	;================================================
; 3
	; other init

	lda	#$86							; 2
	sta	COLUP0							; 3
	sta	COLUP1		; color of sprite grid			; 3
; 8
	lda	#$00							; 2
        sta	COLUBK							; 3
	sta	VDELP0							; 3
	sta	VDELP1		; turn off delay			; 3
; 19
	lda	#NUSIZ_QUAD_SIZE					; 2
	sta	NUSIZ0		; make sprite grid large		; 3
	sta	NUSIZ1							; 3

	sta	WSYNC

	;=================================
	; scanline 10
	;=================================

	lda	#0							; 2
	sta	COLUPF			; fg, black			; 3
	sta	GRP0			; sprite 1			; 3
	sta	GRP1			; sprite 2			; 3
; 16

	lda	#$0			; clear playfields		; 2
	sta	PF0			;				; 3
	sta	PF1			;				; 3
	sta	PF2							; 3
; 27
	lda	#CTRLPF_REF|CTRLPF_PFP	; reflect			; 2
	sta	CTRLPF			; also playfield priority	; 3
; 32


	lda	FRAMEL
	rol
	lda	FRAMEH
	rol
;	lsr
;	lsr
;	lsr
;	lsr
;	lsr
;	lsr
	and	#$7
	tay
	lda	fg_colors,Y
;	lda	#$4e							; 2
	sta	COLUPF							; 3
; 37
	ldy	#0							; 2
	ldx	#0			; scanline			; 2
; 41
	sta	WSYNC							; 3



	;=========================
	;=========================
	; kernel
	;=========================
	;=========================

parallax_playfield:
	; comes in at 3 cycles

; 3

	;============================
	; set sprite pattern
	;============================
	lda	FRAMEL							; 3
	lsr								; 2
	lsr								; 2
	sta	TEMP2							; 3
; 13
	ldy	#$AA							; 2
	txa								; 2
	sec								; 2
	sbc	TEMP2							; 2
	and	#$8							; 2
; 23
	beq	alternate_sprite0					; 2/3
	ldy	#$55							; 2
alternate_sprite0:
; 27
	sty	GRP0							; 3
	sty	GRP1							; 3
; 33

	;============================
	; set playfield pattern
	;============================
	ldy	#$3C							; 2
	txa								; 2
	sec								; 2
	sbc	FRAMEL							; 2
	and	#$20							; 2
; 43
	beq	alternate_pf0						; 2/3
	ldy	#$C3							; 2
alternate_pf0:
; 47
	sty	PF2							; 3
; 50

	txa								; 2
	adc	FRAMEL							; 3
	and	#$7							; 2
	tay								; 2
	lda	ZIGZAG0,Y						; 4+
	sta	PF0							; 3

; 63 worst case

	inx								; 2


	cpx	#80-13							; 1

; 67
	sta	WSYNC							; 3
; 70/0
;
	bne	parallax_playfield					; 2/3


done_parallax:
	sta	WSYNC

	jmp	effect_done

zigzag:
	.byte $80,$40,$20,$10, $10,$20,$40,$80
zigzag2:
	.byte $40,$40,$20,$20, $40,$40,$20,$20

fg_colors:
	.byte $4E,$9E,$AE,$12, $4E,$9E,$AE,$7E

effect_done:

	;===============================
	; turn things off

	ldx	#0
	stx	GRP0
	stx	GRP1
	stx	PF0
	stx	PF1
	stx	PF2


	sta	WSYNC
