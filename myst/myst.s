; Myst for Atari 2600

; by Vince `deater` Weaver <vince@deater.net>

.include "../vcs.inc"

; defines
POINTER_HEIGHT	= 16

; zero page addresses

TITLE_COLOR	=	$80

POINTER_ON	=	$81
POINTER_X	=	$82
POINTER_Y	=	$83
POINTER_X_COARSE=	$84
POINTER_X_END	=	$85
POINTER_Y_END	=	$86

TEMP1		=	$90
TEMP2		=	$91
FRAME		=	$92
CURRENT_SCANLINE=	$93
LEVEL		=	$94
INPUT_COUNTDOWN	=	$95
POINTER_TYPE	=	$96
	POINTER_TYPE_POINT	= $00
	POINTER_TYPE_GRAB	= $01
	POINTER_TYPE_LEFT	= $02
	POINTER_TYPE_RIGHT	= $03

INL		=	$9E
INH		=	$9F

PF0L_CACHE	=	$A0
PF1L_CACHE	=	$A1
PF2L_CACHE	=	$A2
PF0R_CACHE	=	$A3
PF1R_CACHE	=	$A4
PF2R_CACHE	=	$A5

HAND_SPRITE	=	HAND_SPRITE_LINE0
HAND_SPRITE_LINE0=	$E0
HAND_SPRITE_LINE1=	$E1
HAND_SPRITE_LINE2=	$E2
HAND_SPRITE_LINE3=	$E3
HAND_SPRITE_LINE4=	$E4
HAND_SPRITE_LINE5=	$E5
HAND_SPRITE_LINE6=	$E6
HAND_SPRITE_LINE7=	$E7
HAND_SPRITE_LINE8=	$E8
HAND_SPRITE_LINE9=	$E9
HAND_SPRITE_LINE10=	$EA
HAND_SPRITE_LINE11=	$EB
HAND_SPRITE_LINE12=	$EC
HAND_SPRITE_LINE13=	$ED
HAND_SPRITE_LINE14=	$EE
HAND_SPRITE_LINE15=	$EF




myst:
	sei		; disable interrupts
	cld		; clear decimal bit

;	ldx	#$ff
;	txs		; point stack to $1FF (mirrored at top of zero page)

restart_game:


	; init zero page and addresses to 0

	ldx	#0
	txa
clear_loop:
	sta	$0,X
	inx
	bne	clear_loop
	dex
	txs

	lda	#2
	sta	VBLANK	; disable beam



	;===========================
	;===========================
	; title
	;===========================
	;===========================

	.include "title.s"

	;===========================
	;===========================
	; cleft
	;===========================
	;===========================

	.include "cleft.s"

	;===========================
	;===========================
	; linking book
	;===========================
	;===========================

	.include "book.s"

	;===========================
	;===========================
	; clock
	;===========================
	;===========================

	.include "clock.s"

	;===========================
	; common routines
	;===========================

	.include "adjust_sprite.s"
	.include "common_routines.s"
	.include "hand_motion.s"
	.include "hand_copy.s"

.align $100

.include "myst_data.inc"

.segment "IRQ_VECTORS"
	.word myst	; NMI
	.word myst	; RESET
	.word myst	; IRQ
