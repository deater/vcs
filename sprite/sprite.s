; sample sprite code
;	based on code by Sebastian Mihai


.include "../vcs.inc"

SPRITE_WIDTH	=	8
SPRITE_HEIGHT	=	10
BOTTOM_LAYER_HEIGHT =	20
SPRITE_ANIMATION_FRAME_COUNT = 2
SPRITE_TOTAL_FRAME_LINES = SPRITE_ANIMATION_FRAME_COUNT * SPRITE_HEIGHT

; zero page addresses

SPRITE0_TOP_Y		=	$80
SPRITE0_BOTTOM_Y	=	$81
SPRITE0_LEFT_X		=	$82
SPRITE0_RIGHT_X		=	$83
SPRITE0_LEFT_X_COARSE	=	$84
SPRITE0_PIXEL_OFFSET	=	$85
CURRENT_SCANLINE	=	$86
FRAME_COUNTER		=	$87

start:
	cld		; clear decimal mode
	ldx	#$FF
	txs		; set stack to $FF

	lda	#$0F
	sta	COLUP0	; set sprite color

	lda	#$00				; set initial x position
	sta	SPRITE0_LEFT_X
	jsr	spr0_moved_horizontally		;		6+49

	lda	#1				; initial sprite Y
	sta	SPRITE0_TOP_Y
	jsr	spr0_moved_vertically

	lda	#0
	sta	SPRITE0_PIXEL_OFFSET
	sta	FRAME_COUNTER

start_frame:

	;============================
	; Start Vertical Blank
	;============================

	lda	#0
	sta	VBLANK

	lda	#2			; reset beam to top of screen
	sta	VSYNC

	;=================================
	; wait for 3 scanlines of VSYNC
	;=================================

	sta	WSYNC			; wait until end of scanline
	sta	WSYNC
	sta	WSYNC

	lda	#0			; done beam reset
	sta	VSYNC

	;=================================
	; 37 lines of vertical blank
	;=================================

.repeat 29
	sta	WSYNC
.endrepeat

	;=============================
	; now at scanline 30

	; handle left being pressed

	lda	SPRITE0_LEFT_X		;			3
	beq	after_check_left	;			2/3

	lda	#$40			; check left		2
	bit	SWCHA			;			3
	bne	after_check_left	;			2/3

left_pressed:
	dec	SPRITE0_LEFT_X		; move sprite left	5

after_check_left:
	sta	WSYNC			;			3
					;============================
					; 9 / 20 / 16 cycles

	;========================
	; now at scanline 31

	; handle right being pressed

	lda	SPRITE0_RIGHT_X		;			3
	cmp	#160+SPRITE_WIDTH-3	;			2
	bcs	after_check_right	;			2/3

	lda	#$80			; check right		2
	bit	SWCHA			;			3
	bne	after_check_right	;			2/3

	inc	SPRITE0_LEFT_X		; move sprite right	5
after_check_right:
	sta	WSYNC			;			3
					;===========================
					; 11 / 22 / 18

	;=======================
	; now at scaline 32

	; see if up pressed

	lda	SPRITE0_TOP_Y		;			3
	cmp	#1			;			2
	beq	after_check_up		;			2/3

	lda	#$10			; check up		2
	bit	SWCHA			;			3
	bne	after_check_up		;			2/3

	dec	SPRITE0_TOP_Y		; move sprite up	5

	jsr	spr0_moved_vertically	; 			6+17
after_check_up:
	sta	WSYNC			; 			3
					;=================================
					; 11 / 18 / 45

	;=====================
	; now scanline 33

	lda	SPRITE0_BOTTOM_Y	;			3
	cmp	#192 - BOTTOM_LAYER_HEIGHT - 1	;		2
	bcs	after_check_down	;			2/3

	lda	#$20			;			2
	bit	SWCHA			;			3
	bne	after_check_down	;			2/3

	inc	SPRITE0_TOP_Y		; move sprite down	5
	jsr	spr0_moved_vertically	;			6+17
after_check_down:
	sta	WSYNC			;			3
					;==============================
					; 11 / 18 / 45

	;===================
	; now scanline 34

	; do this separately as too long to fit in with left/right code

	jsr	spr0_moved_horizontally	;			6+49
	sta	WSYNC			;			3
					;============================
					;			58

	;====================
	; now scanline 35


	; set up sprite to be at proper X position
	; we can do this here and the sprite will be drawn as a long
	; vertical column
	; later we only enable it for the lines we want

	ldx	#0		; sprite 0 display nothing	2
	stx	GRP0		;				3

	ldx	SPRITE0_LEFT_X_COARSE	;			3
	inx			;				2
	inx			;				2
