	;===========================
	; do some Snake Boxing!
	;===========================
	; ideally called with VBLANK disabled


	lda	#20
	sta	SNAKE_HEALTH
	sta	BOXER_HEALTH

	sta	BUTTON_COUNTDOWN	; for now, avoid immediate button
					; press leftover from title

	lda	#100
	sta	BOXER_X
	sta	SNAKE_X

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

	ldx	#33
	jsr	common_delay_scanlines

	;==============================
	; now VBLANK scanline 34+35
	;==============================

.if 0
	; position boxer
	lda	#0
	sta	HMCLR

	lda	BOXER_X			; position		; 3
        ldx     #0			; 0=sprite1		; 2
        jsr     set_pos_x               ; 2 scanlines           ; 6+62
        sta     WSYNC
swait_pos1:
	dey
	bpl	swait_pos1
	sta	RESP0
.endif
	sta	WSYNC
;	sta	HMOVE

	;==============================
	; now VBLANK scanline 36
	;==============================

	lda	#$FF
	sta	PF1
	sta	PF2

	lda	#0
	sta	PF0
	sta	COLUPF

	sta	GRP0
	sta	GRP1

	sta	COLUBK

	lda	#CTRLPF_REF|CTRLPF_BALL_SIZE4				; 2
							; reflect playfield
	sta	CTRLPF                                                  ; 3


	sta	VBLANK	; enable beam

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

	; draw_score here is 8 lines

;.include "draw_score.s"

;	lda	#$E
;	sta	COLUPF

	ldx	#8
	jsr	common_delay_scanlines

	; done with score, set up rest

	lda	#$0
	sta	COLUPF
	lda	#NUSIZ_DOUBLE_SIZE
	sta	NUSIZ0
	sta	NUSIZ1


	sta	WSYNC


	;===============================
	; 8 lines of rope  (12..19)
	;===============================

	lda	#$e			; white
	sta	COLUPF

	lda	#$BF			; pattern for ropes
	sta	PF1

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC

;	sta	WSYNC
;	sta	WSYNC
;	sta	WSYNC
;	sta	WSYNC

	lda	#$40			; other pattern
	sta	PF1
	lda	#$00
	sta	PF2

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC

	;================================
	; setup for snake


	lda	#$BF
	sta	PF1
	lda	#$FF
	sta	PF2

	lda	#$6			; medium grey
	sta	COLUPF

	lda	#98*2
	sta	COLUP0

	lda	#0
	sta	VDELP0
	sta	VDELP1


	sta	WSYNC

	;===============================
	; 76 lines of snake (20..95)
	;===============================

	ldy	#19
	ldx	#20
ring2_loop:
;	cpx	#20
;	bne	skip_activate_snake
;activate_snake:
;	ldy	#19
;skip_activate_snake:
	lda	snake_sprite,Y
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

	sta	WSYNC

	; position boxer left sprite

	lda	#0
	sta	HMCLR			; clear horizontal move

	lda	BOXER_X			; position		; 3
        ldx     #0			; 0=sprite1		; 2
        jsr     set_pos_x               ; 2 scanlines           ; 6+62
					; HM* position set by this
					;  coarse RESP0 set by us

        sta     WSYNC

swait_pos1:				; set position at 5*Y (15*Y TIA)
	dey				; 2
	bpl	swait_pos1		; 2/3
	sta	RESP0			; 3


	lda	BOXER_X			; position		; 3
	clc
	adc	#16
	ldx	#1
	jsr	set_pos_x

	sta	WSYNC

swait_pos2:				; set position at 5*Y (15*Y TIA)
	dey				; 2
	bpl	swait_pos2		; 2/3
	sta	RESP1			; 3



	sta	WSYNC
	sta	HMOVE

	lda	#(39*2)		; pink color
	sta	COLUP0
	sta	COLUP1


	sta	WSYNC

	;===============================
	; 52 lines of boxer (100..151)
	;===============================

	ldy	#0
	ldx	#100
ring_loop:
	cpx	#100
	bne	done_activate_boxer
activate_boxer:
	ldy	#21
	jmp	done_really
done_activate_boxer:
	nop
	nop
done_really:
	lda	boxer_sprite_left,Y
	sta	GRP0
	lda	boxer_sprite_right,Y
	sta	GRP1

	tya

	beq	level_no_cheat
	dey
	jmp	level_no_cheat2
level_no_cheat:
	nop
	nop
level_no_cheat2:


	inx
	sta	WSYNC
	inx
	cpx	#152
	sta	WSYNC
	bne	ring_loop

;	ldx	#52
;	jsr	common_delay_scanlines

	;====================================
	; 8 lines of rope (bottom) (152..159)
	;====================================

	lda	#$e			; white
	sta	COLUPF

	lda	#$40
	sta	PF1
	lda	#$00
	sta	PF2

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC

	lda	#$BF
	sta	PF1
	lda	#$FF
	sta	PF2

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC

	;====================================
	; 4 lines of blank (160..163)
	;====================================

	lda	#$0			; black
	sta	COLUPF

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC

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
	sta	WSYNC
	sta	WSYNC

	;=========================
	; prep for green

	lda	#(99*2)		; green
	sta	COLUPF

	ldx	SNAKE_HEALTH	; load health

	ldy	#8		; 8 lines

	sta	WSYNC


	;==================================
	; snake health (green)
	;==================================

	; 8 lines
	jsr	health_line

	; 4 lines

	lda	#$00
	sta	PF1
	sta	PF2

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC

	; prep for red

	lda	#(34*2)		; red
	sta	COLUPF

	ldx	BOXER_HEALTH	; load health

	ldy	#8		; 8 lines

	sta	WSYNC

	; 8 lines
	jsr	health_line

	; 4 lines

	lda	#$00
	sta	PF1
	sta	PF2

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC



	;==================================
	;==================================
	;==================================
	; overscan 30, handle end
	;==================================
	;==================================
	;==================================
	;==================================

	ldx	#27
	jsr	common_overscan


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

	dec	SNAKE_HEALTH
	bpl	snake_still_alive
snake_dead:
	inc	SNAKE_KOS
	lda	#20
	sta	SNAKE_HEALTH

	; debug
	dec	BOXER_HEALTH
	dec	BOXER_HEALTH

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
