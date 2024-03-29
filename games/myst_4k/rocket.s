	;=====================
	; the rocket
	;=====================
do_rocket:
	lda	#30
	sta	INPUT_COUNTDOWN

;	jmp	rocket_frame
;.align	$100
rocket_frame:

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
rocket_vblank_loop:
	sta	WSYNC
	dex
	bne	rocket_vblank_loop


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
	lda	#$0							; 2
	sta	ENAM0	; disable missile 0				; 3
; 16
	sta	WSYNC							; 3


	;=============================
	; now VBLANK scanline 33
	;=============================
	; do some init
	; FIXME: merge with previous?

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

	lda	$80

; 8
	ldx	#6		;					3
qrocketpad_x:
	dex			;					2
	bne	qrocketpad_x	;					2/3
				;===========================================
				;	5*(4+2)-1 = 29


	; beam is at proper place
	sta	RESP1							; 3

	lda	#$00		; fine adjust overlay			; 2
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

rocket_pad_x:
	dex			;					2
	bne	rocket_pad_x	;					2/3
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
; 14

	lda	#$22		; medium brown				; 2
	sta	COLUP0		; set pointer color (sprite0)		; 3
; 19
	lda	rocket_overlay_colors					; 4+
	sta	COLUP1		; set overlay color (sprite1)		; 3
; 26
	lda	#NUSIZ_DOUBLE_SIZE|NUSIZ_MISSILE_WIDTH_8		; 2
	sta	NUSIZ0							; 3
	lda	#NUSIZ_QUAD_SIZE|NUSIZ_MISSILE_WIDTH_4			; 2
	sta	NUSIZ1							; 3
; 36
	ldy	#0		; current block				; 2
	sty	CTRLPF		; no_reflect				; 3
; 41
	lda	#$F4		; sort of a medium brown		; 2
	sta	COLUPF							; 3
; 46
	ldx	#0			; setup X?			; 2
; 48
	stx	VBLANK			; turn on beam			; 3
; 51
	sta	WSYNC							; 3


	;===========================================
	;===========================================
	;===========================================
	; draw playfield, 192 scanlines
	;===========================================
	;===========================================
	;===========================================

rocket_draw_playfield:

	; A has rocket colors

	;======================
	; draw playfield 0/4
	;======================
; 0
	lda	rocket_bg_colors,Y					; 4+
	sta	COLUBK							; 3
	lda	rocket_overlay_sprite,Y					; 4+
	sta	GRP1							; 3
; 14
;	lda	rocket_playfield0_left,Y	;			; -
	lda	#0							; 2
	sta	PF0			;				; 3
	;   has to happen by 22 (GPU 68)
; 19
	lda	rocket_playfield1_left,Y	;			; 4
	sta	PF1			;				; 3
	;  has to happen by 28 (GPU 84)
; 26
	lda	rocket_playfield2_left,Y	;			; 4
        sta	PF2							; 3
	;  has to happen by 38 (GPU 116)	;
; 33
	lda	rocket_playfield0_right,Y	;			; 4
        sta	PF0				;			; 3
	; has to happen 28-49 (GPU 84-148)
; 40
        lda	rocket_playfield1_right,Y	;			; 4
        sta	PF1				;			; 3
	; has to happen 38-56 (GPU 116-170)
; 47
        lda	rocket_playfield2_right,Y	;			; 4
        sta	PF2				;			; 3
	; has to happen 49-67 (GPU148-202)
; 54
	; activate hand sprite if necessary
	lda	#$f							; 2
	ldx	CURRENT_SCANLINE					; 3
	cpx	POINTER_Y						; 3
	bne	no_rocket_activate_hand					; 2/3
	sta	POINTER_ON						; 3
	jmp	done_rocket_activate_hand				; 3
no_rocket_activate_hand:
	inc	TEMP1				; nop5			; 5
done_rocket_activate_hand:
								;===========
								; 16 / 16
; 70

;	lda	rocket_playfield0_left,Y	;			; -
	lda	#0							; 2

; 72

	;===================
	; draw playfield 1/4
	;===================
; -4
	sta	PF0			;				; 3
	;   has to happen by 22 (GPU 68)
; -1
	lda	rocket_playfield1_left,Y	;			; 4
        sta	PF1			;				; 3
	;  has to happen by 28 (GPU 84)
; 6
	lda	rocket_playfield2_left,Y	;			; 4
        sta	PF2							; 3
	;  has to happen by 38 (GPU 116)	;
; 13

	;==================
	; draw pointer
	;==================

	ldx	POINTER_ON						; 3
	beq	rocket_no_pointer					; 2/3
	lda	HAND_SPRITE,X						; 4
	sta	GRP0							; 3
	dec	POINTER_ON						; 5
	jmp	rocket_done_pointer					; 3
rocket_no_pointer:
	inc	TEMP1		; nop5					; 5
	inc	TEMP1		; nop5					; 5
	nop			;					; 2
	nop								; 2
rocket_done_pointer:
								;===========
								; 20 / 6

; 33
	lda	rocket_playfield0_right,Y	;			; 4+
	sta	PF0				;			; 3
	; has to happen 28-49 (GPU 84-148)
; 40
	lda	rocket_playfield1_right,Y	;			; 4+
	sta	PF1				;			; 3
	; has to happen 39-56 (GPU 116-170)
; 47
	lda	#0							; 2
	sta	COLUPF							; 3
; 52
	lda	rocket_playfield2_right,Y	;			; 4+
	sta	PF2				;			; 3
	; has to happen 50-67 (GPU148-202)
; 59

	inc	CURRENT_SCANLINE					; 5
