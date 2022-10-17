; Monkey Island

.include "../vcs.inc"

; zero page addresses

.include "zp.inc"



monkey:

	;==========================
	; initialize the 6506
	;	and clear RAM
	;==========================

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
	; show opening

	jsr	do_opening

	;=====================
	; show title

;	jsr	do_title

	;=====================
	; play game

;	jsr	do_game

	;=====================
	; Part 1
	jsr	part1_trials

	;=====================
	; Cart message
	jsr	do_cart_message

	;=====================
	; Recycle

	jmp	monkey


	;=====================
	; other includes

.include "opening.s"
.include "cart.s"
.align $100
.include "trials.s"

.include "common_routines.s"

.align	$100
.include "lucas.inc"
.align $100
.include "cart_message.inc"
.align $100
.include "trials.inc"

;.include "rr_trackdata.s"

.segment "IRQ_VECTORS"
	.word monkey	; NMI
	.word monkey	; RESET
	.word monkey	; IRQ
