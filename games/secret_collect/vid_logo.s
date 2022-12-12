	;=========================================
	;=========================================
	; draw Videlectrix Logo sprite (11 lines)
	;=========================================
	;=========================================

	; assume coming in 2 cycles after WSYNC

	;========================
	; Now scanline vidlogo+0
	;========================
	; configure 48-pixel sprite code
; 2
	; make playfield black
	lda	#$00		; black					; 2
	sta	COLUPF		; playfield color			; 3
	sta	PF0		; turn off playfield so don't collide	; 3
	sta	PF1							; 3
	sta	PF2							; 3
; 16
	sta	GRP0			; turn off sprites		; 3
	sta	GRP1							; 3
; 22

	; set color

	lda	#$0E	; bright white					; 2
	sta	COLUP0	; set sprite color				; 3
	sta	COLUP1	; set sprite color				; 3
; 30
	; set to be 48 adjacent pixels

	lda	#NUSIZ_THREE_COPIES_CLOSE				; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1							; 3
; 38
	; turn on delay

	lda	#1							; 2
	sta	VDELP0							; 3
	sta	VDELP1							; 3
; 46
	; number of lines to draw
	ldx	#7							; 2
	stx	TEMP2							; 3
; 51
	sta	WSYNC							; 3


	;========================
	; Now scanline vidlogo+1
	;========================
	; center the sprite position
	; needs to be right after a WSYNC

	; to center exactly would want sprite0 at
	;	CPU cycle 41.3
	; and sprite1 at
	;	GPU cycle 44

; 0
	ldx	#0		; sprite 0 display nothing		; 2
	stx	GRP0		;					; 3

	ldx	#6		;					; 2
; 7
vpad_x:
	dex			;					; 2
	bne	vpad_x		;					; 2/3
	; (5*X)-1, so for X=6 then 29
; 36
	; beam is at proper place
	sta	RESP0							; 3
	; 39 (GPU=???, want ???) +?
; 39
	sta	RESP1							; 3
	; 42 (GPU=???, want ???) +?
; 42
	lda	#$F0		; opposite what you'd think		; 2
	sta	HMP0							; 3
	lda	#$00							; 2
	sta	HMP1							; 3
; 52
	sta	WSYNC

	sta	HMOVE		; adjust fine tune, must be after WSYNC


	;========================
	; Now scanline vidlogo+2
	;========================
; 3
	ldx	TEMP2		; restore length of sprite		; 3
; 6
	sta	WSYNC

	;========================
	; Now scanline vidlogo+3
	;========================

spriteloop:
; 0
	lda	vid_bitmap0,X		; load sprite data		; 4+
	sta	GRP0			; 0->[GRP0] [GRP1 (?)]->GRP1	; 3
; 7
	lda	vid_bitmap1,X		; load sprite data		; 4+
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3
; 14
	lda	vid_bitmap2,X		; load sprite data		; 4+
	sta	GRP0			; 2->[GRP0], [GRP1 (1)]-->GRP1	; 3
; 21

	lda	vid_bitmap5,X						; 4+
	sta	TEMP1							; 3
; 28
	lda	vid_bitmap4,X						; 4+
	tay								; 2
; 34
	lda	vid_bitmap3,X		;				; 4+
	ldx	TEMP1							; 3
; 41

	sta	GRP1			; 3->[GRP1], [GRP0 (2)]-->GRP0	; 3
	; 44 (need this to be 44 .. 46)
; 44

	sty	GRP0			; 4->[GRP0], [GRP1 (3)]-->GRP1	; 3
	; 47 (need this to be 47 .. 49)
; 47

	stx	GRP1			; 5->[GRP1], [GRP0 (4)]-->GRP0	; 3
	; 50 (need this to be 50 .. 51)
; 50
	sty	GRP0			; ?->[GRP0], [GRP1 (5)]-->GRP1 	; 3
	; 53 (need this to be 52 .. 54)
; 53
	; 12 cycles of nops
	inc	TEMP1							; 5
	inc	TEMP1							; 5
	nop								; 2

; 65

	dec	TEMP2							; 5
	ldx	TEMP2							; 3
	bpl	spriteloop						; 2/3
	; 76  (goal is 76)

; 75

	;========================
	; Now scanline vidlogo+10
	;========================

	;
	; done drawing line
	;

	ldy	#0							; 2

	;========================
	; Now scanline vidlogo+11
	;========================

	sty	GRP1							; 3
	sty	GRP0							; 3
	sty	GRP1							; 3

; 10


