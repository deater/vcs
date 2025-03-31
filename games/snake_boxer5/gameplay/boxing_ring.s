PUNCH_LENGTH = 15
SNAKE_INJURE_TIME = 15
SNAKE_KO_TIME	= 64
SNAKE_ATTACK_LENGTH = 30
BOXER_KO_TIME	= 64

SNAKE_ATTACK_MASK = $3f		; 1 time in 64
				; TODO, make comparison with zero page
				; value and not mask

	;===========================
	; do some Snake Boxing!
	;===========================


	;===========================
	; initialization!
	;===========================
	; takes 2 scanlines
	;===========================
	; ideally called with VBLANK disabled in VBLANK line 28

; 13

	lda	#20							; 2
	sta	SNAKE_HEALTH						; 3
	sta	BOXER_HEALTH						; 3
; 21
	sta	BUTTON_COUNTDOWN	; avoid immediate button	; 3
					; press leftover from title
; 24

	lda	#3							; 2
	sta	MANS							; 3
	sta	RAND_C							; 3

; 42
	lda	#1							; 2
	sta	SNAKE_SPEED						; 3
; 47
	sta	WSYNC

;=============================

; 0
	lda	#SNAKE_SPRITE_NEUTRAL	; 0				; 2
	sta	SNAKE_WHICH_SPRITE					; 3
; 5
	sta	SNAKE_STATE						; 3
	sta	BOXER_WHICH_SPRITE					; 3
	sta	BOXER_STATE						; 3
; 14
;	lda	#0
	sta	FRAME							; 3
	sta	FRAMEH							; 3
	sta	BOXER_STATE						; 3
	sta	SNAKE_KOS						; 3
	sta	SNAKE_KOS_BCD						; 3
	sta	SNAKE_X_LOW						; 3
	sta	SNAKE_SPEED_LOW						; 3
; 38

	; re-ceneter both, ring bell
level_restart:

	lda	#0
	sta	LEVEL_OVER						; 3

	lda	#SFX_BELL		; start with bell
	sta	SFX_NEW

	lda	#64			; roughly center on screen	; 2
	sta	BOXER_X							; 3
	lda	#72							; 2
	sta	SNAKE_X							; 3

	sta	WSYNC

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

	ldx	#10
	jsr	common_delay_scanlines

	;==============================
	; now VBLANK scanline 11
	;==============================
	; pre-emptive collision detect

	; doing sort of Minkowski Sum Collision

	lda	#0
	sta	COLLIDING

	; snake_x should never be less than 16 so no need to worry
	;	about bounds

	; if (snake_X+8 <boxer_X-8) no collision?
	;	same as if (boxer_X-16 > snake_x)


	lda	BOXER_X
	sec
	sbc	#8
	cmp	SNAKE_X
	bcs	no_collision

	; if (snake_X > boxer_X+40) no collision
	;	sams as if (boxer_X+40 < snake_X)

	lda	BOXER_X
	clc
	adc	#40
	cmp	SNAKE_X
	bcc	no_collision

	inc	COLLIDING

no_collision:
	sta	WSYNC


	;==============================
	; now VBLANK scanline 12
	;==============================
	; update rng

	jsr	random8							; 6+48
	sta	WSYNC

	;==============================
	; now VBLANK scanline 13+14
	;==============================
	; position ball
	;==============================
	; takes 2 scanlines
	; FIXME: not currently using this

	lda	#100			; position		; 3
        ldx     #4			; 4=ball		; 2
					; must call with less than 16 cycles
        jsr     set_pos_x               ; usually 2 scanlines
;	sta	WSYNC

; 6

	;==============================
	; now VBLANK scanline 15
	;==============================
	; handle boxer punching
	;==============================
	; keep boxing for BOXER_COUNTDOWN time
	; if just starting, randomly pick left/right
	; at end, return to neutral

	lda	BOXER_STATE		; only if in PUNCHING state	; 3
	cmp	#BOXER_PUNCHING						; 2
	bne	skip_boxer_punching					; 2/3

