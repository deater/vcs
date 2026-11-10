	;================================================
	; draws bounce effect
	;================================================
	; effects
	;	make bigger?
	;	make 2 or 3 copies
	;	move behind playfield


BOUNCE_SPRITE0_LOW = 16
BOUNCE_SPRITE0_HIGH = 136
BOUNCE_SPRITE1_LOW = 24
BOUNCE_SPRITE1_HIGH = 144

PLAYFIELD_MAX = 184


; arrive
; 	31 + 3 (bankset) + 6 (jsr) = 40

do_bounce_effect:
	; in theory arrives a scanline early so time to init here?

	inc	FIRST_TIME


; 24/64

bounce_effect:

	;====================================
	; start VBLANK
	;====================================
	; this code takes 4 scanlines, it does a WSYNC soon after
	;       to ensure 3 scanlines total
	; this means it's really stealing one of the previous frame's lines

	jsr	common_vblank

; 9
	;====================================
	;====================================
	;====================================
	; 37 lines of VBLANK
	;====================================
	;====================================
	;====================================

	;=============================
	; scanlines 0..13 (unused)
	;=============================

	ldx	#14
	jsr	repeat_wsync
; 8
	;================================
	; play music -- scanlines 14..24
	;================================
	; takes 11 lines, doesn't WSYNC at end?

	lda	#1		; our bank
	jsr	do_play_music
	sta	WSYNC


	;================================
	; init if necessary -- scanlines 25
	;================================
; 0
	lda	FIRST_TIME						; 3
	beq	done_first_time						; 2/3
; 5
	dec	FIRST_TIME	; reset to 0				; 5
; 10
	ldy	#100							; 2
	sty	SPRITE0_X						; 3
	sty	SPRITE0_Y						; 3
	sty	SPRITE1_Y						; 3
; 21
	ldy	#108							; 2
	sty	SPRITE1_X						; 3
; 26
	lda	#$FF							; 2
	sta	SPRITE0_XADD						; 3
	sta	SPRITE0_YADD						; 3
	sta	SPRITE1_XADD						; 3
; 37
done_first_time:
	sta	WSYNC

	;==============================
	; scaline 26 -- incremement frame
	;==============================
	jsr	inc_frame		; 30
	sta	WSYNC

	;============]============================
	; scanline 27/28/29: set SPRITE0_X
	;=========================================

	lda	SPRITE0_X
	ldx	#0		; sprite0
	jsr	set_pos_x	; takes 3 scanlines

; 6

	;============]============================
	; scanline 30/31/32: set SPRITE1_X
	;=========================================

	lda	SPRITE1_X
	ldx	#1		; sprite1
	jsr	set_pos_x

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
	cmp	#BOUNCE_SPRITE0_HIGH					; 2
	bcs	sprite0_invert_x	; bge				; 2/3
	cmp	#BOUNCE_SPRITE0_LOW					; 2
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
	cmp	#BOUNCE_SPRITE1_HIGH					; 2
	bcs	sprite1_invert_x	; bge				; 2/3
	cmp	#BOUNCE_SPRITE1_LOW					; 2
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
	sta	COLUBK		; black background			; 3
	sta	VDELP0							; 3
	sta	VDELP1		; turn off delay			; 3

	lda	#NUSIZ_ONE_COPY						; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1		; configure sprite size			; 3

	; reflect sprite 1

	lda	#$8							; 2
	sta	REFP1							; 3

	sta	WSYNC
	sta	WSYNC

	;=================================
	; VBLANK scanline 37
	;=================================
; 0

	lda	#0							; 2
	sta	COLUPF			; fg, black			; 3
	sta	GRP0			; sprite 1			; 3
	sta	GRP1			; sprite 2			; 3

; 13

	lda	#$F0			; set playfield			; 2
	sta	PF0			;				; 3
	lda	#$FF							; 2
	sta	PF1			;				; 3
	sta	PF2			; all on			; 3

; 29
	lda	#CTRLPF_REF		; reflect			; 2
	sta	CTRLPF							; 3

; 34
	ldy	#0							; 2
	ldx	#0							; 2
	txa			; needed so top line is black		; 2
; 40

	stx	VBLANK                  ; turn on beam			; 3

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

	inx								; 2
	cpx	#191							; 2


	sta	WSYNC							; 3
; 0

	bne	raster_playfield					; 2/3


done_raster:

; 2
	;=============================================
	; overscan (30 scanlines)
	;=============================================

	ldx	#29
	jsr	common_overscan						; 10

; 10
	lda	FRAMEL							; 3
	cmp	#BOUNCE_TIME_L						; 2
	bne	not_done_bounce						; 2/3
; 17
	lda	FRAMEH							; 3
	cmp	#BOUNCE_TIME_H						; 2
	beq	done_bounce						; 2/3

; 18 / 24
not_done_bounce:
	jmp	bounce_effect

; 25
done_bounce:
	rts
; 31









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

