	;===========================
	; draw the videlectrix title
	;===========================
	; ideally called with VBLANK disabled

	lda	#144
	sta	RUNNER_X

level_frame:


	;============================
	; Start Vertical Blank
	;============================
	; actually takes 4 scanlines, clears out current then three more

	jsr	common_vblank

; 9

	;=================================
	;=================================
	; 37 lines of vertical blank
	;=================================
	;=================================

	ldx	#23
	jsr	common_delay_scanlines


	;==============================
	; now VBLANK scanline 24+25
	;==============================

	; position ball, takes 2 scanlines
	; FIXME: not currently using this

	lda	#100			; position		; 3
        ldx     #4			; 4=ball		; 2
					; must call with less than 16 cycles
        jsr     set_pos_x               ; 1 scanline + most of another
	sta	WSYNC

	;==============================
	; now VBLANK scanline 26
	;==============================
	; move snake

	; snake bounds are 28 ... 116

	lda	SNAKE_SPEED
	bne	snake_speed_go
	; if zero, ??
	inc	SNAKE_SPEED

snake_speed_go:
	clc
	lda	SNAKE_X
	adc	SNAKE_SPEED
	sta	SNAKE_X

	; see if out of bounds
	cmp	#116
	bcc	snake_ok_left

	lda	#$ff
	sta	SNAKE_SPEED

snake_ok_left:
	cmp	#28
	bcs	snake_ok_right

	lda	#$1
	sta	SNAKE_SPEED

snake_ok_right:


	sta	WSYNC

	;==============================
	; now VBLANK scanline 27
	;==============================
	; set up sprites
; 0
	; set up sprites

	ldx	RUNNER_STATE					; 3
; 3
.if 0
	lda	lboxer_sprites_l,X				; 4+
	sta	BOXER_PTR_L					; 3
	lda	rboxer_sprites_l,X				; 4+
	sta	BOXER_PTR_R					; 3
	lda	lboxer_colors_l,X				; 4+
	sta	BOXER_COL_L					; 3
	lda	rboxer_colors_l,X				; 4+
	sta	BOXER_COL_R					; 3
; 31

	; all in same page
	lda	#>boxer_data					; 2
	sta	BOXER_PTR_LH					; 3
	sta	BOXER_PTR_RH					; 3
	sta	BOXER_COL_LH					; 3
	sta	BOXER_COL_RH					; 3

; 45
	ldx	SNAKE_STATE					; 3
; 48
	lda	snake_sprites_l,X				; 4+
	sta	SNAKE_PTR					; 3
	lda	snake_sprites_h,X				; 4+
	sta	SNAKE_PTR_H					; 3
; 62
.endif
	sta	WSYNC

	;==============================
	; now VBLANK scanline 28
	;==============================
	; setting up KO score takes 6 scanlines

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC

	;==============================
	; now VBLANK scanline 34+35
	;==============================

	; position sidebar (missile1)

	lda	#150			; position		; 3
        ldx     #3			; 3=missile1		; 2
					; must be <20 when calling
        jsr     set_pos_x               ; almost 2 scanlines

	; NOTE! This close to edge the rts does kick it just barely
	; into the next scanline

;        sta     WSYNC

	;==============================
	; now VBLANK scanline 36
	;==============================

	; setup playfield

	lda	#$FF		; boxing ring playfield entirely on	; 2
	sta	PF1							; 3
	sta	PF2							; 3

;	sta	ENABL		; enable ball				; 3

	lda	#0							; 2
	sta	PF0		; sides of screen entirely off		; 3
	sta	COLUPF		; set playfield color to black?		; 3

	sta	GRP0		; turn off sprite0			; 3
	sta	GRP1		; turn off sprite1			; 3

	sta	COLUBK		; set playfiel background to black	; 3

	lda	#CTRLPF_REF|CTRLPF_BALL_SIZE8				; 2
				; playfield reflected with big ball
	sta	CTRLPF                                                  ; 3

	sta	VBLANK		; enable beam				; 3

	jmp	score_align

.align	$100

score_align:

	sta	WSYNC

	;==============================
	; now VBLANK scanline 37
	;==============================

	;===============================
	;===============================
	;===============================
	; visible area: 192 lines (NTSC)
	;===============================
	;===============================
	;===============================


	;===============================
	; 12 lines of score	(0..11)
	;===============================

