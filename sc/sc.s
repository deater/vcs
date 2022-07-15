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

; some defines

STRONGBAD_HEIGHT	=	8
VID_LOGO_START		=	181

; zero page addresses

STRONGBAD_X		=	$80
STRONGBAD_Y		=	$81
OLD_STRONGBAD_X		=	$82
OLD_STRONGBAD_Y		=	$83
STRONGBAD_Y_END		=	$84
OLD_STRONGBAD_Y_END	=	$85
STRONGBAD_X_END		=	$86
OLD_STRONGBAD_X_END	=	$87
STRONGBAD_X_COARSE	=	$88
CURRENT_SCANLINE	=	$89
FRAME			=	$8A
LEVEL			=	$8B

INL			=	$8C
INH			=	$8D
SCORE_LOW		=	$8E
SCORE_HIGH		=	$8F


TEMP1			=	$90
TEMP2			=	$91

TIME			=	$92
TIME_SUBSECOND		=	$93
LEVEL_OVER		=	$94
BACKGROUND_COLOR	=	$95
MANS			=	$96
ZAP_BASE		=	$97
ZAP_COLOR		=	$98
ZAP_OFFSET		=	$99

SFX_RIGHT		=	$9A
SFX_LEFT		=	$9B
SOUND_TO_PLAY		=	$9C
TITLE_COLOR		=	$9D
DONE_TITLE		=	$9E
BASE_TITLE_COLOR	=	$9F

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

TEXT_COLOR		=	$AE

MANS_SPRITE_0		=	$B0
MANS_SPRITE_1		=	$B1
MANS_SPRITE_2		=	$B2
MANS_SPRITE_3		=	$B3
MANS_SPRITE_4		=	$B4
MANS_SPRITE_5		=	$B5
MANS_SPRITE_6		=	$B6

LEVEL_SPRITE0		=	$C0
LEVEL_SPRITE1		=	$C1
LEVEL_SPRITE2		=	$C2
LEVEL_SPRITE3		=	$C3
LEVEL_SPRITE4		=	$C4
LEVEL_SPRITE5		=	$C5
LEVEL_SPRITE6		=	$C6
LEVEL_SPRITE7		=	$C7
LEVEL_SPRITE8		=	$C8
LEVEL_SPRITE9		=	$C9
LEVEL_SPRITE10		=	$CA
LEVEL_SPRITE11		=	$CB
LEVEL_SPRITE12		=	$CC
LEVEL_SPRITE13		=	$CD
LEVEL_SPRITE14		=	$CE
LEVEL_SPRITE15		=	$CF

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

title_screen:

	.include "title_screen.s"



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

.repeat 14
	sta	WSYNC
.endrepeat

	;=============================
	; now at VBLANK scanline 18
	;=============================
	; update score/mans/level values

	; 14 scanlines
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

	lda	STRONGBAD_X_END						; 3
	sta	OLD_STRONGBAD_X_END					; 3
	lda	STRONGBAD_Y_END						; 3
	sta	OLD_STRONGBAD_Y_END					; 3

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

	lda	STRONGBAD_X_END		;				; 3
	cmp	#167			;				; 2
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

	jsr	strongbad_moved_vertically	; 			; 6+16
after_check_up:
	sta	WSYNC			; 				; 3
					;	===============================
					; 			11 / 18 / 44

	;==========================
	; now VBLANK scanline 32
	;==========================
	; handle down being pressed

	lda	STRONGBAD_Y_END		;				; 3
	cmp	#VID_LOGO_START		;				; 2
	bcs	after_check_down	;				; 2/3

	lda	#$20			;				; 2
	bit	SWCHA			;				; 3
	bne	after_check_down	;				; 2/3

	inc	STRONGBAD_Y		; move sprite down		; 5
	jsr	strongbad_moved_vertically	;			; 6+16
after_check_down:
	sta	WSYNC			;				; 3
					;	==============================
					; 			11 / 18 / 44

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

	ldx	ZAP_BASE

	and	#$1
	beq	done_rotate_zap

	dec	ZAP_BASE						; 5
	ldx	ZAP_BASE						; 3
	cpx	#$7f							; 2
	bcs	done_rotate_zap						; 2/3
	ldx	#$AF							; 2
	stx	ZAP_BASE						; 3
done_rotate_zap:
	stx	ZAP_COLOR						; 3
dont_rotate_zap:

;	dec	ZAP_BASE
;	lda	ZAP_BASE
;	and	#$3F
;	sta	ZAP_BASE
;	sta	ZAP_COLOR

                                                                ;============
                                                                ; 20 worse case


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

	; draw part of the playfield level #

	lda	#$0	; 2
	sta	PF0	; 3
	; after 28
	inc	TEMP1
	inc	TEMP1
	inc	TEMP1
	inc	TEMP1
	inc	TEMP1
	lda	LEVEL_SPRITE8
	sta	PF0

	sta	WSYNC

	; draw part of the playfield level #

	lda	#$0	; 2
	sta	PF0	; 3
	; after 28
	inc	TEMP1
	inc	TEMP1
	inc	TEMP1
	inc	TEMP1
	inc	TEMP1
	lda	LEVEL_SPRITE9
	sta	PF0

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

	.repeat 27
	sta	WSYNC
	.endrepeat

	;==================================
	; overscan 28, trigger sound

	ldy	SOUND_TO_PLAY
	beq	no_sound_to_play

	jsr	trigger_sound		; 6+40

	ldy	#0
	sty	SOUND_TO_PLAY
no_sound_to_play:
	sta	WSYNC

	;==================================
	; overscan 29, update sound

	.include "sound_update.s"
	sta	WSYNC

	;==================================
	; overscan 30, collision detection

	lda	CXPPMM			; check if p0/p1 collision
	bpl	no_collision_secret
collision_secret:
	inc	LEVEL_OVER
	ldy	#SFX_COLLECT
;	ldy	#SFX_GAMEOVER
	sty	SOUND_TO_PLAY
	jmp	collision_done

no_collision_secret:

	lda	CXP0FB			; check if p0/pf collision
	bpl	no_collision_wall
collision_wall:
	lda	OLD_STRONGBAD_X
	sta	STRONGBAD_X
	lda	OLD_STRONGBAD_Y
	sta	STRONGBAD_Y

	lda	OLD_STRONGBAD_X_END
	sta	STRONGBAD_X_END
	lda	OLD_STRONGBAD_Y_END
	sta	STRONGBAD_Y_END

;	ldy	#SFX_ZAP
	ldy	#SFX_COLLIDE
	sty	SOUND_TO_PLAY

no_collision_wall:


collision_done:
	sta	WSYNC

	jmp	start_frame

.include	"adjust_sprite.s"
.include	"init_game.s"
.include	"init_level.s"
.include	"sound_trigger.s"

; data, which has alignment constraints
.include	"game_data.s"

.byte "by Vince `deater` Weaver <vince@deater.net>"

.segment "IRQ_VECTORS"
	.word start	; NMI
	.word start	; RESET
	.word start	; IRQ
