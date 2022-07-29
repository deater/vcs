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
	ldx	#6		;					3
	inx			;					2
	inx			;					2
; 12
zarrivalpad_x:
	dex			;					2
	bne	zarrivalpad_x		;					2/3
				;===========================================
				;	5*(6+2)-1 = 39
				; FIXME: describe better what's going on

; 51
	; beam is at proper place
	sta	RESP1							; 3
; 54
	lda	#$60		; fine tune missile1 (book edge)	; 2
	sta	HMM1							; 3
; 59
	lda	#$40		; fine tune sprite1 (book page)		; 2
	sta	HMP1							; 3
; 64
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
	lda	#$0C		; off white				; 2
	sta	COLUP1		; set page color (sprite1)		; 3
; 24
	lda	#NUSIZ_DOUBLE_SIZE|NUSIZ_MISSILE_WIDTH_8		; 2
	sta	NUSIZ0							; 3
	lda	#NUSIZ_QUAD_SIZE|NUSIZ_MISSILE_WIDTH_4			; 2
	sta	NUSIZ1							; 3
; 34
	ldy	#0		; Y=current block (scanline/4)		; 2
; 36

	lda	#0							; 2
	sta	VBLANK			; turn on beam			; 3
	sta	POINTER_ON						; 3
; 44
	lda	#CTRLPF_REF		; reflect playfield		; 2
	sta	CTRLPF							; 3
; 49

	lda	#0			; bg color			; 2
	sta	COLUBK							; 3
; 54
	sta	WSYNC							; 3

	;===========================================
	;===========================================
	;===========================================
	; draw playfield, 192 scanlines
	;===========================================
	;===========================================
	;===========================================

	;==========================
	; draw top eight lines

	;==========================
	; black line (4 lines)
	;==========================

	; in playfield scanline 0
	lda	#$00		; black					; 2
	sta	COLUPF							; 3
	sta	WSYNC

	; in playfield scanline 1

	sta	WSYNC

	; in playfield scanline 2

	sta	WSYNC

	; in playfield scanline 3

	sta	WSYNC

	;==========================
	; grey line (4 lines)
	;==========================

	; in playfield scanline 4
; 0
	lda	#$04		; dark grey				; 2
	sta	COLUPF							; 3
	lda	#$7F		; overhanging page			; 2
	sta	PF1							; 3
	lda	#$FF							; 2
	sta	PF2							; 3
; 15
	sta	WSYNC

	; in playfield scanline 5

	sta	WSYNC

	; in playfield scanline 6

	sta	WSYNC

	; in playfield scanline 7
; 0
	; delay things a bit so we enable towards the end of the scanline
	ldx	#6
; 2
parrival_x:
	dex			;					2
	bne	parrival_x		; (6*5)-1 = 29				2/3
; 31
	lda	#$2							; 2
	sta	ENAM0	; enable missile 0				; 3
	sta	ENAM1	; enable missile 1				; 3
; 39
	lda	#$3F		; Set playfield				; 2
	sta	PF1							; 3
	lda	#$FF							; 2
        sta	PF2							; 3
; 49
	sta	WSYNC




	jmp	arrival_draw_playfield_plus_3				; 3

arrival_draw_playfield:



	;================================
	;================================
	; draw playfield EVEN
	;================================
	;================================
	; playfield scanlines 8 .. ?

arrival_draw_playfield_even:

; 3
arrival_draw_playfield_plus_3:

	lda	#$0E		; reset book color (lgrey)		; 2
	sta	COLUPF		; store playfield color			; 3
; 8
	lda	book_edge_colors,Y					; 4
	sta	COLUP1		; set edge colors (missile1)		; 3
; 15

;	lda	$80		; nop3					; 3
; 15


	;==============================
	; update sprite1

	lda	page_sprite,Y		; load sprite1 data		4+
	sta	GRP1		;					3
; 22

	; activate hand sprite if necessary
	lda	#$f							; 2
	ldx	CURRENT_SCANLINE					; 3
	cpx	POINTER_Y						; 3
	bne	no_arrival_activate_hand					; 2/3
	sta	POINTER_ON						; 3
	jmp	done_arrival_activate_hand					; 3
no_arrival_activate_hand:
	inc	TEMP1			; nop5				; 5
done_arrival_activate_hand:
								;===========
								; 16 / 16

; 38
	lda	#$0C		; off white				; 2
	sta	COLUP1		; set page color (sprite1)		; 3
; 43

	nop
	lda	#$F8		; change color to tan			; 2
	sta	COLUPF		; store playfield color			; 3
	; want this to happen around 49..50
; 50

	inc	CURRENT_SCANLINE					; 5
; 55

	sta	WSYNC

	;====================
	;====================
	; draw playfield ODD
	;====================
	;====================
; 0
	lda	#$0E		; reset book color (lgrey)		; 2
	sta	COLUPF		; store playfield color			; 3
; 5
	lda	book_edge_colors,Y					; 4
	sta	COLUP1							; 3

; 12

	;==================
	; draw pointer
	;==================

	ldx	POINTER_ON						; 3
	beq	no_arrival_pointer						; 2/3
	lda	HAND_SPRITE,X						; 4
	sta	GRP0							; 3
	dec	POINTER_ON						; 5
	jmp	done_arrival_pointer						; 3
no_arrival_pointer:
	inc	TEMP1		; nop5					; 5
	inc	TEMP1		; nop5					; 5
	nop			;					; 2
	nop								; 2

done_arrival_pointer:
								;===========
								; 20 / 6
; 32
	inc	TEMP1	; nop5						; 5
	lda	$80	; nop3						; 3
; 40
	lda	#$0C		; off white				; 2
	sta	COLUP1		; set page color (sprite1)		; 3
; 45

	lda	#$F8		; change color to tan			; 2
	sta	COLUPF		; store playfield color			; 3
	; want this to happen around 49..50
; 50

	lda	CURRENT_SCANLINE					; 3
	and	#$1							; 2
	beq	arrival_yes_inc4						; 2/3
	.byte	$A5     ; begin of LDA ZP				; 3
arrival_yes_inc4:
	iny             ; $E8 should be harmless to load		; 2
done_arrival_inc_block:
                                                                ;===========
                                                                ; 10/10

; 60
	cpy	#44		; see if hit end			; 2
; 62
	sta	WSYNC
; 0
	bne	arrival_draw_playfield					; 2/3


arrival_done_playfield:


; 2

	;==========================
	; bottom grey line

	lda	#$04		; dark grey				; 2
	sta	COLUPF							; 3
	lda	#$7F		; overhanging page			; 2
	sta	PF1							; 3
; 12

	lda	#$0							; 2
	sta	ENAM0	; disable missile 0				; 3
	sta	ENAM1	; disable missile 1				; 3
	sta	GRP1							; 3
; 23
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC


	;==========================
	; black line
; 0
	lda	#$00		;					; 2
	sta	PF0		; turn off playfield			; 3
	sta	PF1							; 3
	sta	PF2							; 3
	sta	COLUPF		; color black				; 3
; 14
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC


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

;	ldy	POINTER_X						; 3
;	cpy	#88
;	bcc	arrival_not_in_window
;	cpy	#128
;	bcs	arrival_not_in_window
;	ldy	POINTER_Y
;	cpy	#35
;	bcs	arrival_not_in_window
;	cpy	#8
;	bcc	arrival_not_in_window
;	lda	#POINTER_TYPE_GRAB

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
	cmp	#POINTER_TYPE_POINT
	beq	done_arrival

arrival_keep_going:

done_check_arrival_input:
	sta	WSYNC
	jmp	arrival_frame


done_arrival:

; move on to rocket
