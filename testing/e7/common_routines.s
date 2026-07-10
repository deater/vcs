	;=====================
	; VBLANK/VSYNC
	;=====================
	; our code takes 4 scanlines, clears out old one first
	; this makes sure we get a full 3 scanlines of VSYNC

common_vblank:

	;============================
	; Start Vertical Blank
	;============================

	lda	#2


	;=================================
	; wait for 3 scanlines of VSYNC
	;=================================

	sta	WSYNC		; wait until end of scanline
	sta	VSYNC

	sta	WSYNC
	sta	WSYNC
	lda	#0		; done beam reset			; 2
	sta	WSYNC

	; now in VSYNC scanline 3

	sta	VSYNC							; 3

	rts

; 9 cycles in

	;=============================
	; repeat wsync
	;=============================
	; repeat count in X
repeat_wsync:
	sta	WSYNC
	dex
	bne	repeat_wsync
	rts
; 8 cycles

	;=============================
	; overscan
	;=============================
	; amount of scanlines to wait is in X

common_overscan:
	lda	#$2		; turn off beam
	sta	VBLANK

common_delay_scanlines:
	sta	WSYNC							; 3
	dex								; 2
	bne	common_delay_scanlines					; 2/3
	rts								; 6



	;===================================
	; check joypad button, with debounce
	;===================================
	; returns carry set if pressed, carry clear otherwise

check_joypad_button:

	lda	BUTTON_COUNTDOWN					; 3
	beq	waited_button_enough					; 2/3
	dec	BUTTON_COUNTDOWN					; 5
	jmp	done_check_button_nopress				; 3

waited_button_enough:

	lda	INPT4		; check joystick button pressed		; 3
	bpl	done_check_button_press					; 2/3

done_check_button_nopress:
	clc
	rts

done_check_button_press:
	sec
	rts


