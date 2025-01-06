	;===========================
	; do some Snake Boxing!
	;===========================
	; ideally called with VBLANK disabled


	lda	#20
	sta	SNAKE_HEALTH
	sta	BOXER_HEALTH

	sta	BUTTON_COUNTDOWN	; for now, avoid immediate button
					; press leftover from title

	lda	#64			; roughly center on screen
	sta	BOXER_X
	lda	#100
	sta	SNAKE_X

	lda	#3
	sta	MANS

level_frame:

	; comes in with 3 cycles from loop


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

	lda	#100			; position		; 3
        ldx     #4			; 4=ball		; 2
        jsr     set_pos_x               ; 2 scanlines           ; 6+56
;	sta	WSYNC
;ball_pos1:
;	dey
;	bpl	ball_pos1
;	sta	RESBL
;	sta	WSYNC



	;==============================
	; now VBLANK scanline 26
	;==============================
	; move snake

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
	cmp	#120
	bcc	snake_ok_left

	lda	#$ff
	sta	SNAKE_SPEED

snake_ok_left:
	cmp	#32
	bcs	snake_ok_right

	lda	#$1
	sta	SNAKE_SPEED

snake_ok_right:


	sta	WSYNC

	;==============================
	; now VBLANK scanline 27
	;==============================
	; set up sprites

	ldx	BOXER_STATE

	lda	lboxer_sprites_l,X
	sta	BOXER_PTR_L
	lda	lboxer_sprites_h,X
	sta	BOXER_PTR_L_H

	lda	rboxer_sprites_l,X
	sta	BOXER_PTR_R
	lda	rboxer_sprites_h,X
	sta	BOXER_PTR_R_H

	ldx	SNAKE_STATE

	lda	snake_sprites_l,X
	sta	SNAKE_PTR
	lda	snake_sprites_h,X
	sta	SNAKE_PTR_H





	;==============================
	; now VBLANK scanline 28
	;==============================
	; setting up KO score takes 6 scanlines

.include "update_score.s"

	;==============================
	; now VBLANK scanline 34+35
	;==============================

	; position sidebar (missile1)

	lda	#148			; position		; 3
        ldx     #3			; 3=missile1		; 2
        jsr     set_pos_x               ; 2 scanlines           ; 6+56
								; must be < 72
        sta     WSYNC
;mis1_pos1:
;	dey
;	bpl	mis1_pos1
;	sta	RESM1
;	sta	WSYNC
;	sta	HMOVE

	;==============================
	; now VBLANK scanline 36
	;==============================

	; setup playfield


	lda	#$FF
	sta	PF1
	sta	PF2

;	sta	ENABL		; enable ball

	lda	#0
	sta	PF0
	sta	COLUPF

	sta	GRP0
	sta	GRP1

	sta	COLUBK

	lda	#CTRLPF_REF|CTRLPF_BALL_SIZE8				; 2
							; reflect playfield
	sta	CTRLPF                                                  ; 3


	sta	VBLANK	; enable beam


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

	; draw_score here is 10 lines

	; need this to not cross page

.include "draw_score.s"

;	lda	#$E
;	sta	COLUPF

;	ldx	#8
;	jsr	common_delay_scanlines


; cycle 75 of scanline 10

	; done with score, set up rest

	lda	#$0
; scanline 11
	sta	COLUPF
	lda	#NUSIZ_DOUBLE_SIZE
	sta	NUSIZ0
	sta	NUSIZ1


	sta	WSYNC


	;===============================
	; 8 lines of rope  (12..19)
	;===============================

; scanline 12

	lda	#$e			; white
	sta	COLUPF

	lda	#$BF			; pattern for ropes
	sta	PF1

	lda	#0			; needed?
	sta	HMCLR			; clear out sprite ajustments

	sta	WSYNC
; scanline 13

	;====================================
	; position boxer right sprite (well in advance)

	lda	BOXER_X			; position		; 3
	clc				; it's 16 pixels to right
	adc	#16
	ldx	#1			; positioning SPRITE1
	jsr	set_pos_x

;	sta	WSYNC
; scanline 13+14

;swait_pos2:				; set position at 5*Y (15*Y TIA)
;	dey				; 2
;	bpl	swait_pos2		; 2/3
;	sta	RESP1			; 3

;	sta	WSYNC
;	sta	HMOVE
; scanline 15
	sta	WSYNC
; scanline 16

	lda	#$40			; other pattern
	sta	PF1
	lda	#$00
	sta	PF2

	;================================
	; position snake

	lda	SNAKE_X			; position		; 3
        ldx     #0			; 0=sprite1		; 2
        jsr     set_pos_x               ; 2 scanlines           ; 6+62
;        sta     WSYNC
; scanline 17+18

;swait_pos3:
;	dey
;	bpl	swait_pos3
;	sta	RESP0

	sta	WSYNC
