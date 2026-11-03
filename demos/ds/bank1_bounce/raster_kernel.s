	;================================================
	; draws raster effect
	;================================================


	; effects
	;	make bigger?
	;	make 2 or 3 copies
	;	move behind playfield

PLAYFIELD_MAX = 184


; init rasterbars
;        ldy     #90
 ;       sty     RASTER_G_Y
  ;      ldy     #122
   ;     sty     RASTER_R_Y
    ;    ldy     #154
     ;   sty     RASTER_B_Y
      ;  inc     RASTER_R_YADD
       ; inc     RASTER_B_YADD
        ;inc     RASTER_G_YADD

	; init sprites

	ldy	#100
	sty	SPRITE0_X
	sty	SPRITE0_Y
	sty	SPRITE1_X
	dec	SPRITE0_XADD
	inc	SPRITE0_YADD
	inc	SPRITE0_YADD
	inc	SPRITE1_XADD


raster_effect:

	;====================================
	; start VBLANK
	;====================================

	jsr	common_vblank

	;====================================
	; 37 lines of VBLANK
	;====================================

	ldx	#28
	jsr	repeat_wsync

	;==============================
	; scaline 29 -- ???
	;==============================
	sta	WSYNC

	;============]============================
	; scanline 30/31/32: setup X/Y for sprites
	;=========================================

	jsr	adjust_sprites

; 6


	;=========================================
	; scanline 33: move sprite0
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
	cmp	#164							; 2

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
	; scanline 34: move sprite1
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
	; VBLANK scanline 35/36 -- init sprites
	;================================================

	; various init

	lda	#$56		; medium purple				; 2
	sta	COLUP0		; set sprite0 color			; 3
	sta	COLUP1		; set sprite1 color			; 3

	lda	#$00							; 2
	sta	COLUBK							; 3
	sta	VDELP0							; 3
	sta	VDELP1		; turn off delay			; 3

	lda	#NUSIZ_ONE_COPY						; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1		; configure sprite size			; 3

	sta	WSYNC
	sta	WSYNC

	;=================================
	; VBLANK scanline 37
	;=================================
; 0
	lda	#0							; 2
	sta	VBLANK                  ; turn on beam			; 3
; 5

	lda	#0							; 2
	sta	COLUPF			; fg, black			; 3
	sta	GRP0			; sprite 1			; 3
	sta	GRP1			; sprite 2			; 3

; 13

	lda	#$F0			; set playfield			; 2
	sta	PF0			;				; 3
	lda	#$FF							; 2
	sta	PF1			;				; 3
	sta	PF2							; 3

; 29
	lda	#CTRLPF_REF						; 2
	sta	CTRLPF							; 3

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
	; 192 scanlines

raster_playfield:
	; comes in at 3 cycles

; 3
	; color is already in A
;	sta	COLUPF							; 3


; 6
	;============================
	; set sprite size
	;============================

	ldy	#$0							; 2
	txa								; 2
	sbc	SPRITE0_Y						; 3
	cmp	#17 ;BOX_HEIGHT						; 2
	bcs	no_sprite0						; 2/3
	tay								; 2
	lda	sprite_data,Y						; 4
	tay								; 2
no_sprite0:
	sty	GRP0							; 3
	sty	GRP1							; 3
								;==========
								; 22 worst
; 22

	;============================
	; setup raster bars
	;============================
; 22
	; raster red

;	txa								; 2
;	sec								; 2
;	sbc	RASTER_R_Y						; 3
;	cmp	#8							; 2
;	bcs	no_raster_red						; 2/3
; 33
;	asl								; 2
;	adc	#$C0		; green?				; 2
;	bne	done_raster_color			; bra		; 3
; 40

no_raster_red:
; 34
	; raster green

;	txa								; 2
;	sec								; 2
;	sbc	RASTER_G_Y						; 3
;	cmp	#8							; 2
;	bcs	no_raster_green						; 2/3
; 45
;	asl								; 2
;	adc	#$40		; red?	($30 might be closer)		; 2

;	bne	done_raster_color			; bra		; 3
; 52

no_raster_green:
; 46

	; raster blue

;	txa								; 2
;	sec								; 2
;	sbc	RASTER_B_Y						; 3
;	cmp	#8							; 2
;	bcs	no_raster_blue						; 2/3
; 57
;	asl								; 2
;	adc	#$80		; blue					; 2

;	bne	done_raster_color			; bra		; 3
; 64

no_raster_blue:
; 64
;	lda	#$0							; 2
done_raster_color:
; R=40, G=52, B=58 none=66

; 66 worst case

	inx								; 2
	cpx	#191							; 2

; 70
	sta	WSYNC							; 3
; 73/0
; NOTE: this is worst case
;	max overlapping bars is 2 so always 4 less than this? (check)

	bne	raster_playfield					; 2/3


done_raster:

	ldx	#30
	jsr	common_overscan

	jmp	raster_effect




sprite_data:
	.byte	$06	; .... .**.
	.byte	$1E	; ...* ***.
	.byte	$3A	; ..** *.*.
	.byte	$62	; .**. ..*.
	.byte	$3A	; ..** *.*.
	.byte	$CC	; **.. **..
	.byte	$E7	; ***. .***
	.byte	$BB	; *.** *.**
	.byte	$8C	; *... **..
	.byte	$B3	; *.** ..**
	.byte	$E6	; ***. .**.
	.byte	$CE	; **.. ***.
	.byte 	$3A	; ..** *.*.
	.byte	$62	; .**. ..*.
	.byte	$3A	; ..** *.*.
	.byte	$0E	; .... ***.
	.byte	$02	; .... ..*.

