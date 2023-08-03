; Background colors: 2, on 2/4 of lines switches to bg color 2 at cycle 60
; foreground colors, one per block (4 lines)
; vertical bar, full height of screen, same color as pointer
; block overlay (sprite1) one color per line (black harder to do)
;	for best results at least 4 blocks from left of screen
;	due to limitations of kernel


	level_data		= $1400
        level_colors            = level_data+$10	; $1410
        level_playfield0_left   = level_data+$40	; $1440
        level_playfield1_left   = level_data+$70	; $1470
        level_playfield2_left   = level_data+$A0	; $14A0
        level_playfield0_right  = level_data+$D0	; $14D0
        level_playfield1_right  = level_data+$100	; $1500
        level_playfield2_right  = level_data+$130	; $1530
        level_overlay_colors    = level_data+$160	; $1560
        level_overlay_sprite    = level_data+$190	; $1590

        level_overlay_colors_write    = $1160
        level_overlay_sprite_write    = $1190



	;==========================
	; the generic level engine
	;==========================
do_level:
	lda	#20
	sta	INPUT_COUNTDOWN

level_frame:

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

	ldx	#14
	jsr	common_delay_scanlines

; 10

	;===============================================
	; now at VBLANK scanline 14
	;===============================================
	; patch center destination for barrier if needed

	lda	LEVEL_CENTER_PATCH_COND				; 3
	beq	no_center_patch					; 2/3

	and	BARRIER_STATUS					; 3
	beq	no_center_patch					; 2/3

	lda	LEVEL_CENTER_PATCH_DEST				; 3
	sta	LEVEL_CENTER_DEST				; 3

no_center_patch:
	sta	WSYNC

	;======================================
	; now at VBLANK scanline 15,16,17,18,19
	;======================================
	; patch overlay if needed
	; allow 5 scanlines

check_overlay_patch:
	lda	LEVEL_OVERLAY_PATCH_TYPE				; 3
	beq	no_overlay_patch					; 2/3

	jmp	handle_overlay_patch					; 3
; 8

no_overlay_patch:
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
done_overlay_patch:
	sta	WSYNC

	;==============================
	; now at VBLANK scanline 20..25
	;==============================
	; copy in hand sprite
	; takes 6 scanlines

	lda	E7_SET_BANK6
	jsr	pointer_update
	sta	E7_SET_BANK7_RAM


; 9

	;=======================
	; now scanline 26,27,28
	;========================
	; setup missile0 location

	lda	LEVEL_MISSILE0_X
	bne	le_do_missile0

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	beq	no_missile0	; bra

le_do_missile0:
	ldx	#2			; enable missile		; 2
	stx	ENAM0							; 3
	ldx	#POS_MISSILE0
	jsr	set_pos_x

; 6

no_missile0:

	;=============================
	; now VBLANK scanline 29
	;=============================
	; do some init
	; handle marker switches

	inc	FRAME							; 5

	ldx	#$00							; 2
	stx	CURRENT_SCANLINE	; reset scanline counter	; 3

	; flip switch if necessary
	lda	CURRENT_LOCATION
	cmp	#8
	bcs	done_flip_switch

	tax
	lda	powers_of_two,X
	and	SWITCH_STATUS
	beq	switch_off
switch_on:
	lda	#$A2		; blue
	sta	level_overlay_colors_write+30
	lda	#$18		; yellow
	sta	level_overlay_colors_write+31

	lda	#$78
	sta	level_overlay_sprite_write+30
	lda	#$30
	sta	level_overlay_sprite_write+31

	jmp	done_flip_switch		; bra

switch_off:
	lda	#$18		; yellow
	sta	level_overlay_colors_write+30
	lda	#$A2		; blue
	sta	level_overlay_colors_write+31

	lda	#$30
	sta	level_overlay_sprite_write+30
	lda	#$78
	sta	level_overlay_sprite_write+31

done_flip_switch:
	sta	WSYNC

	;=============================
	; now VBLANK scanline 30,31,32
	;=============================
	; set up sprite1 (overlay) to be at proper X position
	;====================================================

	lda	LEVEL_OVERLAY_X						; 3
	ldx	#POS_SPRITE1						; 2
	jsr	set_pos_x						;6+...


	;=========================================
	; now vblank 33,34,35
	;==========================================
	; set up sprite0 to be at proper X position
	;==========================================
