	; come in with one more line left in the vblank
title_entry:

	sta	WSYNC


title_frame_loop:

	;============================================
	; Start Vertical Blank (with one extra WSYNC)
	;============================================

	jsr	common_vblank


	;============================
	; 37 lines of vertical blank
	;=============================

	ldx	#34
	jsr	common_delay_scanlines

	;=======================
	; scanline 35 -- do nothing, makes sure alignment happens fresh

	sta	WSYNC

	;=======================
	; scanline 36 -- align sprite


	; to center exactly would want sprite0 at
	;	CPU cycle 41.3
	; and sprite1 at
	;	GPU cycle 44

	ldx	#6		;				2
cpad_x:
	dex			;				2
	bne	cpad_x		;				2/3
	; 3 + 5*X each time through

	lda	$80		; nop 6
	lda	$80


	; beam is at proper place
	sta	RESP0						; 3
	; 41 (GPU=123, want 124) +1
	sta	RESP1						; 3
	; 44 (GPU=132, want 132) 0

	lda	#$00		; opposite what you'd think
	sta	HMP0			;			3
	lda	#$10
	sta	HMP1			;			3

	sta	WSYNC
	sta	HMOVE		; adjust fine tune, must be after WSYNC


	;=======================
	; scanline 37 -- config

	lda	#NUSIZ_QUAD_SIZE
	sta	NUSIZ0

	lda	#$0		; yellow		; set color
	sta	COLUP0
	sta	COLUPF
	sta	CTRLPF		; no mirror

	ldy	#0
	sty	VBLANK		; re-enable VBLANK

	ldx	#0

	jmp	title_align2
	.align $100
title_align2:
	sta	WSYNC


	;=============================================
	;=============================================
	; title screen, 192 lines
	;=============================================
	;=============================================

	;=============================================
	; draw 112 lines of the title
	; need to race beam to draw other half of playfield
	;=============================================

title_loop:
	lda	left_colors,Y		;				; 4+
	sta	COLUPF			; set playfield color		; 3
; 7
	lda	playfield0_left,Y	;				; 4+
	sta	PF0			;				; 3
	; must write by CPU 22 [GPU 68]
; 14
	lda	playfield1_left,Y	;				; 4+
	sta	PF1			;				; 3
	; must write by CPU 28 [GPU 84]

; 21
	lda	playfield2_left,Y	;				; 4+
	sta	PF2			;				; 3
	; must write by CPU 38 [GPU 116]

; 28
	; at this point we're at 28 cycles
	lda	playfield0_right,Y	;				; 4+
	sta	PF0			;				; 3
	; must write by CPU 49 [GPU 148]
; 35
	lda	playfield1_right,Y	;				; 4+
	sta	PF1			;				; 3
	; must write by CPU 54 [GPU 164]
; 42
	lda	$80							; 3
	lda	playfield2_right,Y	;				; 4+
	sta	PF2			;				; 3
	; must write by CPU 65 [GPU 196]

; 52

	lda	right_colors,Y		;				; 4+
;	force 4-cycle store
	sta	a:COLUPF						; 4

; 60
	inx                                                             ; 2
	txa                                                             ; 2
	and	#$3                                                     ; 2
	beq	yes_iny                                                 ; 2/3
	.byte	$A5     ; begin of LDA ZP                               ; 3
yes_iny:
	iny		; $E8 should be harmless to load                ; 2
done_iny:
                                                                ;===========
                                                                ; 11/11

; 71
	cpx	#112						; 2
	bne	title_loop					; 2/3
done_toploop:

; 75

	;===========================
	;===========================
	; 112 - 191 = snake sprite
	;===========================
	;===========================
	; 48-pixel sprite!!!!
	;
draw_the_snake:
	;================
	; scanline 112
	;	set things up

	lda	#0			; turn off playfield
	sta	PF0
	sta	PF1
	sta	PF2

	lda	#$D8			; green for snake
	sta	COLUP0	; set sprite color
	sta	COLUP1	; set sprite color

	lda	#NUSIZ_THREE_COPIES_CLOSE
	sta	NUSIZ0
	sta	NUSIZ1

	lda	#1
	sta	CTRLPF		; mirror playfield


	lda	#0		; turn off sprite
	sta	GRP0
	sta	GRP1
	sta	HMP1			;			3



	lda	#1		; turn on delay
	sta	VDELP0
	sta	VDELP1

	sta	WSYNC



;	ldx	#76		; init X
	ldx	#45
	stx	TEMP2

	;===============================
	; scanline 113

	jmp	over_align2
.align $100
over_align2:
	sta	WSYNC

	;================================
	; scanline 114


	; To do background
	; set color whenever
	; load left PF2 before 38
	; clear PF2 before 64

TOP_OFFSET	=	31

