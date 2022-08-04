	;=====================
	; Arrival Location
	;=====================

	lda	#30
	sta	INPUT_COUNTDOWN

;	jmp	arrival_frame
;.align	$100
arrival_frame:

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
arrival_vblank_loop:
	sta	WSYNC
	dex
	bne	arrival_vblank_loop


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

	sta	WSYNC							; 3


	;=============================
	; now VBLANK scanline 33
	;=============================
	; do some init
; 0
	ldx	#$00							; 2
	stx	COLUBK			; set background color to black	; 3
	stx	CURRENT_SCANLINE	; reset scanline counter	; 3
; 8
	inc	TEMP1
	inc	TEMP1
	inc	TEMP1
	inc	TEMP1
	nop
	nop
	nop

; 30
	sta	RESM0

	sta	WSYNC

	;======================
	; now VBLANK scanline 34
	;======================

	;==========================================
	; set up sprite1 to be at proper X position
	;==========================================

; 0
	ldx	#0		; sprite 0 display nothing		2
	stx	GRP1		; (FIXME: this already set?)		3
; 5
	ldx	#7		;					3
; 8
zarrivalpad_x:
	dex			;					2
	bne	zarrivalpad_x	;					2/3
				;===========================================
				;	(5*5)-1 = 24


; 32
	; beam is at proper place
	sta	RESP1							; 3

; 35
	lda	#$60		; fine tune sprite1 (book page)		; 2
	sta	HMP1							; 3
; 40
	lda	#$F0							; 2
	sta	HMM0							; 3
; 45
;	sta	RESM0

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
	ldx	#0		; sprite 0 display nothing		2
	stx	GRP0		; (FIXME: this already set?)		3
; 5
	ldx	POINTER_X_COARSE	;				3
	inx			;					2
	inx			;					2
; 12

zzarrivalpad_x:
	dex			;					2
	bne	zzarrivalpad_x		;					2/3
				;===========================================
				;	5*(coarse_x+2)-1
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
	lda	#$0							; 2
	sta	PF0			; disable playfield		; 3
	sta	PF1							; 3
	sta	PF2							; 3
; 14

	; setup hand sprite

	lda	#$24		; middle orange				; 2
	sta	COLUP0		; set hand color (sprite0)		; 3
; 19
	lda	#NUSIZ_DOUBLE_SIZE|NUSIZ_MISSILE_WIDTH_2		; 2
	sta	NUSIZ0							; 3
	lda	#NUSIZ_QUAD_SIZE|NUSIZ_MISSILE_WIDTH_4			; 2
	sta	NUSIZ1							; 3
; 29
	ldy	#0		; Y=current block (scanline/4)		; 2
; 31

	lda	#0							; 2
	sta	POINTER_ON						; 3
; 36
	lda	#CTRLPF_REF		; reflect playfield		; 2
	sta	CTRLPF							; 3
; 41
	lda	#$0E
	sta	COLUPF

	lda	#$00		; fine tune sprite1 (overlay)		; 2
	sta	HMP1							; 3
	sta	HMP0

	lda	#0			; bg color			; 2
	sta	COLUBK							; 3
	sta	ENAM0			; turn off missile		; 3
	sta	VBLANK			; turn on beam			; 3
; 49

	sta	WSYNC							; 3

	;===========================================
	;===========================================
	;===========================================
	; draw playfield, 192 scanlines
	;===========================================
	;===========================================
	;===========================================


	jmp	arrival_draw_playfield					; 3

arrival_draw_playfield:

	;================================
	;================================
	; draw playfield EVEN
	;================================
	;================================
	; playfield scanlines 8 .. ?

arrival_draw_playfield_even:

; 3
	lda	#$0		; reset	bg color			; 2
	sta	COLUBK							; 3
; 8
	lda	#$0E		; reset sky color (lgrey)		; 2
	cpy	#24							; 2
	bcc	draw_sky_d4						; 2/3
	lda	#$F2		; low color (brown)			; 2
	jmp	draw_sky						; 3
draw_sky_d4:
	nop								; 2
	nop								; 2
draw_sky:
	sta	COLUPF							; 3
								;==========
								; 14 / 10

; 22
	lda	arrival_playfield1_left,Y				; 4+
	sta	PF1							; 3
; 29
	lda	arrival_playfield2_left,Y				; 4+
	sta	PF2							; 3
; 36


	;==============================
	; update sprite1

	lda	arrival_overlay,Y		; load sprite1 data	; 4+
	sta	GRP1		;					; 3

