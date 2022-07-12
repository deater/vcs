	;===========================
	; set up playfield (4 scanlines)
	;===========================

	sta	WSYNC

	; update strongbad horizontal position

	; do this separately as too long to fit in with left/right code

	jsr	spr0_moved_horizontally	;				6+49
	sta	WSYNC			;				3
					;====================================
					;				58


	; set up sprite to be at proper X position

	; we can do this here and the sprite will be drawn as a long
	; vertical column
	; later we only enable it for the lines we want

	ldx	#0		; sprite 0 display nothing		2
	stx	GRP0		; (FIXME: this already set?)		3

	ldx	STRONGBAD_X_COARSE	;				3
	inx			;					2
	inx			;					2
pad_x:
	dex			;					2
	bne	pad_x		;					2/3
				;===========================================
				;	12-1+5*(coarse_x+2)
				; FIXME: describe better what's going on

	; beam is at proper place
	sta	RESP0							; 3

	sta	WSYNC							; 3
	sta	HMOVE		; adjust fine tune, must be after WSYNC	; 3
				; also draws black artifact on left of
				; screen


	; 1 scanline

	lda	#28
	sta	CURRENT_SCANLINE

	lda	#0
	sta	CURRENT_BLOCK

	lda	#$00			; disable playefield
	sta	PF0
	sta	PF1
	sta	PF2

	lda	#$C2			; green
	sta	COLUPF			; playfield color

	lda	#CTRLPF_REF		; reflect playfield
	sta	CTRLPF

	; reset back to strongbad sprite

	lda	#$40		; dark red				; 2
	sta	COLUP0		; set sprite color			; 3

	lda	#NUSIZ_ONE_COPY						; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1							; 3

	lda	#0							; 2
	sta	VDELP0							; 3
	sta	VDELP1							; 3


	sta	WSYNC


	; now at scanline 28

	;===========================================
	;===========================================
	; draw playfield, 192-28-10 = 154 scanlines
	;===========================================
	;===========================================
draw_playfield:

	;=============================================
	; we get 23 cycles in HBLANK, use them wisely


	; draw playfield
	ldx	CURRENT_BLOCK						; 3
	lda	playfield0_left,X	;				; 4+
        sta	PF0			;				; 3
        lda	playfield1_left,X	;				; 4+
        sta	PF1			;				; 3
        lda	playfield2_left,X	;				; 4+
        sta	PF2			;				; 3
	inc	CURRENT_BLOCK		;				; 5
								;============
								;	29
	lda	#$C2
	cpx	#9
	bcc	not_blue
	cpx	#29
	bcs	not_blue
	lda	#$80		; blue
not_blue:
	sta	COLUPF


	; activate strongbad sprite if necessary

	lda	CURRENT_SCANLINE
	; A = current scanline
	cmp	STRONGBAD_END_Y						; 3
	bcs	turn_off_sprite0					; 2/3
	cmp	STRONGBAD_Y						; 3
	bcc	turn_off_sprite0					; 2/3
turn_on_sprite0:
	lda	#$F0			; load sprite data		; 2
	sta	GRP0			; and display it		; 3
	iny				; increment			; 2
	jmp	after_sprite						; 3
turn_off_sprite0:
	lda	#0			; turn off sprite		; 2
	sta	GRP0							; 3
after_sprite:

	inc	CURRENT_SCANLINE					; 5
	sta	WSYNC							; 3

	inc	CURRENT_SCANLINE					; 5
	sta	WSYNC							; 3

	inc	CURRENT_SCANLINE					; 5
	sta	WSYNC							; 3

	inc	CURRENT_SCANLINE					; 5
	lda	CURRENT_SCANLINE					; 3
	cmp	#180			; draw 154 lines		; 2
	sta	WSYNC							; 3
	bcc	draw_playfield						; 2/3


