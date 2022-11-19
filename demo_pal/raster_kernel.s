	;================================================
	; draws raster effect
	;================================================

PLAYFIELD_MAX = 220

raster_effect:

	;============]========================
	; scanline 38/39/40: setup X/Y for sprites
	;====================================

	jsr	adjust_sprites

; 6


	;=========================================
	; scanline 41: move sprite0
	;=========================================
; 6
	lda	SPRITE0_XADD						; 3
; 9
	; XADD in A
	clc								; 2
	adc	SPRITE0_X						; 3
	sta	SPRITE0_X						; 3
	cmp	#144							; 2
	bcs	sprite0_invert_x	; bge				; 2/3
	cmp	#16							; 2
	bcs	done_sprite0_x		; bge				; 2/3
								;============
								; 16 worst
sprite0_invert_x:
; 25
	lda	SPRITE0_XADD						; 3
	eor	#$FF							; 2
	tay								; 2
	iny								; 2
	sty	SPRITE0_XADD						; 3
; 37

done_sprite0_x:

	lda	SPRITE0_YADD						; 3
; 40
	clc								; 2
	adc	SPRITE0_Y						; 3
	sta	SPRITE0_Y						; 3
	cmp	#200							; 2
	bcs	sprite0_invert_y	; bge				; 2/3
	cmp	#8							; 2
	bcs	done_sprite0_y		; bge				; 2/3
								;============
								; 16 worst

sprite0_invert_y:
; 56
	lda	SPRITE0_YADD						; 3
	eor	#$FF							; 2
	tay								; 2
	iny								; 2
	sty	SPRITE0_YADD						; 3

	; make so goes behind playfield?
	; note it's not transparent color, but whether playfield drawn
	; at all
	; we'd have to reset PF0/PF1/PF2 in kernel, prob not possible :(

;	lda	#CTRLPF_PFP
;	sta	CTRLPF

; 68
done_sprite0_y:
	sta	WSYNC


	;=========================================
	; scanline 42: move sprite1
	;=========================================
; 0
	lda	SPRITE1_XADD						; 3
	clc								; 2
	adc	SPRITE1_X						; 3
	sta	SPRITE1_X						; 3
	cmp	#144							; 2
	bcs	sprite1_invert_x	; bge				; 2/3
	cmp	#16							; 2
	bcs	done_sprite1_x		; bge				; 2/3
								;============
								; 18 worst

sprite1_invert_x:
; 18
	lda	SPRITE1_XADD						; 3
	eor	#$FF							; 2
	clc								; 2
	adc	#1							; 2
	sta	SPRITE1_XADD						; 3
; 30

done_sprite1_x:

	; TODO: change color?

	sta	WSYNC
	sta	HMOVE		; finalize fine adjust

	;================================================
	; VBLANK scanline 43 -- adjust green and blue rasterbar
	;================================================
; 3
	lda	RASTER_G_YADD						; 3
; 6
	clc								; 2
	adc	RASTER_G_Y						; 3
	sta	RASTER_G_Y						; 3
	cmp	#PLAYFIELD_MAX						; 2
	bcs	raster_g_invert_y	; bge				; 2/3
	cmp	#0							; 2
	bcs	done_raster_g_y		; bge				; 2/3
								;============
								; 16 worst
raster_g_invert_y:
; 22
	lda	RASTER_G_YADD						; 3
	eor	#$FF							; 2
	clc								; 2
	adc	#1							; 2
	sta	RASTER_G_YADD						; 3
; 34

done_raster_g_y:

	;=========================
	; blue rasterbar
; 34
	lda	RASTER_B_YADD						; 3
; 37
	clc								; 2
	adc	RASTER_B_Y						; 3
	sta	RASTER_B_Y						; 3
	cmp	#PLAYFIELD_MAX						; 2
	bcs	raster_b_invert_y	; bge				; 2/3
	cmp	#0							; 2
	bcs	done_raster_b_y		; bge				; 2/3
								;============
								; 16 worst case
raster_b_invert_y:
; 53
	lda	RASTER_B_YADD						; 3
	eor	#$FF							; 2
	clc								; 2
	adc	#1							; 2
	sta	RASTER_B_YADD						; 3
; 65

done_raster_b_y:
	sta	WSYNC



	;================================================
	; VBLANK scanline 44 -- adjust red rasterbar
	;================================================
; 0
	lda	RASTER_R_YADD						; 3
; 3
	clc								; 2
	adc	RASTER_R_Y						; 3
	sta	RASTER_R_Y						; 3
	cmp	#PLAYFIELD_MAX						; 2
	bcs	raster_r_invert_y	; bge				; 2/3
	cmp	#0							; 2
	bcs	raster_r_done_y		; bge				; 2/3
								;============
								; 16
