	;=========================
	;=========================
	; kernel
	;=========================
	;=========================
	; 192 scanlines

	; X is zero here

bounce_kernel_1:

bounce_kernel_1_loop:
	; comes in at 3 cycles

; 3
	;============================
	; set sprite size
	;============================

	ldy	#$0			; sprite pointer		; 2
	txa				; X is row			; 2
	sbc	SPRITE0_Y		; subtract y-position		; 3
	cmp	SPRITE_HEIGHT						; 3
; 13
	bcs	b1no_sprite0						; 2/3
; 15
	tay				; otherwise result is offset	; 2
	lda	sprite_data,Y						; 4
	tay								; 2
; 27
b1no_sprite0:
	sty	GRP0							; 3
	sty	GRP1							; 3
; 33/16
								;==========
								; 33 worst
; 33

	; setup checkerboard

	txa
	and	#$04
	bne	b1odd_checks
b1even_checks:
	lda	#FOREGROUND_COLOR
	ldy	#$0
	beq	b1done_checks
b1odd_checks:
	lda	#$0
	ldy	#FOREGROUND_COLOR
b1done_checks:
	sta	COLUPF
	sty	COLUBK

	inx								; 2
	cpx	#191							; 2

	sta	WSYNC							; 3
; 0

	bne	bounce_kernel_1_loop					; 2/3


done_bounce_kernel_1:

	jmp	done_bounce_kernel