; 6
	lda	POINTER_X						; 3
	ldx	#POS_SPRITE0						; 2
	jsr	set_pos_x						;6+...

; 6


	;==========================================
	; now vblank 36
	;==========================================


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
	stx	GRP0
	stx	PF0			; disable playfield		; 3
	stx	PF1							; 3
	stx	PF2							; 3

; 14
	lda	POINTER_COLOR						; 3
	bne	pointer_color_override					; 2/3
	lda	LEVEL_HAND_COLOR	;				; 3
pointer_color_override:
	sta	COLUP0		; set pointer color (sprite0)		; 3
; 25
	lda	level_overlay_colors					; 4+
	sta	COLUP1		; set secret color (sprite1)		; 3
; 32
	lda	#NUSIZ_DOUBLE_SIZE|NUSIZ_MISSILE_WIDTH_8		; 2
	sta	NUSIZ0							; 3
	lda	#NUSIZ_QUAD_SIZE|NUSIZ_MISSILE_WIDTH_4			; 2
	sta	NUSIZ1							; 3
; 42
	lda	#0							; 2
	tay			; current block 			; 2
	sty	CTRLPF		; no_reflect				; 3
; 49
	lda	LEVEL_BACKGROUND_COLOR		;			; 3
	sta	COLUBK		; set background color			; 3
; 55
	lda	#$FF		; ??					; 2
	sta	GRP1							; 3
; 60
;	lda	level_colors	; load level color in advance		; 4
; 64

	lda	#62							; 2
	sta	SCREEN_Y_MAX						; 3
; 65
	ldx	#0		; init hand visibility			; 2
	stx	VBLANK		; turn on beam				; 3
; 70
	sta	WSYNC							; 3


	;===========================================
	;===========================================
	;===========================================
	; draw playfield, 192 scanlines
	;===========================================
	;===========================================
	;===========================================

draw_playfield:

	; A has level colors

	;============================
	; draw playfield line 0 (1/4)
	;============================
; 0
	lda	level_colors,Y						; 4
	sta	COLUPF			; playfield color		; 3
; 7
	lda	level_playfield0_left,Y	; playfield pattern 0		; 4
	sta	PF0			;				; 3
	;   has to happen by 22 (GPU 68)
; 14
	lda	level_playfield1_left,Y	; playfield pattern 1		; 4
	sta	PF1			;				; 3
	;  has to happen by 28 (GPU 84)
; 21
	lda	level_overlay_sprite,Y					; 4
	sta	GRP1			; overlay pattern		; 3
	; really want this to happen by 22
	; in practice we try not to be closer than 4 so 28 is fine?
	; we're like one cycle too late
; 28
	lda	level_playfield2_left,Y	; playfield pattern 2		; 4
        sta	PF2							; 3
	;  has to happen by 38 (GPU 116)	;
; 35
	lda	level_playfield0_right,Y	; left pf pattern 0	; 4
        sta	PF0				;			; 3
	; has to happen 28-49 (GPU 84-148)
; 42
        lda	level_playfield1_right,Y	; left pf pattern 1	; 4
        sta	PF1				;			; 3
	; has to happen 38-56 (GPU 116-170)
; 49
        lda	level_playfield2_right,Y	; left pf pattern 2	; 4
        sta	PF2				;			; 3
	; has to happen 49-67 (GPU148-202)
; 56


	lda	CURRENT_SCANLINE					; 3
	cmp	POINTER_Y						; 3
	beq	no_level_activate_hand					; 2/3
	jmp	done_level_activate_hand				; 3
no_level_activate_hand:
	ldx	#$f							; 2
done_level_activate_hand:
								;===========
								; 11 / 11

; 67

;	nop
;	nop
	inc	TEMP1		; nop5

; 72

	;============================
	; draw playfield line 1 (2/4)
	;============================
	lda	level_playfield0_left,Y	;				; 4
; 0
	sta	PF0			;				; 3
	;   has to happen by 22 (GPU 68)
; 3
	lda	level_playfield1_left,Y	;				; 4
        sta	PF1			;				; 3
	;  has to happen by 28 (GPU 84)
