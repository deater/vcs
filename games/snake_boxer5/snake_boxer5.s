; Snake Boxer5

; based on the Videlectrix game

; by Vince `deater` Weaver <vince@deater.net>

.include "../../vcs.inc"

; zero page addresses

FRAME	=	$80

INL	=	$84
INH	=	$85

TEMP1	=	$90
TEMP2	=	$91

start:
	sei		; disable interrupts
	cld		; clear decimal bit


restart_game:

	; init zero page and addresses to 0

	ldx	#0
	txa
clear_loop:
	dex
	txs
	pha
	bne	clear_loop

	; S=$FF, A=$00, X=$00, Y=??


	.include "title_screen.s"


done_forever:
	jmp	done_forever


.align $100

.include "title.inc"
.include "snake_sprite.inc"

.include "common_routines.s"

.segment "IRQ_VECTORS"
	.word start	; NMI
	.word start	; RESET
	.word start	; IRQ


