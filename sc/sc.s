; secret collect.
;
; based on the Videlectrix game from Homestarrunner.com
;

; by Vince `deater` Weaver	<vince@deater.net>

; 10 pixels for score
; 10 pixels for MANS
; 10 pixels for time bar
; 152 pixels for playfield?
; 10 pixels for VIDELECTRIX


.include "../vcs.inc"

SPRITE_WIDTH	=	8
SPRITE_HEIGHT	=	10
BOTTOM_LAYER_HEIGHT =	20
SPRITE_ANIMATION_FRAME_COUNT = 1
SPRITE_TOTAL_FRAME_LINES = SPRITE_ANIMATION_FRAME_COUNT * SPRITE_HEIGHT

VID_LOGO_START	=	181

; zero page addresses

STRONGBAD_X		=	$80
STRONGBAD_Y		=	$81
STRONGBAD_END_Y		=	$82
SPRITE0_RIGHT_X		=	$83
STRONGBAD_X_COARSE	=	$84
SPRITE0_PIXEL_OFFSET	=	$85
CURRENT_SCANLINE	=	$86
FRAME			=	$87

TEMP1			=	$90
TEMP2			=	$91

TIME			=	$92
TIME_SUBSECOND		=	$93

LEVEL_OVER		=	$94

MANS			=	$96

start:
	;============================
	;============================
	; initial init
	;============================
	;============================

	cld			; clear decimal mode

	ldx	#$FF		; set stack to $1FF (mirrored at $FF)
	txs

	jsr	init_game

	jsr	init_level

start_frame:

	;============================
	; Start Vertical Blank
	;============================

	lda	#0
	sta	VBLANK			; turn on beam

	lda	#2			; reset beam to top of screen
	sta	VSYNC

	;=================================
	; wait for 3 scanlines of VSYNC
	;=================================

	sta	WSYNC			; wait until end of scanline
	sta	WSYNC
	sta	WSYNC

	; now in VSYNC scanline 3

	lda	#0			; done beam reset
	sta	VSYNC



	;=================================
	;=================================
	; 37 lines of vertical blank
	;=================================
	;=================================

.repeat 28
	sta	WSYNC
.endrepeat

	;=============================
	; now at VBLANK scanline 28
	;=============================

	sta	WSYNC							; 3
								;============
								;	24
	;=============================
	; now at VBLANK scanline 29
	;=============================
	; handle left being pressed

	lda	STRONGBAD_X		;				; 3
	beq	after_check_left	;				; 2/3

	lda	#$40			; check left			; 2
	bit	SWCHA			;				; 3
	bne	after_check_left	;				; 2/3

left_pressed:
	dec	STRONGBAD_X		; move sprite left		; 5

after_check_left:
	sta	WSYNC			;				; 3
					;	============================
					;	 		9 / 20 / 16

	;=============================
	; now at VBLANK scanline 30
	;=============================
	; handle right being pressed

	lda	SPRITE0_RIGHT_X		;				; 3
	cmp	#160+SPRITE_WIDTH-3	;				; 2
	bcs	after_check_right	;				; 2/3

	lda	#$80			; check right			; 2
	bit	SWCHA			;				; 3
	bne	after_check_right	;				; 2/3

	inc	STRONGBAD_X		; move sprite right		; 5
after_check_right:
	sta	WSYNC			;				; 3
					;	===========================
					; 			11 / 22 / 18

	;===========================
	; now at VBLANK scanline 31
	;===========================
	; handle up being pressed

	lda	STRONGBAD_Y		;				; 3
	cmp	#1			;				; 2
	beq	after_check_up		;				; 2/3

	lda	#$10			; check up			; 2
	bit	SWCHA			;				; 3
	bne	after_check_up		;				; 2/3

	dec	STRONGBAD_Y		; move sprite up		; 5

	jsr	spr0_moved_vertically	; 				; 6+17
after_check_up:
	sta	WSYNC			; 				; 3
					;	===============================
					; 			11 / 18 / 45

	;==========================
	; now VBLANK scanline 32
	;==========================
	; handle down being pressed

	lda	STRONGBAD_END_Y		;				; 3
	cmp	#VID_LOGO_START		;				; 2
	bcs	after_check_down	;				; 2/3

	lda	#$20			;				; 2
	bit	SWCHA			;				; 3
	bne	after_check_down	;				; 2/3

	inc	STRONGBAD_Y		; move sprite down		; 5
	jsr	spr0_moved_vertically	;				; 6+17
after_check_down:
	sta	WSYNC			;				; 3
					;	==============================
					; 			11 / 18 / 45

	;==========================
	; now VBLANK scanline 33
	;==========================
	; update horizontal position

	; do this separately as too long to fit in with left/right code

	jsr	spr0_moved_horizontally	;				6+49
	sta	WSYNC			;				3
					;====================================
					;				58

	;========================
	; now VBLANK scanline 34
	;========================
	; set up sprite to be at proper X position

	; we can do this here and the sprite will be drawn as a long
	; vertical column
	; later we only enable it for the lines we want

	ldx	#0		; sprite 0 display nothing		2
	stx	GRP0		; (FIXME: this already set?)		3

	ldx	STRONGBAD_X_COARSE	;				3
	inx			;					2
	inx			;					2
