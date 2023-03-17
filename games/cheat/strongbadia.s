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

.if 0
	;===========================
	; 32 lines of title
	;===========================
logo_loop:
; 3
	lda	title_playfield0_left,X					; 4+
	sta	PF0							; 3
	; must write by CPU 22 [GPU 68]
; 10
	lda	title_playfield1_left,X					; 4+
	sta	PF1							; 3
	; must write by CPU 28 [GPU 84]
; 17
	lda	title_playfield2_left,X					; 4+
	sta	PF2							; 3
	; must write by CPU 38 [GPU 116]
; 24
	cpy	#28			; 2
	bcc	blargh			; 2/3

	lda	#$30			; 2
	sta	GRP0			; 3
	sta	GRP1			; 3
	bne	blargh2			; 3
blargh:
	inc	$95	; nop5		; 5
	dec	$95	; nop5		; 5

blargh2:
	; 15/15

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
	iny								; 2
	tya								; 2
	lsr								; 2
	tax								; 2
; 68
	cpy	#32							; 2
; 70
	sta	WSYNC
	bne	logo_loop

	; at scaline 46 here?

.endif
	;===========================

	ldx	#192
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

