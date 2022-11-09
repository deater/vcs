
	;================================================
	; draws logo effect
	;================================================

logo_effect:

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
; 0
	lda	LOGO_YADD					; 3
	clc							; 2
	adc	LOGO_Y						; 3
        sta	LOGO_Y						; 3
        cmp	#200						; 2
; 13
        bcs	logo_invert_y			; bge		; 2/3
        cmp	#0						; 2
        bcs	logo_done_y			; bge		; 2/3
logo_invert_y:
	lda	LOGO_YADD					; 3
	eor	#$FF						; 2
	clc							; 2
	adc	#1						; 2
	sta	LOGO_YADD					; 3

logo_done_y:
        sta     WSYNC


	;=================================
	; VBLANK scanline 45
	;=================================
; 0
	lda	#0							; 2
	sta	VBLANK                  ; turn on beam			; 3
; 5

	; update bg color
	lda	FRAMEL							; 3
	lsr								; 2
	lsr								; 2
	lsr								; 2
	and	#$7							; 2
	tax								; 2
	lda	bg_colors,X						; 4+
        sta	COLUBK							; 3
; 25
	lda	#0							; 2
	sta	VDELP0							; 3
	sta	VDELP1		; turn off delay			; 3
; 33

	lda	#NUSIZ_QUAD_SIZE|NUSIZ_MISSILE_WIDTH_8			; 2
	sta	NUSIZ0							; 3
	lda	#NUSIZ_QUAD_SIZE|NUSIZ_MISSILE_WIDTH_8			; 2
	sta	NUSIZ1							; 3
; 43
	; set playfield color?
	lda	#2							; 2
	sta	COLUPF			; fg, dark grey			; 3

; 48
	; move the logo

	clc								; 2
	lda	LOGO_Y							; 3
	adc	LOGO_YADD						; 3
	sta	LOGO_Y							; 3
; 59

	ldy	#0							; 2
	ldx	#0							; 2
	sta	WSYNC							; 3
; 66


	;=========================
	;=========================
	; kernel
	;=========================
	;=========================
	; 228 scanlines (192 on NTSC)

	; comes in at 3 cycles

	jmp	start_ahead						; 3

draw_playfield:
; 3

draw_logo:
; 3
	lda	desire_colors,Y						; 4
	sta	COLUPF							; 3
; 10
	lda	desire_playfield0_left,Y	; playfield pattern 0	; 4
	sta	PF0			;				; 3
	;   has to happen by 22 (GPU 68)
; 17
	lda	desire_playfield1_left,Y	; playfield pattern 1	; 4
	sta	PF1			;				; 3
        ;  has to happen by 28 (GPU 84)
; 24
	lda	desire_playfield2_left,Y	; playfield pattern 2	; 4
	sta	PF2							; 3
        ;  has to happen by 38 (GPU 116)	;
; 31
	lda	desire_playfield0_right,Y	; left pf pattern 0     ; 4
	sta	PF0				;                       ; 3
	; has to happen 28-49 (GPU 84-148)
; 38
	lda	desire_playfield1_right,Y	; left pf pattern 1	; 4
	sta	PF1				;			; 3
	; has to happen 38-56 (GPU 116-170)
; 45
	lda	desire_playfield2_right,Y	; left pf pattern 2	; 4
	sta	PF2				;			; 3
	; has to happen 49-67 (GPU148-202)
; 52
	dey					; decrement logo count	; 2

start_ahead:
; 5 / 54

	; see if line eqyals Y location?
	cpx	LOGO_Y							; 2
	bne	not_logo_start						; 2/3
	ldy	#29			; set logo height		; 2
not_logo_start:

	inx				; inc current scanline		; 2

; ?? / ?? / 61	worst case?

	; finish 1 early so time to clear up
	cpx	#227							; 2
	beq	done_playfield						; 2/3
; 65

	cpy	#0			; check if drawing logo		; 2

; 67
	sta	WSYNC							; 3
	bne	draw_logo		; if so, draw it		; 2/3
	beq	start_ahead		; otherwise draw nothing	; 2/3

done_playfield:

done_kernel:

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


bg_colors:
	.byte $00,$04,$08,$0A, $0A,$08,$04,$00
