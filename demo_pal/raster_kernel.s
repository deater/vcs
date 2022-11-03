	;================================================
	; draws raster effect
	;================================================

raster_effect:

	;============]========================
	; scanline 38: setup X for sprites
	;====================================
; 0
	lda	SPRITE0_X						; 3
; 3
        ; spritex DIV 16

	lsr								; 2
	lsr								; 2
	lsr								; 2
	lsr								; 2

        sta	SPRITE0_X_COARSE					; 3
; 14
	; apply fine adjust
	lda	SPRITE0_X						; 3
	and	#$0f							; 2
	tax								; 2
	lda	fine_adjust_table,X					; 4+
	sta	HMP0							; 3
; 28

	lda	SPRITE1_X						; 3
; 31
        ; spritex DIV 16

	lsr								; 2
	lsr								; 2
	lsr								; 2
	lsr								; 2

        sta	SPRITE1_X_COARSE					; 3
; 44
	; apply fine adjust
	lda	SPRITE1_X						; 3
	and	#$0f							; 2
	tax								; 2
	lda	fine_adjust_table,X					; 4+
	sta	HMP1							; 3
; 58

	sta	WSYNC

	;=========================================
	; scanline 39: move sprite0
	;=========================================
; 0
	lda	SPRITE0_XADD						; 3
	bne	sprite0_xadd_ok						; 2/3

; 5
	; was zero, dec it
	ldy	#100							; 2
	sty	SPRITE0_X						; 3
	dec	SPRITE0_XADD						; 5

sprite0_xadd_ok:
; 6 / 15

	; XADD in A
	clc								; 2
	adc	SPRITE0_X						; 3
	sta	SPRITE0_X						; 3
	cmp	#160							; 2
	bcs	sprite0_invert_x	; bge				; 2/3
	cmp	#0							; 2
	bcs	done_sprite0_x		; bge				; 2/3
								;============
								; 16 worst

sprite0_invert_x:
; 33
	lda	SPRITE0_XADD						; 3
	eor	#$FF							; 2
	clc								; 2
	adc	#1							; 2
	sta	SPRITE0_XADD						; 3
; 45


done_sprite0_x:

	sta	WSYNC


	;=========================================
	; scanline 40: move sprite1
	;=========================================
; 0
	lda	SPRITE1_XADD						; 3
	bne	sprite1_xadd_ok						; 2/3

; 5
	; was zero, dec it
	ldy	#100							; 2
	sty	SPRITE1_X						; 3
	inc	SPRITE1_XADD						; 5

sprite1_xadd_ok:
; 6 / 15

	; XADD in A
	clc								; 2
	adc	SPRITE1_X						; 3
	sta	SPRITE1_X						; 3
	cmp	#160							; 2
	bcs	sprite1_invert_x	; bge				; 2/3
	cmp	#0							; 2
	bcs	done_sprite1_x		; bge				; 2/3
								;============
								; 16 worst

sprite1_invert_x:
; 33
	lda	SPRITE1_XADD						; 3
	eor	#$FF							; 2
	clc								; 2
	adc	#1							; 2
	sta	SPRITE1_XADD						; 3
; 45


done_sprite1_x:

	sta	WSYNC

	;=======================================================
	; scanline 41: set up sprite0 to be at proper X position
	;=======================================================

; 0

	ldx	a:SPRITE0_X_COARSE	; force 4-cycle version		; 4

;	cpx	#$A                                                     ; 2
;	bcs	far_right	; bge                                   ; 2/3

	nop
	nop

; 8
	inx                     ;                                       ; 2
	inx                     ;                                       ; 2
; 12 (want to be 12 here)


pad_x:
	dex                     ;                                       2
	bne	pad_x           ;                                       2/3
                                ;===========================================
                                ;       5*(coarse_x+2)-1
                                ; MAX is 9, so up to 54
; up to 66
        ; beam is at proper place
        sta     RESP0                                                   ; 3
; up to 69

	sta	WSYNC


	;=======================================================
	; scanline 42: set up sprite1 to be at proper X position
	;=======================================================

; 0

	ldx	a:SPRITE1_X_COARSE	; force 4-cycle version		; 4

;	cpx	#$A                                                     ; 2
;	bcs	far_right	; bge                                   ; 2/3

	nop
	nop

; 8
	inx                     ;                                       ; 2
	inx                     ;                                       ; 2
; 12 (want to be 12 here)


pad_x1:
	dex                     ;                                       2
	bne	pad_x1           ;                                       2/3
                                ;===========================================
                                ;       5*(coarse_x+2)-1
                                ; MAX is 9, so up to 54
; up to 66
        ; beam is at proper place
	sta     RESP1                                                   ; 3
; up to 69

	sta	WSYNC

	sta	WSYNC
	sta	HMOVE

	;================================================
	; VBLANK scanline 43 -- adjust green rasterbar
	;================================================
; 3
	lda	RASTER_G_YADD					; 3
;	bne	raster_g_yadd_ok				; 2/3

	; was zero, dec it
;	ldy	#114						; 2
;	sty	RASTER_G_Y					; 3
;	dec	RASTER_G_YADD					; 5

raster_g_yadd_ok:
; 9/18

	; YADD in A
	clc								; 2
	adc	RASTER_G_Y						; 2
	sta	RASTER_G_Y						; 2
	cmp	#220							; 2
	bcs	raster_g_invert_y	; bge				; 2/3
	cmp	#0							; 2
	bcs	done_raster_g_y		; bge				; 2/3

