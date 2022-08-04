	;=====================
	; the clock
	;=====================
do_clock:
	lda	#30
	sta	INPUT_COUNTDOWN

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
; 6
	inc	FRAME							; 5
; 11
	ldx	#4							; 2
; 13
mclock_pad:
	dex								; 2
	bne	mclock_pad	; (X*5)-1 = 14				; 2/3
; 27
	sta	RESM0							; 3
; 30
	lda	#$2							; 2
	sta	ENAM0	; enable missile 0				; 3
; 35
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
	ldx	#5		;					3
	inx			;					2
	inx			;					2
qpad_x:
	dex			;					2
	bne	qpad_x		;					2/3
				;===========================================
				;	5*(6+2)-1 = 39


	; beam is at proper place
	sta	RESP1							; 3

	lda	#$F0		; fine adjust overlay			; 2
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

	lda	#$22		; medium brown				; 2
	sta	COLUP0		; set pointer color (sprite0)		; 3

	lda	clock_overlay_colors					; 4+
	sta	COLUP1		; set secret color (sprite1)		; 3

	lda	#NUSIZ_DOUBLE_SIZE|NUSIZ_MISSILE_WIDTH_8		; 2
	sta	NUSIZ0							; 3
	lda	#NUSIZ_QUAD_SIZE|NUSIZ_MISSILE_WIDTH_4			; 2
	sta	NUSIZ1							; 3

	lda	#0							; 2
	tay			; current block 			; 2
	sty	CTRLPF		; no_reflect				; 3

	lda	#$E0		; sort of a dark brown			; 2
	sta	COLUBK							; 3

	lda	#$FF
	sta	GRP1

	lda	clock_colors

	ldx	#0

	stx	VBLANK			; turn on beam			; 3

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

	; A has clock colors

	;======================
	; draw playfield 0/4
	;======================
; 0
;	lda	clock_colors,Y						; 4+
	sta	COLUPF							; 3
	lda	clock_overlay_sprite,Y					; 4
	sta	GRP1							; 3
; 10
	lda	clock_playfield0_left,Y	;				; 4
	sta	PF0			;				; 3
	;   has to happen by 22 (GPU 68)
; 17
	lda	clock_playfield1_left,Y	;				; 4
	sta	PF1			;				; 3
	;  has to happen by 28 (GPU 84)
; 24
	lda	clock_playfield2_left,Y	;				; 4
        sta	PF2							; 3
	;  has to happen by 38 (GPU 116)	;
; 31
	lda	clock_playfield0_right,Y	;			; 4
        sta	PF0				;			; 3
	; has to happen 28-49 (GPU 84-148)
; 38
        lda	clock_playfield1_right,Y	;			; 4
        sta	PF1				;			; 3
	; has to happen 38-56 (GPU 116-170)
; 45
        lda	#$FF				;			; 2
	nop					;			; 2
        sta	PF2				;			; 3
	; has to happen 49-67 (GPU148-202)
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

	nop
	nop

; 72

	;===================
	; draw playfield 1/4
	;===================
	lda	clock_playfield0_left,Y	;				; 4
; 0
	sta	PF0			;				; 3
	;   has to happen by 22 (GPU 68)
; 3
	lda	clock_playfield1_left,Y	;				; 4
        sta	PF1			;				; 3
	;  has to happen by 28 (GPU 84)
; 10
	lda	clock_playfield2_left,Y	;				; 4
        sta	PF2							; 3
	;  has to happen by 38 (GPU 116)	;
; 17

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

; 37
	lda	clock_playfield0_right,Y	;			; 4+
	sta	PF0				;			; 3
	; has to happen 28-49 (GPU 84-148)
; 44
	lda	clock_playfield1_right,Y	;			; 4+
	sta	PF1				;			; 3
	; has to happen 39-56 (GPU 116-170)
; 51
	lda	#$FF				;			; 2
	nop								; 2
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

	inc	TEMP1
	inc	TEMP1
	nop
	nop
	nop

; 37
	lda	clock_playfield0_right,Y	;			; 4+
	sta	PF0				;			; 3
	; has to happen 28-49 (GPU 84-148)
; 44
	lda	clock_playfield1_right,Y	;			; 4+
	sta	PF1				;			; 3
	; has to happen 39-56 (GPU 116-170)
; 51
	lda	#$FF				;			; 2
	nop
	sta	PF2				;			; 3
	; has to happen 50-67 (GPU148-202)
; 58
	lda	clock_playfield0_left,Y	;				; 4
	sta	WSYNC




	;===================
	; draw playfield 3/4
	;===================
; 0
	sta	PF0			;				; 3
	;   has to happen by 22 (GPU 68)
; 3
	lda	clock_playfield1_left,Y	;				; 4
        sta	PF1			;				; 3
	;  has to happen by 28 (GPU 84)
; 10
	lda	clock_playfield2_left,Y	;				; 4
        sta	PF2							; 3
	;  has to happen by 38 (GPU 116)	;
; 17

	;==================
	; draw pointer
	;==================
	ldx	POINTER_ON						; 3
	beq	clock_no_pointer2					; 2/3
	lda	HAND_SPRITE,X						; 4
	sta	GRP0							; 3
	dec	POINTER_ON						; 5
	jmp	clock_done_pointer2					; 3
clock_no_pointer2:
	inc	TEMP1		; nop5					; 5
	inc	TEMP1		; nop5					; 5
	nop			;					; 2
	nop								; 2
clock_done_pointer2:
								;===========
								; 20 / 6

; 37
	lda	clock_playfield0_right,Y	;			; 4+
	sta	PF0				;			; 3
	; has to happen 28-49 (GPU 84-148)
; 44
	lda	clock_playfield1_right,Y	;			; 4+
	sta	PF1				;			; 3
	; has to happen 39-56 (GPU 116-170)
; 51
	lda	#$FF				;			; 2
	sta	PF2				;			; 3
	; has to happen 50-67 (GPU148-202)
; 56
	iny								; 2
	lda	clock_overlay_colors,Y					; 4
	sta	COLUP1							; 3
	lda	clock_colors,Y						; 4+
; 69
	cpy	#48		; see if hit end			; 2
; 71
	beq	done_playfield
; 73
	jmp	draw_playfield						; 2/3


done_playfield:



	;===========================
	;===========================
	; overscan (30 cycles)
	;===========================
	;===========================

	ldx	#26
	jsr	common_overscan


	;==================================
	; overscan 28, update sound

	jsr	update_sound

	sta	WSYNC

	;==================================
	; overscan 29, update pointer

	lda     #POINTER_TYPE_POINT					; 2

	ldy	POINTER_X						; 3
	cpy	#32
	bcs	clock_not_left
	lda	#POINTER_TYPE_LEFT
	jmp	clock_done_collision
clock_not_left:
	cpy	#128
	bcc	clock_done_collision
	lda	#POINTER_TYPE_RIGHT
clock_done_collision:
	sta	POINTER_TYPE

        sta     WSYNC

	;==================================
	; overscan 30, see if end of level

	lda	INPUT_COUNTDOWN						; 3
	beq	waited_enough_clock					; 2/3
	dec	INPUT_COUNTDOWN						; 5
	jmp	done_check_clock_input					; 3

waited_enough_clock:

	lda	INPT4			; check if joystick button pressed
	bmi	done_check_clock_input

	; button was pressed
	lda	POINTER_TYPE
	cmp	#POINTER_TYPE_POINT
	beq	done_clock		; done level

done_check_clock_input:

	sta	WSYNC

	jmp	clock_frame

arrival:
done_clock:
	jmp	arrival