; scanline 13

	;====================================
	; position boxer right sprite (well in advance)

	lda	RUNNER_X		; position			; 3
	clc				; it's 16 pixels to right	; 2
	adc	#16							; 2
	ldx	#1			; positioning SPRITE1		; 2

					; must be called <20
	jsr	set_pos_x		; bit less than 2 scanlines

	sta	WSYNC
; scanline 14

; scanline 15
	sta	WSYNC
; scanline 16


	;=========================================
	; 4 lines to set up boxer (?) check that
	;=========================================
	; ideally 96 ... 99

; scanline 96

	lda	#$0		; turn off sprites			; 2
;	sta	ENAM1
	sta	GRP0							; 3
	sta	GRP1							; 3

;	lda	#(39*2)		; pink color

	lda	#(32*2)		; red color				; 2
	sta	COLUP0							; 3
	sta	COLUP1							; 3

	jmp	align2

.align $100

align2:

	sta	WSYNC
; scanline 97

	;====================================
	; position boxer left sprite

	lda	#0							; 2
	sta	HMCLR			; clear horizontal move		; 3

	lda	BOXER_X			; position			; 3
	ldx	#0			; 0=sprite1			; 2
	jsr	set_pos_x		; almost 2 scanlins	; needs <20

; scanline 98

	sta	WSYNC
; scanline 99
	sta	HMOVE						; 3

	; unused?

	ldy	#12							; 2
	ldx	#100							; 2

	sta	WSYNC
; scanline 100

	;===============================
	; 18 lines of runner (100..151)
	;===============================
	; boxer each pixel is 4 high

	; at entry already at 4 cycles

runner_loop:
.if 0
;	ldy	BOXER_PTR_L
;	lda	boxer_data,Y
;	sta	GRP0
;	ldy	BOXER_PTR_R
;	lda	boxer_data,Y
;	sta	GRP1
;	ldy	BOXER_COL_L
;	lda	boxer_data,Y
;	sta	COLUP0
;	ldy	BOXER_COL_R
;	lda	boxer_data,Y
;	sta	COLUP1

	lda	(BOXER_PTR_L),Y		; load left sprite data		; 5+
	sta	GRP0			; set left sprite		; 3
	lda	(BOXER_PTR_R),Y		; load right sprite data	; 5+
	sta	GRP1			; set right sprite		; 3

	lda	(BOXER_COL_L),Y		; load left color data		; 5+
	sta	COLUP0			; set left color		; 3
	lda	(BOXER_COL_R),Y		; load right color data		; 5+
	sta	COLUP1			; set right color		; 3



;	cpx	#116							; 2
;	bne	same_color						; 2/3

;	lda	#(39*2)		; pink color
;	sta	COLUP0
;	sta	COLUP1
;same_color:
;	tya
;	beq	level_no_boxer
	dey
;level_no_boxer:

	inx
	sta	WSYNC
;	inc	BOXER_PTR_L
;	inc	BOXER_PTR_R
;	inc	BOXER_COL_L
;	inc	BOXER_COL_R

	inx
	sta	WSYNC
	inx
.endif
	sta	WSYNC

	inx
	cpx	#152
	sta	WSYNC
	bne	runner_loop



	;==================
	;==================
	; 118-192 delay
	;==================
	;==================

	ldx	#74
	jsr	common_delay_scanlines


	;==================================
	;==================================
	;==================================
	; overscan 30, handle end
	;==================================
	;==================================
	;==================================
	;==================================

	ldx	#26
	jsr	common_overscan

	;=============================
	; now at VBLANK scanline 27
	;=============================
	; handle down being pressed
; 0

after_check_down:
	sta	WSYNC


	;=============================
	; now at VBLANK scanline 28
	;=============================
	; handle button being pressed
; 0
	; debounce
	lda	BUTTON_COUNTDOWN					; 3
	beq	waited_button_enough					; 2/3
	dec	BUTTON_COUNTDOWN					; 5
	jmp	done_check_button					; 3

waited_button_enough:

	lda	INPT4		; check joystick button pressed         ; 3
	bmi	done_check_button					; 2/3


done_check_button:
	sta	WSYNC

	;=============================
	; now at VBLANK scanline 29
	;=============================
	; handle left being pressed
; 0
after_check_left:
	sta	WSYNC


	;==================================
	; overscan 30, handle end
	;==================================
	; handle right being pressed

after_check_right:

	jmp	level_frame

.include "position.s"