; 19
raster_r_invert_y:
	lda	RASTER_R_YADD						; 3
	eor	#$FF							; 2
	clc								; 2
	adc	#1							; 2
	sta	RASTER_R_YADD						; 3
; 31
raster_r_done_y:

	; other init

; 31
	lda	#$86							; 2
	sta	COLUP0							; 3
; 38
	lda	#$7E							; 2
	sta	COLUP1							; 3
; 43
	lda	#$00							; 2
        sta	COLUBK							; 3
	sta	VDELP0							; 3
	sta	VDELP1		; turn off delay			; 3
; 54
	lda	#NUSIZ_ONE_COPY						; 2
	sta	NUSIZ0							; 3
; 59
	lda	#NUSIZ_ONE_COPY						; 2
	sta	NUSIZ1							; 3
; 64
	sta	WSYNC

	;=================================
	; VBLANK scanline 45
	;=================================
; 0
	lda	#0							; 2
	sta	VBLANK                  ; turn on beam			; 3
; 5

	lda	#0							; 2
	sta	COLUPF			; fg, black			; 3
	sta	GRP0			; sprite 1			; 3
; 13

	lda	#$F0							; 2
	sta	PF0			;				; 3
	lda	#$FF							; 2
	sta	PF1			;				; 3
	sta	PF2							; 3
	sta	GRP1			; sprite 2			; 3

; 29
	lda	#CTRLPF_REF						; 2
	sta	CTRLPF							; 3

	; adjust size of box
;	ldy	#16
;	lda	IS_NOTE
;	beq	box_no_drum
;	ldy	#20
;	dec	IS_NOTE
;box_no_drum:
;	sty	BOX_HEIGHT


; 34
	ldy	#0							; 2
	ldx	#0							; 2
	txa			; needed so top line is black		; 2
; 40


	sta	WSYNC							; 3
; 67


	;=========================
	;=========================
	; kernel
	;=========================
	;=========================
	; 228 scanlines (192 on NTSC)

raster_playfield:
	; comes in at 3 cycles

; 3
	; color is already in A
	sta	COLUPF							; 3


; 6
	;============================
	; set sprite size
	;============================

	ldy	#$0							; 2
	txa								; 2
	sbc	SPRITE0_Y						; 3
	cmp	#16 ;BOX_HEIGHT						; 2
	bcs	no_sprite0						; 2/3
	ldy	#$FF							; 2
no_sprite0:
	sty	GRP0							; 3
								;==========
								; 16 worst
; 22

	;============================
	; setup raster bars
	;============================
; 22
	; raster red

	txa								; 2
	sec								; 2
	sbc	RASTER_R_Y						; 3
	cmp	#8							; 2
	bcs	no_raster_red						; 2/3
; 33
	asl								; 2
	adc	#$50							; 2
	bne	done_raster_color			; bra		; 3
; 40

no_raster_red:
; 34
	; raster green

	txa								; 2
	sec								; 2
	sbc	RASTER_G_Y						; 3
	cmp	#8							; 2
	bcs	no_raster_green						; 2/3
; 45
	asl								; 2
	adc	#$60							; 2
	bne	done_raster_color			; bra		; 3
; 52

no_raster_green:
; 46

	; raster blue

	txa								; 2
	sec								; 2
	sbc	RASTER_B_Y						; 3
	cmp	#8							; 2
	bcs	no_raster_blue						; 2/3
; 57
	asl								; 2
	adc	#$B0							; 2
	bne	done_raster_color			; bra		; 3
; 64

no_raster_blue:
; 64
	lda	#$0							; 2
done_raster_color:
; R=40, G=52, B=58 none=66

; 66 worst case

	inx								; 2
	cpx	#227							; 2
; 70
	sta	WSYNC							; 3
; 73/0
; NOTE: this is worst case
;	max overlapping bars is 2 so always 4 less than this? (check)

	bne	raster_playfield					; 2/3


done_raster:

	;===========================
	;===========================
	; overscan (36 cycles) (30 on NTSC)
	;===========================
	;===========================
; 0
	; turn off everything
	lda	#0							; 2
	sta	GRP0							; 3
; 5
	lda	#2		; we do this in common			; 2
	sta	VBLANK		; but want it to happen in hblank	; 3
; 10
	lda	#0
	sta	GRP1							; 3
	sta	PF0							; 3
	sta	PF1							; 3
	sta	PF2							; 3
; 22

	jmp	effect_done


;raster_color:
;	.byte $00
;raster_color_red:
;	.byte $60,$62,$64,$66,$68,$6A,$6C,$6E
;raster_color_green:
;	.byte $50,$52,$54,$56,$58,$5A,$5C,$5E
;raster_color_blue:
;	.byte $B0,$B2,$B4,$B6,$B8,$BA,$BC,$BE

