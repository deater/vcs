	;============]========================
	; scanline 1: setup sprite0/1 X/Y
	;====================================
adjust_sprites:

; 6
	lda	SPRITE0_X						; 3
; 9
        ; spritex DIV 16

	lsr								; 2
	lsr								; 2
	lsr								; 2
	lsr								; 2

        sta	SPRITE0_X_COARSE					; 3
; 20
	; apply fine adjust
	lda	SPRITE0_X						; 3
	and	#$0f							; 2
	tax								; 2
	lda	fine_adjust_table,X					; 4+
	sta	HMP0							; 3
; 34

	lda	SPRITE1_X						; 3
; 37
        ; spritex DIV 16

	lsr								; 2
	lsr								; 2
	lsr								; 2
	lsr								; 2

        sta	SPRITE1_X_COARSE					; 3
; 48
	; apply fine adjust
	lda	SPRITE1_X						; 3
	and	#$0f							; 2
	tax								; 2
	lda	fine_adjust_table,X					; 4+
	sta	HMP1							; 3
; 62
	sta	WSYNC

	;=======================================================
	; scanline 2: set up sprite0 to be at proper X position
	;=======================================================
	; value will be 0..9

; 0

	ldx	a:SPRITE0_X_COARSE	; force 4-cycle version		; 4
; 4

	nop								; 2
	nop								; 2

; 8
	inx                     ;                                       ; 2
	inx                     ;                                       ; 2
; 12 (want to be 12 here)


	; X is 2..12 here
pad_x:
	dex                     ;                                       2
	bne	pad_x           ;                                       2/3
                                ;===========================================
                                ;       5*(coarse_x+2)-1
                                ; COARSE_X is 0..9 so
				;   9 .. 54 cycles

; up to 66
        ; beam is at proper place
        sta     RESP0                                                   ; 3
; up to 69

	sta	WSYNC


	;=======================================================
	; scanline 3: set up sprite1 to be at proper X position
	;=======================================================

; 0

	ldx	a:SPRITE1_X_COARSE	; force 4-cycle version		; 4
; 4

;	cpx	#$A                                                     ; 2
;	bcs	far_right	; bge                                   ; 2/3

	nop								; 2
	nop								; 2

; 8
	inx                     ;                                       ; 2
	inx                     ;                                       ; 2
; 12 (want to be 12 here)


pad_x1:
	dex                     ;                                       2
	bne	pad_x1           ;                                       2/3
                                ;===========================================
                                ;       5*(coarse_x+2)-1
                                ; COARSE_X is 0..9 so
				;   9 .. 54 cycles
; up to 66
        ; beam is at proper place
	sta     RESP1                                                   ; 3
; up to 69

	sta	WSYNC


	rts
