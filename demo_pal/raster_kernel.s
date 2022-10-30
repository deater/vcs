
	;================================================
	; draws raster effect
	;================================================

raster_effect:

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC

	;================================================
	; VBLANK scanline 43 -- adjust Y2
	;================================================

	lda	RASTER_YADD
	bne	raster_yadd_ok

	; was zero, dec it
	ldy	#114
	sty	RASTER_Y
	dec	RASTER_YADD

raster_yadd_ok:
	; YADD in A
	clc
	adc	RASTER_Y
	sta	RASTER_Y
	cmp	#220
	bcs	raster_invert_y		; bge
	cmp	#0
	bcs	done_raster_y		; bge

raster_invert_y:
	lda	RASTER_YADD
	eor	#$FF
	clc
	adc	#1
	sta	RASTER_YADD

done_raster_y:
	sta	WSYNC


	;================================================
	; VBLANK scanline 44 -- adjust Y
	;================================================

	lda	YADD
	bne	yadd_ok

	ldy	#114
	sty	LOGO_Y
	; was zero, inc it
	inc	YADD

yadd_ok:
	; YADD in A
	clc
	adc	LOGO_Y
	sta	LOGO_Y
	cmp	#220
	bcs	invert_y		; bge
	cmp	#0
	bcs	done_y			; bge

invert_y:
	lda	YADD
	eor	#$FF
	clc
	adc	#1
	sta	YADD

done_y:
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

	lda	#NUSIZ_QUAD_SIZE|NUSIZ_MISSILE_WIDTH_8			; 2
	sta	NUSIZ0							; 3
	lda	#NUSIZ_QUAD_SIZE|NUSIZ_MISSILE_WIDTH_8			; 2
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
draw_raster_red:
; 3
	lda	#$00
	ldy	LOGO_LEFT
	cpy	#0
	beq	draw_raster_green
	lda	raster_color_red,Y					; 4
	dec	LOGO_LEFT

draw_raster_green:
	ldy	RASTER_LEFT
	beq	raster_skip_color
	lda	raster_color_green,Y					; 4
	dec	RASTER_LEFT

raster_skip_color:
	sta	COLUPF							; 3


	inx
	cpx	#227
	beq	done_raster

	ldy	#8

	cpx	LOGO_Y
	bne	no_start_raster_red
	sty	LOGO_LEFT
no_start_raster_red:
	cpx	RASTER_Y
	bne	no_start_raster
	sty	RASTER_LEFT

no_start_raster:

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
