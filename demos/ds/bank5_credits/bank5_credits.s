; credits for demo

; by Vince `deater` Weaver <vince@deater.net>

.include "../../../vcs.inc"

.include "../zp.inc"

.include "../common_routines.inc"
.include "../timing.inc"


; font 4x8, 6 columns
;	128 rows


;	2A= 42 lines / 8 = 5


do_credits:

	; clear to black

	lda	#0
	tax
clear_loop:
	sta	$1800,X
	dex
	bne	clear_loop

	; setup

	lda	#<code_string
	sta	INL
	lda	#>code_string
	sta	INH

	lda	#0

	jsr	print_string

	lda	#<deater_string
	sta	INL
	lda	#>deater_string
	sta	INH

	lda	#10

	jsr	print_string

	lda	#<music_string
	sta	INL
	lda	#>music_string
	sta	INH

	lda	#22

	jsr	print_string

	lda	#<miker_string
	sta	INL
	lda	#>miker_string
	sta	INH

	lda	#32

	jsr	print_string




	; comes in at unknown cycles, w/o last WSYNC


start_credits:

	;=================
	; start VBLANK
	;=================
	; this code takes 4 scanlines, it does a WSYNC soon after
	;       to ensure 3 scanlines total
	; this means it's really stealing one of the previous frame's lines

	jsr	common_vblank

; 9
	; now 9 cycles in

	;=============================
	; 37 lines of vertical blank
	;=============================

	ldx	#24
	jsr	repeat_wsync

	;================================
	; play music -- scanlines 25..35
	;================================
        ; takes 11 lines?

	lda	#5		; our bank
	jsr	do_play_music

	;===================
	; now scanline 35
	;===================
	; center the sprite position
	; needs to be right after a WSYNC
; 0
	jsr	inc_frame

	sta	WSYNC

	;=======================
	; scanline 36

	sta	WSYNC

	;=======================
	; scanline 37 -- config
; 0
	ldy	#0							; 2
	ldx	#0							; 2
	stx	GRP0							; 3
	stx	GRP1							; 3
	stx	CTRLPF		; unreflect playfield
	stx	COLUBK		; background color			; 3

	lda	#$0e
	sta	COLUPF

	ldx	#0							; 2
	stx	REFP1			; don't reflect sprite1		; 3

	stx	VBLANK			; turn on beam			; 3

	sta	WSYNC

	;=============================================
	;=============================================
	; draw framebuffer
	;=============================================
	;=============================================
	; 42

	;===========================
	; scanline 0 -- configure
	;===========================
	; configure 48-pixel sprite code

	; make playfield black
	nop
	lda	#$00		; black					; 2
	sta	COLUPF		; playfield color			; 3
	sta	GRP0		; turn off sprites			; 3
	sta	GRP1		;					; 3
	sta	PF0		; turn off playfield so don't collide	; 3
	sta	PF1		;					; 3

	sta	SPRITE_OFFSET

	lda	#CTRLPF_REF
	sta	CTRLPF

	lda	#$fc
	sta	PF2		;					; 3

; 22
	; set color

	lda	#$0E		; bright white				; 2
	sta	COLUP0		; set sprite color			; 3
	sta	COLUP1		; set sprite color			; 3
; 31
	; set to be 48 adjacent pixels

	lda	#NUSIZ_THREE_COPIES_CLOSE				; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1							; 3
; 39
	; turn on delay

	lda	#1							; 2
	sta	VDELP0							; 3
	sta	VDELP1							; 3
; 47
	; number of lines to draw
	ldx	#42							; 2
	stx	SPRITE_LENGTH							; 3
; 52
	sta	WSYNC							; 3

	;====================================
	; now scanline 1 -- center sprite
	;====================================
	; center the sprite position
	; needs to be right after a WSYNC
; 0
	; to center exactly would want sprite0 at
	;	CPU cycle 41.3
	; and sprite1 at
	;	GPU cycle 44

	ldx	#0		; sprite 0 display nothing		; 2
	stx	GRP0		;					; 3

	ldx	#6h		;					; 2
; 7

tpad_x:
	dex			;					; 2
	bne	tpad_x		;					; 2/3
	; for X delays (5*X)-1
	; so in this case, 29
; 36
	; beam is at proper place
	sta	RESP0							; 3
	; 39 (GPU=??, want ??) +?
; 39
	sta	RESP1							; 3
	; 42 (GPU=??, want ??) +?
; 42

	lda	#$E0		; opposite what you'd think		; 2
	sta	HMP0							; 3
	lda	#$F0							; 2
	sta	HMP1							; 3
; 52
	sta	WSYNC
; 0
	sta	HMOVE		; adjust fine tune, must be after WSYNC
; 3


	;===================
	; now scanline 2
	;===================

	ldx	SPRITE_OFFSET	; restore sprite offset

	sta	WSYNC

	;==========================
	; now scanline 3+(0..41)
	;==========================