boxer_punching:
	dec	BOXER_COUNTDOWN						; 5
	lda	BOXER_COUNTDOWN						; 3
	bne	boxer_still_punching					; 2/3

boxer_done_punching:
	lda	#BOXER_NEUTRAL		; reset back to normal		; 2
	sta	BOXER_STATE						; 3
	lda	#BOXER_SPRITE_NEUTRAL					; 3
	jmp	boxer_punch_update_sprite	; FIXME			; 3

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
	; now VBLANK scanline 16
	;==============================
	; handle snake being punched
	;==============================
	; if begin of punch, collision check with snake
	; if hit, decrement snake health, set injured, start countdown
; 0
	lda	BOXER_STATE		; make sure we are punching	; 3
	cmp	#BOXER_PUNCHING						; 2
	bne	done_snake_collide					; 2/3
; 7
	lda	BOXER_COUNTDOWN		; check if punch just happened	; 3
	cmp	#(PUNCH_LENGTH-1)					; 2
	bne	done_snake_collide					; 2/3

punch_just_happened:

; 15
	;======================
	; collision detection

	lda	COLLIDING
	beq	punch_not_hit_snake	; not colliding

	lda	SNAKE_STATE		; no hit if snake injured
	cmp	#SNAKE_NEUTRAL
	beq	punch_hit_snake

punch_not_hit_snake:

	lda	#SFX_PUNCH_MISS
	sta	SFX_NEW
	jmp	done_snake_collide

punch_hit_snake:

	lda	#SFX_PUNCH_HIT
	sta	SFX_NEW

	lda	#SNAKE_SPRITE_INJURED	; move to injured sprite	; 2
	sta	SNAKE_WHICH_SPRITE					; 3
; 20
	lda	#SNAKE_INJURED		; move to injured state		; 2
	sta	SNAKE_STATE						; 3
; 25
	lda	#SNAKE_INJURE_TIME	; set up countdown for injury	; 2
	sta	SNAKE_COUNTDOWN						; 3
; 30
	dec	SNAKE_HEALTH		; decrement the snake health	; 5
					; not this could be $FF if
					; about to be KOed
done_snake_collide:


	sta	WSYNC


	;===============================
	; now VBLANK scanline 17
	;===============================
	; randomly adjust snake behavior
	;===============================
	; randomly have snake reverse direction or strike
	; should not move/strike if boxer injured, koed, or dead

	lda	SNAKE_STATE		; only if neutral (0)		; 3
	bne	skip_snake_adjust					; 2/3

	lda	BOXER_STATE
	beq	do_random_snake		; ok if neutral
	cmp	#BOXER_BLOCKING
	bne	skip_snake_adjust	; if not blocking continue

do_random_snake:

	; see if change state
; 5
	lda	RAND_A							; 3
	and	#$7f							; 2
	bne	snake_same_dir						; 2/3
; 12
	; switch direction
	jsr	switch_snake_direction					; 6+28

snake_same_dir:
; 46 / 13
	; see if attack

	lda	RAND_B							; 3
	and	#SNAKE_ATTACK_MASK					; 2
; 51
	bne	snake_no_attack						; 2/3
snake_attack:
; 53
	lda	#SNAKE_ATTACKING					; 2
	sta	SNAKE_STATE						; 3
	lda	#SNAKE_ATTACK_LENGTH					; 2
	sta	SNAKE_COUNTDOWN						; 3
snake_no_attack:
skip_snake_adjust:
; 63 worst case
	sta	WSYNC

	;==============================
	; now VBLANK scanline 18
	;==============================
	; handle snake injured
	;==============================
	; countdown while showing injured sprite
	; at end if health then return to neutral
	; if KO'd, set KO state + countdown

; 0
	lda	SNAKE_STATE		; only if injured		; 3
	cmp	#SNAKE_INJURED						; 2
	bne	skip_snake_injured					; 2/3

; 7
	dec	SNAKE_COUNTDOWN		; countdown			; 5
	bne	skip_snake_injured					; 2/3

; 14

done_snake_injured:
	lda	SNAKE_HEALTH		; check health			; 3
	bne	still_snake_health	; if still health, skip ahead	; 2/3
					; note 0 = out of health