; 64
	lda	#$F4							; 2
	sta	COLUPF							; 3
; 69
	sta	WSYNC

	;===================
	; draw playfield 2/4
	;===================
; 0
;	lda	rocket_playfield0_left,Y	;			; -
	lda	#$0							; 2
	sta	PF0			;				; 3
	;   has to happen by 22 (GPU 68)
; 5
	lda	rocket_playfield1_left,Y	;			; 4
        sta	PF1			;				; 3
	;  has to happen by 28 (GPU 84)
; 12
	lda	rocket_playfield2_left,Y	;			; 4
        sta	PF2							; 3
	;  has to happen by 38 (GPU 116)	;
; 19

	inc	TEMP1		; nop5					; 5
	inc	TEMP1		; nop5					; 5
	nop			; 2					; 2
	nop			; 2					; 2

; 33
	lda	rocket_playfield0_right,Y	;			; 4+
	sta	PF0				;			; 3
	; has to happen 28-49 (GPU 84-148)
; 40
	lda	rocket_playfield1_right,Y	;			; 4+
	sta	PF1				;			; 3
	; has to happen 39-56 (GPU 116-170)
; 47
	lda	rocket_playfield2_right,Y	;			; 4+
	sta	PF2				;			; 3
	; has to happen 50-67 (GPU148-202)
; 54
	lda	#0							; 2
	sta	COLUPF							; 3
; 59

	lda	rocket_overlay_colors,Y					; 4
	sta	COLUP1							; 3
	lda	$80		; nop3					; 3
; 69
	lda	#$F4							; 2
	sta	COLUPF							; 3
; 74
	lda	#0		; rocket_playfield0_left,Y		; 2
; 76




	;===================
	; draw playfield 3/4
	;===================
; 0
	sta	PF0			;				; 3
	;   has to happen by 22 (GPU 68)
; 3
	lda	rocket_playfield1_left,Y	;			; 4
        sta	PF1			;				; 3
	;  has to happen by 28 (GPU 84)
; 10
	lda	rocket_playfield2_left,Y	;			; 4
        sta	PF2							; 3
	;  has to happen by 38 (GPU 116)	;
; 17

	;==================
	; draw pointer
	;==================
	ldx	POINTER_ON						; 3
	beq	rocket_no_pointer2					; 2/3
	lda	HAND_SPRITE,X						; 4
	sta	GRP0							; 3
	dec	POINTER_ON						; 5
	jmp	rocket_done_pointer2					; 3
rocket_no_pointer2:
	inc	TEMP1		; nop5					; 5
	inc	TEMP1		; nop5					; 5
	nop			;					; 2
	nop								; 2
rocket_done_pointer2:
								;===========
								; 20 / 6

; 37
	lda	rocket_playfield0_right,Y	;			; 4+
	sta	PF0				;			; 3
	; has to happen 28-49 (GPU 84-148)
; 44
	lda	rocket_playfield1_right,Y	;			; 4+
	sta	PF1				;			; 3
	; has to happen 39-56 (GPU 116-170)
; 51
	lda	rocket_playfield2_right,Y	;			; 4+
	sta	PF2				;			; 3
	; has to happen 50-67 (GPU148-202)
; 58

	; only increment blocks once we hit
	; this saves some bytes

	lda	CURRENT_SCANLINE					; 3
	cmp	#13							; 2
	bcs	doinc_y							; 2/3
	.byte	$A5		; LDA zp				; 3
doinc_y:
	iny			; $C8					; 2
								;===========
								; 10 / 10


; 68
	cpy	#36		; (Was 48) see if hit end		; 2
; 70
	beq	done_rocket_playfield					; 2/3
; 72
	jmp	rocket_draw_playfield					; 2/3


done_rocket_playfield:



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
	; overscan 29, update_pointer

	lda     #POINTER_TYPE_POINT					; 2

	ldy	POINTER_Y
	cpy	#17
	bcc	rocket_check_side
	cpy	#25
	bcs	rocket_check_side
	ldy	POINTER_X
	cpy	#72 ; $46
	bcc	rocket_check_side
	cpy	#91 ; $5B
	bcs	rocket_check_side

	lda	#POINTER_TYPE_GRAB
	jmp	rocket_done_update_pointer
rocket_check_side:
	ldy	POINTER_X						; 3
	cpy	#32
	bcs	rocket_not_left
	lda	#POINTER_TYPE_LEFT
	jmp	rocket_done_update_pointer
rocket_not_left:
	cpy	#128
	bcc	rocket_done_update_pointer
	lda	#POINTER_TYPE_RIGHT
rocket_done_update_pointer:
	sta	POINTER_TYPE
        sta     WSYNC

	;==================================
	; overscan 30, see if end of level

	lda     INPUT_COUNTDOWN						; 3
	beq     waited_enough_rocket					; 2/3
	dec     INPUT_COUNTDOWN						; 5
	jmp	done_check_rocket_input					; 3

waited_enough_rocket:

	lda     INPT4                   ; check if joystick button pressed
	bmi	done_check_rocket_input

	; button was pressed

	lda	POINTER_TYPE
	cmp	#POINTER_TYPE_GRAB
	bne	rocket_not_grabbing

rocket_was_grabbing:
	ldy	#SFX_CLICK
	sty	SFX_PTR
	jmp	done_check_rocket_input


rocket_not_grabbing:
	cmp	#POINTER_TYPE_POINT
	beq	done_rocket		; done level


rocket_not_walking:
done_check_rocket_input:
	sta	WSYNC

	jmp	rocket_frame

done_rocket:
