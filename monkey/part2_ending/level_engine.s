
	;==========================
	; the generic level engine
	;==========================
do_level:
	lda	#20
	sta	DEBOUNCE_COUNTDOWN

level_frame:

	sta	WSYNC


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

	ldx	#27
le_vblank_loop:
	sta	WSYNC
	dex
	bne	le_vblank_loop

	;=============================
	; now at VBLANK scanline 27
	;=============================
	; 4 scanlines of handling input

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC

	;=======================
	; now scanline 31
	;========================
	; increment frame
	; setup missile0 location
; 6
;	lda	$80				; nop3			; 3
;	ldx	LEVEL_MISSILE0_COARSE					; 3
;	beq	no_missile0						; 2/3
; 14
mlevel_pad:
;	dex								; 2
;	bne	mlevel_pad	; (X*5)-1 = 14				; 2/3

		; 9 = (8*5)-1 = 39 + 14 = 53
		; 10 = (9*5)-1 = 44 + 14 = 58
		; 11 = (10*5)-1 = 49 + 14 =64

; 64 max
;	sta	RESM0							; 3
; 67

; max=73

no_missile0:
	sta	WSYNC							; 3

	;=======================
	; now scanline 32
	;========================
	; increment frame
	; setup missile0 location
; 0
;	ldx	LEVEL_MISSILE0_COARSE					; 3
;	beq	really_no_missile0					; 2/3

;	ldx	#2			; enable missile		; 2
;	stx	ENAM0							; 3

;	lda	LEVEL_MISSILE0_FINE	; fine adjust overlay		; 3
;	sta	HMM0							; 3

really_no_missile0:
	sta	WSYNC							; 3


	;=============================
	; now VBLANK scanline 33
	;=============================
	; do some init

	inc	FRAME							; 5

	ldx	#$00							; 2
	stx	CURRENT_SCANLINE	; reset scanline counter	; 3

	; flip switch if necessary
;	lda	CURRENT_LOCATION
;	cmp	#8
;	bcs	done_flip_switch

;	tax
;	lda	powers_of_two,X
;	and	SWITCH_STATUS
;	beq	switch_off
switch_on:
;	lda	#$A2		; blue
;	sta	level_overlay_colors_write+30
;	lda	#$18		; yellow
;	sta	level_overlay_colors_write+31

;	lda	#$78
;	sta	level_overlay_sprite_write+30
;	lda	#$30
;	sta	level_overlay_sprite_write+31

;	jmp	done_flip_switch		; bra

switch_off:
;	lda	#$18		; yellow
;	sta	level_overlay_colors_write+30
;	lda	#$A2		; blue
;	sta	level_overlay_colors_write+31

;	lda	#$30
;	sta	level_overlay_sprite_write+30
;	lda	#$78
;	sta	level_overlay_sprite_write+31

done_flip_switch:
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
	ldx	#3							; 2
	inx			;					; 2
	inx			;					; 2
; 11
qpad_x:
	dex			;					; 2
	bne	qpad_x		;					; 2/3
				;===========================================


	; beam is at proper place
	sta	RESP1							; 3

	lda	#$D0			; fine adjust overlay		; 2
	sta	HMP1							; 3


	sta	WSYNC

	;======================================
	; now vblank 35
	;=======================================
	; update pointer horizontal position
	;=======================================

	; do this separately as too long to fit in with left/right code

;	jsr	pointer_moved_horizontally	;			6+48
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

;	ldx	#0		; sprite 0 display nothing		; 2
;	stx	GRP0		; (FIXME: this already set?)		; 3

;	ldx	POINTER_X_COARSE	;				; 3
;	inx			;					; 2
;	inx			;					; 2
; 12

pad_x:
;	dex			;					; 2
;	bne	pad_x		;					; 2/3
				;===========================================
				;	12-1+5*(coarse_x+2)
;

	; beam is at proper place
;	sta	RESP0							; 3

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

;	lda	LEVEL_HAND_COLOR	;				; 3
;	sta	COLUP0		; set pointer color (sprite0)		; 3
; 20
;	lda	level_overlay_colors					; 4+
;	sta	COLUP1		; set secret color (sprite1)		; 3
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
;	lda	LEVEL_BACKGROUND_COLOR		;			; 3
	lda	#0
	sta	COLUBK		; set background color			; 3
; 50
	lda	#$FF		; ??					; 2
	sta	GRP1							; 3
; 55
;	lda	level_colors	; load level color in advance		; 4
; 59
	ldx	#0		; init hand visibility			; 2
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

	;============================
	; draw playfield line 0 (1/4)
	;============================
; 0
	lda	lookout_colors,Y					; 4
	sta	COLUPF				; playfield color	; 3
; 7
	lda	lookout_playfield0_left,Y	; playfield pattern 0	; 4
	sta	PF0			;				; 3
	;   has to happen by 22 (GPU 68)
; 14
	lda	lookout_playfield1_left,Y	; playfield pattern 1	; 4
	sta	PF1			;				; 3
	;  has to happen by 28 (GPU 84)
; 21
	lda	lookout_sprite,Y					; 4
	sta	GRP1			; overlay pattern		; 3

	; really want this to happen by 22
	; in practice we try not to be closer than 4 so 28 is fine?
	; we're like one cycle too late
; 28
	lda	lookout_playfield2_left,Y	; playfield pattern 2	; 4
        sta	PF2							; 3
	;  has to happen by 38 (GPU 116)	;

; 35
	lda	lookout_playfield0_right,Y	; left pf pattern 0	; 4
        sta	PF0				;			; 3
	; has to happen 28-49 (GPU 84-148)
; 42
        lda	lookout_playfield1_right,Y	; left pf pattern 1	; 4
        sta	PF1				;			; 3
	; has to happen 38-56 (GPU 116-170)
; 49
        lda	lookout_playfield2_right,Y	; left pf pattern 2	; 4
        sta	PF2				;			; 3
	; has to happen 49-67 (GPU148-202)
; 56


	lda	CURRENT_SCANLINE					; 3
	cmp	GUYBRUSH_Y						; 3
	beq	no_activate_guybrush					; 2/3
	jmp	done_activate_guybrush					; 3
no_activate_guybrush:
	ldx	#$f							; 2
done_activate_guybrush:
								;===========
								; 11 / 11

; 67

	inc	TEMP1		; nop5

; 72

	;============================
	; draw playfield line 1 (2/4)
	;============================
	lda	lookout_playfield0_left,Y	;			; 4
; 76

;	sta	WSYNC

; 0
	sta	PF0			;				; 3
	;   has to happen by 22 (GPU 68)
; 3
	lda	lookout_playfield1_left,Y	;			; 4
        sta	PF1			;				; 3
	;  has to happen by 28 (GPU 84)
; 10
	lda	lookout_playfield2_left,Y	;			; 4
        sta	PF2							; 3
	;  has to happen by 38 (GPU 116)	;
; 17

	;==================
	; draw guybrush
	;==================

	txa								; 2
	beq	level_no_guybrush					; 2/3
	lda	GUYBRUSH_SPRITE,X					; 4
	sta	GRP0							; 3
	dex								; 2
	jmp	level_done_guybrush					; 3
level_no_guybrush:
	inc	TEMP1		; nop5					; 5
	nop								; 2
	nop								; 2
	nop								; 2
level_done_guybrush:
								;===========
								; 16 / 6



; 33
	lda	lookout_playfield0_right,Y	;			; 4+
	sta	PF0				;			; 3
	; has to happen 28-49 (GPU 84-148)
; 40
	lda	lookout_playfield1_right,Y	;			; 4+
	sta	PF1				;			; 3
	; has to happen 39-56 (GPU 116-170)
; 47
	lda	lookout_playfield2_right,Y	;			; 4+
	sta	PF2				;			; 3
	; has to happen 50-67 (GPU148-202)
; 54
;	lda	LEVEL_BACKGROUND_COLOR2		;			; 3
;	sta	COLUBK		; set background color			; 3
; 60
;	inc	CURRENT_SCANLINE					; 5
; 65
;	lda	LEVEL_BACKGROUND_COLOR		;			; 3
; 68
	iny
	lda	lookout_colors,Y					; 4
	sta	WSYNC



	;============================
	; draw playfield line 2 (3/4)
	;============================
; 0
;	lda	$80		; nop3
	sta	COLUPF			; playfield color		; 3
	lda	$80
; 3
	lda	lookout_playfield0_left,Y	;			; 4
	sta	PF0			;				; 3
	;   has to happen by 22 (GPU 68)
; 10
	lda	lookout_playfield1_left,Y	;			; 4
        sta	PF1			;				; 3
	;  has to happen by 28 (GPU 84)
; 17
	lda	lookout_playfield2_left,Y	;			; 4
        sta	PF2							; 3
	;  has to happen by 38 (GPU 116)	;
; 24

	nop								; 2
	nop								; 2

	lda	#$2					; 2
	sta	COLUPF			; playfield color		; 3

;	inc	TEMP1		; nop5					; 5


; 33
	lda	lookout_playfield0_right,Y	;			; 4+
	sta	PF0				;			; 3
	; has to happen 28-49 (GPU 84-148)
; 40
	lda	lookout_playfield1_right,Y	;			; 4+
	sta	PF1				;			; 3
	; has to happen 39-56 (GPU 116-170)
; 47
	lda	lookout_playfield2_right,Y	;			; 4+
	sta	PF2				;			; 3
	; has to happen 50-67 (GPU148-202)
; 54
;	lda	LEVEL_BACKGROUND_COLOR2		;			; 3
;	sta	COLUBK		; set background color			; 3
; 60
	lda	lookout_playfield0_left,Y	;			; 4
	sta	WSYNC




	;=============================
	; draw playfield line 3 (4/4)
	;=============================
; 0
	sta	PF0			;				; 3
; 3
	;   has to happen by 22 (GPU 68)
;	lda	LEVEL_BACKGROUND_COLOR		;			; 3
;	sta	COLUBK		; reset background color		; 3


	lda	lookout_colors,Y					; 4
	sta	COLUPF							; 3

