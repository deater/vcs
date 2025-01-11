PUNCH_LENGTH = 15


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
	sta	RAND_C

	lda	#SNAKE_SPRITE_NEUTRAL	;0
	sta	SNAKE_WHICH_SPRITE
	sta	SNAKE_STATE
	sta	BOXER_WHICH_SPRITE
	sta	BOXER_STATE

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

	ldx	#19
	jsr	common_delay_scanlines


	;==============================
	; now VBLANK scanline 20
	;==============================
	; update rng

	jsr	random8							; 6+48
	sta	WSYNC

	;==============================
	; now VBLANK scanline 21+22
	;==============================

	; position ball, takes 2 scanlines
	; FIXME: not currently using this

	lda	#100			; position		; 3
        ldx     #4			; 4=ball		; 2
					; must call with less than 16 cycles
        jsr     set_pos_x               ; usually 2 scanlines
;	sta	WSYNC

; 6

	;==============================
	; now VBLANK scanline 23
	;==============================
	; handle boxer punching

	lda	BOXER_STATE						; 3
	cmp	#BOXER_PUNCHING
	bne	skip_boxer_punching					; 2/3

boxer_punching:
	dec	BOXER_COUNTDOWN
	lda	BOXER_COUNTDOWN
	bne	boxer_still_punching
boxer_done_punching:
	lda	#BOXER_NEUTRAL
	sta	BOXER_STATE
	lda	#BOXER_SPRITE_NEUTRAL
	jmp	boxer_punch_update_sprite

boxer_still_punching:
	; A is boxer_countdown
	cmp	#(PUNCH_LENGTH-1)
	bne	boxer_already_punching

boxer_start_punching:
	lda	RAND_B
	bmi	boxer_punch_right

boxer_punch_left:
	lda	#BOXER_SPRITE_LPUNCH
	bne	boxer_punch_update_sprite	; bra
boxer_punch_right:
	lda	#BOXER_SPRITE_RPUNCH

boxer_punch_update_sprite:
	sta	BOXER_WHICH_SPRITE

boxer_already_punching:
skip_boxer_punching:

	sta	WSYNC


	;==============================
	; now VBLANK scanline 24
	;==============================
	; randomly update snake

	lda	SNAKE_STATE		; only if neutral (0)		; 3
	bne	skip_snake_adjust					; 2/3

	; see if change state
; 5
	lda	RAND_A							; 3
	and	#$7f							; 2
	bne	snake_same_dir						; 2/3
; 12
	; switch direction
	jsr	switch_snake_direction					; 6+18

snake_same_dir:
; 36 / 13
	; see if attack

	lda	RAND_B							; 3
	and	#$7f							; 2
	bne	snake_no_attack						; 2/3
snake_attack:

	lda	#SNAKE_ATTACKING
	sta	SNAKE_STATE
	lda	#30
	sta	SNAKE_COUNTDOWN
snake_no_attack:
skip_snake_adjust:
	sta	WSYNC

	;==============================
	; now VBLANK scanline 25
	;==============================
	; actually move snake
	; snake bounds are 28 ... 116

	lda	SNAKE_STATE		; only if neutral (0)		; 3
	bne	skip_snake_move						; 2/3

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


skip_snake_move:
; 6
	sta	WSYNC


	;==============================
	; now VBLANK scanline 26
	;==============================
	; handle snake attack

	lda	SNAKE_STATE						; 3
	cmp	#SNAKE_ATTACKING
	bne	skip_snake_attack					; 2/3
skip_attacking:
	dec	SNAKE_COUNTDOWN
	lda	SNAKE_COUNTDOWN
	bne	snake_still_attacking
snake_done_attacking:
	lda	#SNAKE_NEUTRAL
	sta	SNAKE_STATE
	lda	#SNAKE_SPRITE_NEUTRAL
	jmp	snake_attack_update_sprite

snake_still_attacking:
	; A is snake_countdown
	cmp	#15
	bcc	snake_attack_lunging

snake_attack_coiled:
	lda	#SNAKE_SPRITE_COILED
	bne	snake_attack_update_sprite	; bra
snake_attack_lunging:
	lda	#SNAKE_SPRITE_ATTACK
snake_attack_update_sprite:
	sta	SNAKE_WHICH_SPRITE

snake_done_handle_attack:
skip_snake_attack:

	sta	WSYNC

	;==============================
	; now VBLANK scanline 27
	;==============================
	; set up sprites
