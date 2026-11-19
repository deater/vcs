	;==========================
	; knowthis2 screen
	;==========================
	; ideally VBLANK=2 (beam off)


start_knowthis2:

	;=================
	; start VBLANK
	;=================
	; this takes 4 scalines

	jsr	common_vblank

; 9

	;=============================
	;=============================
	;=============================
	; 37 lines of vertical blank
	;=============================
	;=============================
	;=============================


	;================================
	; scanlines 0..20 unused
	;================================

        ldx     #19
	jsr	repeat_wsync

	;================================
	; play music -- scanlines 21..31
	;================================
	; takes 11 lines?

	lda	#3		; our bank
	jsr	do_play_music
	sta	WSYNC

	;====================
	; now in scanline 32
	;====================
	jsr	inc_frame		; 48

	lda	#$aa
	sta	GRP0			; sprite 0

;	lda	#$1e
;	sta	COLUP0

	lda	#NUSIZ_DOUBLE_SIZE
	sta	NUSIZ0

        sta     WSYNC


	;=======================
	; now scanline 33/34/35
	;=======================

	lda	#119
	ldx	#0			; sprite 0
	jsr	set_pos_x

	sta	WSYNC
	sta	HMOVE


	;=======================
	; scanline 36

	sta	WSYNC

	;=======================
	; scanline 37 -- config
; 0
	ldy	#0							; 2
	ldx	#0							; 2
	stx	VBLANK			; turn on beam			; 3
	stx	PF0
	stx	PF1
	stx	PF2

	stx	GRP0							; 3
	stx	GRP1							; 3
	stx	CTRLPF			; reset playfield


	lda	FRAMEL
	lsr
	lsr
	lsr
	lsr
	and	#$7
	tax
	lda	bg_range,X
	sta	COLUBK							; 3

	ldx	#0

	sta	WSYNC


	;===========================================================
	;===========================================================
	; draw 16*2 = 32 lines of sprites
	;===========================================================
	;===========================================================

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

;	lda	#CTRLPF_REF
;	sta	CTRLPF

	lda	#$fc
	sta	PF2		;					; 3

; 22
	; set color

	lda	#$1E		; bright white				; 2
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
	ldx	#15
	stx	SPRITE_OFFSET
	ldx	#30							; 2
	stx	SPRITE_LENGTH						; 3
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

	ldx	#6		;					; 2
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

	;===================
	; now scanline 3
	;===================
	; 32 scalines of frameloop

title_spriteloop:
; 0
	lda	ikt_message0,X		; load sprite0 data		; 4+
	sta	GRP0			; 0->[GRP0] [GRP1 (?)]->GRP1	; 3
; 7
	lda	ikt_message1,X		; load sprite1 data		; 4+
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3
; 14
	lda	ikt_message2,X		; load sprite2 data		; 4+
	sta	GRP0			; 2->[GRP0], [GRP1 (1)]-->GRP1	; 3
; 21

	lda	ikt_message5,X		; sprite5			; 4+
	sta	TEMP1			; save for later		; 3
; 28
	lda	ikt_message4,X		; sprite4			; 4+
	tay				; save in Y			; 2
; 34
	lda	ikt_message3,X		; sprite3			; 4+
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

	; need 12 cycles of nops
;	inc	TEMP1		; nop5					; 5
;	inc	TEMP1		; nop5					; 5
	nop								; 2

; 65

	dec	SPRITE_LENGTH						; 5
;	ldx	SPRITE_LENGTH		; decrement count		; 3
;
	lda	SPRITE_LENGTH						; 3
	lsr								; 2
	sta	SPRITE_OFFSET						; 3
	tax								; 2
	lda	SPRITE_LENGTH		; check for zero

; 73
	bpl	title_spriteloop					; 2/3
	; 76  (goal is 76)


