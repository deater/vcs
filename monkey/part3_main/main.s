; Monkey Island (Main)

.include "../../vcs.inc"

; zero page addresses

.include "../zp.inc"

; Common routines, try not to mess with or we need to re-gen
.include "common_routines.s"



monkey:
	;=============================
	; clear out mem / init things
	;=============================
	; initialize the 6507
	;	and clear RAM
	;==========================

	sei			; disable interrupts			; 2
	cld			; clear decimal mode			; 2
	ldx	#0							; 2
	txa								; 2
clear_loop:
	dex								; 2
	txs								; 2
	pha								; 3
	bne	clear_loop						; 2/3
						;============================
	; S = $FF, A=$0, x=$0, Y=??		;       8+(256*10)-1=2567 / 10B

	;=====================
	; show opening


	; map in ROM

	; We want page0 at $1000 and page1 at $1400

.if 0
	lda	$1FE0
	lda	$1FE9

;	jsr	do_opening
	jsr	$F000
.endif

	;=====================
	; show title

.if 0
	; we want page2 at $1000, page3 at $1400, and page4 at $1C00
	lda	$1FE2
	lda	$1FEB
	lda	$1FF4

;	jsr	do_title
	jsr	$F000
.endif
	;=====================
	; Do ending

	; We want page0 at $1005 and page6 at $1400

.if 1
	lda	$1FE5
	lda	$1FEE

;	jsr	do_level
	jsr	$F000
.endif




	;=====================
	; Part 1
;	jsr	part1_trials

	;=====================
	; Cart message
;	jsr	do_cart_message

	;=====================
	; Recycle

	jmp	monkey




; NOTE: need to reserve from $1FE0 on or else stomp on bank switch

.segment "IRQ_VECTORS"
	.word monkey	; NMI
	.word monkey	; RESET
	.word monkey	; IRQ