pad_x:
	dex			;				2
	bne	pad_x		;				2/3
				;==================================
				;	12-1+5*(coarse_x+2)
				; FIXME: what's going on here

	; beam is at proper place
	sta	RESP0

	sta	WSYNC
	sta	HMOVE		; adjust fine tune, must be after WSYNC

	;=======================
	; now scanline 36

	; handle animated sprite
	inc	FRAME_COUNTER	;			5
	lda	#15		;			2
	bit	FRAME_COUNTER	;			3

	bne	done_frame_count	;		2/3

	; advance frame

	clc					;	2
	lda	SPRITE0_PIXEL_OFFSET		;	3
	adc	SPRITE_HEIGHT			;	3
	cmp	SPRITE_TOTAL_FRAME_LINES	;	3
	bne	store_animation_frame		;	2/3

	lda	#0	; return to begin	;	2
store_animation_frame:
	sta	SPRITE0_PIXEL_OFFSET		;	3
done_frame_count:
	lda	#0				;	2
	sta	CURRENT_SCANLINE		;	3
	ldy	SPRITE0_PIXEL_OFFSET		;	3

	sta	WSYNC				;	3
done_animation_frame:

	;=============================
	; now scanline 37

	sta	WSYNC

	;=============================================
	; visible area: 192 lines (NTSC) / 228 (PAL)
	;=============================================

;	ldx	#0
;colorful_loop:
;	stx	COLUBK
;	sta	WSYNC
;	inx
;	cpx	#192
;	bne	colorful_loop

	ldx	#$80
	stx	COLUBK		; set background

visible_loop:

	; A = current scanline
	cmp	SPRITE0_BOTTOM_Y
	bcs	turn_off_sprite
	cmp	SPRITE0_TOP_Y
	bcc	turn_off_sprite
turn_on_sprite:
	lda	sprite_bitmap,Y		; load sprite data
	sta	GRP0			; and display it
	iny				; increment
	jmp	after_sprite
turn_off_sprite:
	lda	#0			; turn off sprite
	sta	GRP0
after_sprite:

	inc	CURRENT_SCANLINE
	lda	CURRENT_SCANLINE
	cmp	#192-BOTTOM_LAYER_HEIGHT
	sta	WSYNC
	bne	visible_loop

	; draw bottom graphics
	ldx	#$B1
bottom_scan:
	cmp	#192
	beq	vertical_blank
	inx
	inx
	inx
	inx
	stx	COLUBK

	inc	CURRENT_SCANLINE
	lda	CURRENT_SCANLINE
	sta	WSYNC
	bne	bottom_scan

vertical_blank:
	lda	#$42		; enable INPT4/INPT5, start vert blank
	sta	VBLANK

	;===========================
	; overscan
	;===========================

	ldx	#0
overscan_loop:
	sta	WSYNC
	inx
	cpx	#30
	bne	overscan_loop

	jmp	start_frame

;================================
;================================
; spr0 moved horizontally
;================================
;================================
; call after X changes
;	compute horiz fine adjust

spr0_moved_horizontally:
	clc				;			2
	lda	SPRITE0_LEFT_X		;			3

	pha				;			3
	adc	SPRITE_WIDTH		;			3
	sta	SPRITE0_RIGHT_X		;			3
	pla				;			4

	; spritex DIV 16

	lsr				;			2
	lsr				;			2
	lsr				;			2
	lsr				;			2
	sta	SPRITE0_LEFT_X_COARSE	;			3

	; apply fine adjust
	lda	SPRITE0_LEFT_X		;			3
	and	#$0f			;			2
	tax				;			2
	lda	fine_adjust_table,X	;			4+
	sta	HMP0			;			3
	rts				;			6
					;==========================
					;			49


;================================
;================================
; spr0 moved vertically
;================================
;================================
; call after Y changes

spr0_moved_vertically:
	clc				;				2
	lda	SPRITE0_TOP_Y		;				3
	adc	SPRITE_HEIGHT		;				3
	sta	SPRITE0_BOTTOM_Y	;				3
	rts				;				6
					;=================================
					;				17

.align	$100

sprite_bitmap:
	.byte	$AA
	.byte	$55
	.byte	$AA
	.byte	$55
	.byte	$AA
	.byte	$55
	.byte	$AA
	.byte	$55
	.byte	$AA
	.byte	$55

sprite_bitmap2:
	.byte	$55
	.byte	$AA
	.byte	$55
	.byte	$AA
	.byte	$55
	.byte	$AA
	.byte	$55
	.byte	$AA
	.byte	$55
	.byte	$AA


fine_adjust_table:
	; left
	.byte $70
	.byte $60
	.byte $50
	.byte $40
	.byte $30
	.byte $20
	.byte $10
	.byte $00
	; right
	.byte $F0	; -1
	.byte $E0	; -2
	.byte $D0	; -3
	.byte $C0	; -4
	.byte $B0	; -5
	.byte $A0	; -6
	.byte $90	; -7
	.byte $80	; -8 (?)



.segment "IRQ_VECTORS"
	.word start	; NMI
	.word start	; RESET
	.word start	; IRQ