;	nop
;	nop
;	nop
; 9
	lda	lookout_playfield1_left,Y	;			; 4
        sta	PF1			;				; 3
	;  has to happen by 28 (GPU 84)
; 16
	lda	lookout_playfield2_left,Y	;			; 4
        sta	PF2							; 3
	;  has to happen by 38 (GPU 116)	;
; 23

	;==================
	; draw pointer
	;==================
;	txa								; 2
;	beq	level_no_pointer2					; 2/3
;	lda	HAND_SPRITE,X						; 4
;	sta	GRP0							; 3
;	dex								; 2
;	jmp	level_done_pointer2					; 3
level_no_pointer2:
;	inc	TEMP1		; nop5					; 5
;	lda	TEMP1		; nop3					; 3
;	lda	TEMP1		; nop3					; 3
level_done_pointer2:
								;===========
								; 16 / 6

	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop

; 39

	lda	lookout_playfield0_right,Y	;			; 4+
	sta	PF0				;			; 3
	; has to happen 28-49 (GPU 84-148)
; 46
	lda	lookout_playfield1_right,Y	;			; 4+
	sta	PF1				;			; 3
	; has to happen 39-56 (GPU 116-170)
; 53
	lda	lookout_playfield2_right,Y	;			; 4
	sta	PF2				;			; 3
	; has to happen 50-67 (GPU148-202)
; 60
	iny								; 2
	lda	lookout_sprite_colors,Y					; 4
	sta	COLUP1							; 3
;	lda	level_colors,Y						; 4+
; 69
	cpy	#96		; see if hit end			; 2
; 71
	beq	done_playfield						; 2/3
; 73
	jmp	draw_playfield						; 3
; 76


done_playfield:
; 74


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

;	jsr	update_sound

	sta	WSYNC

	;==================================
	; overscan 29, update pointer
;0
;	lda     #POINTER_TYPE_POINT		; set default		; 2
; 2
;	ldx	POINTER_X						; 3
;	ldy	POINTER_Y						; 3
; 8
	; first see if grabbing

;	cpx	LEVEL_GRAB_MINX						; 3
;	bcc	not_grabbing						; 2/3
;	cpx	LEVEL_GRAB_MAXX						; 3
;	bcs	not_grabbing						; 2/3
;	cpy	LEVEL_GRAB_MINY						; 3
;	bcc	not_grabbing						; 2/3
;	cpy	LEVEL_GRAB_MAXY						; 3
;	bcs	not_grabbing						; 2/3
;	lda	#POINTER_TYPE_GRAB					; 3
;	bne	level_done_update_pointer	; bra			; 3
								; 21 worst case
; 29

not_grabbing:

; 29
	;==================================
	; check if want left/right pointer

;	ldy	LEVEL_LEFT_DEST						; 3
;	bmi	level_not_left						; 2/3

	; POINTER_X is in X from way before

;	cpx	#32							; 2
;	bcs	level_not_left						; 2/3
;	lda	#POINTER_TYPE_LEFT					; 2
;	jmp	level_done_update_pointer				; 3
level_not_left:

;	ldy	LEVEL_RIGHT_DEST					; 3
;	bmi	level_done_update_pointer				; 2/3

;	cpx	#128							; 2
;	bcc	level_done_update_pointer				; 2/3
;	lda	#POINTER_TYPE_RIGHT					; 2

level_done_update_pointer:
;	sta	POINTER_TYPE						; 3

        sta     WSYNC

	;==================================
	;==================================
	; overscan 30, handle button press
	;==================================
	;==================================

	lda	DEBOUNCE_COUNTDOWN					; 3
	beq	waited_enough_level					; 2/3
	dec	DEBOUNCE_COUNTDOWN					; 5
	jmp	done_check_level_input					; 3

waited_enough_level:

	lda	INPT4			; check if joystick button pressed
	bmi	done_check_level_input

	; reset input countdown for debounce
	lda	#10
	sta	DEBOUNCE_COUNTDOWN

	; button was pressed
;	lda	POINTER_TYPE
;	cmp	#POINTER_TYPE_POINT
;	beq	clicked_forward

;	cmp	#POINTER_TYPE_LEFT
;	beq	clicked_left

;	cmp	#POINTER_TYPE_RIGHT
;	beq	clicked_right

clicked_grab:			; process of elimination
	;==========================
	; clicked grab
;	ldx	CURRENT_LOCATION
;	cpx	#8			; if level >8 not switch
;	bcc	handle_switch
;	cpx	#11
;	bcs	done_check_level_input	; if level>11 not book

handle_book:

;	jsr	do_book

;	jmp	load_new_level

handle_switch:
;	ldy	#SFX_CLICK		; play sound
;	sty	SFX_PTR

	; toggle switch
;	lda	powers_of_two,X
;	eor	SWITCH_STATUS
;	sta	SWITCH_STATUS

	; TODO: switch to white page if switch from $FF to $7F

done_check_level_input:

	sta	WSYNC

	jmp	level_frame


