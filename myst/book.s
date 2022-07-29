	;=====================
	; Linking Book
	;=====================

	jmp	book_frame
.align	$100
book_frame:

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
book_vblank_loop:
	sta	WSYNC
	dex
	bne	book_vblank_loop


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
	ldx	#3							; 2
; 13
bzpad_x:
	dex			;					; 2
	bne	bzpad_x		; (X*5)-1, X=3=14			; 2/3


; 27
	sta	RESM1		; adjust missile location for		; 3
				; left edge of book

; 30
	inc	TEMP1							; 5
	inc	TEMP1							; 5
	nop								; 2
	nop								; 2
; 44
	sta	RESM0		; adjust missile0 location		; 3
				; for spine of book
; 47
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
	lda	FRAME
	and	#$20
	lsr
	lsr
	lsr
	lsr
	adc	#$A0
	sta	ROOT_LINK_COLOR

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
zpad_x:
	dex			;					2
	bne	zpad_x		;					2/3
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

zzpad_x:
	dex			;					2
	bne	zzpad_x		;					2/3
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
pbook_x:
	dex			;					2
	bne	pbook_x		; (6*5)-1 = 29				2/3
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




	jmp	book_draw_playfield_plus_3				; 3

book_draw_playfield:



	;================================
	;================================
	; draw playfield EVEN
	;================================
	;================================
	; playfield scanlines 8 .. ?

book_draw_playfield_even:

; 3
book_draw_playfield_plus_3:

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
	bne	no_activate_hand					; 2/3
	sta	POINTER_ON						; 3
	jmp	done_activate_hand					; 3
no_activate_hand:
	inc	TEMP1			; nop5				; 5
done_activate_hand:
								;===========
								; 16 / 16

; 38
	lda	LINK_COLOR	; off white				; 3
	sta	COLUP1		; set page color (sprite1)		; 3
; 44

	lda	#$F8		; change color to tan			; 2
	sta	COLUPF		; store playfield color			; 3
	; want this to happen around 49..50
; 49

	;=============================
	; update the link book window
	;=============================

	lda	#$0C				; off white		; 2
	cpy	#14							; 2
	bcc	done_link_animation					; 2/3
	cpy	#20							; 2
	bcs	done_link_animation					; 2/3

	lda	ROOT_LINK_COLOR						; 3
done_link_animation:
	sta	LINK_COLOR						; 3

								;===========
								; 16 worst
; 65
	inc	CURRENT_SCANLINE					; 5
; 70

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
	beq	no_pointer						; 2/3
	lda	HAND_SPRITE,X						; 4
	sta	GRP0							; 3
	dec	POINTER_ON						; 5
	jmp	done_pointer						; 3
no_pointer:
	inc	TEMP1		; nop5					; 5
	inc	TEMP1		; nop5					; 5
	nop			;					; 2
	nop								; 2

done_pointer:
								;===========
								; 20 / 6
; 32
	inc	TEMP1	; nop5						; 5
	nop								; 2
; 39
	lda	LINK_COLOR	; off white				; 3
	sta	COLUP1		; set page color (sprite1)		; 3
; 45

	lda	#$F8		; change color to tan			; 2
	sta	COLUPF		; store playfield color			; 3
	; want this to happen around 49..50
; 50

	lda	CURRENT_SCANLINE					; 3
	and	#$1							; 2
	beq	yes_inc4						; 2/3
	.byte	$A5     ; begin of LDA ZP				; 3
yes_inc4:
	iny             ; $E8 should be harmless to load		; 2
done_inc_block:
                                                                ;===========
                                                                ; 10/10

; 60
	cpy	#44		; see if hit end			; 2
; 62
	sta	WSYNC
; 0
	bne	book_draw_playfield					; 2/3


book_done_playfield:


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

	ldx	#24
	jsr	common_overscan

	;==================================
	; overscan 26, trigger sound

;	ldy	SOUND_TO_PLAY
;	beq	no_sound_to_play

;	jsr	trigger_sound		; 6+40

;	ldy	#0
;	sty	SOUND_TO_PLAY
;no_sound_to_play:
	sta	WSYNC

	;==================================
	; overscan 27+28, update sound

;	jsr	update_sound

	sta	WSYNC
	sta	WSYNC

	;==================================
	; overscan 29, collision detection

	lda	#POINTER_TYPE_POINT					; 2
	sta	POINTER_TYPE						; 3

	lda	POINTER_X						; 3
	cmp	#88
	bcc	not_in_window
	cmp	#128
	bcs	not_in_window
	lda	POINTER_Y
	cmp	#35
	bcs	not_in_window
	cmp	#8
	bcc	not_in_window
	lda	#POINTER_TYPE_GRAB
	sta	POINTER_TYPE
not_in_window:
	sta	WSYNC

	;==================================
	; overscan 30, see if at end

	lda	INPT4			; check if joystick button pressed
	bpl	book_clicked

book_keep_going:
	sta	WSYNC
	jmp	book_frame

book_clicked:
	lda	POINTER_TYPE
	cmp	#POINTER_TYPE_GRAB
	bne	book_keep_going

; otherwise, exit...

	; start linking noise
	ldy	#SFX_LINK
	sty	SFX_PTR



