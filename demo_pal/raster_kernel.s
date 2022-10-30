
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
	sta	WSYNC


	;================================================
	; VBLANK scanline 44 -- adjust Y
	;================================================

	lda	YADD
	bne	yadd_ok

	; was zero, inc it
	inc	YADD

yadd_ok:
	; YADD in A
	clc
	adc	LOGO_Y
	sta	LOGO_Y
	cmp	#227
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

; 56


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
draw_raster:
; 3
	lda	#$00
	cpy	#0
	beq	raster_skip_color
	lda	raster_color,Y						; 4
	dey
raster_skip_color:
	sta	COLUPF							; 3
	lda	#$F0
	sta	PF0			;				; 3
	lda	#$FF
	sta	PF1			;				; 3
	lda	#$FF
	sta	PF2							; 3



	inx
	cpx	#227
	beq	done_raster

	cpx	LOGO_Y
	bne	no_start_raster
	ldy	#8

no_start_raster:

; 64
	sta	WSYNC							; 3
	bne	draw_raster						; 2/3

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
	.byte $60,$62,$64,$66,$68,$6A,$6C,$6E
