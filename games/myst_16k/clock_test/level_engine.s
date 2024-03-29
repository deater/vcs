; Background colors: 2, on 2/4 of lines switches to bg color 2 at cycle 60
; foreground colors, one per block (4 lines)
; vertical bar, full height of screen, same color as pointer
; block overlay (sprite1) one color per line (black harder to do)
;	for best results at least 4 blocks from left of screen
;	due to limitations of kernel


	level_data		= $1400
        level_colors            = level_data+$10	;$1410
        level_playfield0_left   = level_data+$40	;$1440
        level_playfield1_left   = level_data+$70	;$1470
        level_playfield2_left   = level_data+$A0	;$14A0
        level_playfield0_right  = level_data+$D0	;$14D0
        level_playfield1_right  = level_data+$100	;$1500
        level_playfield2_right  = level_data+$130	;$1530
        level_overlay_colors    = level_data+$160	;$1560
        level_overlay_sprite    = level_data+$190	;$1590

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

	ldx	#22
	jsr	common_delay_scanlines


	;=============================
	; now at VBLANK scanline 23
	;=============================
	; copy in hand sprite
	; takes 4 scanlines

	jsr	hand_copy
; 6

	;=============================
	; now at VBLANK scanline 27
	;=============================
	; 4 scanlines of handling input

	jsr	hand_motion
; 6

	;=======================
	; now scanline 31
	;========================
	; increment frame
	; setup missile0 location
; 6
	lda	$80				; nop3			; 3
	ldx	LEVEL_MISSILE0_COARSE					; 3
	beq	no_missile0						; 2/3
; 14
mlevel_pad:
	dex								; 2
	bne	mlevel_pad	; (X*5)-1 = 14				; 2/3

		; 9 = (8*5)-1 = 39 + 14 = 53
		; 10 = (9*5)-1 = 44 + 14 = 58
		; 11 = (10*5)-1 = 49 + 14 =64

; 64 max
	sta	RESM0							; 3
; 67

; max=73

no_missile0:
	sta	WSYNC							; 3

	;=======================
	; now scanline 32
	;========================
	; increment frame
	; setup missile0 location
; 0
	ldx	LEVEL_MISSILE0_COARSE					; 3
	beq	really_no_missile0					; 2/3

	ldx	#2			; enable missile		; 2
	stx	ENAM0							; 3

	lda	LEVEL_MISSILE0_FINE	; fine adjust overlay		; 3
	sta	HMM0							; 3

really_no_missile0:
	sta	WSYNC							; 3


	;=============================
	; now VBLANK scanline 33
	;=============================
	; do some init

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

	;=======================
	; now VBLANK scanline 34
	;=======================

	;====================================================
	; set up sprite1 (overlay) to be at proper X position
	;====================================================
	; now in setup scanline 0

; 0
	nop								; 2
	nop								; 2
; 4
	ldx	LEVEL_OVERLAY_COARSE					; 3
	inx			;					; 2
	inx			;					; 2
; 11
qpad_x:
	dex			;					; 2
	bne	qpad_x		;					; 2/3
				;===========================================
				;	(5*COASRE+2)-1

	; beam is at proper place
	sta	RESP1							; 3

	lda	LEVEL_OVERLAY_FINE	; fine adjust overlay		; 3
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
	; now vblank 35,36
	;==========================================
	; set up sprite to be at proper X position
	;==========================================
; 0

	lda	POINTER_X
	ldx	#POS_SPRITE0
	jsr	set_pos_x

	sta	WSYNC

wait_le_sp0:
	dey
	bpl	wait_le_sp0

	sta	RESP0

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
	ldx	#0		; init hand visibility			; 2
; 66
	stx	VBLANK		; turn on beam				; 3
; 69
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

	ldx	#15
	jsr	common_overscan

	;==================================
	; overscan 27, general stuff

	lda	#$0							; 2
	sta	ENAM0		; disable missile 0			; 3
	sta	WSYNC


	;=======================================
	; clock stuff


clock_update = $1000

	lda	E7_SET_BANK6
	jsr	clock_update
	sta	E7_SET_BANK7_RAM


	;==========================================
	; update the clockface if it changed

update_clock_face:
; 0

	ldx	#8							; 2
update_clock_loop:

	lda	CLOCKFACE_0,X						; 4
	sta	level_overlay_sprite_write+8,X				; 5

	dex								; 2
	bpl	update_clock_loop					; 2/3

; (9*14)-1 = 129??

done_update_clock:

	sta	WSYNC


	;==================================
	; overscan 28, update sound

	jsr	update_sound		; 56 cycles?

	lda	#0							; 2
	sta	POINTER_GRABBING					; 3
	sta	WAS_CLICKED

	sta	WSYNC

	;==================================
	; overscan 29, update pointer
;0
	ldx	POINTER_X						; 3
	ldy	POINTER_Y						; 3

	; not needed as A=0 from above
;	lda	#POINTER_TYPE_POINT

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
	lda	#POINTER_TYPE_GRAB					; 3
	inc	POINTER_GRABBING					; 5
;	bne	level_done_update_pointer	; bra			; 3
								; 26 worst case
; 39

