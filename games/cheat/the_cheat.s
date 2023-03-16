; the cheat?

; by Vince `deater` Weaver <vince@deater.net>

.include "../../vcs.inc"


; zero page addresses

TEXT_COLOR		=	$80
MAIN_COLOR              =       $81
LINE_COLOR              =       $82
FRAME                   =       $83
FRAMEH                  =       $84
FRAME2                  =       $85
MUSIC_POINTER		=	$86
MUSIC_COUNTDOWN		=	$87
MUSIC_PTR_L		=	$88
MUSIC_PTR_H		=	$89

TEMP1			=	$90
TEMP2			=	$91
DIV3			=	$92
XSAVE			=	$93




the_cheat_start:

	;=======================
	; clear registers/ZP/TIA
	;=======================

	sei			; disable interrupts
	cld			; clear decimal mode
	ldx	#0
	txa
clear_loop:
	dex
	txs
	pha
	bne	clear_loop

	; S = $FF, A=$0, x=$0, Y=??


title_loop:

	;=========================
	; Start Vertical Blank
	;=========================

	lda	#2			; reset beam to top of screen
	sta	VSYNC

	; wait for 3 scanlines of VSYNC

	sta	WSYNC			; wait until end of scanline
	sta	WSYNC

	dec	MAIN_COLOR		; rotate colors
	lda	MAIN_COLOR		; copy over main color
	sta	LINE_COLOR

	sta	WSYNC

	lda	#0			; done beam reset
	sta	VSYNC

	; 37 lines of vertical blank

	ldx	#36
	jsr	scanline_wait		; Leaves X zero
; 10

	;===========================
	; 36

	 ; apply fine adjust

	lda	#$e0
        sta     HMP0			; sprite0 + 2

	lda	#$20
        sta     HMP1			; sprite1 - 2

	sta	RESP0			; coasre sprite0

	lda	#$40			; red
	sta	COLUP0
	sta	COLUP1

	ldx	#6
atari_right_loop:
	dex
	bne	atari_right_loop

	nop								; 2
	lda	$00			; nop3				; 3

	sta	RESP1			; coarse sprite1

        sta     WSYNC                   ;                               3
	sta	HMOVE


	;=============================
	; 37


	lda	#$00
	sta	PF0
	sta	PF1
	sta	PF2


;	lda	#<music_len		; set up music pointer
;	sta	MUSIC_PTR_L
;	lda	#>music_len
;	sta	MUSIC_PTR_H

	jsr	inc_frame				; 6+18

	sta	WSYNC

	stx	VBLANK			; turn on beam (X=0)


	;===========================
	;===========================
	; playfield
	;===========================
	;===========================
	; draw 192 lines


	;===========================
	; first 15 lines blue
	;===========================
	lda	#$72			; dark blue
	sta	COLUBK			; set playfield background

	lda	#$34			; ugly orange
	sta	COLUPF			; for later

	ldx	#14
	jsr	scanline_wait		; leaves X 0


; 10
	;=============
	; scanline 14
	ldx	#0
	sta	WSYNC
	jmp	logo_loop

	;===========================
	; 32 lines of title
	;===========================
logo_loop:
; 3
	nop
	nop
	lda	$80
; 10
	lda	title_playfield0_left,X					; 4+
	sta	PF0							; 3
	; must write by CPU 22 [GPU 68]
; 17
	lda	title_playfield1_left,X					; 4+
	sta	PF1							; 3
	; must write by CPU 28 [GPU 84]
; 24
	lda	title_playfield2_left,X					; 4+
	sta	PF2							; 3
	; must write by CPU 38 [GPU 116]
; 31
	nop
	nop
	nop
	nop
; 39
	lda	title_playfield0_right,X				; 4+
	sta	PF0                                                     ; 3
	; must write by CPU 49 [GPU 148]
; 46
	lda	title_playfield1_right,X				; 4+
	sta	PF1							; 3
	; must write by CPU 54 [GPU 164]
; 53
	lda	title_playfield2_right,X				; 4+
	sta	PF2							; 3
	; must write by CPU 65 [GPU 196]