spriteloop_snake_top:
	; 0
	lda	snake_sprite0+TOP_OFFSET,X	; load sprite data		; 4+
	sta	GRP0			; 0->[GRP0] [GRP1 (?)]->GRP1	; 3
	; 7
	lda	snake_sprite1+TOP_OFFSET,X	; load sprite data		; 4+
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3
	; 14
	lda	snake_sprite2+TOP_OFFSET,X	; load sprite data		; 4+
	sta	GRP0			; 2->[GRP0], [GRP1 (1)]-->GRP1	; 3
	; 21

	lda	snake_sprite5+TOP_OFFSET,X					; 4+
	sta	TEMP1							; 3
	; 28
	lda	snake_sprite4+TOP_OFFSET,X					; 4+
	tay								; 2
	; 34
	lda	snake_sprite3+TOP_OFFSET,X	;				; 4+
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

	; draw BG, takes 11

	ldx	TEMP2			; restore X			; 3
	lda	snake_pf2_left+TOP_OFFSET,X	; load bg pattern		; 4
	sta	PF2							; 3

	; 64

	nop
	nop

	; 68

	dex								; 2
	stx	TEMP2			; save X			; 3

	bpl	spriteloop_snake_top					; 2/3
	; 76  (goal is 76)


	;=======================================================
	; mid-snake break to change color
	;	thanks to glurk for suggesting this
	;=======================================================

spriteloop_snake_middle:
	; -1
	lda	#$00			; load sprite data		; 2
	sta	GRP0			; 0->[GRP0] [GRP1 (?)]->GRP1	; 3
	; 4
	lda	#$f9			; load sprite data		; 2
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3
	; 9
	lda	#$e7			; load sprite data		; 2
	sta	GRP0			; 2->[GRP0], [GRP1 (1)]-->GRP1	; 3
	; 14
	lda	#$60							; 2
	sta	TEMP1			; 5				; 3
	; 19
	lda	#$FC			; 4				; 2
	tay								; 2
	; 23
	lda	#$FF			;				; 2
	ldx	TEMP1			; 3 force extra cycle		; 3

	; 28

	nop
	nop
	nop
	nop
	nop
	nop
	nop

	; 42

	sta	GRP1			; 3->[GRP1], [GRP0 (2)]-->GRP0	; 3
	; 45 (need this to be 44 .. 46)

	sty	GRP0			; 4->[GRP0], [GRP1 (3)]-->GRP1	; 3
	; 48 (need this to be 47 .. 49)
	stx	GRP1			; 5->[GRP1], [GRP0 (4)]-->GRP0	; 3
	; 51 (need this to be 50 .. 51)

	sty	GRP0			; ?->[GRP0], [GRP1 (5)]-->GRP1 	; 3
	; 54 (need this to be 52 .. 54)

	; draw BG, takes 11

	lda	#$C0			; load bg pattern		; 2
	sta	PF2							; 3

	; 57

	ldx	#29							; 2
	stx	TEMP2							; 3

	lda	#$2E							; 2
	sta	COLUPF							; 3

	; 67

	sta	WSYNC

	;=======================================
	; bottom of snake
	;=======================================

BOTTOM_OFFSET = 0

spriteloop_snake_bottom:

	; 0
	lda	snake_sprite0+BOTTOM_OFFSET,X	; load sprite data		; 4+
	sta	GRP0			; 0->[GRP0] [GRP1 (?)]->GRP1	; 3
	; 7
	lda	snake_sprite1+BOTTOM_OFFSET,X	; load sprite data		; 4+
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3
	; 14
	lda	snake_sprite2+BOTTOM_OFFSET,X	; load sprite data		; 4+
	sta	GRP0			; 2->[GRP0], [GRP1 (1)]-->GRP1	; 3
	; 21

	lda	snake_sprite5+BOTTOM_OFFSET,X					; 4+
	sta	TEMP1							; 3
	; 28
	lda	snake_sprite4+BOTTOM_OFFSET,X					; 4+
	tay								; 2
	; 34
	lda	snake_sprite3+BOTTOM_OFFSET,X	;				; 4+
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

	; draw BG, takes 11

	ldx	TEMP2			; restore X			; 3
	lda	snake_pf2_left+BOTTOM_OFFSET,X	; load bg pattern		; 4
	sta	PF2							; 3

	; 64

	nop
	nop

	; 68

	dex								; 2
	stx	TEMP2			; save X			; 3

	bpl	spriteloop_snake_bottom					; 2/3
	; 76  (goal is 76)


	;========================
	; done with snake sprite


	ldy	#0		; clear out sprites
	sty	GRP1
	sty	GRP0
	sty	GRP1

	sta	WSYNC


	;==========================
	; overscan
	;==========================

	ldx	#27
	jsr	common_overscan


	;============================
	; Overscan scanline 28
	;============================
	; check for button
	; we used to check for RESET too, but we'd need to debounce it
	;       and in theory it would be sorta pointless to RESET at title
	;============================

; 0
	; debounce
	lda	BUTTON_COUNTDOWN					; 3
	beq	twaited_button_enough					; 2/3
	dec	BUTTON_COUNTDOWN					; 5
	jmp	tdone_check_button					; 3

twaited_button_enough:

	lda	INPT4		; check joystick button pressed		; 3
	bmi	tdone_check_button					; 2/3

	inc	LEVEL_OVER
	lda	#20
	sta	BUTTON_COUNTDOWN

tdone_check_button:

	sta     WSYNC

	;============================
	; Overscan scanline 29
	;============================

	; want to exit at scanline 29
	lda	LEVEL_OVER
	bne	done_title

	sta     WSYNC

	;============================
	; Overscan scanline 30
	;============================


        jmp     title_frame_loop        ; bra


done_title:

	; fall through
