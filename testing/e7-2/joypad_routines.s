DEBOUNCE_VAL = 32


	;===================================
	; check joypad button, with debounce
	;===================================
	; returns carry set if pressed, carry clear otherwise

check_joypad_button:
; 6
	lda	DEBOUNCE_COUNTDOWN					; 3
	beq	waited_button_enough					; 2/3
; 11
	dec	DEBOUNCE_COUNTDOWN					; 5
	jmp	common_check_not_pressed				; 3
; 19

waited_button_enough:
; 12
	lda	INPT4		; check joystick button pressed		; 3
	bpl	common_check_was_pressed				; 2/3
	bmi	common_check_not_pressed	; bra (3)		; 3

; 19/20
common_check_not_pressed:
	clc								; 2
	rts								; 6
; 27/28

; 18
common_check_was_pressed:
	lda	#DEBOUNCE_VAL						; 2
	sta	DEBOUNCE_COUNTDOWN					; 3
	sec								; 2
	rts								; 6
; 31


	;===================================
	; check up button, with debounce
	;===================================
	; returns carry set if up pressed, carry clear otherwise

check_joypad_up:

	lda	DEBOUNCE_COUNTDOWN					; 3
	beq	waited_up_enough					; 2/3
	dec	DEBOUNCE_COUNTDOWN					; 5
	jmp	common_check_not_pressed				; 3

waited_up_enough:

	lda	#$10		; up
	bit	SWCHA		; check joystick up pressed		; 3
	beq	common_check_was_pressed				; 2/3
	bne	common_check_not_pressed


	;===================================
	; check down button, with debounce
	;===================================
	; returns carry set if down pressed, carry clear otherwise

check_joypad_down:

	lda	DEBOUNCE_COUNTDOWN					; 3
	beq	waited_down_enough					; 2/3
	dec	DEBOUNCE_COUNTDOWN					; 5
	jmp	common_check_not_pressed				; 3

waited_down_enough:

	lda	#$20		; down
	bit	SWCHA		; check joystick down pressed		; 3
	beq	common_check_was_pressed				; 2/3
	bne	common_check_not_pressed


	;===================================
	; check right button, with debounce
	;===================================
	; returns carry set if right pressed, carry clear otherwise

check_joypad_right:

	lda	DEBOUNCE_COUNTDOWN					; 3
	beq	waited_right_enough					; 2/3
	dec	DEBOUNCE_COUNTDOWN					; 5
	jmp	common_check_not_pressed				; 3

waited_right_enough:

	lda	#$80		; right
	bit	SWCHA		; check joystick right pressed		; 3
	beq	common_check_was_pressed				; 2/3
	bne	common_check_not_pressed


	;===================================
	; check left button, with debounce
	;===================================
	; returns carry set if left pressed, carry clear otherwise

check_joypad_left:

	lda	DEBOUNCE_COUNTDOWN					; 3
	beq	waited_left_enough					; 2/3
	dec	DEBOUNCE_COUNTDOWN					; 5
	jmp	common_check_not_pressed				; 3

waited_left_enough:

	lda	#$40		; left
	bit	SWCHA		; check joystick left pressed		; 3
	beq	common_check_was_pressed				; 2/3
	bne	common_check_not_pressed









;SWCHA   =       $280            ; Port A (joystick)
                                ;       bits 4-7 = player 1
                                ;       bits 0-3 = player 2
                                ;       $01=up   $02=down
                                ;       $04=left $08=right
