	;=====================
	; VBLANK/VSYNC
	;=====================

common_vblank:

	;============================
	; Start Vertical Blank
	;============================

	lda	#2
	sta	VSYNC

	;=================================
	; wait for 3 scanlines of VSYNC
	;=================================

	sta	WSYNC		; wait until end of scanline
	sta	WSYNC
	lda	#0		; done beam reset			; 2
	sta	WSYNC

	; now in VSYNC scanline 3

	sta	VSYNC							; 3

	rts

; 9 cycles in




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



	;======================================
	; check if button/reset pressed
	;======================================
	; need to set DEBOUNCE_COUNTDOWN earlier

check_button_or_reset:

	;===============================
	; debounce reset/keypress check

	sec				; not pressed by default	; 2
	lda	DEBOUNCE_COUNTDOWN					; 3
	beq	waited_enough						; 2/3
	dec	DEBOUNCE_COUNTDOWN					; 5
	jmp	done_check_input					; 3

waited_enough:

; 8
	lda	INPT4			; check joystick button pressed	; 3
	rol				; put button press into C	; 2
					; (0=pressed)
	bcc	done_check_input					; 2/3

; 15
	lda	SWCHB			; check if reset pressed	; 3
	lsr				; put reset into carry		; 2
					; 0=switch pressed
; 20
done_check_input:
	rts
; 26 worst case?