; scanline 19
	sta	HMOVE


	;================================
	; setup for snake


	lda	#$BF
	sta	PF1
	lda	#$FF
	sta	PF2

	lda	#$6			; medium grey
	sta	COLUPF

	ldx	SNAKE_KOS		; set snake color
	lda	snake_colors,X
	sta	COLUP0

	lda	#0
	sta	VDELP0
	sta	VDELP1
	sta	MAN_BAR

	ldx	MANS
	lda	mans_max_lookup,X
	sta	MAX_MANS

	; turn on missile

;	lda	#$ff
;	sta	ENAM1

	lda	#NUSIZ_MISSILE_WIDTH_4|NUSIZ_DOUBLE_SIZE
	sta	NUSIZ1

	; setup missle color
	lda	#(33*2)
	sta	COLUP1


	sta	WSYNC

	;===============================
	; 76 lines of snake (20..95)
	;===============================

	ldy	#19
	ldx	#20
ring2_loop:
	lda	(SNAKE_PTR),Y
	sta	GRP0
	tya
	beq	level_no_snake
	dey
level_no_snake:
	inx
	inx
	inx
	inx
	cpx	#92
	bne	still_green

	lda	#32*2
	sta	COLUP0
still_green:

	sta	WSYNC

	cpx	MAX_MANS
	bcc	no_skip_mans

	lda	#$00
	sta	ENAM1
	jmp	skip_mans

no_skip_mans:
	txa
	and	#$07
	bne	skip_mans

	lda	MAN_BAR
	eor	#$FF
	sta	MAN_BAR
	sta	ENAM1
skip_mans:
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	cpx	#96
	bne	ring2_loop

;	ldx	#76
;	jsr	common_delay_scanlines

	;===============================
	; 4 lines to set up boxer (?) check that
	;===============================
	; ideally 96 ... 99

; scanline 96

	lda	#$0		; turn off sprites
;	sta	ENAM1
	sta	GRP0
	sta	GRP1

;	lda	#(39*2)		; pink color

	lda	#(32*2)		; red color
	sta	COLUP0
	sta	COLUP1

	jmp	align2

.align $100

align2:

	sta	WSYNC
; scanline 97

	;====================================
	; position boxer left sprite

	lda	#0
	sta	HMCLR			; clear horizontal move

	lda	BOXER_X			; position		; 3
	ldx	#0			; 0=sprite1		; 2
	jsr	set_pos_x		; 2 scanlines           ; 6+62
					; HM* position set by this
					;  coarse RESP0 set by us

;        sta     WSYNC
; scanline 98+99

	; actually position left sprite

;swait_pos1:				; set position at 5*Y (15*Y TIA)
;	dey				; 2
;	bpl	swait_pos1		; 2/3
;	sta	RESP0			; 3




	sta	WSYNC
	sta	HMOVE

; scanline 102

	;===============================
	; 52 lines of boxer (100..151)
	;===============================
	; boxer each pixel is 4 high

	; at entry already at 4 cycles

	ldy	#13						; 2
	ldx	#100						; 2

boxer_loop:
	lda	(BOXER_PTR_L),Y		; load left sprite data
	sta	GRP0			; set left sprite
	lda	(BOXER_PTR_R),Y		; load right sprite data
	sta	GRP1			; set right sprite


	cpx	#116
	bne	same_color

	lda	#(39*2)		; pink color
	sta	COLUP0
	sta	COLUP1
same_color:
	tya
	beq	level_no_boxer
	dey
level_no_boxer:

	inx
	sta	WSYNC
	inx
	sta	WSYNC
	inx
	sta	WSYNC

	inx
	cpx	#152
	sta	WSYNC
	bne	boxer_loop

;	ldx	#52
;	jsr	common_delay_scanlines

	;====================================
	; 8 lines of rope (bottom) (152..159)
	;====================================
; scanline 152
	lda	#$e			; white
	sta	COLUPF

	lda	#$40
	sta	PF1
	lda	#$00
	sta	PF2

	sta	WSYNC
; scanline 153
	sta	WSYNC
; scanline 154
	sta	WSYNC
; scanline 155
	sta	WSYNC
; scanline 156

	lda	#$BF
	sta	PF1
	lda	#$FF
	sta	PF2

	sta	WSYNC
; scanline 157
	sta	WSYNC
; scanline 158
	sta	WSYNC
; scanline 159
	sta	WSYNC
; scanline 160

	;====================================
	; 4 lines of blank (160..163)
	;====================================

	lda	#$0			; black
	sta	COLUPF

	sta	WSYNC
; scanline 161
	sta	WSYNC
; scanline 162
	sta	WSYNC
; scanline 163
	sta	WSYNC
; scanline 164

	;===============================
	; 28 lines of health (164..191)
	;===============================

	lda	#134		; blue
	sta	COLUBK		; set background

	lda	#$00		; set playfield empty

	sta	PF0
	sta	PF1
	sta	PF2

	lda	#0		; set no reflect			; 2
	sta	CTRLPF                                                  ; 3


	sta	WSYNC		; 4 lines of blue