title_spriteloop:
; 0
	lda	$1900,X			; load sprite0 data		; 4+
	sta	GRP0			; 0->[GRP0] [GRP1 (?)]->GRP1	; 3
; 7
	lda	$192A,X			; load sprite1 data		; 4+
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3
; 14
	lda	$1954,X			; load sprite2 data		; 4+
	sta	GRP0			; 2->[GRP0], [GRP1 (1)]-->GRP1	; 3
; 21

	lda	$19D2,X			; sprite5			; 4+
	sta	TEMP1			; save for later		; 3
; 28
	lda	$19A8,X			; sprite4			; 4+
	tay				; save in Y			; 2
; 34
	lda	$197E,X			; sprite3			; 4+
	ldx	TEMP1			; restore saved value		; 3
; 41

	sta	GRP1			; 3->[GRP1], [GRP0 (2)]-->GRP0	; 3
	; (need this to be 44 .. 46)
; 44
	sty	GRP0			; 4->[GRP0], [GRP1 (3)]-->GRP1	; 3
	; (need this to be 47 .. 49)
; 47
	stx	GRP1			; 5->[GRP1], [GRP0 (4)]-->GRP0	; 3
	; (need this to be 50 .. 51)
; 50
	sty	GRP0			; ?->[GRP0], [GRP1 (5)]-->GRP1 	; 3
	; (need this to be 52 .. 54)
; 53

	; need 9 cycles of nops
	lda	$80
	lda	$80
	lda	$80


; 62
	inc	SPRITE_OFFSET						; 5
	ldx	SPRITE_OFFSET						; 3
	cpx	SPRITE_LENGTH						; 3
; 73
	bne	title_spriteloop					; 2/3
	; 76  (goal is 76)


; 75
	;=========================
	; done drawing line
	; 3+(42)

	ldy	#0		; clear out sprite data			; 2
	sty	GRP1							; 3
	sty	GRP0							; 3
	sty	GRP1							; 3

	lda	#$0		; end the black window
	sta	PF2

	sta	WSYNC


	; scanilne 46



	;=============================
	; draw bottom lines

	ldx	#146
	jsr	repeat_wsync



done_loop:

; 75

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



	;=================================
	; print_string
	;=================================
	; string is in INL,INH
	; line  is in A

	; cycles = (20-1)+6*((38-1)+8*31)+17)
	;	  19+6*(54+248)
	;	=1831
	;	1831/76=25 scanlines

print_string:

	sta	OUTL							; 3

	lda	#>E7_256B_WRITE_ADDR					; 2
	sta	OUTH							; 3

	lda	#>simple_font						; 2
	sta	FONT2H							; 3
	sta	FONTH							; 3

	ldx	#0		; 6*2 chars wide			; 2
	ldy	#0							; 2
; 20

font_outer_loop:

	txa			; load column offset			; 2
	asl								; 2
	tay								; 2
	lda	(INL),Y							; 5
; 11
	asl								; 2
	asl								; 2
	asl								; 2
	sta	FONTL							; 3
; 20
	iny								; 2
	lda	(INL),Y							; 5
; 27
	asl								; 2
	asl								; 2
	asl								; 2
	sta	FONT2L							; 3
; 36
	ldy	#0							; 2
; 38
font_inner_loop:
	lda	(FONTL),Y						; 5
	and	#$f0							; 2
	sta	TEMP							; 3
	lda	(FONT2L),Y						; 5
	and	#$0f							; 2
	ora	TEMP							; 3
; 20
	sta	(OUTL),Y						; 6
	iny								; 2
	cpy	#8							; 2
	bne	font_inner_loop						; 2/3
; 31

	clc								; 2
	lda	OUTL							; 3
	adc	#(42)							; 2
	sta	OUTL							; 3
; 10
	inx								; 2
	cpx	#6							; 2
	bmi	font_outer_loop						; 2/3
; 17
	rts


	;==========================
	; graphics
	;==========================

code_string:
	.byte FONT_CLEFT,FONT_CRIGHT,FONT_O,FONT_D,FONT_E,FONT_SPACE
	.byte FONT_B,FONT_Y,FONT_COLON,FONT_SPACE,FONT_SPACE,FONT_SPACE

deater_string:
	.byte FONT_SPACE, FONT_SPACE, FONT_SPACE, FONT_SPACE, FONT_SPACE, FONT_DLEFT
	.byte FONT_DRIGHT, FONT_E, FONT_A, FONT_T, FONT_E, FONT_R

music_string:
	.byte FONT_MLEFT,FONT_MRIGHT,FONT_U,FONT_S,FONT_I,FONT_C
	.byte FONT_SPACE,FONT_B,FONT_Y,FONT_COLON,FONT_SPACE,FONT_SPACE

miker_string:
	.byte FONT_SPACE,FONT_SPACE,FONT_SPACE,FONT_SPACE,FONT_SPACE,FONT_SPACE
	.byte FONT_MLEFT,FONT_MRIGHT,FONT_I,FONT_K,FONT_E,FONT_R


	.include "simple_font.inc"


