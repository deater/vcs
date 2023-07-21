	;=============================
	;=============================
	; update the hand pointer
	;=============================
	;=============================
	; first copies hand data to zero page
	; then it actually updates the position
	; originally these were separate routines called back to back
	; we merged them to save some room
	;=============================
	; takes 6 scalines total

hand_update:

	;=============================
	;=============================
	; copy in hand sprite
	;=============================
	;=============================
	; takes 4 scanlines


	; look at POINTER_TYPE
; 6
;hand_copy:
	lda	POINTER_TYPE						; 3
	asl								; 2
	asl								; 2
	asl								; 2
	asl	; multiply by 16					; 2
; 17

	; carry should be 0 from the shifting
	adc	#<hand_sprite						; 2
	sta	INL							; 3
	lda	#>hand_sprite						; 2
	sta	INH							; 3
; 27
	ldy	#15							; 2
; 29

hand_copy_loop:
	lda	(INL),Y							; 5+
	sta	HAND_SPRITE,Y						; 4+
	dey								; 2
	bpl	hand_copy_loop						; 2/3

	; (16*14)-1 = 223
; 242
	;	around 3.3 scanlines
	sta	WSYNC


;hand_motion:

	;=============================
	; now at scanline 5
	;=============================
	; handle left being pressed
	;=============================

; 0
	lda	POINTER_X		;				; 3
	beq	after_check_left	;				; 2/3
; 5
	lda	#$40			; check left			; 2
	bit	SWCHA			;				; 3
	bne	after_check_left	;				; 2/3

; 12
left_pressed:
	dec	POINTER_X		; move sprite left		; 5

after_check_left:
					;	============================
					;	 		6 / 13 / 17


	;===========================
	; still at scanline 5
	;===========================
	; handle up being pressed
	;===========================
; 17 (worst case)

	lda	POINTER_Y		; bounds check			; 3
	cmp	#1			;				; 2
	bcc	after_check_up		;				; 2/3

; 24
	lda	#$10			; check joystick up		; 2
	bit	SWCHA			;				; 3
	bne	after_check_up		;				; 2/3

; 31

	dec	POINTER_Y		; move sprite up		; 5

after_check_up:
	sta	WSYNC			; 				; 3
					;	===============================
					; 			28 / 35 / 39



	;=============================
	; scanline 6
	;=============================
	; handle right being pressed
	;=============================

; 0
	lda	POINTER_X_END		;				; 3
	cmp	#150			;				; 2
	bcs	after_check_right	;				; 2/3
; 7
	lda	#$80			; check joystick right		; 2
	bit	SWCHA			;				; 3
	bne	after_check_right	;				; 2/3
; 14
	inc	POINTER_X		; move sprite right		; 5
after_check_right:
					;	===========================
					; 			8 / 15 / 19



	;==========================
	; still scanline 16
	;==========================
	; handle down being pressed
; 19
	lda	POINTER_Y_END		;				; 3
	cmp	#86			;				; 2
	bcs	after_check_down	;				; 2/3
; 26
	lda	#$20			;				; 2
	bit	SWCHA			;				; 3
	bne	after_check_down	;				; 2/3
; 33
	inc	POINTER_Y		; move sprite down		; 5
after_check_down:
					;	==============================
					; 			27 / 34 / 38

	;====================================
	; always adjust this every frame

;pointer_moved_vertically:
	clc								; 2
	lda     POINTER_Y						; 3
	adc     #16     ; pointer height				; 2
	sta     POINTER_Y_END						; 3

; 48 worst case

;pointer_moved_horizontally:
	clc								; 2
	lda	POINTER_X						; 3
	adc	#8							; 2
	sta	POINTER_X_END						; 3

; 58 worst case

	; wait

	sta	WSYNC			;				; 3


	rts								; 6
