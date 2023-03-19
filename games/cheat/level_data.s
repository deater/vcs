
	; call with new X in A
	; call with new level in Y
init_level:
	sty	CURRENT_LEVEL

	sta	CHEAT_X						; 3
	clc							; 2
	ldx	CHEAT_DIRECTION					; 3
; 8
	beq	init_level_left					; 2/3
init_level_right:
	adc	#2						; 2
	jmp	done_adjust_cheat				; 3

init_level_left:
	adc	#$FE						; 2

done_adjust_cheat:
; 8+7/8+5, so 15 worst case

	sta	SHADOW_X					; 3
; 18

	rts


minx_data:
	.byte 8			; strongbadia
	.byte 8			; blue

maxx_data:
	.byte 150		; strongbadia
	.byte 152		; blue

miny_data:
	.byte 112		; strongbadia
	.byte 20		; blue

maxy_data:
	.byte 162		; strongbadia
	.byte 80		; blue (note, div2)

left_dest_data:
	.byte DESTINATION_NONE		; strongbadia
	.byte DESTINATION_STRONGBADIA	; blue

right_dest_data:
	.byte DESTINATION_BLUE	; strongbadia
	.byte DESTINATION_NONE	; blue

left_dest_x:
	.byte 0			; strongbadia
	.byte 140		; blue

right_dest_x:
	.byte 10		; strongbadia
	.byte 0			; blue

