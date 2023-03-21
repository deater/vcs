	; 4 scanlines?

common_movement:

	;=============================
	; now at VBLANK scanline 27
	;=============================
	; handle down being pressed
; 6
	lda	#$ff
	sta	NEW_LEVEL

	ldy	CURRENT_LEVEL

	lda	#$20			; check down			; 2
	bit	SWCHA                   ;				; 3
	bne	after_check_down        ;				; 2/3
down_pressed:
	lda	maxy_data,Y
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

	lda	miny_data,Y
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

	lda	minx_data,Y
	cmp	CHEAT_X
	bcs	cant_dec
can_dec:
        dec	CHEAT_X
	jmp	update_left
cant_dec:
	; if hit here, tried to go off left
	lda	left_dest_data,Y	; see if should leave
	bmi	update_left
	sta	NEW_LEVEL
	lda	left_dest_x,Y
	sta	NEW_X

update_left:
;	lda	#SFX_CLICK
;	sta	SFX_NEW

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

	lda	maxx_data,Y
	cmp	CHEAT_X
	bcc	cant_inc
can_inc:
	inc	CHEAT_X
	jmp	update_right
cant_inc:
	; if hit here, tried to go off left
	lda	right_dest_data,Y	; see if should leave
	bmi	update_right
	sta	NEW_LEVEL
	lda	right_dest_x,Y
	sta	NEW_X

update_right:
	lda	#$8
	sta	CHEAT_DIRECTION

	clc
	lda	CHEAT_X
	adc	#2
	sta	SHADOW_X

after_check_right:

	ldy	NEW_LEVEL
	bpl	done_level
	rts

done_level:

	lda	level_dest_h,Y
	pha
	lda	level_dest_l,Y
	pha

	lda	NEW_X

	rts

level_dest_l:
	.byte	<(strongbadia_start-1),<(blue_land-1)
	.byte	<(the_pit-1),<(the_stick-1)

level_dest_h:
	.byte	>(strongbadia_start-1),>(blue_land-1)
	.byte	>(the_pit-1),>(the_stick-1)
