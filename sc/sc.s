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
SPRITE_HEIGHT	=	8
SPRITE_ANIMATION_FRAME_COUNT = 1
SPRITE_TOTAL_FRAME_LINES = SPRITE_ANIMATION_FRAME_COUNT * SPRITE_HEIGHT

VID_LOGO_START	=	181

; zero page addresses

STRONGBAD_X		=	$80
STRONGBAD_Y		=	$81
OLD_STRONGBAD_X		=	$82
OLD_STRONGBAD_Y		=	$83
STRONGBAD_END_Y		=	$84
SPRITE0_RIGHT_X		=	$85
STRONGBAD_X_COARSE	=	$86
CURRENT_SCANLINE	=	$87
FRAME			=	$88
ZAP_COLOR		=	$89

INL			=	$8A
INH			=	$8B
SCORE_LOW		=	$8C
SCORE_HIGH		=	$8D


TEMP1			=	$90
TEMP2			=	$91

TIME			=	$92
TIME_SUBSECOND		=	$93

LEVEL_OVER		=	$94

MANS			=	$96

SCORE_SPRITE_LOW_0	=	$A0
SCORE_SPRITE_LOW_1	=	$A1
SCORE_SPRITE_LOW_2	=	$A2
SCORE_SPRITE_LOW_3	=	$A3
SCORE_SPRITE_LOW_4	=	$A4
SCORE_SPRITE_LOW_5	=	$A5
SCORE_SPRITE_LOW_6	=	$A6

SCORE_SPRITE_HIGH_0	=	$A7
SCORE_SPRITE_HIGH_1	=	$A8
SCORE_SPRITE_HIGH_2	=	$A9
SCORE_SPRITE_HIGH_3	=	$AA
SCORE_SPRITE_HIGH_4	=	$AB
SCORE_SPRITE_HIGH_5	=	$AC
SCORE_SPRITE_HIGH_6	=	$AD

MANS_SPRITE_0		=	$B0
MANS_SPRITE_1		=	$B1
MANS_SPRITE_2		=	$B2
MANS_SPRITE_3		=	$B3
MANS_SPRITE_4		=	$B4
MANS_SPRITE_5		=	$B5
MANS_SPRITE_6		=	$B6

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

.repeat 16
	sta	WSYNC
.endrepeat

	;=============================
	; now at VBLANK scanline 18
	;=============================
	; update score/mans values

	; 12 scanlines
	.include "update_score.s"

	;=============================
	; now at VBLANK scanline 28
	;=============================
	; stuff for collision detection

	; save old X/Y in case we have a collision
	lda	STRONGBAD_X						; 3
	sta	OLD_STRONGBAD_X						; 3
	lda	STRONGBAD_Y						; 3
	sta	OLD_STRONGBAD_Y						; 3

	sta	WSYNC							; 3
								;============
								;	15
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
	; check if level over

	lda	LEVEL_OVER						; 3
	beq	level_good

	dec	MANS							; 5
	jsr	init_level					;6+alot

level_good:
	sta	WSYNC



	;========================
	; now VBLANK scanline 34
	;========================
	; empty for now

	sta	WSYNC



	;=======================
	; now scanline 35
	;========================
	; increment frame
	; handle any frame-related activity
; 0
	inc	FRAME							; 5
	lda	FRAME							; 3
; 8

	; update zap color
	; every other frame?

	and	#$1
	beq	done_rotate_zap

	inc	ZAP_COLOR                                               ; 5
	lda	ZAP_COLOR                                               ; 3
	cmp	#$A0                                                    ; 2
	bcc	done_rotate_zap						; 2/3
	lda	#$80                                                    ; 2
	sta	ZAP_COLOR                                               ; 3
done_rotate_zap:
                                                                ;============
                                                                ; 17 worse case

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

	; at VISIBLE scanline 8

	;============================
	;============================
	; draw MANS, 7 scanlines
	;============================
	;============================

	sta	WSYNC
	sta	WSYNC
	.include "mans.s"
	sta	WSYNC

	; at VISIBLE scanline 10

	;============================
	;============================
	; draw timer bar, (6 scanlines)
	;============================
	;============================

	.include	"timer_bar.s"

	;============================================================
	; draw playfield (4 scanlines setup + 152 scanlines display)
	;============================================================

	.include "level1_playfield.s"

	;=========================================
	;=========================================
	; draw Videlectrix Logo sprite (11 lines)
	;=========================================
	;=========================================

	.include "vid_logo.s"

	sta	WSYNC

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

	.repeat 29
	sta	WSYNC
	.endrepeat

	;==================================
	; overscan 30, collision detection

	lda	CXPPMM			; check if p0/p1 collision
	bpl	no_collision_secret
collision_secret:
	inc	LEVEL_OVER
no_collision_secret:

	lda	CXP0FB			; check if p0/pf collision
	bpl	no_collision_wall
collision_wall:
	lda	OLD_STRONGBAD_X
	sta	STRONGBAD_X
	lda	OLD_STRONGBAD_Y
	sta	STRONGBAD_Y

no_collision_wall:
	sta	WSYNC

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

; data, which has alignment constraints
.include	"game_data.s"

.byte "by Vince `deater` Weaver <vince@deater.net>"

.segment "IRQ_VECTORS"
	.word start	; NMI
	.word start	; RESET
	.word start	; IRQ
