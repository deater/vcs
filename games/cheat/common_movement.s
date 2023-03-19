
common_movement:

	;=============================
	; now at VBLANK scanline 27
	;=============================
	; handle down being pressed
; 0
	lda	#$20			; check down			; 2
	bit	SWCHA                   ;				; 3
	bne	after_check_down        ;				; 2/3
down_pressed:
	lda	MAXY
	cmp	CHEAT_Y
	bcc	cant_inc_y

        inc	CHEAT_Y
        inc	CHEAT_Y
cant_inc_y:

after_check_down:
	sta	WSYNC                   ;                               ; 3

	;=============================
	; now at VBLANK scanline 28
	;=============================
	; handle up being pressed
; 0
	lda	#$10			; check up			; 2
	bit	SWCHA                   ;				; 3
	bne	after_check_up		;				; 2/3
up_pressed:

	lda	MINY
	cmp	CHEAT_Y
	bcs	cant_dec_y
        dec	CHEAT_Y
        dec	CHEAT_Y
cant_dec_y:

after_check_up:
	sta	WSYNC                   ;                               ; 3


	;=============================
	; now at VBLANK scanline 29
	;=============================
	; handle left being pressed
; 0
	lda	#$40                    ; check left                    ; 2
	bit	SWCHA                   ;                               ; 3
	bne	after_check_left        ;                               ; 2/3
left_pressed:

	lda	MINX
	cmp	CHEAT_X
	bcs	can_dec

        dec	CHEAT_X
can_dec:

	lda	#$0
	sta	CHEAT_DIRECTION

	sec
	lda	CHEAT_X
	sbc	#2
	sta	SHADOW_X


after_check_left:
	sta	WSYNC                   ;                               ; 3

	;=============================
	; now at VBLANK scanline 30
	;=============================
	; handle right being pressed
; 0
	lda	#$80			; check right                    ; 2
	bit	SWCHA			;                               ; 3
	bne	after_check_right	;                               ; 2/3
right_pressed:

	lda	MAXX
	cmp	CHEAT_X
	bcc	can_inc
	inc	CHEAT_X
can_inc:

	lda	#$8
	sta	CHEAT_DIRECTION

	clc
	lda	CHEAT_X
	adc	#2
	sta	SHADOW_X

	cmp	#140
	bcs	done_level

after_check_right:

	rts

done_level:
	jmp	blue_land


