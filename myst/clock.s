	;=====================
	; the clock
	;=====================

	jmp	clock_frame
.align	$100
clock_frame:

	;============================
	; start VBLANK
	;============================
	; in scanline 0

	jsr	common_vblank

	;=================================
	;=================================
	; 37 lines of vertical blank
	;=================================
	;=================================

; in VBLANK scanline 0

	ldx	#24
le_vblank_loop:
	sta	WSYNC
	dex
	bne	le_vblank_loop


	;=============================
	; now at VBLANK scanline 24
	;=============================
	; copy in hand sprite
	; takes 4 scanlines

	jsr	hand_copy
; 6

	;=============================
	; now at VBLANK scanline 28
	;=============================
	; 4 scanlines of handling input

	jsr	hand_motion
; 6

	;=======================
	; now scanline 32
	;========================
	; increment frame
	; setup missile
	inc	FRAME							; 5

	lda	#$2
	sta	ENAM0	; enable missile 0



	sta	WSYNC							; 3


	;=============================
	; now VBLANK scanline 33
	;=============================
	; do some init

	ldx	#$00							; 2
	stx	COLUBK			; set background color to black	; 3
	stx	CURRENT_SCANLINE	; reset scanline counter	; 3

	sta	WSYNC

	;=======================
	; now VBLANK scanline 34
	;=======================

	;==========================================
	; set up sprite1 to be at proper X position
	;==========================================
	; now in setup scanline 0

	; we can do this here and the sprite will be drawn as a long
	; vertical column
	; later we only enable it for the lines we want
; 3
	ldx	#0		; sprite 0 display nothing		2
	stx	GRP1		; (FIXME: this already set?)		3
; 8
	ldx	#6		;					3
	inx			;					2
	inx			;					2
qpad_x:
	dex			;					2
	bne	qpad_x		;					2/3
				;===========================================
				;	12-1+5*(coarse_x+2)
				; FIXME: describe better what's going on

	; beam is at proper place
	sta	RESP1							; 3


	sta	WSYNC

	;======================================
	; now vblank 35
	;=======================================
	; update pointer horizontal position
	;=======================================

	; do this separately as too long to fit in with left/right code

	jsr	pointer_moved_horizontally	;			6+48
	sta	WSYNC			;				3
					;====================================
					;				57

	;=========================================
	; now vblank 36
	;==========================================
	; set up sprite to be at proper X position
	;==========================================
; 0
	; we can do this here and the sprite will be drawn as a long
	; vertical column
	; later we only enable it for the lines we want

	ldx	#0		; sprite 0 display nothing		2
	stx	GRP0		; (FIXME: this already set?)		3

	ldx	POINTER_X_COARSE	;				3
	inx			;					2
	inx			;					2
; 12

pad_x:
	dex			;					2
	bne	pad_x		;					2/3
				;===========================================
				;	12-1+5*(coarse_x+2)
;

	; beam is at proper place
	sta	RESP0							; 3

	sta	WSYNC							; 3
	sta	HMOVE		; adjust fine tune, must be after WSYNC	; 3
				; also draws black artifact on left of
				; screen

	;==========================================
	; now vblank 37
	;==========================================
	; Final setup before going
	;==========================================

; 3 (from HMOVE)
	ldx	#0			; current scanline?		; 2
	stx	PF0			; disable playfield		; 3
	stx	PF1							; 3
	stx	PF2							; 3

								;===========
								;        23
; 26
	; reset back to strongbad sprite

	lda	#$40		; dark red				; 2
	sta	COLUP0		; set strongbad color (sprite0)		; 3

	lda	#$1E		; yellow				; 2
	sta	COLUP1		; set secret color (sprite1)		; 3

	lda	#NUSIZ_ONE_COPY						; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1							; 3

	ldy	#0		; current block 			; 2
								;============
								;	28

	sty	CTRLPF		; no_reflect

	lda	#0
	sta	VBLANK			; turn on beam



	lda	clock_colors						; 4
	ldx	clock_bg_colors

	sta	WSYNC							; 3
								;============
								;============
								;	60

	;===========================================
	;===========================================
	;===========================================
	; draw playfield, 192 scanlines
	;===========================================
	;===========================================
	;===========================================

draw_playfield:

draw_playfield_even:

	;===================
	; draw playfield 1/4
	;===================

	; Y is zero
	; A has clock_colors,Y
	; X has clock_bg_colors,Y

; 1
	sta	COLUPF							; 3
	stx	COLUBK							; 3
; 7
	lda	clock_playfield0_left,Y	;				; 4
	sta	PF0			;				; 3
	;   has to happen by 22 (GPU 68)
; 14
	lda	clock_playfield1_left,Y	;				; 4
	sta	PF1			;				; 3
	;  has to happen by 28 (GPU 84)