; 19
make_snake_koed:
	; out of health, KO
	lda	#SFX_SNAKE_KO		; play sound			; 2
	sta	SFX_NEW							; 3
; 24
	lda	#SNAKE_KOED		; set KO state			; 2
	sta	SNAKE_STATE						; 3
	lda	#SNAKE_KO_TIME		; set KO countdown		; 2
	sta	SNAKE_COUNTDOWN						; 3
; 44
	; increment KOs

	inc	SNAKE_KOS						; 5

; 49
	; increment KO score which is BCD

	clc								; 2
	sed								; 2
	lda	SNAKE_KOS_BCD		; bcd				; 3
	adc	#1							; 2
	sta	SNAKE_KOS_BCD						; 3
	cld								; 2
; 64

	jmp	skip_snake_injured

	; still health

still_snake_health:
	lda	#SNAKE_NEUTRAL		; reset state to neutral	; 2
	sta	SNAKE_STATE						; 3
	lda	#SNAKE_SPRITE_NEUTRAL					; 2
	sta	SNAKE_WHICH_SPRITE					; 3

skip_snake_injured:
; 6
	sta	WSYNC


	;==============================
	; now VBLANK scanline 19
	;==============================
	; handle boxer injured
	;==============================
	; if injured, countdown while showing injured sprite
	; at end, reduce health
	; if health negative, move to KO state

	lda	BOXER_STATE		; only if injured (0)		; 3
	cmp	#BOXER_INJURED
	bne	skip_boxer_injured					; 2/3

	dec	BOXER_COUNTDOWN
	bne	still_boxer_injured

done_boxer_injured:
	dec	BOXER_HEALTH						; 5
	dec	BOXER_HEALTH						; 5

	lda	BOXER_HEALTH		; health=0 means KO		; 3
	bne	boxer_health_still_ok					; 2/3

boxer_health_negative:
	lda	#BOXER_KOED						; 2
	sta	BOXER_STATE						; 3
	lda	#BOXER_KO_TIME						; 2
	sta	BOXER_COUNTDOWN						; 3
	lda	#BOXER_SPRITE_NEUTRAL					; 2
	jmp	boxer_injured_update_sprite				; 3

boxer_health_still_ok:
	lda	#BOXER_NEUTRAL						; 2
	sta	BOXER_STATE						; 3
	lda	#BOXER_SPRITE_NEUTRAL					; 2

boxer_injured_update_sprite:
	sta	BOXER_WHICH_SPRITE					; 3

still_boxer_injured:
skip_boxer_injured:
; 6
	sta	WSYNC

	;==============================
	; now VBLANK scanline 20
	;==============================
	; handle boxer koed
	;==============================
	; if in KO state, blink sprite
	; when done, decrement MANS count
	; if MANS count hits zero, enter dead state

	lda	BOXER_STATE		; only if koed state		; 3
	cmp	#BOXER_KOED
	bne	skip_boxer_koed						; 2/3

	dec	BOXER_COUNTDOWN		; dec countdown			; 5
	bne	still_boxer_koed	; if not zero, still KOed	; 2/3

	; done KO countdown

done_boxer_koed:
	dec	MANS			; decrement MANS		; 5
	lda	MANS			; load MANS count		; 3
	beq	boxer_make_dead		; if hit zero then dead		; 2/3

	inc	LEVEL_OVER		; reset				; 5
	jmp	boxer_still_alive

boxer_make_dead:
	lda	#SFX_GAMEOVER
	sta	SFX_NEW
	lda	#BOXER_DEAD
	sta	BOXER_STATE
	lda	#BOXER_SPRITE_DEAD
	jmp	boxer_koed_update_sprite

boxer_still_alive:

	lda	#20
	sta	BOXER_HEALTH		; reset health

	; reset back to neutral
	lda	#BOXER_NEUTRAL
	sta	BOXER_STATE
	lda	#BOXER_SPRITE_NEUTRAL
	jmp	boxer_koed_update_sprite

	; blink sprite
still_boxer_koed:
	lda	BOXER_COUNTDOWN
	and	#$08
	beq	boxer_koed_sprite_off
