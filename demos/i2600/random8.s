; https://wimcouwenberg.wordpress.com/2020/11/15/a-fast-24-bit-prng-algorithm-for-the-6502-processor/

random8:
	lda	rand_a		; Operation 7 (with carry clear).	; 3
	asl								; 2
	eor	rand_b							; 3
	sta	rand_b							; 3
; 11
	rol			; Operation 9.				; 2
	eor	rand_c							; 3
	sta	rand_c							; 3
; 19
	eor	rand_a		; Operation 5.				; 3
	sta	rand_a							; 3
; 25
	lda	rand_b		; Operation 15.				; 3
	ror								; 2
	eor	rand_c							; 3
	sta	rand_c							; 3
; 36
	eor	rand_b		; Operation 6.				; 3
	sta	rand_b							; 3
; 42
	rts
; 48

;rand_a:	.byte 0
;rand_b:	.byte 0
;rand_c:	.byte 1