; 10
	lda	level_playfield2_left,Y	;				; 4
        sta	PF2							; 3
	;  has to happen by 38 (GPU 116)	;
; 17

	;==================
	; draw pointer
	;==================

	txa								; 2
	beq	level_no_pointer					; 2/3
	lda	HAND_SPRITE,X						; 4
	sta	GRP0							; 3
	dex								; 2
	jmp	level_done_pointer					; 3
level_no_pointer:
	inc	TEMP1		; nop5					; 5
	nop								; 2
	nop								; 2
	nop								; 2
level_done_pointer:
								;===========
								; 16 / 6

; 33
	lda	level_playfield0_right,Y	;			; 4+
	sta	PF0				;			; 3
	; has to happen 28-49 (GPU 84-148)
; 40
	lda	level_playfield1_right,Y	;			; 4+
	sta	PF1				;			; 3
	; has to happen 39-56 (GPU 116-170)
; 47
	lda	level_playfield2_right,Y	;			; 4+
	sta	PF2				;			; 3
	; has to happen 50-67 (GPU148-202)
; 54
	lda	LEVEL_BACKGROUND_COLOR2		;			; 3
	sta	COLUBK		; set background color			; 3
; 60
	inc	CURRENT_SCANLINE					; 5
; 65
	lda	LEVEL_BACKGROUND_COLOR		;			; 3
; 68
	sta	WSYNC

	;============================
	; draw playfield line 2 (3/4)
	;============================
; 0
	sta	COLUBK		; set background color			; 3
; 3
	lda	level_playfield0_left,Y	;				; 4
	sta	PF0			;				; 3
	;   has to happen by 22 (GPU 68)
; 10
	lda	level_playfield1_left,Y	;				; 4
        sta	PF1			;				; 3
	;  has to happen by 28 (GPU 84)
; 17
	lda	level_playfield2_left,Y	;				; 4
        sta	PF2							; 3
	;  has to happen by 38 (GPU 116)	;
; 24

	inc	TEMP1		; nop5					; 5
	nop								; 2
	nop								; 2

; 33
	lda	level_playfield0_right,Y	;			; 4+
	sta	PF0				;			; 3
	; has to happen 28-49 (GPU 84-148)
; 40
	lda	level_playfield1_right,Y	;			; 4+
	sta	PF1				;			; 3
	; has to happen 39-56 (GPU 116-170)
; 47
	lda	level_playfield2_right,Y	;			; 4+
	sta	PF2				;			; 3
	; has to happen 50-67 (GPU148-202)
; 54
	lda	LEVEL_BACKGROUND_COLOR2		;			; 3
	sta	COLUBK		; set background color			; 3
; 60
	lda	level_playfield0_left,Y	;				; 4
	sta	WSYNC




	;=============================
	; draw playfield line 3 (4/4)
	;=============================
; 0
	sta	PF0			;				; 3
; 3
	;   has to happen by 22 (GPU 68)
	lda	LEVEL_BACKGROUND_COLOR		;			; 3
	sta	COLUBK		; reset background color		; 3
; 9
	lda	level_playfield1_left,Y	;				; 4
        sta	PF1			;				; 3
	;  has to happen by 28 (GPU 84)
; 16
	lda	level_playfield2_left,Y	;				; 4
        sta	PF2							; 3
	;  has to happen by 38 (GPU 116)	;
; 23

	;==================
	; draw pointer
	;==================
	txa								; 2
	beq	level_no_pointer2					; 2/3
	lda	HAND_SPRITE,X						; 4
	sta	GRP0							; 3
	dex								; 2
	jmp	level_done_pointer2					; 3
level_no_pointer2:
	inc	TEMP1		; nop5					; 5
	lda	TEMP1		; nop3					; 3
	lda	TEMP1		; nop3					; 3
level_done_pointer2:
								;===========
								; 16 / 6

; 39

	lda	level_playfield0_right,Y	;			; 4+
	sta	PF0				;			; 3
	; has to happen 28-49 (GPU 84-148)
; 46
	lda	level_playfield1_right,Y	;			; 4+
	sta	PF1				;			; 3
	; has to happen 39-56 (GPU 116-170)
; 53
	lda	level_playfield2_right,Y	;			; 4
	sta	PF2				;			; 3
	; has to happen 50-67 (GPU148-202)
