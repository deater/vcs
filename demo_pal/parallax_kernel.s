	;================================================
	; draws parallax effect
	;================================================

parallax_effect:

	;================================================
	; VBLANK scanline 38 -- init
	;================================================

; ?

	lda	#48
	sta	SPRITE0_X
	lda	#82
	sta	SPRITE1_X

	sta	WSYNC



	;=====================================
	; scanline 39: setup X for sprites
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
	; scanline 40/41 : setup zigzag
	;=========================================
; 0

	lda	#8
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


	;=========================================
	; scanline 41: ?
	;=========================================

	sta	WSYNC

	;=======================================================
	; scanline 42: set up sprite0 to be at proper X position
	;=======================================================
	; value will be 0..9

; 0

	ldx	a:SPRITE0_X_COARSE	; force 4-cycle version		; 4
; 4

	nop								; 2
	nop								; 2

; 8
	inx                     ;                                       ; 2
	inx                     ;                                       ; 2
; 12 (want to be 12 here)


	; X is 2..12 here
par_pad_x:
	dex                     ;                                       2
	bne	par_pad_x           ;                                       2/3
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
	; scanline 43: set up sprite1 to be at proper X position
	;=======================================================

; 0

	ldx	a:SPRITE1_X_COARSE	; force 4-cycle version		; 4
; 4

	nop								; 2
	nop								; 2

; 8
	inx                     ;                                       ; 2
	inx                     ;                                       ; 2
; 12 (want to be 12 here)


par_pad_x1:
	dex			;					; 2
	bne	par_pad_x1	;					; 2/3
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
	; VBLANK scanline 44 -- init
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
	; VBLANK scanline 45
	;=================================
; 0
	lda	#0							; 2
	sta	VBLANK                  ; turn on beam			; 3
; 5

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
	and	#$3
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
	; 228 scanlines (192 on NTSC)

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
	cpx	#227							; 2
; 67
	sta	WSYNC							; 3
; 70/0
;
	bne	parallax_playfield					; 2/3


done_parallax:
	sta	WSYNC

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

zigzag:
	.byte $40,$40,$20,$20, $40,$40,$20,$20
zigzag2:
	.byte $80,$40,$20,$10, $10,$20,$40,$80



fg_colors:
	.byte $12,$4E,$9E,$AE
