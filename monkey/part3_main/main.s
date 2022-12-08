; Monkey Island (Main)

.include "../../vcs.inc"

; zero page addresses

.include "../zp.inc"

; Common routines, try not to mess with or we need to re-gen
.include "common_routines.s"

        ;===================================
        ; music code, wouldn't fit in part2
.include "chapter_variables.s"
.include "handle_music.s"
.include "chapter_trackdata.s"
	;===================================
	; 48-pixel sprite data

fine_adjust_table:
        ; left
        .byte $70,$60,$50,$40,$30,$20,$10,$00
        ; right -1 ... -8
        .byte $F0,$E0,$D0,$C0,$B0,$A0,$90,$80

.align $100
.include "cart_message.inc"

.include "title_words.inc"


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

	jsr	$F000		; do_opening
.endif

	;=====================
	; show title

.if 1
	; we want page2 at $1000, page3 at $1400, and page4 at $1C00
	lda	$1FE2
	lda	$1FEB
	lda	$1FF4

;	lda	#$5
;	sta	FRAMEL
;	lda	#$80
;	sta	FRAMEL


	jsr	$F000			; do_title

.endif
	;=====================
	; Do ending

	; We want page0 at $1005 and page6 at $1400

.if 1

	lda	#$28			; for testing
	sta	FRAMEH
	lda	#$80
	sta	FRAMEL

	lda	$1FE5
	lda	$1FEE

	jsr	$F000			; do_level
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
