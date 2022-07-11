

init_level:

	lda	#19		; 19 seconds				; 2
	sta	TIME							; 3

	jsr	update_timer_bar					;6+??

	lda	#$16			; set initial x position
	sta	STRONGBAD_X
	jsr	spr0_moved_horizontally	;               6+49

	lda     #32			; initial sprite Y
	sta     STRONGBAD_Y
	jsr     spr0_moved_vertically

	lda	#0
	sta	SPRITE0_PIXEL_OFFSET
	sta	FRAME



	rts								; 6
								;============
								;	??