; 21
	lda	clock_playfield2_left,Y	;				; 4
        sta	PF2							; 3
	;  has to happen by 38 (GPU 116)	;
; 28

	lda	clock_playfield0_right,Y	;			; 4
        sta	PF0				;			; 3
	; has to happen 28-49 (GPU 84-148)
; 35
        lda	clock_playfield1_right,Y	;			; 4
        sta	PF1				;			; 3
	; has to happen 38-56 (GPU 116-170)
; 42
        lda	clock_playfield2_right,Y	;			; 4
        sta	PF2				;			; 3
	; has to happen 49-67 (GPU148-202)
; 49

	lda	$80

; 52

	; activate hand sprite if necessary
	lda	#$f							; 2
	ldx	CURRENT_SCANLINE					; 3
	cpx	POINTER_Y						; 3
	bne	no_clock_activate_hand					; 2/3
	sta	POINTER_ON						; 3
	jmp	done_clock_activate_hand				; 3
no_clock_activate_hand:
	inc	TEMP1				; nop5			; 5
done_clock_activate_hand:
								;===========
								; 16 / 16


; 68
	inc	CURRENT_SCANLINE					; 5
	lda	$80		; nop3					; 3
; 76

	;===================
	; draw playfield 2/4
	;===================
; 0
	lda	clock_playfield0_left,Y	;				; 4
	sta	PF0			;				; 3
	;   has to happen by 22 (GPU 68)
; 7
	lda	clock_playfield1_left,Y	;				; 4
        sta	PF1			;				; 3
	;  has to happen by 28 (GPU 84)
; 14
	lda	clock_playfield2_left,Y	;				; 4
        sta	PF2							; 3
	;  has to happen by 38 (GPU 116)	;
; 21
	lda	clock_playfield0_right,Y	;			; 4+
	sta	PF0				;			; 3
	; has to happen 28-49 (GPU 84-148)
; 28
	lda	clock_playfield1_right,Y	;			; 4+
	ldx	$80							; 3
	nop
	sta	PF1				;			; 3
	; has to happen 39-56 (GPU 116-170)
; 40
	lda	clock_playfield2_right,Y	;			; 4+
	nop
	nop
	sta	PF2				;			; 3
	; has to happen 50-67 (GPU148-202)
; 51

	;==================
	; draw pointer
	;==================

	ldx	POINTER_ON						; 3
	beq	clock_no_pointer					; 2/3
	lda	HAND_SPRITE,X						; 4
	sta	GRP0							; 3
	dec	POINTER_ON						; 5
	jmp	clock_done_pointer					; 3
clock_no_pointer:
	inc	TEMP1		; nop5					; 5
	inc	TEMP1		; nop5					; 5
	nop			;					; 2
	nop								; 2
clock_done_pointer:
								;===========
								; 20 / 6

; 71
	inc	CURRENT_SCANLINE					; 5
; 76

	;===================
	; draw playfield 3/4
	;===================
; 0
	lda	clock_playfield0_left,Y	;				; 4
	sta	PF0			;				; 3
	;   has to happen by 22 (GPU 68)
; 7
	lda	clock_playfield1_left,Y	;				; 4
        sta	PF1			;				; 3
	;  has to happen by 28 (GPU 84)
; 14
	lda	clock_playfield2_left,Y	;				; 4
        sta	PF2							; 3
	;  has to happen by 38 (GPU 116)	;
; 21
	lda	clock_playfield0_right,Y	;			; 4+
	sta	PF0				;			; 3
	; has to happen 28-49 (GPU 84-148)
; 28
	lda	clock_playfield1_right,Y	;			; 4+
	ldx	$80							; 3
	nop
	sta	PF1				;			; 3
	; has to happen 39-56 (GPU 116-170)
; 40
	lda	clock_playfield2_right,Y	;			; 4+
	nop
	nop
        sta	PF2				;			; 3
	; has to happen 50-67 (GPU148-202)
; 51
	inc	CURRENT_SCANLINE
	sta	WSYNC

	;===================
	; draw playfield 4/4
	;===================
; 0
	lda	clock_playfield0_left,Y	;				; 4
	sta	PF0			;				; 3
	;   has to happen by 22 (GPU 68)
; 7
	lda	clock_playfield1_left,Y	;				; 4
        sta	PF1			;				; 3
	;  has to happen by 28 (GPU 84)
; 14
	lda	clock_playfield2_left,Y	;				; 4
        sta	PF2							; 3
	;  has to happen by 38 (GPU 116)	;
; 21
	lda	clock_playfield0_right,Y	;			; 4+
	sta	PF0				;			; 3
	; has to happen 28-49 (GPU 84-148)
; 28
	lda	clock_playfield1_right,Y	;			; 4+
	ldx	$80							; 3
	nop								; 2
	sta	PF1				;			; 3
	; has to happen 39-56 (GPU 116-170)
