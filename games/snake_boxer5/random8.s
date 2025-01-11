; https://wimcouwenberg.wordpress.com/2020/11/15/a-fast-24-bit-prng-algorithm-for-the-6502-processor/

random8:
	lda	RAND_A		; Operation 7 (with carry clear).	; 3
	asl								; 2 5
	eor	RAND_B							; 3 8
	sta	RAND_B							; 3 11
	rol			; Operation 9.				; 2 13
	eor	RAND_C							; 3 16
	sta	RAND_C							; 3 19
	eor	RAND_A		; Operation 5.				; 3 22
	sta	RAND_A							; 3 25
	lda	RAND_B		; Operation 15.				; 3 28
	ror								; 2 30
	eor	RAND_C							; 3 33
	sta	RAND_C							; 3 36
	eor	RAND_B		; Operation 6.				; 3 39
	sta	RAND_B							; 3 42
;
	rts								; 6 48