; 60


	inx
	cpx	#32
	sta	WSYNC
	bne	logo_loop

	; at scaline 46 here?


	;===========================
	; 46 - 79 = blank
	;===========================

	ldx	#32
	jsr	scanline_wait


	;===========================
	; 80 - 129 = bitmap
	;===========================

	lda	#$1A			; yellow
	sta	COLUBK			; set playfield background

	ldx	#50
	jsr	scanline_wait


	;===========================
	; 129 - 170 = rest
	;===========================

	lda	#$72			; dark blue
	sta	COLUBK			; set playfield background

	ldx	#42
	jsr	scanline_wait

	;===========================
	;===========================
	; 171 - 191 = bottom logo
	;===========================
	;===========================
	; 48-pixel sprite!!!!
	;

	;================
	; scanline 172
	;	set things up


	lda	#$9A			; light blue
	sta	COLUBK			; set playfield background

	lda	#$C2			; dark green 97*2=194  C2
	sta	COLUP0	; set sprite color
	sta	COLUP1	; set sprite color

	lda	#NUSIZ_THREE_COPIES_CLOSE
	sta	NUSIZ0
	sta	NUSIZ1

	lda	#0		; turn off sprite
	sta	GRP0
	sta	GRP1
	sta	HMP1			;			3

	lda	#1		; turn on delay
	sta	VDELP0
	sta	VDELP1

	sta	WSYNC

	;=================
	; scanline 173

	; to center exactly would want sprite0 at
	;	CPU cycle 41.3
	; and sprite1 at
	;	GPU cycle 44

	ldx	#6		;				2
pad_x:
	dex			;				2
	bne	pad_x		;				2/3
	; 3 + 5*X each time through

	lda	$80		; nop 6
	lda	$80


	; beam is at proper place
	sta	RESP0						; 3
	; 41 (GPU=123, want 124) +1
	sta	RESP1						; 3
	; 44 (GPU=132, want 132) 0

	lda	#$F0		; opposite what you'd think
	sta	HMP0			;			3
;	lda	#$00
;	sta	HMP1			;			3

	sta	WSYNC
	sta	HMOVE		; adjust fine tune, must be after WSYNC

	ldx	#16		; init X
	stx	TEMP2

	;===============================
	; scanline 174

	jmp	over_align
.align $100
over_align:
	sta	WSYNC

	;================================
	; scanline 175

spriteloop:
	; 0
	lda	vid_sprite0,X	; load sprite data		; 4+
	sta	GRP0			; 0->[GRP0] [GRP1 (?)]->GRP1	; 3
	; 7
	lda	vid_sprite1,X	; load sprite data		; 4+
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3
	; 14
	lda	vid_sprite2,X	; load sprite data		; 4+
	sta	GRP0			; 2->[GRP0], [GRP1 (1)]-->GRP1	; 3
	; 21

	lda	vid_sprite5,X					; 4+
	sta	TEMP1							; 3
	; 28
	lda	vid_sprite4,X					; 4+
	tay								; 2
	; 34
	lda	vid_sprite3,X	;				; 4+
	ldx	a:TEMP1			; force extra cycle		; 4
	; 42

	sta	GRP1			; 3->[GRP1], [GRP0 (2)]-->GRP0	; 3
	; 45 (need this to be 44 .. 46)

	sty	GRP0			; 4->[GRP0], [GRP1 (3)]-->GRP1	; 3
	; 48 (need this to be 47 .. 49)
	stx	GRP1			; 5->[GRP1], [GRP0 (4)]-->GRP0	; 3
	; 51 (need this to be 50 .. 51)

	sty	GRP0			; ?->[GRP0], [GRP1 (5)]-->GRP1 	; 3
	; 54 (need this to be 52 .. 54)

	; delay 11

	inc	$95	; 5
	lda	$95	; 3
	lda	$95	; 3


	; 65

	dec	TEMP2							; 5
	ldx	TEMP2							; 3
	bpl	spriteloop						; 2/3
	; 76  (goal is 76)

	ldy	#0		; clear out sprites
	sty	GRP1
	sty	GRP0
	sty	GRP1

	sta	WSYNC



	;============================
	; overscan
	;============================
common_overscan:
	lda	#$2		; turn off beam
	sta	VBLANK

	; wait 30 scanlines

	ldx	#29
	jsr	scanline_wait

	;=======================
	; 29

	; fallthrough

;	jsr	play_music

	jmp	title_loop


blah:
	jmp	blah

.include "title_pf.inc"
.align $100
.include "title_sprites.inc"

	;====================
	; scanline wait
	;====================
	; scanlines to wait in X

scanline_wait:
	sta	WSYNC
	dex						; 2
	bne	scanline_wait				; 2/3
	rts						; 6

	;==================
	; increment frame
	;==================
	; worst case 18
inc_frame:
	inc	FRAME					; 5
	bne	no_inc_high				; 2/3
	inc	FRAMEH					; 5
no_inc_high:
	rts						; 6


.segment "IRQ_VECTORS"
	.word the_cheat_start	; NMI
	.word the_cheat_start	; RESET
	.word the_cheat_start	; IRQ







