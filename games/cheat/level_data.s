
	; call with new X in A
	; call with new level in Y
init_level:
	sta	CHEAT_X						; 3
	clc							; 2
	ldx	CHEAT_DIRECTION					; 3
; 8
	bne	init_level_left					; 2/3
init_level_right:
	adc	#2						; 2
	jmp	done_adjust_cheat				; 3

init_level_left:
	adc	#$FE						; 2

done_adjust_cheat:
; 8+7/8+5, so 15 worst case

	sta	SHADOW_X					; 3
; 18
	dey							; 2
	lda	level_lookup_l,Y				; 4+
	sta	INL						; 3
	lda	level_lookup_h,Y				; 4+
	sta	INH						; 3
; 34

	ldy	#5						; 2
; 36

init_level_loop:
	lda	(INL),Y						; 5
	sta	MINX,Y						; 5
	dey							; 2
	bpl	init_level_loop					; 2/3

							; 6*15 = 90-1
; 125
	rts
; 131

level_lookup_l:
	.byte <strongbadia_data
	.byte <blue_level_data

level_lookup_h:
	.byte >strongbadia_data
	.byte >blue_level_data


strongbadia_data:
	.byte	8		; MINX
	.byte	160		; MAXX
	.byte	112		; MINY
	.byte	162		; MAXY	(note, div2)
	.byte	0		; LEFT_DEST
	.byte	DESTINATION_BLUE		; RIGHT_DEST

blue_level_data:
	.byte	8		; MINX
	.byte	152		; MAXX
	.byte	20		; MINY
	.byte	80		; MAXY	(note, div2)
	.byte	DESTINATION_STRONGBADIA	; LEFT_DEST
	.byte	0		; RIGHT_DEST

