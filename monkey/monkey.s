; Monkey Island

.include "../vcs.inc"

; zero page addresses

.include "zp.inc"



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


	; =========================
	; Initialize music.
	; Set tt_cur_pat_index_c0/1 to the indexes of the first patterns from
	; tt_SequenceTable for each channel.
	; Set tt_timer and tt_cur_note_index_c0/1 to 0.
	; All other variables can start with any value.
	; =========================

	lda	#0
	sta	tt_cur_pat_index_c0
	lda	#14
	sta	tt_cur_pat_index_c1


	;=======================
	; more init

.include "monkey_variables.s"


	;=====================
	; show opening

	jsr	do_opening

	;=====================
	; show title

	jsr	do_title

	;=====================
	; play game

;	jsr	do_level

	;=====================
	; Part 1
;	jsr	part1_trials

	;=====================
	; Cart message
;	jsr	do_cart_message

	;=====================
	; Recycle

	jmp	monkey


	;=====================
	; other includes

.include "handle_music.s"
.include "opening.s"
;.include "cart.s"
.align $100
;.include "trials.s"
;.include "level_engine.s"
.include "title.s"

.include "common_routines.s"

.align	$100
.include "lucas.inc"
.align $100
.include "title.inc"

.align $100
;.include "lookout.inc"
.align $100
;.include "cart_message.inc"
.align $100
;.include "trials.inc"
;.include "lookout_over.inc"

.include "monkey_trackdata.s"

.segment "IRQ_VECTORS"
	.word monkey	; NMI
	.word monkey	; RESET
	.word monkey	; IRQ