; 75

	;======================== scanline 3+32


	;=========================
	; done drawing line

	ldy	#0		; clear out sprite data			; 2
	sty	GRP1							; 3
	sty	GRP0							; 3
	sty	GRP1							; 3

	; turn off delay

	lda	#0							; 2
	sta	VDELP0							; 3
	sta	VDELP1							; 3

	lda	#NUSIZ_DOUBLE_SIZE					; 2
	sta	NUSIZ0							; 3

	lda	#7
	sta	HMP0

	ldx	#18

	lda	$80
	lda	$80
	lda	$80
	lda	$80
	lda	$80
	lda	$80
	lda	$80
	lda	$80
	nop
	nop

	sta	RESP0

	sta	WSYNC
	sta	HMOVE

	sta	WSYNC

	;=============================================
	;=============================================
	; draw desktop
	;=============================================
	;=============================================
	; draw 192-36=156/2=78 lines
	; need to race beam to draw other half of playfield
	; split across 2

knowthis2_loop:

; 0
	ldy	ikt_colors,X	;					; 4
	lda	#168		; blue					; 2
	sta	COLUPF		; set playfield color			; 3
	nop								; 2
; 13
	lda	ikt_playfield0_left,X		;			; 4
	sta	PF0				;			; 3
	; must write by CPU 22 [GPU 68]

; 20
	lda	ikt_playfield1_left,X		;			4+
	sta	PF1				;			3
	; must write by CPU 28 [GPU 84]
	nop								; 2

; 27
	lda	ikt_playfield2_left,X		;			4+
	sta	PF2				;			3
	; must write by CPU 38 [GPU 116]
; 34


	nop					;			2

	lda	ikt_playfield0_right,X		;			4+
	sta	PF0				;			3
	; must write by CPU 49 [GPU 148]
; 43
	lda	ikt_playfield1_right,X		;			4+
	sta	PF1				;			3
	; must write by CPU 54 [GPU 164]
; 50

	sty	COLUPF

;	lda	$80				; nop3			3
	lda	ikt_playfield2_right,X		;			4+
	sta	PF2				;			3
	; must write by CPU 65 [GPU 196]
; 60

	lda	ikt_face_overlay_colors,X				; 4
	sta	COLUP0							; 3
; 67
	ldy	ikt_face_overlay_sprite,X				; 4
; 71

	sta	WSYNC

; 76

	; line 2


; 0
	lda	ikt_colors,X	;					; 4
	sta	COLUPF		; set playfield color			; 3
	sty	GRP0							; 3
	lda	$80		; nop3					; 3

; 13
	lda	ikt_playfield0_left,X		;			; 4
	sta	PF0				;			; 3


	; must write by CPU 22 [GPU 68]
; 20
	lda	ikt_playfield1_left,X		;			4+
	sta	PF1				;			3
	; must write by CPU 28 [GPU 84]
; 27
	lda	ikt_playfield2_left,X		;			4+
	sta	PF2				;			3
	; must write by CPU 38 [GPU 116]
; 34

	nop					;			2
	lda	ikt_playfield0_right,X		;			4+
	sta	PF0				;			3
	; must write by CPU 49 [GPU 148]
; 43
	lda	ikt_playfield1_right,X		;			4+
	sta	PF1				;			3
	; must write by CPU 54 [GPU 164]
; 50

	lda	$80				; nop3			3
	lda	ikt_playfield2_right,X		;			4+
	sta	PF2				;			3
	; must write by CPU 65 [GPU 196]
; 60
	lda	$80	; nop3
	lda	$80	; nop3
	lda	$80	; nop3

;	nop
;	nop
;	lda	#168			; 2
;	sta	COLUPF			; 3


; 69
        inx								; 2
	cpx	#(96)							; 2
	bne	knowthis2_loop						; 2/3

; 76


done_knowthis2_loop:

; 75

	;==========================
	; overscan for 30 scanlines
	;==========================

	ldx	#29
	jsr	common_overscan

	lda	FRAMEL
	cmp	#KNOWTHIS_TIME_L
	bne	not_done_knowthis2
	lda     FRAMEH
	cmp     #KNOWTHIS_TIME_H
	beq     done_knowthis2
not_done_knowthis2:
	jmp	start_knowthis2						; 3
; 18

done_knowthis2:
; 16