; 60
	iny								; 2
	lda	level_overlay_colors,Y					; 4
	sta	COLUP1							; 3
;	lda	level_colors,Y						; 4+
; 69
	cpy	#48		; see if hit end			; 2
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

	lda	CURRENT_LOCATION					; 3
	cmp	#LOCATION_INSIDE_FIREPLACE				; 2
	beq	handle_fireplace					; 2/3
; 7
	cmp	#LOCATION_CLOCK_PUZZLE					; 2
	beq	handle_clock_puzzle					; 2/3
; 11
	; otherwise 21
	ldx	#21
	jsr	common_overscan
	jmp	done_special_cases


	;==================================
	; handle clock_puzzle
	;==================================
handle_clock_puzzle:

; 12
	; skip proper number of scanlines

	ldx	#12							; 2
	jsr	common_overscan						; 6+...

; 10
	lda	E7_SET_BANK5						; 3
	jsr	clock_update						; 6+...
; 19/23
	sta	E7_SET_BANK7_RAM					; 3
; 26

;	sta	WSYNC

	;==========================================
	; update the clockface if it changed

update_clock_face:
; 26
	ldx	#8							; 2
; 28
update_clock_loop:

	lda	CLOCKFACE_0,X						; 4
	sta	level_overlay_sprite_write+8,X				; 5

	dex								; 2
	bpl	update_clock_loop					; 2/3

; 28+(9*14)-1 = 152

done_update_clock:

        sta     WSYNC

	jmp	done_special_cases


	;==================================
	; handle fireplace
	;==================================
handle_fireplace:
; 8
	; skip proper number of scanlines

	ldx	#13
	jsr	common_overscan

	lda	E7_SET_BANK5
	jsr	fireplace_update
	sta	E7_SET_BANK7_RAM

	;==========================================
	; update the puzzle playfield if it changed
	;
	; try to be as short as possible (offloading other work elsewhere)
	; as we are severely size constrained
	;
	; must be in main ROM as we modify the playfield data in RAM
	;
	; this takes 4 scanlines

update_fireplace:

; 0
	lda	FIREPLACE_CHANGED					; 3
	bpl	do_update_fireplace					; 2/3
; 5
	ldx	#3
	jsr	common_delay_scanlines

	jmp	done_update_fireplace

do_update_fireplace:
; 6
	asl								; 2
	asl								; 2
	sta	SAVED_ROW		; put row offset in Y		; 3
; 13

	ldx	#4			; X is column			; 2
; 15

update_fireplace_loop_col:

; 0 (loop)
	lda	playfield_locations_l,X		; get adress for column	; 4+
	sta	INL				; into (INL)		; 3
	lda	playfield_locations_h,X					; 4+
	sta	INH							; 3
; 14
	ldy	SAVED_ROW						; 3
; 17
	lda	FIREPLACE_C0_R0,X		; load proper column	; 4
; 21

	; store 3 lines

	sta	(INL),Y							; 6
	iny								; 2
	sta	(INL),Y							; 6
	iny								; 2
	sta	(INL),Y							; 6
; 43
	dex					; next column		; 2
	bpl	update_fireplace_loop_col				; 2/3
; 48


; total = (48*5)-1 + 15 = 255 / 76 = 3.3 scanlines

done_update_fireplace:

	sta	WSYNC




	;============================
	; overscan 23, general stuff
	;============================
done_special_cases:
; 3
	lda	#$0							; 2
	sta	ENAM0		; disable missile 0			; 3
	sta	POINTER_GRABBING					; 3
	sta	WAS_CLICKED						; 3
; 13

	; handle reset
	lda	SWCHB		; check if reset pressed		; 3
	lsr			; put reset into carry			; 2
	bcs	no_reset						; 2/3

	; reset
	jmp	myst

no_reset:

	; handle color/bw
	ldx	#0
	lsr			; check if select pressed
	lsr
	lsr
	bcs	no_colorbw
yes_colorbw:
	ldx	#5
no_colorbw:
	stx	LOCATION_LOAD_DELAY



	sta	WSYNC

	;==================================
	; overscan 24, update sound
	;==================================

	lda	E7_SET_BANK5						; 3
	jsr	update_sound						; 50+6
	lda	E7_SET_BANK7_RAM					; 3
