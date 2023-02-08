start_frame:

	;=========================
	; Start Vertical Blank
	;=========================

	lda	#2			; reset beam to top of screen
	sta	VSYNC

	; wait for 3 scanlines of VSYNC

	sta	WSYNC			; wait until end of scanline
	sta	WSYNC

	inc	TEXT_COLOR		; update text color

	sta	WSYNC

	lda	#0			; done beam reset
	sta	VSYNC

	; 37 lines of vertical blank

	ldx	#35
	jsr	scanline_wait
; 10
	sta	WSYNC

	lda	#0
	sta	CTRLPF

	sta	WSYNC
	lda	#0			; turn on beam
	sta	VBLANK

	;===========================
	;===========================
	; playfield
	;===========================
	;===========================
	; draw 192 lines



	;===========================
	; first 9 lines black
	;===========================

	lda	#0
	sta	COLUPF
	ldx	#8
	jsr	scanline_wait

	; FIXME: X already 0 here?
; 10

	tsx
	stx	XSAVE		; save stack as we corrupt it

	ldy	#0		; clear div3 count
	sty	PF0		; also clear leftmost playfield

	ldx	#171		; we count down 171

	lda	#2		; start color count full
	sta	DIV3

	sta	WSYNC

colorful_loop:
; 3
	txs				; save X in stack		; 2
	lda	colors,Y		; get color			; 4+
	sta	COLUPF			; set playfield color		; 3
	lda	row_lookup,X		; get which playfield lookup	; 4+
	tax				; put in X			; 2
; 18/19

	; PF0 set in previous scanline
	lda	playfield1_left,X	;				; 4+
	sta	PF1			;				; 3
	; has to happen by 28
; 25/26
	lda	playfield2_left,X	;				; 4+
	sta	PF2			;				; 3
	; has to happen by 38
; 32/33
	lda	playfield0_right,X	;				; 4+
	sta	PF0			;				; 3
	; has to happen 28-49
; 39/40
	lda	playfield1_right,X	;				; 4+
	sta	PF1			;				; 3
	; has to happen 38-56
; 46/47
	lda	#0			; always 0			; 2
	sta	PF2			;				; 3
	sta	PF0							; 3
	; has to happen 49-67
; 54/55

	dec	DIV3			; dec div3 count		; 5
	bpl	not3							; 2/3

	lda	#2			; reset div3 count		; 2
	sta	DIV3							; 3
	iny				; inc div3 color ptr		; 2
not3:
; 68/69 worst case

	tsx				; restore X from stack ptr	; 2
	dex				; dec X				; 2

; 72/73

	sta	WSYNC			;				; 3
; 75/76
	bne	colorful_loop		;				; 2/3

	;=================
	; done!

	ldx	XSAVE			; restore stack			; 3
	txs								; 2


	;==============================================================
	; 48-pixel sprite!!!!
	;==============================================================

	;================
	; scanline 180
	;	set things up

	lda	TEXT_COLOR
	sta	COLUP0	; set sprite color
	sta	COLUP1	; set sprite color

	lda	#NUSIZ_THREE_COPIES_CLOSE
	sta	NUSIZ0
	sta	NUSIZ1

	lda	#0		; turn off sprite
	sta	GRP0
	sta	GRP1

	lda	#1		; turn on delay
	sta	VDELP0
	sta	VDELP1

	sta	WSYNC

	;=================
	; scanline 181

	; to center exactly would want sprite0 at
	;	CPU cycle 41.3
	; and sprite1 at
	;	GPU cycle 44

	ldx	#7		;				2
pad_x:
	dex			;				2
	bne	pad_x		;				2/3
	; 3 + 5*X each time through

	; beam is at proper place
	sta	RESP0						; 3
	; 41 (GPU=123, want 124) +1
	sta	RESP1						; 3
	; 44 (GPU=132, want 132) 0

	lda	#$F0		; opposite what you'd think
	sta	HMP0			;			3
	lda	#$00
	sta	HMP1			;			3

	sta	WSYNC
	sta	HMOVE		; adjust fine tune, must be after WSYNC

	ldx	#7		; init X
	stx	TEMP2

	; scanline 182

	sta	WSYNC

	; scanline 183

spriteloop:
	; 0
	lda	sprite_bitmap0,X	; load sprite data		; 4+
	sta	GRP0			; 0->[GRP0] [GRP1 (?)]->GRP1	; 3
	; 7
	lda	sprite_bitmap1,X	; load sprite data		; 4+
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3
	; 14
	lda	sprite_bitmap2,X	; load sprite data		; 4+
	sta	GRP0			; 2->[GRP0], [GRP1 (1)]-->GRP1	; 3
	; 21

	lda	sprite_bitmap5,X					; 4+
	sta	TEMP1							; 3
	; 28
	lda	sprite_bitmap4,X					; 4+
	tay								; 2
	; 34
	lda	sprite_bitmap3,X	;				; 4+
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

	jsr	delay_12

;	nop								; 2
;	nop								; 2
;	nop								; 2
;	nop								; 2
;	nop								; 2
;	nop								; 2

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

	; scanline 192

	;===========================
	; overscan
	;============================

	lda	#$2		; turn off beam
	sta	VBLANK

	; wait 30 scanlines

	ldx	#29
	jsr	scanline_wait

	;=====================

	jsr	play_music

	sta	WSYNC


	jmp	start_frame