; scanline 165
	sta	WSYNC
; scanline 166
	sta	WSYNC
; scanline 167

	;=========================
	; prep for green

	ldx	SNAKE_KOS
	lda	snake_colors,X	; load same color as snake
	sta	COLUPF

	ldx	SNAKE_HEALTH	; load health

	ldy	#8		; 8 lines

	sta	WSYNC
; scanline 168

	;==================================
	; snake health (green at first)
	;==================================

	; 8 lines
	jsr	health_line
; scanline 176

	; 4 lines

	lda	#$00
	sta	PF1
	sta	PF2

	sta	WSYNC
; scanline 177
	sta	WSYNC
; scanline 178
	sta	WSYNC
; scanline 179

	; prep for red

	lda	#(34*2)		; red
	sta	COLUPF

	ldx	BOXER_HEALTH	; load health

	ldy	#8		; 8 lines

	sta	WSYNC
; scanline 180

	; 8 lines
	jsr	health_line
; scanline 188

	; 4 lines

	lda	#$00
	sta	PF1
	sta	PF2

	sta	WSYNC
; scanline 189
	sta	WSYNC
; scanline 190
	sta	WSYNC
; scanline 191
	sta	WSYNC
; scanline 192


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
	lda	#$20			; check down			; 2
	bit	SWCHA			;				; 3
	bne	after_check_down	;				; 2/3
down_pressed:

	lda	#1
	sta	BOXER_STATE


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

	lda	#0
	sta	BOXER_STATE

	dec	SNAKE_HEALTH

	bpl	snake_still_alive
snake_dead:

	; increment KOs

	inc	SNAKE_KOS

	; increment KO score which is BCD

	clc
	sed
	lda	SNAKE_KOS_BCD		; bcd
	adc	#1
	sta	SNAKE_KOS_BCD
	cld

	lda	#20
	sta	SNAKE_HEALTH

	; debug
	dec	BOXER_HEALTH
	dec	BOXER_HEALTH
	bne	snake_still_alive

	dec	MANS
	lda	#20
	sta	BOXER_HEALTH


snake_still_alive:
	lda	#8			; debounce
	sta	BUTTON_COUNTDOWN

done_check_button:
	sta	WSYNC

	;=============================
	; now at VBLANK scanline 29
	;=============================
	; handle left being pressed
; 0
	lda	#$40			; check left			; 2
	bit	SWCHA			;				; 3
	bne	after_check_left	;				; 2/3
left_pressed:
	lda	#32
	cmp	BOXER_X
	bcs	cant_dec
can_dec:
	dec	BOXER_X
cant_dec:

update_left:
	clc
	lda	BOXER_X
	adc	#8
	sta	RBOXER_X

after_check_left:
	sta	WSYNC


	;==================================
	; overscan 30, handle end
	;==================================
	; handle right being pressed
; 0
	lda	#$80                    ; check right                    ; 2
	bit	SWCHA                   ;                               ; 3
	bne	after_check_right       ;                               ; 2/3
right_pressed:
	lda     #104
	cmp	BOXER_X
	bcc	cant_inc
can_inc:
	inc	BOXER_X
cant_inc:

update_right:
	clc
	lda	BOXER_X
	adc	#8
	sta	RBOXER_X

after_check_right:

	jmp	level_frame



; color 99/98	$C6/$C4	0110 0100	so and with $FC for last line
; color 34/33	$4E/$4C 1110 1100


	;====================================
	;====================================
	; draw line of health
	;====================================
	;====================================
health_line:
; 5/6
	nop								; 2
; 8
	lda	health_pf1_l,X						; 4+
	sta	PF1							; 3
; 15
	lda	health_pf2_l,X						; 4+
	sta	PF2							; 3
; 22

	nop
	nop
	nop
; 28
	;after 28
	lda	health_pf0_r,X						; 4+
	sta	PF0							; 3
; 35
	; after 38
	nop
; 37
	lda	health_pf1_r,X						; 4+
	sta	PF1							; 3
; 44
	nop
	nop
	nop
	nop

; 52

	; after 50 (but before 65)

	lda	#0							; 2
	sta	PF2							; 3
; 57

	; after 55

	lda	#0							; 2
	sta	PF0							; 3


	sta	WSYNC

	dey								; 2
	bne	health_line						; 2/3

	rts


; original game had 20 hitpoints snake, 10 for you
; a lot easier here to have 16/8?
; full width 40/20?
; compromise centered 20/10


; PF0  PF1      PF2      PF0  PF1      PF2
; 4567 76543210 01234567 4567 76543210 01234567
;            XX XXXXXXXX XXXX XXXXXX

; 21 entries each

; 8,8,4,8,8,4


.include "position.s"
