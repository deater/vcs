

init_level:

	lda	#20		; 20 seconds				; 2
	sta	TIME							; 3

	lda	#59							; 2
	sta	TIME_SUBSECOND						; 3

	lda	#$16			; set initial x position
	sta	STRONGBAD_X
	jsr	spr0_moved_horizontally	;               6+49

	lda     #32			; initial sprite Y
	sta     STRONGBAD_Y
	jsr     spr0_moved_vertically

	lda	#0
	sta	SPRITE0_PIXEL_OFFSET
	sta	FRAME
	sta	LEVEL_OVER


	rts								; 6
								;============
								;	??