; 0
	; set up boxer sprites

	ldx	BOXER_WHICH_SPRITE				; 3
; 3
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
	ldx	SNAKE_WHICH_SPRITE				; 3
; 48
	lda	snake_sprites_l,X				; 4+
	sta	SNAKE_PTR					; 3
	lda	snake_sprites_h,X				; 4+
	sta	SNAKE_PTR_H					; 3
; 62
	sta	WSYNC

	;==============================
	; now VBLANK scanline 28
	;==============================
	; setting up KO score takes 6 scanlines

.include "update_score.s"

	;==============================
	; now VBLANK scanline 34+35
	;==============================

	; position sidebar (missile1)

	lda	#150			; position		; 3
        ldx     #3			; 3=missile1		; 2
					; must be <20 when calling
        jsr     set_pos_x               ; usually 2 scanlines

; 6
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

	; draw_score here is 10 lines

	; need this to not cross page

.include "draw_score.s"

; cycle 75 of scanline 10

	; done with score, set up rest

	lda	#$0
; scanline 11
	sta	COLUPF			; playfiel black
	lda	#NUSIZ_DOUBLE_SIZE	; make sprites double wide
	sta	NUSIZ0
	sta	NUSIZ1


	sta	WSYNC


	;===============================
	; 8 lines of rope  (12..19)
	;===============================

; scanline 12

	lda	#$e			; set playfield white white
	sta	COLUPF

	lda	#$BF			; pattern for ropes
	sta	PF1

	lda	#0			; needed?
	sta	HMCLR			; clear out sprite ajustments

	sta	WSYNC

; scanline 13

	;====================================
	; position boxer right sprite (well in advance)

	lda	BOXER_X			; position			; 3
	clc				; it's 16 pixels to right	; 2
	adc	#16							; 2
	ldx	#1			; positioning SPRITE1		; 2

					; must be called <20
	jsr	set_pos_x		; usually 2 scanlines

; 6

; scanline 14

; scanline 15
	sta	WSYNC
; scanline 16

	lda	#$40			; setup rope on edges		; 2
	sta	PF1							; 3
	lda	#$00			; empty space between ropes	; 2
	sta	PF2							; 3

	;================================
	; position snake

	lda	SNAKE_X			; position			; 3
        ldx     #0			; 0=sprite1			; 2
							; call with <20
        jsr     set_pos_x               ; usually 2 scanlines
; scanline 17

; scanline 18

; 6

	;===============================
	; unused scanline 18!
	;===============================

	sta	WSYNC

; scanline 19

; 0
	sta	HMOVE							; 3
; 3
	;================================
	; setup for snake

	lda	#$BF			; boxing ring pattern		; 2
	sta	PF1							; 3
	lda	#$FF							; 2
	sta	PF2							; 3
; 13
	lda	#$6			; medium grey			; 2
	sta	COLUPF			; set boxing ring color		; 3
; 18
	ldx	SNAKE_KOS		; set snake color		; 3
	lda	snake_colors,X		; from lookup table		; 4+
	sta	COLUP0							; 3
; 28
	lda	#0			; turn off delay on sprites	; 2
	sta	VDELP0							; 3
	sta	VDELP1							; 3
	sta	MAN_BAR			; clear mans bar value		; 3
; 39
	ldx	MANS			; setup man max for bar		; 3
	lda	mans_max_lookup,X					; 4+
	sta	MAX_MANS						; 3
; 49

	;==================================
	; setup missile for mans bar

;	lda	#$ff
;	sta	ENAM1

	lda	#NUSIZ_MISSILE_WIDTH_4|NUSIZ_DOUBLE_SIZE		; 2
	sta	NUSIZ1							; 3
; 54
	; setup missle color
	lda	#(33*2)			; red				; 2
	sta	COLUP1							; 3
; 59

	sta	WSYNC

	;===============================
	; 76 lines of snake (20..95)
	;===============================

	ldy	#19		; Y = index into snake sprite		; 2
	ldx	#20		; X = scanline				; 2

ring2_loop:
	lda	(SNAKE_PTR),Y	; load snake sprite data		; 5+
	sta	GRP0		; save in SPRITE0			; 3

	tya			; stop drawing if hit 0			; 2
	beq	level_no_snake
	dey
level_no_snake:

	inx			; draw 4 lines
	inx
	inx
	inx

	cpx	#92		; see if change color of tongue
	bne	still_green

	lda	#32*2
	sta	COLUP0
