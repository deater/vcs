hand_motion:

	;=============================
	; now at VBLANK scanline 28
	;=============================
	; handle left being pressed

	lda	POINTER_X		;				; 3
	beq	after_check_left	;				; 2/3

	lda	#$40			; check left			; 2
	bit	SWCHA			;				; 3
	bne	after_check_left	;				; 2/3

left_pressed:
	dec	POINTER_X		; move sprite left		; 5

after_check_left:
	sta	WSYNC			;				; 3
					;	============================
					;	 		9 / 20 / 16

	;=============================
	; now at VBLANK scanline 29
	;=============================
	; handle right being pressed

	lda	POINTER_X_END		;				; 3
	cmp	#167			;				; 2
	bcs	after_check_right	;				; 2/3

	lda	#$80			; check right			; 2
	bit	SWCHA			;				; 3
	bne	after_check_right	;				; 2/3

	inc	POINTER_X		; move sprite right		; 5
after_check_right:
	sta	WSYNC			;				; 3
					;	===========================
					; 			11 / 22 / 18

	;===========================
	; now at VBLANK scanline 30
	;===========================
	; handle up being pressed

	lda	POINTER_Y		;				; 3
	cmp	#1			;				; 2
	beq	after_check_up		;				; 2/3

	lda	#$10			; check up			; 2
	bit	SWCHA			;				; 3
	bne	after_check_up		;				; 2/3

	dec	POINTER_Y		; move sprite up		; 5

	jsr	pointer_moved_vertically	; 			; 6+16
after_check_up:
	sta	WSYNC			; 				; 3
					;	===============================
					; 			11 / 18 / 44

	;==========================
	; now VBLANK scanline 31
	;==========================
	; handle down being pressed

	lda	POINTER_Y_END		;				; 3
	cmp	#160			;				; 2
	bcs	after_check_down	;				; 2/3

	lda	#$20			;				; 2
	bit	SWCHA			;				; 3
	bne	after_check_down	;				; 2/3

	inc	POINTER_Y		; move sprite down		; 5
	jsr	pointer_moved_vertically	;			; 6+16
after_check_down:
	sta	WSYNC			;				; 3
					;	==============================
					; 			11 / 18 / 44


	rts								; 6
