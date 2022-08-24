; testing rr music player

.include "../vcs.inc"

; zero page addresses

SCANLINE		=	$86
FRAME_COUNTER		=	$87
TEMP1			=	$90
TEMP2			=	$91



start:
	cld		; clear decimal mode

	ldx	#0
	txa
clear_loop:
	sta	$0,X
	inx
	bne	clear_loop
	dex
	txs	; point stack to $1FF (mirrored at top of zero page)


.include "rr_player_framework.s"



.segment "IRQ_VECTORS"
	.word start	; NMI
	.word start	; RESET
	.word start	; IRQ


