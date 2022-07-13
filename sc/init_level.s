

init_level:

	lda	#20		; 20 seconds				; 2
	sta	TIME							; 3
; 5
	lda	#59							; 2
	sta	TIME_SUBSECOND						; 3
; 10
	lda	#$16			; set initial x position	; 2
	sta	STRONGBAD_X						; 5
	jsr	spr0_moved_horizontally	;               		; 6+49
; 72

	lda     #32			; initial sprite Y		; 2
	sta     STRONGBAD_Y						; 3
	jsr     spr0_moved_vertically					;6+17
; 110

	lda	#0							;2
	sta	FRAME							;3
	sta	LEVEL_OVER						;3
;118

	rts								; 6

;124
