
	;=========================================
	;=========================================
	; draw Videlectrix Logo sprite (11 lines)
	;=========================================
	;=========================================

	; assume coming in 2 cycles after WSYNC

	;====================
	; Now scanline 182
	;====================
	; configure 48-pixel sprite code

	; make playfield black
	lda	#$00			; black
	sta	COLUPF			; playfield color
	sta	PF0			; turn off playfield so don't collide
	sta	PF1
	sta	PF2

	sta	GRP0			; turn off sprites
	sta	GRP1

	; set color

	lda	#$0E	; bright white					; 2
	sta	COLUP0	; set sprite color				; 3
	sta	COLUP1	; set sprite color				; 3

	; set to be 48 adjacent pixels

	lda	#NUSIZ_THREE_COPIES_CLOSE				; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1							; 3

	; turn on delay

	lda	#1							; 2
	sta	VDELP0							; 3
	sta	VDELP1							; 3

	; number of lines to draw
	ldx	#7							; 2
	stx	TEMP2							; 3

	sta	WSYNC							; 3
								;===========


	;===================
	; now scanline 183
	;===================
	; center the sprite position
	; needs to be right after a WSYNC

	; to center exactly would want sprite0 at
	;	CPU cycle 41.3
	; and sprite1 at
	;	GPU cycle 44


	ldx	#0		; sprite 0 display nothing		; 2
	stx	GRP0		;					; 3

	ldx	#6		;					; 2
vpad_x:
	dex			;					; 2
	bne	vpad_x		;					; 2/3
	; 3 + 5*X each time through

	; beam is at proper place
	sta	RESP0							; 3
	; 41 (GPU=123, want 124) +1
	sta	RESP1							; 3
	; 44 (GPU=132, want 132) 0

	lda	#$F0		; opposite what you'd think		; 2
	sta	HMP0							; 3
	lda	#$00							; 2
	sta	HMP1							; 3

	sta	WSYNC
	sta	HMOVE		; adjust fine tune, must be after WSYNC


	;===================
	; now scanline 184
	;===================

	ldx	TEMP2		; restore length of sprite

	sta	WSYNC

	;===================
	; now scanline 185
	;===================

spriteloop:
	; 0
	lda	vid_bitmap0,X	; load sprite data		; 4+
	sta	GRP0			; 0->[GRP0] [GRP1 (?)]->GRP1	; 3
	; 7
	lda	vid_bitmap1,X	; load sprite data		; 4+
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3
	; 14
	lda	vid_bitmap2,X	; load sprite data		; 4+
	sta	GRP0			; 2->[GRP0], [GRP1 (1)]-->GRP1	; 3
	; 21

	lda	vid_bitmap5,X					; 4+
	sta	TEMP1							; 3
	; 28
	lda	vid_bitmap4,X					; 4+
	tay								; 2
	; 34
	lda	vid_bitmap3,X	;				; 4+
	ldx	TEMP1							; 3
	; 41

	sta	GRP1			; 3->[GRP1], [GRP0 (2)]-->GRP0	; 3
	; 44 (need this to be 44 .. 46)

	sty	GRP0			; 4->[GRP0], [GRP1 (3)]-->GRP1	; 3
	; 47 (need this to be 47 .. 49)

	stx	GRP1			; 5->[GRP1], [GRP0 (4)]-->GRP0	; 3
	; 50 (need this to be 50 .. 51)

	sty	GRP0			; ?->[GRP0], [GRP1 (5)]-->GRP1 	; 3
	; 53 (need this to be 52 .. 54)

	nop								; 2
	nop								; 2
	nop								; 2
	nop								; 2
	nop								; 2
	nop								; 2

	; 65

	dec	TEMP2							; 5
	ldx	TEMP2							; 3
	bpl	spriteloop						; 2/3
	; 76  (goal is 76)


	;
	; done drawing line
	;

	ldy	#0
	sty	GRP1
	sty	GRP0
	sty	GRP1


