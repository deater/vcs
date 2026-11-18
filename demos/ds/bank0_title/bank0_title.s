; title screen

.include "../../../vcs.inc"

; zero page addresses

.include "../zp.inc"

.include "../common_routines.inc"
.include "../timing.inc"

	;=======================
        ; title screen
        ;=======================

do_title:

.include "frame1_init.s"

; ? / 24
start_title:

	;=================
	; start VBLANK
	;=================
	; this code takes 4 scanlines, it does a WSYNC soon after
	;	to ensure 3 scanlines total
	; this means it's really stealing one of the previous frame's lines

	jsr	common_vblank
; 9

	;=============================
	;=============================
	; 37 lines of vertical blank
	;=============================
	;=============================


	;=============================
	; scanlines 0..21 (unused)
	;=============================
        ldx     #22
	jsr	repeat_wsync

; 8
	;===============================
	; scanlines 22-33 -- play music
	;===============================
	; takes 11 lines, doesn't WSYNC at end

	lda	#0		; our bank
	jsr	do_play_music
	sta	WSYNC


	;====================
	; now in scanline 34
	;====================
	; increment frame

	jsr	inc_frame	; 48 cycles
        sta     WSYNC


	;=======================
	; scanline 35
	;=======================
	; first time

	lda	FIRST_TIME
	beq	skip_first_time
first_time_init:
	dec	FIRST_TIME

	lda	#0
	sta	EFFECTL
	sta	EFFECTH
	sta	WHICH_EFFECT

skip_first_time:
	sta	WSYNC

	;===================
	; now scanline 36
	;===================
	; more init

	lda	#0
	sta	PF0
	sta	PF1
	sta	PF2

	lda	EFFECTH
	sta	WHICH_EFFECT

	tax
	sta	E7_SET_256_BANK0,X

	sta	WSYNC

	;=======================
	; scanline 37 -- config
	;=======================
; 0
	ldy	#0							; 2
	ldx	#0							; 2
	stx	GRP0							; 3
	stx	GRP1							; 3
	stx	CTRLPF			; reset playfield		; 3

; 13
;	lda	#$1E
;	lda	BASE_TITLE_COLOR					; 3
;	sta	TITLE_COLOR						; 3
; 19
;	lda	BACKGROUND_COLOR					; 3
	lda	#$0
	sta	COLUBK							; 3
	sta	VBLANK			; turn on beam			; 3

; 25
	sta	WSYNC



	;=============================================
	;=============================================
	;=============================================
	; draw logo
	;=============================================
	;=============================================
	;=============================================
	; draw 192 lines
	; need to race beam to draw other half of playfield



	;=============================================
	; draw 74 lines of nothing
	;=============================================
	ldx	#74
top_gradient_loop:
	lda	WHICH_EFFECT
	cmp	#3
	bcc	skip_top_gradient

	txa
	adc	FRAMEL
	lsr
	lsr
	sta	COLUBK
skip_top_gradient:
	dex
	sta	WSYNC
	bne	top_gradient_loop

; 8
	; clean WSYNC for alignment

	lda	#0
	sta	COLUBK

	lda	$1900,X			;	preload			; 

	sta	WSYNC

	;=============================================
	; draw 41 lines of logo
	;=============================================



title_loop:
; 0
	nop								; 2
	sta	COLUPF			; set playfield color		; 3
	lda	$1900+42,X						; 4
	sta	COLUBK			; set background color		; 3

; 12
	lda	desire1_playfield0_left,X	;			; 4
	sta	PF0				;			; 3

	; must write by CPU 22 [GPU 68]
; 19
	lda	desire1_playfield1_left,X	;			4+
	sta	PF1				;			3
	; must write by CPU 28 [GPU 84]
; 26
	lda	desire1_playfield2_left,X	;			4+
	sta	PF2				;			3
	; must write by CPU 38 [GPU 116]
; 33
	lda	desire1_playfield0_right,X	;			4+
	sta	PF0				;			3
	; must write by CPU 49 [GPU 148]
; 40
	lda	desire1_playfield1_right,X	;			4+
	sta	PF1				;			3
	; must write by CPU 54 [GPU 164]
; 47
	nop					;			2
	lda	$80				; nop3			3

; 52
	lda	desire1_playfield2_right,X	;			4+
	sta	PF2				;			3
	; must write by CPU 65 [GPU 196]
; 59

	iny								; 2
	inx								; 2
	lda	$1900,X			;	preload			; 4

; 67
	nop								; 2
	nop								; 2

; 71
	cpy	#41							; 2
	bne	title_loop						; 2/3

; 76

done_loop:

; 75

	;===================
	; scanline 75+41
	;===================
	; clear playfield

	lda	#0
	sta	PF0
	sta	PF1
	sta	PF2
	sta	WSYNC


	;=============================================
	; draw 75 lines of gradient
	;=============================================

	lda	#0
	sta	COLUBK
	sta	WSYNC

	ldx	#0
bottom_gradient_loop:
	lda	WHICH_EFFECT
	cmp	#3
	bcc	skip_bottom_gradient

	txa
	adc	FRAMEL
	lsr
	lsr
	sta	COLUBK
skip_bottom_gradient:
	inx
	sta	WSYNC
	cpx	#74
	bne	bottom_gradient_loop



	;==========================
	;==========================
	;==========================
	; overscan for 30 scanlines
	;==========================
	;==========================
	;==========================

	ldx	#29
	jsr	common_overscan						; 10

; 10
	lda	FRAMEL							; 3
	cmp	#TITLE_TIME_L						; 2
	bne	not_done_title						; 2/3
; 17
	lda	FRAMEH							; 3
	cmp	#TITLE_TIME_H						; 2
	beq	done_title						; 2/3

; 21
not_done_title:

	jmp	start_title						; 3
done_title:
; 25
	rts

; 31

.include "checkers.s"

.include "desire_pf.inc"

.include "colors1.inc"
.include "colors2.inc"
.include "colors3.inc"


	;==========================
	; copy to 256 84
	;==========================
	; src is in INL,INH
	; X is which 256 page

	; 7-1+6++84*17 = 1440/76= 18.94
	;	plus overhead really 20

copy_to_256_84:
	sta	E7_SET_256_BANK0,X					; 5
	ldy	#0							; 2
copy_256_84_loop:
	lda	(INL),Y							; 5
	sta	$1800,Y							; 5
	iny								; 2
	cpy	#84							; 2
	bne	copy_256_84_loop					; 2/3

	sta	WSYNC

	rts