boxer_koed_sprite_on:
	lda	#BOXER_SPRITE_NEUTRAL
	beq	boxer_koed_update_sprite	; bra
boxer_koed_sprite_off:
	lda	#BOXER_SPRITE_EMPTY
boxer_koed_update_sprite:
	sta	BOXER_WHICH_SPRITE

skip_boxer_koed:
; 6
	sta	WSYNC


	;==============================
	; now VBLANK scanline 21
	;==============================
	; handle snake koed
; 0
	lda	SNAKE_STATE		; only if koed			; 3
	cmp	#SNAKE_KOED						; 2
	bne	skip_snake_koed						; 2/3
; 7
	dec	SNAKE_COUNTDOWN		; countdown			; 5
	bne	still_snake_koed	; skip if waiting		; 2/3
; 14
done_snake_koed:
	lda	#SNAKE_NEUTRAL						; 2
	sta	SNAKE_STATE						; 3
; 19

	lda	#20			; reset health to full		; 2
	sta	SNAKE_HEALTH						; 3
; 24
	inc	LEVEL_OVER		; reset ring			; 5
; 29
	; speed up snake
	; instead of math, use table

	ldx	SNAKE_KOS						; 3
	cpx	#MAX_SNAKE_SPEED					; 2
	bcc	snake_speed_good					; 2/3
	ldx	#(MAX_SNAKE_SPEED-1)					; 2
snake_speed_good:
; 38
	lda	snake_speed_hi,X					; 4+
	sta	SNAKE_SPEED						; 3
	lda	snake_speed_lo,X					; 4+
	sta	SNAKE_SPEED_LOW						; 3

; 52
	lda	#SNAKE_SPRITE_NEUTRAL					; 2

	jmp	koed_update_sprite					; 3

still_snake_koed:
	lda	SNAKE_COUNTDOWN
	and	#$08
	beq	koed_sprite_off
koed_sprite_on:
	lda	#SNAKE_SPRITE_INJURED
	bne	koed_update_sprite	; bra
koed_sprite_off:
	lda	#SNAKE_SPRITE_EMPTY

; / / / 52
koed_update_sprite:
	sta	SNAKE_WHICH_SPRITE					; 3

skip_snake_koed:
; 6
	sta	WSYNC



	;==============================
	; now VBLANK scanline 22
	;==============================
	; actually move snake
	; snake bounds are 28 ... 116
; 0
	lda	SNAKE_STATE		; only if neutral (0)		; 3
	bne	skip_snake_move						; 2/3
; 5
	lda	BOXER_STATE		; only if NEUTRAL OR BLOCKING	; 3
	beq	snake_speed_go						; 2/3
; 10
	cmp	#BOXER_BLOCKING						; 2
	bne	skip_snake_move						; 2/3
; 14

snake_speed_go:
	clc								; 2
	lda	SNAKE_X_LOW						; 3
	adc	SNAKE_SPEED_LOW						; 3
	sta	SNAKE_X_LOW						; 3
; 25
	lda	SNAKE_X							; 3
	adc	SNAKE_SPEED						; 3
	sta	SNAKE_X							; 3
; 34
skip_snake_move:
	sta	WSYNC

	;==============================
	; now VBLANK scanline 23
	;==============================
	; keep snake in bounds
; 0
	; see if out of bounds
	cmp	#116							; 2
	bcc	snake_ok_left						; 2/3
; 4
	jsr	switch_snake_direction					; 6+28
; 38

;	lda	#$ff
;	sta	SNAKE_SPEED
	jmp	snake_bounds_done

snake_ok_left:
; 5
	cmp	#28							; 2
	bcs	snake_ok_right						; 2/3
; 9

	jsr	switch_snake_direction					; 6+28
; 43

;	lda	#$1
;	sta	SNAKE_SPEED

snake_ok_right:

snake_bounds_done:

; 6
	sta	WSYNC



	;==============================
	; now VBLANK scanline 24
	;==============================
	; handle snake attack
	; if starting:
	;	start
	; if halfway:
	;	do collision detect

