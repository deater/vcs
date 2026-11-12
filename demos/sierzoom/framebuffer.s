	;==========================
	; framebuffer intro
	;==========================
	;

; 31 (exit) + 3 (bank set) + 6 (jsr) = 40

do_framebuffer:

start_framebuffer:
	;=================
	; start VBLANK
	;=================
	; this code takes 4 scanlines, it does a WSYNC soon after
	;       to ensure 3 scanlines total
	; this means it's really stealing one of the previous frame's lines

	jsr	common_vblank

; 9

	;=============================
	;=============================
	;=============================
	; 37 lines of vertical blank
	;=============================
	;=============================
	;=============================

	jsr	do_sierzoom

	;=============================
	; scanlines 0..21 (unused)
	;=============================

;        ldx     #34
;	jsr	repeat_wsync
; 8



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

	stx	VBLANK			; turn on beam			; 3

	sta	WSYNC


	;=============================================
	; wait 30 lines
	;=============================================
;	ldx	#29
;	jsr	repeat_wsync


	;=============================================
	;=============================================
	; draw framebuffer
	;=============================================
	;=============================================
	; 128 lines

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
	ldx	#48							; 2
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
	; now scanline 3+(0..127)
	;===================

title_spriteloop:
; 0
	lda	$1400,X			; load sprite0 data		; 4+
	sta	GRP0			; 0->[GRP0] [GRP1 (?)]->GRP1	; 3
; 7
	lda	$1480,X			; load sprite1 data		; 4+
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3
; 14
	lda	$1500,X			; load sprite2 data		; 4+
	sta	GRP0			; 2->[GRP0], [GRP1 (1)]-->GRP1	; 3
; 21

	lda	$1680,X			; sprite5			; 4+
	sta	TEMP1			; save for later		; 3
; 28
	lda	$1600,X			; sprite4			; 4+
	tay				; save in Y			; 2
; 34
	lda	$1580,X			; sprite3			; 4+
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
	; 128+1

	ldy	#0		; clear out sprite data			; 2
	sty	GRP1							; 3
	sty	GRP0							; 3
	sty	GRP1							; 3

	lda	#$0		; end the black window
	sta	PF2

	sta	WSYNC


	;=============================
	; draw bottom 31 lines

;	ldx	#31
	ldx	#8
	jsr	repeat_wsync


	jsr	do_sierzoom
	jsr	do_sierzoom

	;==========================
	; overscan for 30 scanlines
	;==========================

	ldx	#1
	jsr	common_overscan

	jsr	do_sierzoom









; 75



;	lda	FRAMEL
;	cmp	#FRAMEBUFFER_TIME_L
;	bne	not_done_framebuffer
;	lda	FRAMEH
;	cmp	#FRAMEBUFFER_TIME_H
;	beq	done_framebuffer

not_done_framebuffer:
        jmp     start_framebuffer					; 3

done_framebuffer:

	rts



