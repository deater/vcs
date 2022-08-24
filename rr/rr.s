; testing rr music player

.include "../vcs.inc"

; zero page addresses

.include "zp.inc"



rr:
	cld		; clear decimal mode

	ldx	#0
	txa
clear_loop:
	sta	$0,X
	inx
	bne	clear_loop
	dex
	txs	; point stack to $1FF (mirrored at top of zero page)


	;=====================
	; show title

	jsr	do_title

	;=====================
	; show fake game

	;=====================
	; play music


.include "rr_player_framework.s"

.include "title_screen.s"

.include "common_routines.s"

.include "game_data.inc"

.segment "IRQ_VECTORS"
	.word rr	; NMI
	.word rr	; RESET
	.word rr	; IRQ


