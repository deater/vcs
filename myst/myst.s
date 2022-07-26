; Myst for Atari 2600

; by Vince `deater` Weaver <vince@deater.net>

.include "../vcs.inc"

; defines
POINTER_HEIGHT	= 16

; zero page addresses

TITLE_COLOR	=	$80
ZAP_COLOR	=	$81

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

PF0L_CACHE	=	$A0
PF1L_CACHE	=	$A1
PF2L_CACHE	=	$A2
PF0R_CACHE	=	$A3
PF1R_CACHE	=	$A4
PF2R_CACHE	=	$A5


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

;	.include "book.s"

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

.align $100

.include "myst_data.inc"

.segment "IRQ_VECTORS"
	.word myst	; NMI
	.word myst	; RESET
	.word myst	; IRQ