; 62
	sta	WSYNC							; 3

	;==================================
	; overscan 25, update pointer
	;==================================
;0
	ldx	POINTER_X						; 3
	ldy	POINTER_Y						; 3
; 6
	; possibly not needed as A=0 from above (where?)
	lda	#POINTER_TYPE_POINT					; 2
; 8
	; first see if grabbing

	cpx	LEVEL_GRAB_MINX						; 3
	bcc	not_grabbing						; 2/3
	cpx	LEVEL_GRAB_MAXX						; 3
	bcs	not_grabbing						; 2/3
	cpy	LEVEL_GRAB_MINY						; 3
	bcc	not_grabbing						; 2/3
	cpy	LEVEL_GRAB_MAXY						; 3
	bcs	not_grabbing						; 2/3

grabbing:
; 28 worst case
	lda	#POINTER_TYPE_GRAB					; 3
	inc	POINTER_GRABBING					; 5
;	bne	level_done_update_pointer	; bra			; 3
								; 36 worst case

not_grabbing:
; 29 / 36 worst case
	ldy	POINTER_COLOR		; if page skip pointer type 	; 3
	beq	pointer_not_page					; 2/3
	lda     #POINTER_TYPE_PAGE	; if color then page		; 2
pointer_not_page:
; 43 worse case

	; need to do this to over-ride turn pointer if grabbing

	ldy	POINTER_GRABBING					; 3
	bne	level_done_update_pointer				; 2/3

; 48 worst case

	;==================================
	; check if want left/right pointer

	ldy	LEVEL_LEFT_DEST						; 3
	bmi	level_not_left						; 2/3
; 53

	; POINTER_X is in X from way before

	cpx	#32							; 2
	bcs	level_not_left						; 2/3
; 57
	lda	#POINTER_TYPE_LEFT					; 2
	jmp	level_done_update_pointer				; 3
level_not_left:
; 54 / 58
	ldy	LEVEL_RIGHT_DEST					; 3
	bmi	level_done_update_pointer				; 2/3
; 63
	cpx	#128							; 2
	bcc	level_done_update_pointer				; 2/3
; 67
	lda	#POINTER_TYPE_RIGHT					; 2

level_done_update_pointer:
; 49 / 62 / 64 / 68 / 69
	sta	POINTER_TYPE						; 3
; 72
        sta     WSYNC

	;==========================================
	;==========================================
	; overscan 26, handle fireplace /clock exit
	;==========================================
	;==========================================
; 0
	; 00 = no, FF=yes
	lda	EXIT_PUZZLE						; 3
	beq	fireplace_irrelevant					; 2/3
; 5
	lda	CURRENT_LOCATION					; 3
	cmp	#LOCATION_INSIDE_FIREPLACE				; 2
	beq	fireplace_exit						; 2/3

; 12
	;===================
	; exit clock puzzle
clock_exit:
	sta	WSYNC
	dec	EXIT_PUZZLE						; 5
	lda	#LOCATION_CLOCK_S					; 2
	bne	start_new_level_28	; bra				; 3
; 22

fireplace_exit:
; 13
	; reset to 0 (EXIT_FIREPLACE plus the fireplace values)
	lda	#0							; 2
	ldx	#6							; 2
reset_fireplace_loop:
	sta	FIREPLACE_ROW1,X
	dex
	bpl	reset_fireplace_loop

;	sta	WSYNC
;	sta	WSYNC
;	sta	WSYNC		; make timing work for the branches below
				; as start new level must be called in
				; overscan 30

	lda	FIREPLACE_CORRECT					; 3
	bmi	go_behind						; 2/3

	lda	#LOCATION_LIBRARY_NW					; 3
	bne	start_new_level_28	; bra				; 3
go_behind:
	ldy	#SFX_RUMBLE	; play sound				; 2
	sty	SFX_PTR							; 3

	lda	#LOCATION_BEHIND_FIREPLACE	; change location	; 2
	bne	start_new_level_28	; bra				; 3

fireplace_irrelevant:
; 6
	sta	WSYNC

	;==================================
	;==================================
	; overscan 28, 29, 30 handle button press
	;==================================
	;==================================

	lda	INPUT_COUNTDOWN						; 3
	beq	waited_enough_level					; 2/3
	dec	INPUT_COUNTDOWN						; 5
	jmp	done_check_level_input_28				; 3