; 0
	lda	SNAKE_STATE		; check if snake attacking	; 3
	cmp	#SNAKE_ATTACKING					; 2
	bne	skip_snake_attack					; 2/3
; 8
skip_attacking:
	dec	SNAKE_COUNTDOWN		; count down			; 5
	lda	SNAKE_COUNTDOWN						; 3
	beq	snake_done_attacking	; check if done attacking	; 2/3
	cmp	#(SNAKE_ATTACK_LENGTH-1)				; 2
	bne	snake_still_attacking

snake_attack_start:

;	lda	#BOXER_INJURED
;	sta	BOXER_STATE
;	lda	#BOXER_SPRITE_INJURED
;	sta	BOXER_WHICH_SPRITE
;	lda	#SNAKE_ATTACK_LENGTH
;	sta	BOXER_COUNTDOWN
	jmp	snake_done_handle_attack

snake_done_attacking:
	lda	#SNAKE_NEUTRAL		; reset state to neutral	; 2
	sta	SNAKE_STATE						; 3
	lda	#SNAKE_SPRITE_NEUTRAL	; reset sprite to neutral	; 2
	jmp	snake_attack_update_sprite				; 3

snake_still_attacking:
	; A is snake_countdown
	cmp	#15							; 2
	bcc	snake_attack_lunging					; 2/3

snake_attack_coiled:
	lda	#SNAKE_SPRITE_COILED					; 2
	bne	snake_attack_update_sprite	; bra			; 2/3
snake_attack_lunging:

	; no attack if blocking

	lda	COLLIDING
	beq	snake_lunge_miss

	lda	BOXER_STATE
	cmp	#BOXER_BLOCKING
	beq	snake_lunge_miss

snake_lunge_hit:
	lda	#SFX_SNAKE_HIT
	sta	SFX_NEW

	lda	#BOXER_INJURED
	sta	BOXER_STATE
	lda	#BOXER_SPRITE_INJURED
	sta	BOXER_WHICH_SPRITE
	lda	#SNAKE_ATTACK_LENGTH
	sta	BOXER_COUNTDOWN
	jmp	snake_lunge_draw
snake_lunge_miss:

	lda	#SFX_SNAKE_MISS
	sta	SFX_NEW

snake_lunge_draw:

	lda	#SNAKE_SPRITE_ATTACK					; 2
snake_attack_update_sprite:
	sta	SNAKE_WHICH_SPRITE					; 3

snake_done_handle_attack:
skip_snake_attack:

	sta	WSYNC

	;==============================
	; now VBLANK scanline 25
	;==============================
	; set up boxer sprites
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

	; sadly changed so no longer all in same page
	lda	lboxer_sprites_h,X				; 4+
	sta	BOXER_PTR_LH					; 3
	lda	rboxer_sprites_h,X				; 4+
	sta	BOXER_PTR_RH					; 3
	lda	lboxer_colors_h,X				; 4+
	sta	BOXER_COL_LH					; 3
	lda	rboxer_colors_h,X				; 4+
	sta	BOXER_COL_RH					; 3
; 59
	sta	WSYNC

	;==============================
	; now VBLANK scanline 26
	;==============================
	; set up snake sprites
; 0
	ldx	SNAKE_WHICH_SPRITE				; 3
; 3
	lda	snake_sprites_l,X				; 4+
	sta	SNAKE_PTR					; 3
	lda	snake_sprites_h,X				; 4+
	sta	SNAKE_PTR_H					; 3
; 17
	sta	WSYNC

	;==============================
	; now VBLANK scanline 27
	;==============================
	; setting up KO score takes 6 scanlines

.include "update_score.s"

	;==============================
	; now VBLANK scanline 33+34
	;==============================

	; position sidebar (missile1)

	lda	#150			; position		; 3
        ldx     #3			; 3=missile1		; 2
					; must be <20 when calling
        jsr     set_pos_x               ; usually 2 scanlines

