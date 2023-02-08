; Make the Apple II logo on an Atari 2600
; try to fit in 1k?

; by Vince `deater` Weaver <vince@deater.net>

; $830 -- original code
; $730 -- remove playfield_right2 (always 0)
; $530 -- remove playfield_left0 (always 0)
; $486 -- skip first 9 lines (always 0)
; $3ff -- only read color every 1/3 line
; $38D -- only read playfield_left1 every 1/3 line
; $31A -- only read playfield_right1 every 1/3 line
; $2A8 -- more compact encoding
; $29C -- overlap some of the playfield data

; TODO: Music?
;	Animated sine wave down sides?
;	Forever text

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




apple_tiny_start:

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


.include "atari_code.s"

;jmp	blah

.include "music_code.s"
.include "music_data.s"

.align	$100
blah:
.include "apple_code.s"
.include "music_data2.s"

.include "apple_data.s"
.include "atari_data.s"


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
	.word apple_tiny_start	; NMI
	.word apple_tiny_start	; RESET
	.word apple_tiny_start	; IRQ