; 43
	lda	arrival_overlay_colors,Y				; 4+
	sta	COLUP1		; set page color (sprite1)		; 3

; 50
	lda	#$0E							; 2
; 52
	; activate hand sprite if necessary

	ldx	CURRENT_SCANLINE					; 3
; 55
	sta	COLUBK							; 3
; 58
	lda	#$f							; 2
	cpx	POINTER_Y						; 3
	bne	no_arrival_activate_hand				; 2/3
	sta	POINTER_ON						; 3
	jmp	done_arrival_activate_hand				; 3
no_arrival_activate_hand:
	inc	TEMP1			; nop5				; 5
done_arrival_activate_hand:
								;===========
								; 16 / 16


; 71
	sta	WSYNC
	sta	HMOVE

	;====================
	;====================
	; draw playfield ODD
	;====================
	;====================
; 3
	lda	#$0		; reset	bg color			; 2
	sta	COLUBK							; 3
; 8

	;==================
	; draw pointer
	;==================

	ldx	POINTER_ON						; 3
	beq	no_arrival_pointer					; 2/3
	lda	HAND_SPRITE,X						; 4
	sta	GRP0							; 3
	dec	POINTER_ON						; 5
	jmp	done_arrival_pointer					; 3
no_arrival_pointer:
	inc	TEMP1		; nop5					; 5
	inc	TEMP1		; nop5					; 5
	nop			;					; 2
	nop								; 2

done_arrival_pointer:
								;===========
								; 20 / 6
; 28
	inc	CURRENT_SCANLINE					; 5

; 33
	lda	#$00
	cpy	#28
	bcc	mast_delay4
	lda	#$02
	jmp	done_mast
mast_delay4:
	nop
	nop
done_mast:
	sta	ENAM0
								; 14 / 14
; 47
	; get rid of right reflection/ocean

	lda	#$0E							; 2
	cpy	#24							; 2
	bcc	not_ocean_delay4					; 2/3
	lda	#$C8	; sea green					; 2
	jmp	done_ocean						; 3
not_ocean_delay4:
	nop								; 2
	nop								; 2
done_ocean:
	sta	COLUBK							; 3
								;===========
								; 14 / 14

; 61
	lda	CURRENT_SCANLINE					; 3
	and	#$1							; 2
	beq	arrival_yes_inc4					; 2/3
	.byte	$A5     ; begin of LDA ZP				; 3
arrival_yes_inc4:
	iny             ; $E8 should be harmless to load		; 2
done_arrival_inc_block:
                                                                ;===========
                                                                ; 10/10

; 71
	cpy	#48		; see if hit end			; 2
; 73
	beq	arrival_done_playfield					; 2/3
; 75
	jmp	arrival_draw_playfield					; 3

arrival_done_playfield:


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
	; overscan 29, collision detection

	lda	#POINTER_TYPE_POINT					; 2

	ldy	POINTER_X						; 3
	cpy	#80
	bcc	arrival_not_in_window
	cpy	#88
	bcs	arrival_not_in_window
	ldy	POINTER_Y
	cpy	#53
	bcs	arrival_not_in_window
	cpy	#42
	bcc	arrival_not_in_window
	lda	#POINTER_TYPE_GRAB

arrival_not_in_window:
arrival_check_side:
	ldy	POINTER_X                                               ; 3
	cpy	#32
	bcs	arrival_not_left
	lda	#POINTER_TYPE_LEFT
	jmp	arrival_done_update_pointer
arrival_not_left:
	cpy	#128
	bcc	arrival_done_update_pointer
	lda	#POINTER_TYPE_RIGHT
arrival_done_update_pointer:
	sta	POINTER_TYPE

	sta	WSYNC

	;==================================
	; overscan 30, see if at end

	lda	INPUT_COUNTDOWN
	beq	waited_enough_arrival
	dec	INPUT_COUNTDOWN
	jmp	done_check_arrival_input

waited_enough_arrival:

	lda	INPT4			; check if joystick button pressed
	bmi	done_check_arrival_input

	; button was pressed

	lda	POINTER_TYPE
	cmp	#POINTER_TYPE_GRAB
	bne	arrival_not_grabbing
arrival_was_grabbing:
	ldy	#SFX_CLICK
	sty	SFX_PTR
	jmp	done_check_arrival_input

arrival_not_grabbing:
	cmp	#POINTER_TYPE_POINT
	beq	done_arrival

arrival_keep_going:

done_check_arrival_input:
	sta	WSYNC
	jmp	arrival_frame

done_arrival:

; move on to rocket