pad_x:
	dex			;					2
	bne	pad_x		;					2/3
				;===========================================
				;	12-1+5*(coarse_x+2)
				; FIXME: describe better what's going on

	; beam is at proper place
	sta	RESP0							; 3

	sta	WSYNC							; 3
	sta	HMOVE		; adjust fine tune, must be after WSYNC	; 3
				; also draws black artifact on left of
				; screen

	;=======================
	; now scanline 35
	;========================
	; increment frame
	; handle any frame-related activity

	inc	FRAME							; 5
;	lda	#15							; 2
;	bit	FRAME							; 3

;	bne	done_frame_count					; 2/3

	sta	WSYNC							; 3


	;=============================
	; now VBLANK scanline 36
	;=============================
	; do some init

	ldx	#$00
	stx	COLUBK		; set background color to black

	lda	#0
	sta	CURRENT_SCANLINE	; reset scanline counter

	sta	WSYNC

	; now scanline 37

	;===============================
	;===============================
	;===============================
	; visible area: 192 lines (NTSC)
	;===============================
	;===============================
	;===============================

	;============================
	;============================
	; draw score, 8 scanlines
	;============================
	;============================

	.include "score.s"

	;============================
	;============================
	; draw MANS, 10 scanlines
	;============================
	;============================

	.include "mans.s"

	;============================
	;============================
	; draw timer bar, 9 scanlines
	;============================
	;============================

	jsr	draw_timer_bar

	;===========================
	; set up playfield
	;===========================
	; 1 scanline

	lda	#28
	sta	CURRENT_SCANLINE

	lda	#$C2			; green
	sta	COLUPF			; playfield color

	lda	#CTRLPF_REF		; reflect playfield
	sta	CTRLPF



	; reset back to strongbad sprite

	lda	#$40		; dark red				; 2
	sta	COLUP0		; set sprite color			; 3

	lda	#NUSIZ_ONE_COPY						; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1							; 3

	lda	#0							; 2
	sta	VDELP0							; 3
	sta	VDELP1							; 3




	sta	WSYNC


	; now at scanline 28

	;===========================================
	;===========================================
	; draw playfield, 192-28-10 = 154 scanlines
	;===========================================
	;===========================================
draw_playfield:

	;========================================
	; activate strongbad sprite if necessary

	; draw playfield
	lda	CURRENT_SCANLINE
	sec
	sbc	#28
	lsr
	lsr
	tax
	lda	playfield0_left,X	;				; 4+
        sta	PF0			;				; 3
        lda	playfield1_left,X	;				; 4+
        sta	PF1			;				; 3
        lda	playfield2_left,X	;				; 4+
        sta	PF2			;				; 3

	lda	CURRENT_SCANLINE
	; A = current scanline
	cmp	STRONGBAD_END_Y						; 3
	bcs	turn_off_sprite0					; 2/3
	cmp	STRONGBAD_Y						; 3
	bcc	turn_off_sprite0					; 2/3
turn_on_sprite0:
	lda	#$F0			; load sprite data		; 2
	sta	GRP0			; and display it		; 3
	iny				; increment			; 2
	jmp	after_sprite						; 3
turn_off_sprite0:
	lda	#0			; turn off sprite		; 2
	sta	GRP0							; 3
after_sprite:

	inc	CURRENT_SCANLINE					; 5
	sta	WSYNC							; 3

	inc	CURRENT_SCANLINE					; 5
	sta	WSYNC							; 3

	inc	CURRENT_SCANLINE					; 5
	sta	WSYNC							; 3

	inc	CURRENT_SCANLINE					; 5
	lda	CURRENT_SCANLINE					; 3
	cmp	#180			; draw 154 lines		; 2
	sta	WSYNC							; 3
	bcc	draw_playfield						; 2/3



	;=========================================
	;=========================================
	; draw Videlectrix Logo sprite (12 lines)
	;=========================================
	;=========================================

	.include "vid_logo.s"


	;=============================================
	; vertical blank
	;=============================================
vertical_blank:
	lda	#$42		; enable INPT4/INPT5, turn off beam
	sta	VBLANK

	;===========================
	;===========================
	; overscan (30 cycles)
	;===========================
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
	lda	STRONGBAD_X		;			3

	pha				;			3
	adc	SPRITE_WIDTH		;			3
	sta	SPRITE0_RIGHT_X		;			3
	pla				;			4

	; spritex DIV 16

	lsr				;			2
	lsr				;			2
	lsr				;			2
	lsr				;			2
	sta	STRONGBAD_X_COARSE	;			3

	; apply fine adjust
	lda	STRONGBAD_X		;			3
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
	lda	STRONGBAD_Y		;				3
	adc	SPRITE_HEIGHT		;				3
	sta	STRONGBAD_END_Y	;				3
	rts				;				6
					;=================================
					;				17


.include	"init_game.s"
.include	"init_level.s"
.include	"timer_bar.s"

; data, which has alignment constraints
.include	"game_data.s"

.segment "IRQ_VECTORS"
	.word start	; NMI
	.word start	; RESET
	.word start	; IRQ
