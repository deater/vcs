	level_data		= $1400
        level_colors            = $1410
        level_playfield0_left   = $1440
        level_playfield1_left   = $1470
        level_playfield2_left   = $14A0
        level_playfield0_right  = $14D0
        level_playfield1_right  = $1500
        level_playfield2_right  = $1530
        level_overlay_colors    = $1560
        level_overlay_sprite    = $1590



	;==========================
	; the generic level engine
	;==========================
do_level:
	lda	#30
	sta	INPUT_COUNTDOWN

;	jmp	level_frame

level_frame:

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
	; setup missile0 location
; 6
	lda	$80				; nop3			; 3
	ldx	LEVEL_MISSILE0_COARSE					; 3
	beq	no_missile0						; 2/3
; 14
mlevel_pad:
	dex								; 2
	bne	mlevel_pad	; (X*5)-1 = 14				; 2/3
; 28
	sta	RESM0							; 3
; 31

	lda	#$2							; 2
	sta	ENAM0	; enable missile 0				; 3
; ??
no_missile0:
	sta	WSYNC							; 3


	;=============================
	; now VBLANK scanline 33
	;=============================
	; do some init

	inc	FRAME							; 5

	ldx	#$00							; 2
;	stx	COLUBK			; set background color to black	; 3
	stx	CURRENT_SCANLINE	; reset scanline counter	; 3

	sta	WSYNC

	;=======================
	; now VBLANK scanline 34
	;=======================

	;====================================================
	; set up sprite1 (overlay) to be at proper X position
	;====================================================
	; now in setup scanline 0

; 0
	nop								; 2
	nop								; 2
; 4
	ldx	LEVEL_OVERLAY_COARSE					; 3
	inx			;					; 2
	inx			;					; 2
; 11
qpad_x:
	dex			;					; 2
	bne	qpad_x		;					; 2/3
				;===========================================
				;	(5*COASRE+2)-1

	; beam is at proper place
	sta	RESP1							; 3

	lda	LEVEL_OVERLAY_FINE	; fine adjust overlay		; 3
	sta	HMP1							; 3


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

	ldx	#0		; sprite 0 display nothing		; 2
	stx	GRP0		; (FIXME: this already set?)		; 3

	ldx	POINTER_X_COARSE	;				; 3
	inx			;					; 2
	inx			;					; 2
; 12

pad_x:
	dex			;					; 2
	bne	pad_x		;					; 2/3
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

; 3 (from HMOVE)			; NEEDED?
	ldx	#0			; current scanline?		; 2
	stx	PF0			; disable playfield		; 3
	stx	PF1							; 3
	stx	PF2							; 3

; 14

	lda	LEVEL_HAND_COLOR	;				; 3
	sta	COLUP0		; set pointer color (sprite0)		; 3
; 20
	lda	level_overlay_colors					; 4+
	sta	COLUP1		; set secret color (sprite1)		; 3
; 27
	lda	#NUSIZ_DOUBLE_SIZE|NUSIZ_MISSILE_WIDTH_8		; 2
	sta	NUSIZ0							; 3
	lda	#NUSIZ_QUAD_SIZE|NUSIZ_MISSILE_WIDTH_4			; 2
	sta	NUSIZ1							; 3
; 37
	lda	#0							; 2
	tay			; current block 			; 2
	sty	CTRLPF		; no_reflect				; 3
; 44
	lda	LEVEL_BACKGROUND_COLOR		;			; 3
	sta	COLUBK		; set background color			; 3
; 50
	lda	#$FF							; 2
	sta	GRP1							; 3
; 55
	lda	level_colors	; load level color in advance		; 4
; 59
	ldx	#0		; init scanline				; 2
; 61
	stx	VBLANK		; turn on beam				; 3
; 64
	sta	WSYNC							; 3


	;===========================================
	;===========================================
	;===========================================
	; draw playfield, 192 scanlines
	;===========================================
	;===========================================
	;===========================================

draw_playfield:

	; A has level colors

	;======================
	; draw playfield 0/4
	;======================
