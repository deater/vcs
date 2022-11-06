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
; 42
	; apply fine adjust
	lda	SPRITE1_X						; 3
	and	#$0f							; 2
	tax								; 2
	lda	fine_adjust_table,X					; 4+
	sta	HMP1							; 3
; 56

	sta	WSYNC

	;=========================================
	; scanline 39: move sprite0
	;=========================================
; 0
	lda	SPRITE0_XADD						; 3
; 3
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
; 19
	lda	SPRITE0_XADD						; 3
	eor	#$FF							; 2
	tay								; 2
	iny								; 2
	sty	SPRITE0_XADD						; 3
; 31

done_sprite0_x:

	lda	SPRITE0_YADD						; 3
; 34
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
; 50
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

; 62
done_sprite0_y:
	sta	WSYNC


	;=========================================
	; scanline 40: move sprite1
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

	;=======================================================
	; scanline 41: set up sprite0 to be at proper X position
	;=======================================================
	; value will be 0..9

; 0

	ldx	a:SPRITE0_X_COARSE	; force 4-cycle version		; 4
; 4

;	cpx	#$A                                                     ; 2
;	bcs	far_right	; bge                                   ; 2/3

	nop								; 2
	nop								; 2

; 8
	inx                     ;                                       ; 2
	inx                     ;                                       ; 2
; 12 (want to be 12 here)


	; X is 2..12 here
pad_x:
	dex                     ;                                       2
	bne	pad_x           ;                                       2/3
                                ;===========================================
                                ;       5*(coarse_x+2)-1
                                ; COARSE_X is 0..9 so
				;   9 .. 54 cycles

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
; 4

;	cpx	#$A                                                     ; 2
;	bcs	far_right	; bge                                   ; 2/3

	nop								; 2
	nop								; 2

; 8
	inx                     ;                                       ; 2
	inx                     ;                                       ; 2
; 12 (want to be 12 here)


pad_x1:
	dex                     ;                                       2
	bne	pad_x1           ;                                       2/3
                                ;===========================================
                                ;       5*(coarse_x+2)-1
                                ; COARSE_X is 0..9 so
				;   9 .. 54 cycles
; up to 66
        ; beam is at proper place
	sta     RESP1                                                   ; 3
; up to 69

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
	cmp	#220							; 2
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
	cmp	#220							; 2
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
	cmp	#220							; 2
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
	sta	WSYNC

	;=================================
	; VBLANK scanline 45
	;=================================
; 0
	lda	#0							; 2
	sta	VBLANK                  ; turn on beam			; 3
        sta	COLUBK							; 3
	sta	VDELP0							; 3
	sta	VDELP1		; turn off delay			; 3
; 14

	lda	#NUSIZ_ONE_COPY						; 2
	sta	NUSIZ0							; 3
; 19
	lda	#NUSIZ_ONE_COPY						; 2
	sta	NUSIZ1							; 3
; 24

	lda	#0							; 2
	sta	COLUPF			; fg, black			; 3
	sta	GRP0			; sprite 1			; 3
; 32

	lda	#$F0							; 2
	sta	PF0			;				; 3
	lda	#$FF							; 2
	sta	PF1			;				; 3
	sta	PF2							; 3
	sta	GRP1			; sprite 2			; 3
; 48
	lda	#$86							; 2
	sta	COLUP0							; 3
; 53
	lda	#$7E							; 2
	sta	COLUP1							; 3
; 58
	ldy	#0							; 2
	ldx	#0							; 2
	txa			; needed so top line is black		; 2
; 64
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
	cmp	#16							; 2
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
	ldy	#0							; 2
; 24
	txa								; 2
	sec								; 2
	sbc	RASTER_R_Y						; 3
	cmp	#8							; 2
	bcs	no_raster_red						; 2/3
	tay								; 2
	iny								; 2
								;===========
								; 15 worst

no_raster_red:
; 39
	txa								; 2
	sec								; 2
	sbc	RASTER_G_Y						; 3
	cmp	#8							; 2
	bcs	no_raster_green						; 2/3
	adc	#9							; 2
	tay								; 2
								;===========
								; 15 worst

no_raster_green:
; 54
	txa								; 2
	sec								; 2
	sbc	RASTER_B_Y						; 3
	cmp	#8							; 2
	bcs	no_raster_blue						; 2/3
	adc	#17							; 2
	tay								; 2
								;===========
								; 15 worst
no_raster_blue:
; 69
	lda	raster_color,Y						; 4+
; 73

; 73 worst case

	inx								; 2
	cpx	#227							; 2
; 77
	sta	WSYNC							; 3
; 80/0
; NOTE: this is worst case
;	max overlapping bars is 2 so always 4 less than this? (check)

	bne	raster_playfield					; 2/3




done_raster:

;	sta	WSYNC

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
	.byte $00
raster_color_red:
	.byte $60,$62,$64,$66,$68,$6A,$6C,$6E
raster_color_green:
	.byte $50,$52,$54,$56,$58,$5A,$5C,$5E
raster_color_blue:
	.byte $B0,$B2,$B4,$B6,$B8,$BA,$BC,$BE