not_grabbing:

	ldy	POINTER_COLOR		; if page skip pointer type 	; 3
	beq	pointer_not_page					; 2/3
	lda     #POINTER_TYPE_PAGE	; if color then page		; 2
pointer_not_page:

	; need to do this to over-ride turn pointer if grabbing

	ldy	POINTER_GRABBING
	bne	level_done_update_pointer


	;==================================
	; check if want left/right pointer

	ldy	LEVEL_LEFT_DEST						; 3
	bmi	level_not_left						; 2/3

	; POINTER_X is in X from way before

	cpx	#32							; 2
	bcs	level_not_left						; 2/3
	lda	#POINTER_TYPE_LEFT					; 2
	jmp	level_done_update_pointer				; 3
level_not_left:

	ldy	LEVEL_RIGHT_DEST					; 3
	bmi	level_done_update_pointer				; 2/3

	cpx	#128							; 2
	bcc	level_done_update_pointer				; 2/3
	lda	#POINTER_TYPE_RIGHT					; 2

level_done_update_pointer:
	sta	POINTER_TYPE						; 3

        sta     WSYNC

	;==================================
	;==================================
	; overscan 30, handle button press
	;==================================
	;==================================

	lda	INPUT_COUNTDOWN						; 3
	beq	waited_enough_level					; 2/3
	dec	INPUT_COUNTDOWN						; 5
	jmp	done_check_level_input					; 3

waited_enough_level:

	lda	INPT4			; check if joystick button pressed
	bmi	done_check_level_input

	;====================================
	; reset input countdown for debounce

	lda	#12
	sta	INPUT_COUNTDOWN

	;======================
	; button was pressed

	lda	POINTER_GRABBING	; secial case if grabbing
	bne	clicked_grab

	lda	POINTER_TYPE
	and	#$3			; map "page" and "point (fwd)" to same
	tax

	lda	LEVEL_CENTER_DEST,X

	bmi	done_check_level_input	; if $FF then ignore

	;=====================
	; start new level
start_new_level:
	sta	CURRENT_LOCATION
	jmp	load_new_level




	;==========================
	; clicked grab
	;==========================
clicked_grab:
	ldx	CURRENT_LOCATION
	cpx	#8			; if level >8 not switch
	bcc	handle_switch
	cpx	#12
	bcc	handle_book	; if level>8 && <12 then book

	; otherwise, special grab

	sec
	txa
	sbc	#12			; get offset
	tax

	; set up jump table fakery
handle_special:
	lda	grab_dest_h,X
	pha
	lda	grab_dest_l,X
	pha
	rts				; jump to location


handle_book:

;	jsr	do_book

	jmp	load_new_level

handle_switch:
	ldy	#SFX_CLICK		; play sound
	sty	SFX_PTR

	; toggle switch
	lda	powers_of_two,X
	eor	SWITCH_STATUS
	sta	SWITCH_STATUS

	; Switch to white page if switch from $FF to $7F

	cmp	#$7f
	bne	done_check_level_input

	lda	#POINTER_COLOR_WHITE
	sta	POINTER_COLOR

done_check_level_input:

	sta	WSYNC

	jmp	level_frame



powers_of_two:
.byte	$01,$02,$04,$08, $10,$20,$40,$80


grab_dest_l:
	.byte	<(grab_atrus-1)
	.byte	<(grab_fireplace-1)
	.byte	<(grab_clock-1)
	.byte	<(grab_bookshelf-1)
	.byte	<(grab_close_painting-1)
	.byte	<(grab_open_painting-1)

grab_dest_h:
	.byte	>(grab_atrus-1)
	.byte	>(grab_fireplace-1)
	.byte	>(grab_clock-1)
	.byte	>(grab_bookshelf-1)
	.byte	>(grab_close_painting-1)
	.byte	>(grab_open_painting-1)

	;=========================
	; giving atrus the page
grab_atrus:
	lda	WHITE_PAGE_COUNT
	beq	havent_given_page_yet

	; myst linking book instead
	jmp	handle_book

havent_given_page_yet:
	; if have white page, goto good ending
	lda	POINTER_COLOR
	cmp	#POINTER_COLOR_WHITE
	bne	trapped_with_atrus

	; "good" ending
trapped_on_myst:

	; give white page to atrus
	inc	WHITE_PAGE_COUNT
	lda	#0
	sta	POINTER_COLOR

	lda	#LOCATION_YOU_WIN
	jmp	start_new_level

trapped_with_atrus:
	; else, trapped
	lda	#LOCATION_TRAPPED
	jmp	start_new_level


	; grabbed the puzzle in the fireplace
grab_fireplace:
;	lda	#LOCATION_BEHIND_FIREPLACE
;	jmp	start_new_level

	inc	WAS_CLICKED
	jmp	done_check_level_input

	; grabbed the clock
grab_clock:
	jmp	done_check_level_input

	; grabbed the bookshelf
grab_bookshelf:
	jmp	done_check_level_input

	; grabbed close door painting
grab_close_painting:
	lda	#0
	beq	common_painting

	; grabbed open door painting
grab_open_painting:
	lda	#1
common_painting:
	sta	DOOR_OPEN
	ldy	#SFX_RUMBLE		; play sound
	sty	SFX_PTR

	jmp	done_check_level_input




