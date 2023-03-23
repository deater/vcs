
	; call with new X in A
	; call with new level in Y
init_level:
	sty	CURRENT_LEVEL					; 3
; 3
	sta	CHEAT_X						; 3
	clc							; 2
	ldx	CHEAT_DIRECTION					; 3
; 11
	beq	init_level_left					; 2/3
init_level_right:
	adc	#2						; 2
	jmp	done_adjust_cheat				; 3

init_level_left:
	adc	#$FE						; 2

done_adjust_cheat:
; 11+7/11+5, so 18 worst case

	sta	SHADOW_X					; 3
; 21

	rts
; 27

minx_data:
	.byte 8			; strongbadia
	.byte 8			; blue
	.byte 50		; pit
	.byte 8			; the stick
	.byte 8			; bubs

maxx_data:
	.byte 150		; strongbadia
	.byte 152		; blue
	.byte 110		; pit
	.byte 150		; the stick
	.byte 150		; bubs

miny_data:
	.byte 112		; strongbadia
	.byte 20		; blue
	.byte 124		; pit
	.byte 112		; the stick
	.byte 112		; bubs

maxy_data:
	.byte 162		; strongbadia
	.byte 79		; blue (note, div2)
	.byte 124		; pit
	.byte 162		; the stick
	.byte 162		; bubs

left_dest_data:
	.byte DESTINATION_STICK		; strongbadia
	.byte DESTINATION_BUBS		; blue
	.byte DESTINATION_NONE		; pit
	.byte DESTINATION_NONE		; the stick
	.byte DESTINATION_STRONGBADIA	; bubs

right_dest_data:
	.byte DESTINATION_BUBS	; strongbadia
	.byte DESTINATION_NONE	; blue
	.byte DESTINATION_NONE	; pit
	.byte DESTINATION_STRONGBADIA	; the stick
	.byte DESTINATION_BLUE	; bubs

left_dest_x:
	.byte 140		; strongbadia
	.byte 140		; blue
	.byte 0			; pit
	.byte 140		; the stick
	.byte 140		; bubs

right_dest_x:
	.byte 10		; strongbadia
	.byte 10		; blue
	.byte 0			; pit
	.byte 10		; the stick
	.byte 10		; bubs
