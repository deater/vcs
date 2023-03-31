	;================================================
	; draws fireworks effect
	;================================================


firework7:
;	.byte $10,$44,$00,$82,$00,$44,$10,$00
firework6:
;	.byte $10,$44,$00,$82,$00,$44,$10,$00
firework5:
;	.byte $10,$44,$00,$82,$00,$44,$10,$00
firework4:
;	.byte $10,$44,$00,$82,$00,$44,$10,$00



firework3:
	.byte $10,$44,$00,$82,$00,$44,$10,$00
firework2:
	.byte $00,$10,$28,$44,$28,$10,$00,$00
firework1:
	.byte $00,$00,$10,$28,$10,$00,$00,$00
firework0:
	.byte $00,$00,$00,$10,$00,$00,$00,$00

firework_effect:
; 26
	sta	WSYNC

	;=========================================
	; scanline 39: update firework0
	;=========================================
; 0
	lda	SPRITE0_COLOR						; 3
	and	#$f							; 2
	bne	not_new_firework					; 2/3
new_firework:
; 7
	; new firework color
	ldx	FRAMEL							; 3
	lda	$F000,X							; 4
	ora	#$0F							; 2
	and	#$FE							; 2
	sta	SPRITE0_COLOR						; 3
; 21
	; new X
	lda	$F100,X			; sorta random			; 4
	and	#$7F			; 0..127			; 2
	sta	SPRITE0_X						; 3
; 30
	; new Y
	lda	$F200,X			; sorta random			; 4
	and	#$3F			; 0..127			; 2
	sta	SPRITE0_Y						; 3
; 39

not_new_firework:
	lda	FRAMEL							; 3
	and	#$7							; 2
	bne	skip_progress						; 2/3
; 46
	dec	SPRITE0_COLOR						; 5
	dec	SPRITE0_COLOR						; 5
; 56
skip_progress:
	lda	SPRITE0_COLOR						; 3
	sta	COLUP0							; 3

; 62
	sta	WSYNC
.if 0
	;=========================================
	; scanline 40: update firework1
	;=========================================
; 0
	lda	SPRITE1_COLOR						; 3
	and	#$f							; 2
	bne	not_new_firework1					; 2/3
new_firework1:
; 7
	; new firework color
	ldx	FRAMEL							; 3
	lda	$F300,X							; 4
	ora	#$0F							; 2
	and	#$FE							; 2
	sta	SPRITE1_COLOR						; 3
; 21
	; new X
	lda	$F400,X			; sorta random			; 4
	and	#$7F			; 0..127			; 2
	sta	SPRITE1_X						; 3
; 30
	; new Y
	lda	$F500,X			; sorta random			; 4
	and	#$3F			; 0..127			; 2
	sta	SPRITE1_Y						; 3
; 39

not_new_firework1:
	lda	FRAMEL							; 3
	and	#$7							; 2
	bne	skip_progress1						; 2/3
; 46
	dec	SPRITE1_COLOR						; 5
	dec	SPRITE1_COLOR						; 5
; 56
skip_progress1:
	lda	SPRITE1_COLOR						; 3
	sta	COLUP1							; 3

; 62
	sta	WSYNC

	;=========================================
	; scanline 41/42/43
	;=========================================

;	jsr	adjust_sprites

; 6


	;============]========================
	; scanline 44: setup firework progress
	;====================================
; 6
	;	E C A 8  6  4  2  0
	;               24 16  8  0

	; firework0 progress
	lda	SPRITE0_COLOR						; 3
	and	#$0e							; 2
	asl								; 2
	asl								; 2
	sta	FIREWORK_PROGRESS0					; 3
; 18
	; firework1 progress
	lda	SPRITE1_COLOR						; 3
	and	#$0e							; 2
	asl								; 2
	asl								; 2
	sta	FIREWORK_PROGRESS1					; 3
; 30
	;==================================
	; set sky color

	ldy	SKY_COLOR						; 3
	lda	sky_colors,Y						; 4
	tay								; 2
	bne	set_bg			; only if dark			; 2/3
	lda	SPRITE0_COLOR						; 3
	and	#$E			; if exploding make bright	; 2
	bne	set_bg							; 2/3
	ldy	#$12							; 2
set_bg:
        sty	COLUBK							; 3
; 53
	sta	VDELP0							; 3
	sta	VDELP1		; turn off delay			; 3
; 59
	lda	#NUSIZ_DOUBLE_SIZE					; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1							; 3
; 67


	sta	WSYNC
	sta	HMOVE		; finalize fine adjust

	;=================================
	; VBLANK scanline 45
	;=================================
; 3
	lda	#0							; 2
	sta	VBLANK                  ; turn on beam			; 3
; 8

;	lda	#0							; 2
	sta	COLUPF			; fg, black			; 3
	sta	PF0			;				; 3
	sta	GRP0			; sprite 0			; 3
	sta	GRP1			; sprite 1			; 3
	sta	PF1			;				; 3
	sta	PF2							; 3
; 26
;	ldy	#0							; 2
;	ldx	#0							; 2


; 27
	lda	#CTRLPF_REF		; reflect playfield		; 2
	sta	CTRLPF							; 3
; 32
	; darken the sky
	lda	SKY_COLOR						; 3
	cmp	#6							; 2
	beq	sky_fine						; 2/3
; 39
	lda	FRAMEL							; 3
	and	#$7f							; 2
	bne	sky_fine						; 2/3
; 48
	inc	SKY_COLOR						; 5
; 53

sky_fine:


	sta	WSYNC							; 3



	;=========================
	;=========================
	; kernel
	;=========================
	;=========================
	; 228 scanlines (192 on NTSC)


	;=========================
	; sky
	;=========================
	; 98 scanlines
sky_playfield:
	ldx	#0
sky_loop:
; 2/3
	; X = 100, SPRITE_Y = 100, 0
	; X = 99, SPRITE_Y = 100, -1
	; X = 101, SPRITE_Y= 100, 1
	; X = 116, SPRITE_Y= 100, 16

	ldy	#$0							; 2
	txa								; 2
	sbc	SPRITE0_Y						; 3
	cmp	#32							; 2
	bcs	no_firework0						; 2/3
	lsr								; 2
	lsr								; 2
	clc								; 2
	adc	FIREWORK_PROGRESS0					; 2
	tay								; 2
	lda	firework7,Y						; 4
	tay								; 2
no_firework0:
	sty	GRP0							; 3
								;==========
								; 30 worst


	ldy	#$0							; 2
	txa								; 2
	sbc	SPRITE1_Y						; 3
	cmp	#32							; 2
	bcs	no_firework1						; 2/3
	lsr								; 2
	lsr								; 2
	clc								; 2
	adc	FIREWORK_PROGRESS1					; 2
	tay								; 2
	lda	firework7,Y						; 4
	tay								; 2
no_firework1:
	sty	GRP1							; 3
								;==========
								; 30 worst

	inx								; 2
	cpx	#99							; 2
	sta	WSYNC

	bne	sky_loop						; 2/3

.endif

done_firework:




sky_colors:
	.byte (96*2)+16,(96*2)+16,(88*2)+16,(80*2)+16,2+16,2+16,0