; 6
	;==============================
	; now VBLANK scanline 35
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
	; now VBLANK scanline 36
	;==============================

	; PLACEHOLDER

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

	lda	(BOXER_PTR_L),Y		; load left sprite data		; 5+
	sta	GRP0			; set left sprite		; 3
	lda	(BOXER_PTR_R),Y		; load right sprite data	; 5+
	sta	GRP1			; set right sprite		; 3

	lda	(BOXER_COL_L),Y		; load left color data		; 5+
	sta	COLUP0			; set left color		; 3
	lda	(BOXER_COL_R),Y		; load right color data		; 5+
	sta	COLUP1			; set right color		; 3

	dey

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
	lda	snake_colors,X	; 	load same color as snake
	sta	COLUPF

	ldx	SNAKE_HEALTH		; load health
	bpl	snake_health_good	; if negative, show as 0
	ldx	#0
snake_health_good:

	ldy	#8		; 8 lines

	sta	WSYNC
; scanline 168

	;==================================
	;==================================
	; snake health (snake colored)
	;==================================
	;==================================

	; 8 lines
	jsr	health_line
; scanline 176

	; 4 lines of blue color

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

	ldx	BOXER_HEALTH		; load boxer health
	bpl	boxer_health_good	; if negative, show as 0
	ldx	#0
boxer_health_good:

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

	ldx	#21
	jsr	common_overscan

	;===============================
	; now at overscan 22
	;===============================
	; trigger sound

	ldy	SFX_NEW
	beq	bskip_sound
	jsr	trigger_sound		; 52 cycles
	lda	#0
	sta	SFX_NEW
bskip_sound:
	sta	WSYNC

	;=============================
	; now at overscan 23+24
	;=============================
	; handle sound
	; takes two scanlines

	jsr	update_sound            ; 2 scanlines

	sta	WSYNC

	;=============================
	; now at overscan 25
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
	; now at overscan 26
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

	lda	BOXER_STATE		; check boxer state		; 3
	cmp	#BOXER_DEAD
	bne	button_not_dead

	lda	#$FF			; if dead, trigger level over	; 2
	sta	LEVEL_OVER						; 3
	jmp	button_set_debounce

button_not_dead:
	cmp	#BOXER_NEUTRAL		; only punch if boxer neutral	; 2
	bne	done_check_button					; 2/3

	; TODO: only punch if snake in X state?

	lda	#BOXER_PUNCHING						; 2
	sta	BOXER_STATE						; 3
	lda	#PUNCH_LENGTH						; 2
	sta	BOXER_COUNTDOWN						; 3

button_set_debounce:
	lda	#8			; debounce
	sta	BUTTON_COUNTDOWN

done_check_button:
	sta	WSYNC

	;=============================
	; now at overscan 27
	;=============================
	; handle left being pressed
; 0
	lda	BOXER_STATE
	bne	after_check_left	; don't move if not neutral

	lda	#$40			; check left			; 2
	bit	SWCHA			;				; 3
	bne	after_check_left	;				; 2/3
left_pressed:
	lda	#24
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
	; now at overscan 28
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
	sta	WSYNC

	;==================================
	; now at overscan 29
	;==================================
	; handle end

	lda	LEVEL_OVER
	beq	level_good		; 0 means normal
	bmi	done_game		; $FF means back to title screen

	; reset
	jmp	level_restart		; 1 means reset position
level_good:

	sta	WSYNC

	;==================================
	; now at overscan 30
	;==================================
	; do nothing

	jmp	level_frame


	;===========================
	; done game
	;===========================

done_game:
	; return to title screen

	jmp	switch_to_bank0_and_start_title



	;====================================
	;====================================
	; draw line of health
	;====================================
	;====================================

; potential 3d effect for health lines?
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


	;=============================
	; switch snake direction
	;=============================
	; more complex as it's 16-bit twos complement

	; ff -> 1, 1->FF
switch_snake_direction:
	clc								; 2
	lda	SNAKE_SPEED_LOW						; 3
	eor	#$FF							; 2
	adc	#1							; 2
	sta	SNAKE_SPEED_LOW						; 3
; 12
	lda	SNAKE_SPEED						; 3
	eor	#$FF							; 2
	adc	#0							; 2
	sta	SNAKE_SPEED						; 3
	rts								; 6
; 28

