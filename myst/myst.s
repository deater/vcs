; Myst for Atari 2600

; by Vince `deater` Weaver <vince@deater.net>

.include "../vcs.inc"

; defines
STRONGBAD_HEIGHT	= 8
VID_LOGO_START		= 182

; zero page addresses

TITLE_COLOR	=	$80
ZAP_COLOR	=	$81

STRONGBAD_X	=	$82
STRONGBAD_Y	=	$83
STRONGBAD_X_COARSE=	$84
STRONGBAD_X_END	=	$85
STRONGBAD_Y_END	=	$86

TEMP1		=	$90
TEMP2		=	$91
FRAME		=	$92
CURRENT_SCANLINE=	$93
LEVEL		=	$94

PF0L_CACHE	=	$A0
PF1L_CACHE	=	$A1
PF2L_CACHE	=	$A2
PF0R_CACHE	=	$A3
PF1R_CACHE	=	$A4
PF2R_CACHE	=	$A5


myst:
	sei		; disable interrupts
	cld		; clear decimal bit
	ldx	#$ff
	txs		; point stack to top of zero page

	; clear out the Zero Page (RAM and TIA registers)

	ldx	#0
	txa
clear_loop:
	sta	$0,X
	inx
	bne	clear_loop

	;===========================
	;===========================
	; title
	;===========================
	;===========================

	.include "title.s"


	;===========================
	;===========================
	; clock
	;===========================
	;===========================

	.include "clock.s"


	.include "adjust_sprite.s"

.align $100

.include "myst_data.inc"

.segment "IRQ_VECTORS"
	.word myst	; NMI
	.word myst	; RESET
	.word myst	; IRQ
