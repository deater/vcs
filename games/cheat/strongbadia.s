; strongbadia

; o/~ come to the place where tropical breezes blow o/~

strongbadia_loop:

	;=========================
	; Start Vertical Blank
	;=========================

	lda	#2			; reset beam to top of screen
	sta	VSYNC

	;================================
	; wait for 3 scanlines of VSYNC

	sta	WSYNC			; wait until end of scanline
	sta	WSYNC

	; mirror playfield
	lda	#CTRLPF_REF
	sta	CTRLPF

	sta	WSYNC

	lda	#0			; done beam reset
	sta	VSYNC

	;===============================
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

	nop
	nop
	nop

	sta	RESP0			; coasre sprite0

	lda	#$34			; red for the periods		; 2
	sta	COLUP0							; 3
	sta	a:COLUP1		; force extra cycle		; 4

	sta	RESP1			; coarse sprite1

        sta     WSYNC                   ;                               3
	sta	HMOVE


	;=============================
	; 37

	lda	#NUSIZ_TWO_COPIES_WIDE
	sta	NUSIZ0
	sta	NUSIZ1

	lda	#$0		; turn off delay
	sta	VDELP0
	sta	VDELP1

	sta	GRP0		; clear sprites
	sta	GRP1

	sta	PF0		; clear playfield
	sta	PF1
	sta	PF2


	sta	WSYNC

	stx	VBLANK			; turn on beam (X=0)


	;===========================
	;===========================
	; playfield
	;===========================
	;===========================
	; draw 192 lines

	ldx	#0

	;===========================
	; 60 lines of bushes
	;===========================
	; Hills?  I always thought those were bushes...
	;	(figurative)
bushes_top_loop:
; 3
;	lda	bushes_bg_colors,X					; 4+
	sta	COLUBK							; 3
; 6
	lda	bushes_colors,X						; 4+
	sta	COLUPF							; 3
; 13
	lda	bushes_playfield0_left,X				; 4+
	sta	PF0							; 3
	; must write by CPU 22 [GPU 68]
; 20
	lda	bushes_playfield1_left,X				; 4+
	sta	PF1							; 3
	; must write by CPU 28 [GPU 84]
; 27
	lda	bushes_playfield2_left,X				; 4+
	sta	PF2							; 3
	; must write by CPU 38 [GPU 116]
; 34


	inx								; 2
	lda	bushes_bg_colors,X					; 4+
	cpx	#60							; 2
; 70
	sta	WSYNC
	bne	bushes_top_loop

	ldx	#0

	;===========================
	; 48 lines of strongbadia
	;===========================
strongbadia_top_loop:
; 3
	lda	#$D4							; 2
	sta	COLUBK							; 3
; 8
	lda	strongbadia_colors,X					; 4+
	sta	COLUPF							; 3
; 15
	lda	#$00							; 2
	sta	PF0							; 3
	; must write by CPU 22 [GPU 68]
; 20
	lda	strongbadia_playfield1_left,X				; 4+
	sta	PF1							; 3
	; must write by CPU 28 [GPU 84]
; 27
	lda	strongbadia_playfield2_left,X				; 4+
	sta	PF2							; 3
	; must write by CPU 38 [GPU 116]
; 34

	inx								; 2
	cpx	#48							; 2
; 70
	sta	WSYNC
	bne	strongbadia_top_loop




	;===========================

	ldx	#82
	jsr	scanline_wait


	;============================
	; overscan
	;============================
strongbadia_overscan:
	lda	#$2		; turn off beam
	sta	VBLANK

	; wait 30 scanlines

	ldx	#30
	jsr	scanline_wait

	jmp	strongbadia_loop