waited_enough_level:

; 6
	lda	INPT4			; check joystick button pressed	; 3
	bmi	done_check_level_input_28				; 2/3

; 11
	;====================================
	; reset input countdown for debounce

	lda	#12							; 2
	sta	INPUT_COUNTDOWN						; 3
; 16
	;======================
	; button was pressed

	lda	POINTER_GRABBING	; secial case if grabbing	; 3
	bne	clicked_grab						; 2/3

; 21

	lda	POINTER_TYPE						; 3
	and	#$3		; "page" and "point (fwd)"		; 2
				; pointers mean the same
	tax								; 2

	lda	LEVEL_CENTER_DEST,X					; 4
; 32
	bmi	done_check_level_input_28	; if $FF then ignore	; 2/3


	;==========================================
	; start new level (must happen overscan 30)
	;==========================================
	;
start_new_level_28:
	sta	WSYNC
start_new_level_29:
	sta	WSYNC
start_new_level:

	sta	CURRENT_LOCATION
	lda	E7_SET_BANK7_RAM					; 3
	jmp	load_new_level


	;==========================
	; clicked grab
	;==========================
clicked_grab:
; 22
	lda	E7_SET_BANK6		; moved to bank6		; 3
	jmp	do_clicked_grab						; 3
; 28

	;=======================================
	; done checking input
	;=======================================
	; note this has to happen in overscan 30

done_check_level_input_28:
	sta	WSYNC
;done_check_level_input_29:
	sta	WSYNC
done_check_level_input:
	lda	E7_SET_BANK7_RAM					; 3
	sta	WSYNC

	jmp	level_frame

powers_of_two:
.byte	$01,$02,$04,$08, $10,$20,$40,$80

playfield_locations_l:
	.byte <(level_playfield1_left-$400+23)
	.byte <(level_playfield2_left-$400+23)
	.byte <(level_playfield0_right-$400+23)
	.byte <(level_playfield1_right-$400+23)
	.byte <(level_playfield2_right-$400+23)

playfield_locations_h:
	.byte >(level_playfield1_left-$400+23)
	.byte >(level_playfield2_left-$400+23)
	.byte >(level_playfield0_right-$400+23)
	.byte >(level_playfield1_right-$400+23)
	.byte >(level_playfield2_right-$400+23)



	;===================================
	;===================================
	; handle overlay patch
	;===================================
	;===================================
	; should take 4 cycles?

handle_overlay_patch:
	; LEVEL_OVERLAY_PATCH_TYPE in A and flags still set...

	; 3 cases:
	;	OVERLAY_PATCH_BARRIER		$80 + offset
	;		clock_s (bridge)		1
	;		library_n (bookshelf)		2
	;		library_s (door to outside)	3
	;	OVERLAY_PATCH_LIBRARY_PAGE	$40
	;		red_book_close (red book)	0
	;		blue_book_close (blue book)	1
	;		library_w (red book far)	2
	;		library_e (blue book far)	3
	;	OVERLAY_PATCH_FIREPLACE		$20
	;		behind_fireplace (red/blue pages)


; 8

	bit	LEVEL_OVERLAY_PATCH_TYPE				; 3
	bmi	do_overlay_patch_barrier				; 2/3
	bvs	do_overlay_patch_library_page				; 2/3


	;==================================
	; patch fireplace page
	;==================================
	; note: to handle having the pages disappear instantly w/o reload
	;	we always draw the page, just changing the sprite value
	; FIXME: combine the two routines
	; can we remove the pages from the overlay to save a few bytes?
	;	not really, would still need something there to hold colors

do_overlay_patch_fireplace:
; 15
	lda	#<(level_overlay_sprite_write)			; 2
	sta	OUTL						; 3
	lda	#>(level_overlay_sprite_write)			; 2
	sta	OUTH						; 3
; 25
	ldx	#0						; 2
	jsr	do_fireplace_patch				; 6+133
; 166
	ldx	#1						; 2
	jsr	do_fireplace_patch				; 6+133
; 307

; 307 = 4 scanlines

	jmp	all_done_overlay_patch4


	;==================================
	; patch library page
	;==================================