still_green:

	sta	WSYNC		; start sub line 1

	cpx	MAX_MANS	; upate mans display on side
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

	sta	WSYNC			; start sub-line2
	sta	WSYNC			; start sub-line3
	sta	WSYNC			; start sub-line4

	cpx	#96			; loop if not done
	bne	ring2_loop

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
	jsr	set_pos_x		; usually 2 scanlins	; needs <20

; scanline 98

; 6

; scanline 99


	; unused?

	ldy	#12							; 2
	ldx	#100							; 2

	sta	WSYNC
	sta	HMOVE						; 3

; scanline 100

	;===============================
	; 52 lines of boxer (100..151)
	;===============================
	; boxer each pixel is 4 high

	; at entry already at 4 cycles

boxer_loop:
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
	sta	WSYNC

	inx
	cpx	#152
	sta	WSYNC
	bne	boxer_loop

	;====================================
	; 8 lines of rope (bottom) (152..159)
	;====================================
; scanline 152
	lda	#$e		; white					; 2
	sta	COLUPF		; playfield color			; 3

	lda	#$40		; playfield pattern			; 2
	sta	PF1							; 3

	lda	#$00							; 2
	sta	PF2							; 3
	sta	GRP0
	sta	GRP1

	sta	WSYNC
; scanline 153
	sta	WSYNC
; scanline 154
	sta	WSYNC
; scanline 155
	sta	WSYNC
; scanline 156

	;===================================
	; draw bottom rope

	lda	#$BF		; playfield pattern
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
	; 4 lines of black (160..163)
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

	ldx	#24
	jsr	common_overscan


	;=============================
	; now at VBLANK scanline 25+26
	;=============================
	; handle sound
	; takes two scanlines

	jsr	update_sound            ; 2 scanlines

	sta	WSYNC

	;=============================
	; now at VBLANK scanline 27
	;=============================
	; handle down being pressed

	; if neutral and down -> block
	; if block and down -> block
	; if block and not down -> neutral
	; else, keep same

; 0
	lda	BOXER_STATE
	beq	block_or_neutral	; don't move if not neutral
	cmp	#BOXER_BLOCKING
	bne	after_check_down

	; should be BLOCK or NEUTRAL state here

block_or_neutral:
	lda	#$20			; check down			; 2
	bit	SWCHA			;				; 3
	beq	down_pressed						; 2/3
down_not_pressed:
	lda	#BOXER_SPRITE_NEUTRAL
	sta	BOXER_WHICH_SPRITE
	lda	#BOXER_NEUTRAL
	jmp	down_update_state
down_pressed:
	lda	#BOXER_SPRITE_BLOCK
	sta	BOXER_WHICH_SPRITE

	lda	#BOXER_BLOCKING
down_update_state:
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

button_pressed:

	lda	BOXER_STATE
	cmp	#BOXER_NEUTRAL
	bne	done_check_button

	lda	#BOXER_PUNCHING
	sta	BOXER_STATE
	lda	#PUNCH_LENGTH
	sta	BOXER_COUNTDOWN

;	dec	SNAKE_HEALTH

;	bpl	snake_still_alive
;snake_dead:

	; increment KOs

;	inc	SNAKE_KOS

	; increment KO score which is BCD

;	clc
;	sed
;	lda	SNAKE_KOS_BCD		; bcd
;	adc	#1
;	sta	SNAKE_KOS_BCD
;	cld

;	lda	#20
;	sta	SNAKE_HEALTH

	; debug
;	dec	BOXER_HEALTH
;	dec	BOXER_HEALTH
;	bne	snake_still_alive

;	dec	MANS
;	lda	#20
;	sta	BOXER_HEALTH


;snake_still_alive:
	lda	#8			; debounce
	sta	BUTTON_COUNTDOWN

done_check_button:
	sta	WSYNC

	;=============================
	; now at VBLANK scanline 29
	;=============================
	; handle left being pressed
; 0
	lda	BOXER_STATE
	bne	after_check_left	; don't move if not neutral

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

	lda	BOXER_STATE
	bne	after_check_right	; don't move if not neutral

	lda	#$80                    ; check right			; 2
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


	;=============================
	; ff -> 1, 1->FF
switch_snake_direction:
	lda	SNAKE_SPEED						; 3
	eor	#$FF							; 2
	clc								; 2
	adc	#1							; 2
	sta	SNAKE_SPEED						; 3
	rts								; 6
; 18


.include "position.s"
