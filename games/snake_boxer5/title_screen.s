
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

;	ldx	#80
;	jsr	common_delay_scanlines



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



	ldx	#79		; init X
	stx	TEMP2

	;===============================
	; scanline 82

	jmp	over_align2
.align $100
over_align2:
	sta	WSYNC

	;================================
	; scanline 83


	; To do background
	; set color whenever
	; load left PF2 before 38
	; clear PF2 before 64


spriteloop_cheat:
	; 0
	lda	snake_sprite0,X	; load sprite data		; 4+
	sta	GRP0			; 0->[GRP0] [GRP1 (?)]->GRP1	; 3
	; 7
	lda	snake_sprite1,X	; load sprite data		; 4+
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3
	; 14
	lda	snake_sprite2,X	; load sprite data		; 4+
	sta	GRP0			; 2->[GRP0], [GRP1 (1)]-->GRP1	; 3
	; 21

	lda	snake_sprite5,X					; 4+
	sta	TEMP1							; 3
	; 28
	lda	snake_sprite4,X					; 4+
	tay								; 2
	; 34
	lda	snake_sprite3,X	;				; 4+
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

	ldx	a:TEMP2			; restore X			; 4
	lda	snake_pf2_left,X	; load bg pattern		; 4
	sta	PF2							; 3

	; 65
	dec	TEMP2							; 5
	ldx	TEMP2							; 3

	bpl	spriteloop_cheat					; 2/3
	; 76  (goal is 76)

	ldy	#0		; clear out sprites
	sty	GRP1
	sty	GRP0
	sty	GRP1

	sta	WSYNC


	;==========================
	; overscan
	;==========================

	ldx	#29
	jsr	common_overscan


	;============================
	; Overscan scanline 30
	;============================
	; check for button
	; we used to check for RESET too, but we'd need to debounce it
	;       and in theory it would be sorta pointless to RESET at title
	;============================

waited_enough:
	lda	INPT4			; check if joystick button pressed
	bpl	done_title


done_check_input:

        jmp     title_frame_loop        ; bra

done_title:

        rts