raster_g_invert_y:
; 32
	lda	RASTER_G_YADD						; 3
	eor	#$FF							; 2
	clc								; 2
	adc	#1							; 2
	sta	RASTER_G_YADD						; 3
; 44

done_raster_g_y:
;	sta	WSYNC

raster_b_yadd_ok:
; 9/18
	lda	RASTER_B_YADD
	; YADD in A
	clc								; 2
	adc	RASTER_B_Y						; 2
	sta	RASTER_B_Y						; 2
	cmp	#220							; 2
	bcs	raster_b_invert_y	; bge				; 2/3
	cmp	#0							; 2
	bcs	done_raster_b_y		; bge				; 2/3

raster_b_invert_y:
; 32
	lda	RASTER_B_YADD						; 3
	eor	#$FF							; 2
	clc								; 2
	adc	#1							; 2
	sta	RASTER_B_YADD						; 3
; 44

done_raster_b_y:
	sta	WSYNC



	;================================================
	; VBLANK scanline 44 -- adjust red rasterbar
	;================================================

	lda	RASTER_R_YADD
;	bne	raster_r_yadd_ok

;	ldy	#114
;	sty	RASTER_R_Y
	; was zero, inc it
;	inc	RASTER_R_YADD

raster_r_yadd_ok:
	; YADD in A
	clc
	adc	RASTER_R_Y
	sta	RASTER_R_Y
	cmp	#220
	bcs	raster_r_invert_y	; bge
	cmp	#0
	bcs	raster_r_done_y		; bge

raster_r_invert_y:
	lda	RASTER_R_YADD
	eor	#$FF
	clc
	adc	#1
	sta	RASTER_R_YADD

raster_r_done_y:
	sta	WSYNC

	;=================================
	; VBLANK scanline 45
	;=================================
; 3
	lda	#0							; 2
	sta	VBLANK                  ; turn on beam			; 3
; 8

	lda	#0			; bg, black			; 3
        sta	COLUBK							; 3
;
	lda	#0							; 2
	sta	VDELP0							; 3
	sta	VDELP1		; turn off delay			; 3
;

	lda	#NUSIZ_ONE_COPY
;	lda	#NUSIZ_QUAD_SIZE|NUSIZ_MISSILE_WIDTH_8			; 2
	sta	NUSIZ0
	lda	#NUSIZ_ONE_COPY						; 3
;	lda	#NUSIZ_QUAD_SIZE|NUSIZ_MISSILE_WIDTH_8			; 2
	sta	NUSIZ1							; 3
;

	lda	#0							; 2
	sta	COLUPF			; fg, black			; 3

	lda	#$F0
	sta	PF0			;				; 3
	lda	#$FF
	sta	PF1			;				; 3
	lda	#$FF
	sta	PF2							; 3

; 56
	lda	#$FF
	sta	GRP0			; sprite 1
	sta	GRP1			; sprite 2

	lda	#$80
	sta	COLUP0

	lda	#$70
	sta	COLUP1
; 61
	ldy	#0							; 2
	ldx	#0							; 2
	txa			; needed so top line is black		; 2
	sta	WSYNC							; 3
; 68


	;=========================
	;=========================
	; kernel
	;=========================
	;=========================
	; 228 scanlines (192 on NTSC)

raster_playfield:
	; comes in at 3 cycles

; 3
	sta	COLUPF							; 3

draw_raster_red:
	lda	#$00			; initial color black

	ldy	RASTER_R_LEFT
	cpy	#0
	beq	draw_raster_green
	lda	raster_color_red,Y					; 4
	dec	RASTER_R_LEFT

draw_raster_green:
	ldy	RASTER_G_LEFT
	beq	draw_raster_blue
	lda	raster_color_green,Y					; 4
	dec	RASTER_G_LEFT

draw_raster_blue:
	ldy	RASTER_B_LEFT
	beq	raster_skip_color
	lda	raster_color_blue,Y					; 4
	dec	RASTER_B_LEFT


raster_skip_color:



	inx
	cpx	#227
	beq	done_raster

	ldy	#8

	cpx	RASTER_R_Y
	bne	no_start_raster_red
	sty	RASTER_R_LEFT
no_start_raster_red:
	cpx	RASTER_G_Y
	bne	no_start_raster_green
	sty	RASTER_G_LEFT
no_start_raster_green:
	cpx	RASTER_B_Y
	bne	no_start_raster_blue
	sty	RASTER_B_LEFT

no_start_raster_blue:

; 64
	sta	WSYNC							; 3
	jmp	raster_playfield						; 2/3

done_raster:

	sta	WSYNC

	;===========================
	;===========================
	; overscan (36 cycles) (30 on NTSC)
	;===========================
	;===========================

	; turn off everything
	lda	#0							; 2
	sta	GRP0							; 3
; 1
	lda	#2		; we do this in common
	sta	VBLANK		; but want it to happen in hblank


	lda	#0
	sta	GRP1							; 3
	sta	PF0							; 3
	sta	PF1							; 3
	sta	PF2							; 3
; 13

	jmp	effect_done


raster_color:
raster_color_red:
	.byte $60,$62,$64,$66,$68,$6A,$6C,$6E
raster_color_green:
	.byte $50,$52,$54,$56,$58,$5A,$5C,$5E
raster_color_blue:
	.byte $B0,$B2,$B4,$B6,$B8,$BA,$BC,$BE

