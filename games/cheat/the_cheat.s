; the cheat?

; by Vince `deater` Weaver <vince@deater.net>

.include "../../vcs.inc"


; zero page addresses

TEXT_COLOR		=	$80
MAIN_COLOR              =       $81
LINE_COLOR              =       $82
FRAME                   =       $83
FRAMEH                  =       $84
FRAME2                  =       $85
MUSIC_POINTER		=	$86
MUSIC_COUNTDOWN		=	$87
MUSIC_PTR_L		=	$88
MUSIC_PTR_H		=	$89

TEMP1			=	$90
TEMP2			=	$91
DIV3			=	$92
XSAVE			=	$93




the_cheat_start:

	;=======================
	; clear registers/ZP/TIA
	;=======================

	sei			; disable interrupts
	cld			; clear decimal mode
	ldx	#0
	txa
clear_loop:
	dex
	txs
	pha
	bne	clear_loop

	; S = $FF, A=$0, x=$0, Y=??

	;=========================
	; title
	;=========================

	.include "title.s"

blah:
	jmp	blah

.include "title_pf.inc"
.align $100
.include "title_sprites.inc"

	;====================
	; scanline wait
	;====================
	; scanlines to wait in X

scanline_wait:
	sta	WSYNC
	dex						; 2
	bne	scanline_wait				; 2/3
	rts						; 6

	;==================
	; increment frame
	;==================
	; worst case 18
inc_frame:
	inc	FRAME					; 5
	bne	no_inc_high				; 2/3
	inc	FRAMEH					; 5
no_inc_high:
	rts						; 6


.segment "IRQ_VECTORS"
	.word the_cheat_start	; NMI
	.word the_cheat_start	; RESET
	.word the_cheat_start	; IRQ