do_overlay_patch_library_page:

; 16
	; load Y start
	; close (20-34) far (14-28)
	; for far start higher up, otherwise breaks shelf lip

	lda	LEVEL_OVERLAY_PATCH_TYPE				; 3
	and	#$2							; 2
	lsr								; 2
	tax								; 2
	ldy	library_page_offset,X					; 4+

; 29

	; check if page still there

	lda	LEVEL_OVERLAY_PATCH_TYPE				; 3
	and	#$1	; bit this specifies red/blue			; 2
	tax								; 2
	lda	RED_PAGES_TAKEN,X					; 4
	and	#OCTAGON_PAGE						; 2
; 42
	beq	all_done_overlay_patch1					; 2/3



; 44
	lda	#<(level_overlay_sprite)			; 2
	sta	INL						; 3
	sta	OUTL		; same low offset		; 3
; 52

	lda	#>(level_overlay_sprite)			; 2
	sta	INH						; 3
	lda	#>(level_overlay_sprite_write)			; 2
	sta	OUTH						; 3
; 62

	ldx	#13						; 2
; 64

page_patch_loop:
	lda	(INL),Y						; 5+
	and	LIBRARY_PAGE_MASK				; 3
	sta	(OUTL),Y					; 6
	iny							; 2
	dex							; 2
	bpl	page_patch_loop					; 2/3

	bmi	all_done_overlay_patch	; bra
	; 64+(21*(X+1))-1
	;	x=13 so 357 = 4.7 scanlines (5 is 380)

	;==================================
	; patch barrier
	;==================================

; 14
do_overlay_patch_barrier:
	lda	LEVEL_CENTER_PATCH_COND				; 3
	and	BARRIER_STATUS					; 2
; 19
	bne	do_the_patch					; 2/3
	beq	all_done_overlay_patch1		; bra		; 3

do_the_patch:
; 22
	lda	LEVEL_OVERLAY_PATCH_TYPE			; 3
	and	#$f						; 2
	tax							; 2
	ldy	overlay_patch_start-1,X				; 4+
; 33
	lda	#<(level_overlay_colors_write)			; 2
	sta	INL						; 3
	lda	#>(level_overlay_colors_write)			; 2
	sta	INH						; 3
; 43
	lda	overlay_patch_color-1,X				; 4+
	ldx	#17						; 3
; 50
patch_loop:
	sta	(INL),Y						; 6
	iny							; 2
	dex							; 2
	bpl	patch_loop					; 2/3

	; 50+(13*18)-1
; 283 = 3.7 scalines
	bmi	all_done_overlay_patch4		; bra		; 3


all_done_overlay_patch1:
	sta	WSYNC
;all_done_overlay_patch2:
	sta	WSYNC
;all_done_overlay_patch3:
	sta	WSYNC
all_done_overlay_patch4:
	sta	WSYNC
all_done_overlay_patch:
	jmp	done_overlay_patch


	;===========================
	; do fireplace_patch
	;===========================
	; X = which one

do_fireplace_patch:
; 0
	lda	RED_PAGES_TAKEN,X				; 4
	and	#FINAL_PAGE					; 2
	bne	do_fireplace_patch_not_there			; 2/3

do_fireplace_patch_there:
; 10
	lda	#$1C						; 2
;	bne	finally_do_fireplace_patch	; bra		;
	.byte	$2C	; BIT trick				; 4

do_fireplace_patch_not_there:
; 11
	lda	#0	; $00 A9 should be harmless to bit	; 2
finally_do_fireplace_patch:
; 16 / 13

	; draw in reverse

	ldy	fireplace_offset,X	; draw 7 lines at 39	; 4
	ldx	#6						; 2
; 22 / 29

fireplace_page_patch_loop:
	sta	(OUTL),Y					; 6
	dey							; 2
	dex							; 2
	bpl	fireplace_page_patch_loop			; 2/3

	; (7*13)-1 = 90

; 112 / 119
	and	#$18		; bend page at top		; 2
	sta	(OUTL),Y					; 6
; 120 / 127
	rts
; 126 / 133

fireplace_offset:
	.byte 46,36

overlay_patch_start:
	.byte 33,12,13

overlay_patch_color:
	.byte $4,$2,$0

library_page_offset:
	.byte 20,14