; 40
	lda	clock_playfield2_right,Y	;			; 4+
	nop								; 2
	nop								; 2
	sta	PF2				;			; 3
	; has to happen 50-67 (GPU148-202)
; 51

	; activate strongbad sprite if necessary
.if 0
	ldx	CURRENT_SCANLINE
	; X = current scanline
	lda	#$F0			; load sprite data		; 2
	cpx	POINTER_Y_END						; 3
	bcs	turn_off_strongbad_delay5				; 2/3
	cpx	POINTER_Y						; 3
	bcc	turn_off_strongbad					; 2/3
turn_on_strongbad:
	sta	GRP0			; and display it		; 3
	jmp	after_sprite						; 3
turn_off_strongbad_delay5:
	inc	TEMP1							; 5
turn_off_strongbad:
	lda	#0			; turn off sprite		; 2
	sta	GRP0							; 3
after_sprite:
								;============
								; 13 / 18 / 18
.endif

;	inx								; 2
;	txa								; 2
;	and	#$3							; 2
;	beq	yes_inc4						; 2/3
;	.byte	$A5     ; begin of LDA ZP				; 3
;yes_inc4:
;	iny             ; $E8 should be harmless to load		; 2
;done_inc_block:
                                                                ;===========
                                                                ; 11/11

; 50
	iny								; 2
; 52
	lda	$80
	nop
	lda	$80
	nop

; 62
	lda	clock_colors,Y						; 4+
	ldx	clock_bg_colors,Y					; 4+
; 70

	cpy	#48		; see if hit end			; 2
; 72
	beq	done_playfield						; 2/3
; 74
	jmp	draw_playfield						; 3
; 77
done_playfield:



	;===========================
	;===========================
	; overscan (30 cycles)
	;===========================
	;===========================

	ldx	#25
	jsr	common_overscan

	;==================================
	; overscan 27, trigger sound

;	ldy	SOUND_TO_PLAY
;	beq	no_sound_to_play

;	jsr	trigger_sound		; 6+40

;	ldy	#0
;	sty	SOUND_TO_PLAY
;no_sound_to_play:
	sta	WSYNC

	;==================================
	; overscan 28+29, update sound

;	jsr	update_sound

	sta	WSYNC
	sta	WSYNC

	;==================================
	; overscan 30, collision detection

.if 0
	lda	CXPPMM			; check if p0/p1 collision	; 3
	bpl	no_collision_secret					; 2/3
collision_secret:
; 5
	lda	#LEVEL_OVER_SC						; 2
	sta	LEVEL_OVER						; 3
	ldy	#SFX_COLLECT						; 2
	jsr	trigger_sound
;	sty	SOUND_TO_PLAY						; 3
	jmp	collision_done						; 3
; 18

no_collision_secret:
; 6
	lda	CXP0FB			; check if p0/pf collision	; 3
	bpl	no_collision_wall					; 2/3
collision_wall:
; 11
	; if between Y>9*4 && Y<29*4 X and X>1 and Y<150 we got zapped!

	lda	POINTER_X						; 3
	cmp	#12							; 2
	bcc	regular_collision					; 2/3
; 18
	cmp	#150	; $9E						; 2
	bcs	regular_collision					; 2/3
; 22
	lda	POINTER_Y						; 3
	cmp	#64	; $40						; 2
	bcc	regular_collision					; 2/3
; 29
	cmp	#134	; $86						; 2
	bcs	regular_collision					; 2/3
;33
got_zapped:
	lda	#LEVEL_OVER_ZAP
	sta	LEVEL_OVER
	jmp	collision_done

regular_collision:
	; reset strongbad position
	lda	OLD_POINTER_X
	sta	POINTER_X
	lda	OLD_POINTER_Y
	sta	POINTER_Y

	lda	OLD_POINTER_X_END
	sta	POINTER_X_END
	lda	OLD_POINTER_Y_END
	sta	POINTER_Y_END

	ldy	#SFX_COLLIDE
	;sty	SOUND_TO_PLAY
	jsr	trigger_sound

no_collision_wall:


collision_done:

	lda	LEVEL_OVER
	beq	nothing_special
	bmi	goto_sc
	cmp	#LEVEL_OVER_ZAP
	beq	goto_zap
	cmp	#LEVEL_OVER_TIME
	beq	goto_oot

nothing_special:
.endif

	sta	WSYNC

	jmp	clock_frame

goto_sc:
;	jmp	secret_collect_animation

goto_go:
;	jmp	game_over_animation

goto_zap:
;	ldy	#SFX_ZAP
;	jsr	trigger_sound
;	jsr	init_strongbad	; reset position
;	lda	#0
;	sta	LEVEL_OVER

;	jmp	level_frame

goto_oot:
;	ldy	#SFX_GAMEOVER
;	jsr	trigger_sound

;	dec	MANS
;	bmi	goto_go

;	jsr	init_level
	jmp	clock_frame