; 0
;	lda	level_colors,Y						; --
	sta	COLUPF							; 3
	lda	level_overlay_sprite,Y					; 4
	sta	GRP1							; 3
; 10
	lda	level_playfield0_left,Y	;				; 4
	sta	PF0			;				; 3
	;   has to happen by 22 (GPU 68)
; 17
	lda	level_playfield1_left,Y	;				; 4
	sta	PF1			;				; 3
	;  has to happen by 28 (GPU 84)
; 24
	lda	level_playfield2_left,Y	;				; 4
        sta	PF2							; 3
	;  has to happen by 38 (GPU 116)	;
; 31
	lda	level_playfield0_right,Y	;			; 4
        sta	PF0				;			; 3
	; has to happen 28-49 (GPU 84-148)
; 38
        lda	level_playfield1_right,Y	;			; 4
        sta	PF1				;			; 3
	; has to happen 38-56 (GPU 116-170)
; 45
        lda	level_playfield2_right,Y	;			; 4
        sta	PF2				;			; 3
	; has to happen 49-67 (GPU148-202)
; 52
	; activate hand sprite if necessary
	lda	#$f							; 2
	ldx	CURRENT_SCANLINE					; 3
	cpx	POINTER_Y						; 3
	bne	no_level_activate_hand					; 2/3
	sta	POINTER_ON						; 3
	jmp	done_level_activate_hand				; 3
no_level_activate_hand:
	inc	TEMP1				; nop5			; 5
done_level_activate_hand:
								;===========
								; 16 / 16
; 68

	nop
	nop

; 72

	;===================
	; draw playfield 1/4
	;===================
	lda	level_playfield0_left,Y	;				; 4
; 0
	sta	PF0			;				; 3
	;   has to happen by 22 (GPU 68)
; 3
	lda	level_playfield1_left,Y	;				; 4
        sta	PF1			;				; 3
	;  has to happen by 28 (GPU 84)
; 10
	lda	level_playfield2_left,Y	;				; 4
        sta	PF2							; 3
	;  has to happen by 38 (GPU 116)	;
; 17

	;==================
	; draw pointer
	;==================

	ldx	POINTER_ON						; 3
	beq	level_no_pointer					; 2/3
	lda	HAND_SPRITE,X						; 4
	sta	GRP0							; 3
	dec	POINTER_ON						; 5
	jmp	level_done_pointer					; 3
level_no_pointer:
	inc	TEMP1		; nop5					; 5
	inc	TEMP1		; nop5					; 5
	nop			;					; 2
	nop								; 2
level_done_pointer:
								;===========
								; 20 / 6

; 37
	lda	level_playfield0_right,Y	;			; 4+
	sta	PF0				;			; 3
	; has to happen 28-49 (GPU 84-148)
; 44
	lda	level_playfield1_right,Y	;			; 4+
	sta	PF1				;			; 3
	; has to happen 39-56 (GPU 116-170)
; 51
	lda	level_playfield2_right,Y	;			; 4+
	sta	PF2				;			; 3
	; has to happen 50-67 (GPU148-202)
; 68

	inc	CURRENT_SCANLINE					; 5
; 63
	sta	WSYNC

	;===================
	; draw playfield 2/4
	;===================
; 0
	lda	level_playfield0_left,Y	;				; 4
	sta	PF0			;				; 3
	;   has to happen by 22 (GPU 68)
; 7
	lda	level_playfield1_left,Y	;				; 4
        sta	PF1			;				; 3
	;  has to happen by 28 (GPU 84)
; 14
	lda	level_playfield2_left,Y	;				; 4
        sta	PF2							; 3
	;  has to happen by 38 (GPU 116)	;
; 21

	inc	TEMP1
	inc	TEMP1
	nop
	nop
	nop

; 37
	lda	level_playfield0_right,Y	;			; 4+
	sta	PF0				;			; 3
	; has to happen 28-49 (GPU 84-148)
; 44
	lda	level_playfield1_right,Y	;			; 4+
	sta	PF1				;			; 3
	; has to happen 39-56 (GPU 116-170)
