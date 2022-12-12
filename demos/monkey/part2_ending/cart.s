	;==========================
	; cart message
	;==========================
	; potentially arrive here with an unknown number of cycles/scanlines
	; ideally VBLANK=2 (beam off)

do_cart_message:

; comes in with 0 cycles after last frame of overscan

; 6
	; turn off audio if left on?
	lda	#$0							; 2
	sta	AUDV0							; 3
	sta	AUDV1							; 3
; 14

	jmp	align_cart						; 3
.align	$100
align_cart:
	; the init code sets everything to 0

; 17
	lda	#$28							; 2
	sta	BASE_TITLE_COLOR					; 3
; 22

	lda	#$0E							; 2
	sta	TEXT_COLOR						; 3
	sta	DEBOUNCE_COUNTDOWN					; 3
; 30


start_cart:
; 30 / 3

	sta	WSYNC


	;=================
	; start VBLANK
	;=================
	; in scanline 0


	jsr	common_vblank

; 9
	;=============================
	; 37 lines of vertical blank
	;=============================

        ldx     #34
cvbsc_loop:
        sta     WSYNC
        dex
        bne	cvbsc_loop

	;====================
	; now in scanline 35
	;====================
        sta     WSYNC

	;===================
	; now scanline 36
	;===================
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

	lda	#$F0		; opposite what you'd think		; 2
	sta	HMP0							; 3
	lda	#$00							; 2
	sta	HMP1							; 3
; 52
	sta	WSYNC
; 0
	sta	HMOVE		; adjust fine tune, must be after WSYNC
; 3

	;=======================
	; scanline 37 -- config
; 3
	ldy	#0							; 2
	ldx	#0							; 2
	stx	VBLANK			; turn on beam			; 3
	stx	GRP0							; 3
	stx	GRP1							; 3
; 16
	lda	BASE_TITLE_COLOR					; 3
	sta	TITLE_COLOR						; 3
; 22
	lda	BACKGROUND_COLOR					; 3
	sta	COLUBK							; 3
; 28
	sta	WSYNC


	;=============================================
	;=============================================
	; draw cart
	;=============================================
	;=============================================
	; draw 192 lines
	; need to race beam to draw other half of playfield

	ldx	#80
cart_loop:
	sta	WSYNC
	dex				; 2
	bne	cart_loop		; 2/3

done_cart_loop:

; 4

	;=========================================
	;=========================================
	; draw cart message (30 lines)
	;=========================================
	;=========================================

	;========================
	; Still in scanline 81
	;========================
	; configure 48-pixel sprite code

	; make playfield black
	lda	#$00		; black					; 2
	sta	COLUPF		; playfield color			; 3
	sta	PF0		; turn off playfield so don't collide	; 3
	sta	PF1		;					; 3
	sta	PF2		;					; 3
;	sta	GRP0		; turn off sprites			; 3
;	sta	GRP1		;					; 3
; 22
	; set color

	lda	TEXT_COLOR	; bright white				; 3
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
	ldx	#29							; 2
	stx	TEMP2							; 3
; 52
	sta	WSYNC							; 3

	;===================
	; now scanline 82
	;===================

title_spriteloop:
; 0
	lda	cart_message0,X		; load sprite data		; 4+
	sta	GRP0			; 0->[GRP0] [GRP1 (?)]->GRP1	; 3
; 7
	lda	cart_message1,X		; load sprite data		; 4+
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3
; 14
	lda	cart_message2,X		; load sprite data		; 4+
	sta	GRP0			; 2->[GRP0], [GRP1 (1)]-->GRP1	; 3
; 21

	lda	cart_message5,X						; 4+
	sta	TEMP1			; save for later		; 3
; 28
	lda	cart_message4,X						; 4+
	tay				; save in Y			; 2
; 34
	lda	cart_message3,X	;					; 4+
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
	inc	TEMP1		; nop5					; 5
	inc	TEMP1		; nop5					; 5
	nop								; 2

; 65

	dec	TEMP2							; 5
	ldx	TEMP2			; decrement count		; 3
; 73
	bpl	title_spriteloop					; 2/3
	; 76  (goal is 76)


; 75
	;=========================
	; done drawing line

	ldy	#0		; clear out sprite data			; 2
	sty	GRP1							; 3
	sty	GRP0							; 3
	sty	GRP1							; 3

	sta	WSYNC

	;===================================
	; scanline 112
	;===================================

	ldx	#78
cart2_loop:
	sta	WSYNC
	dex				; 2
	bne	cart2_loop		; 2/3



	;=========================
	; screensaver
; 29
	inc	FRAMEL							; 5
	lda	FRAMEL							; 3
; 37
	and	#$3f			; only every 64 (~1s)		; 2
	bne	no_rotate_color						; 2/3

; 41
	clc								; 2
	lda	BASE_TITLE_COLOR					; 3
	adc	#$17							; 2
	sta	BASE_TITLE_COLOR					; 3
; 51
	clc								; 2
	lda	BACKGROUND_COLOR					; 3
	adc	#$10							; 2
	sta	BACKGROUND_COLOR					; 3
; 61
	clc								; 2
	lda	TEXT_COLOR						; 3
	adc	#$10							; 2
	sta	TEXT_COLOR						; 3

; 71
no_rotate_color:
; 42 / 71

	sta	WSYNC

	;========================================
	; scanline 192
	;========================================


	;==========================
	; overscan for 30 scanlines
	;==========================

	ldx	#29
	jsr	common_overscan

; ???

	jmp	start_cart						; 3


done_cart:
; ??

	rts
