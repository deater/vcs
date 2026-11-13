; credits for demo

; by Vince `deater` Weaver <vince@deater.net>

.include "../../../vcs.inc"

.include "../zp.inc"

.include "../common_routines.inc"
.include "../timing.inc"


; 256/6 = 42 = $2A

; 00, 2A, 54, 7E, A8, D2

do_credits:
	ldx	#0
lloop:
	lda	font_zeros,X
	sta	$1800,X
	lda	font_ones,X
	sta	$182A,X
	lda	font_twos,X
	sta	$1854,X
	lda	font_threes,X
	sta	$187E,X
	lda	font_fours,X
	sta	$18A8,X
	lda	font_fives,X
	sta	$18D2,X


	inx
	cpx	#7
	bne	lloop


	rts


do_credits2:

	; comes in at unknown cycles, w/o last WSYNC


start_credits:

	;=============================
	; Start Vertical Blank

	lda	#2
	sta	VBLANK

	jsr	common_vblank

	; now 9 cycles in

	;=============================
	; 37 lines of vertical blank
	;=============================

	ldx	#25
	jsr	repeat_wsync

	;================================
	; play music -- scanlines 26..36
	;================================
        ; takes 11 lines?

	lda	#5		; our bank
	jsr	do_play_music

	;=============================
	; scanline 36
	;=============================
	jsr	inc_frame
	sta	WSYNC

	;=======================
	; scanline 37 -- ???

	ldx	#0
	stx	VBLANK
	sta	WSYNC

	;============================================
	;============================================
	; playfield
	;============================================
	;============================================


	;===================================
	; 256 bank
	;===================================

	ldy	#0
	jsr	print_string

	ldy	#0
	jsr	print_byte

	; comes back +6 cycles

;	ldx	#1
;	jsr	update_row_color

	sta	WSYNC

	;===================================
	; 1k bank
	;===================================

	ldy	#1
	jsr	print_string

	ldy	#1
	jsr	print_byte

	; comes back +6 cycles

;	ldx	#2
;	jsr	update_row_color

	sta	WSYNC

	;===================================
	; 256 read
	;===================================

	ldy	#2
	jsr	print_string

	ldx	#4
	ldy	#5
	jsr	print_word

	; comes back +6 cycles

;	ldx	#3
;	jsr	update_row_color

	sta	WSYNC


	;===================================
	; 256 write
	;===================================

	ldy	#3
	jsr	print_string

	ldx	#6
	ldy	#7
	jsr	print_word

	; comes back +6 cycles

;	ldx	#4
;	jsr	update_row_color

	sta	WSYNC

	;===================================
	; 1k read
	;===================================

	ldy	#4
	jsr	print_string

	ldx	#8
	ldy	#9
	jsr	print_word

	; comes back +6 cycles

;	ldx	#5
;	jsr	update_row_color

	sta	WSYNC


	;===================================
	; 1k write
	;===================================

	ldy	#5
	jsr	print_string

	ldx	#$A
	ldy	#$B
	jsr	print_word

	; comes back +6 cycles

;	ldx	#6
;	jsr	update_row_color

	sta	WSYNC

	;===================================
	; write value
	;===================================

	ldy	#6
	jsr	print_string

	ldy	#2
	jsr	print_byte

	; comes back +6 cycles

;	ldx	#7
;	jsr	update_row_color

	sta	WSYNC


	;===================================
	; read_value
	;===================================

	ldy	#7
	jsr	print_string

	ldy	#3
	jsr	print_byte

	; comes back +6 cycles

;	ldx	#0
;	jsr	update_row_color

	sta	WSYNC


	;=============================================
	;=============================================
	; pad out end
	;=============================================
	;=============================================

	ldx	#26
	jsr	repeat_wsync


	;==========================
	;==========================
	; overscan
	;==========================
	;==========================

	ldx	#29
	jsr	common_overscan


	lda	FRAMEL
	cmp	#CREDITS_TIME_L
	bne	not_done_credits
	lda	FRAMEH
	cmp	#CREDITS_TIME_H
	beq	done_credits

not_done_credits:

	jmp	start_credits

done_credits:

	rts

;============================================

	.include "print_word.s"
	.include "print_byte.s"
	.include "print_string.s"
	.include "update_byte.s"
	.include "center_string.s"

	;==========================
	; graphics
	;==========================
;.align $100
	.include "strings.inc"
	.include "number_font.inc"