; 51
	lda	level_playfield2_right,Y	;			; 4+
	sta	PF2				;			; 3
	; has to happen 50-67 (GPU148-202)
; 58
	lda	level_playfield0_left,Y	;				; 4
	sta	WSYNC




	;===================
	; draw playfield 3/4
	;===================
; 0
	sta	PF0			;				; 3
	;   has to happen by 22 (GPU 68)
; 3
	lda	level_playfield1_left,Y	;				; 4
        sta	PF1			;				; 3
	;  has to happen by 28 (GPU 84)
; 10
	lda	level_playfield2_left,Y	;				; 4
        sta	PF2							; 3
	;  has to happen by 38 (GPU 116)	;
; 17

	;==================
	; draw pointer
	;==================
	ldx	POINTER_ON						; 3
	beq	level_no_pointer2					; 2/3
	lda	HAND_SPRITE,X						; 4
	sta	GRP0							; 3
	dec	POINTER_ON						; 5
	jmp	level_done_pointer2					; 3
level_no_pointer2:
	inc	TEMP1		; nop5					; 5
	inc	TEMP1		; nop5					; 5
	nop			;					; 2
	nop								; 2
level_done_pointer2:
								;===========
								; 20 / 6

; 37
	lda	level_playfield0_right,Y	;			; 4+
	sta	PF0				;			; 3
	; has to happen 28-49 (GPU 84-148)
; 44
	lda	level_playfield1_right,Y	;			; 4+
	sta	PF1				;			; 3
	; has to happen 39-56 (GPU 116-170)
; 51
	lda	level_playfield2_right,Y	;			; 4
	sta	PF2				;			; 3
	; has to happen 50-67 (GPU148-202)
; 58
	iny								; 2
	lda	level_overlay_colors,Y					; 4
	sta	COLUP1							; 3
	lda	level_colors,Y						; 4+
; 71
	cpy	#48		; see if hit end			; 2
; 73
	beq	done_playfield						; 2/3
; 75
	jmp	draw_playfield						; 3
; 78??


done_playfield:



	;===========================
	;===========================
	; overscan (30 cycles)
	;===========================
	;===========================

	ldx	#25
	jsr	common_overscan

	;==================================
	; overscan 27, general stuff

	lda	#$0							; 2
	sta	ENAM0		; disable missile 0			; 3
	sta	WSYNC

	;==================================
	; overscan 28, update sound

	jsr	update_sound

	sta	WSYNC

	;==================================
	; overscan 29, update pointer

	lda     #POINTER_TYPE_POINT					; 2

	ldy	POINTER_X						; 3
	cpy	#32
	bcs	level_not_left
	lda	#POINTER_TYPE_LEFT
	jmp	level_done_collision
level_not_left:
	cpy	#128
	bcc	level_done_collision
	lda	#POINTER_TYPE_RIGHT
level_done_collision:
	sta	POINTER_TYPE

        sta     WSYNC

	;==================================
	; overscan 30, see if end of level

	lda	INPUT_COUNTDOWN						; 3
	beq	waited_enough_level					; 2/3
	dec	INPUT_COUNTDOWN						; 5
	jmp	done_check_level_input					; 3

waited_enough_level:

	lda	INPT4			; check if joystick button pressed
	bmi	done_check_level_input

	; button was pressed
	lda	POINTER_TYPE
	cmp	#POINTER_TYPE_POINT
	beq	clicked_forward

	cmp	#POINTER_TYPE_LEFT
	beq	clicked_left

	cmp	#POINTER_TYPE_RIGHT
	beq	clicked_right

done_check_level_input:

	sta	WSYNC

	jmp	level_frame


clicked_forward:

	lda	LEVEL_CENTER_DEST
	jmp	start_new_level

clicked_left:
	lda	LEVEL_LEFT_DEST
	jmp	start_new_level

clicked_right:
	lda	LEVEL_RIGHT_DEST
;	jmp	start_new_level


start_new_level:
	sta	CURRENT_LOCATION
	jmp	load_new_level
