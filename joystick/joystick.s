.include "../vcs.inc"

; zero page

COLOR	=	$80

start:
	lda	#$80
	sta	COLOR


start_frame:
	; Start Vertical Blank

	lda	#2				; reset beam to top of screen
	sta	VSYNC

	; wait for 3 scanlines

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC

	lda	#0				; done beam reset
	sta	VSYNC


	; 37 scanlines of vertical blank

	ldx	#37
vblank_loop:
	sta	WSYNC
	dex
	bne	vblank_loop

	lda	#0				; turn on beam
	sta	VBLANK

	; create pattern
	; visible area: 192 lines (NTSC)

	ldx	#$AA
	ldy	#192		; 192 lines
draw_screen_loop:
	sta	WSYNC

	lda	COLOR
	sta	COLUBK

	stx	PF0		; draw playfield
	stx	PF1
	stx	PF2

	dey
	bne	draw_screen_loop

	; overscan

	lda	#$2
	sta	VBLANK		; turn off beam


	;========================
	; read joystick
	;========================

	; player 1 is in high bits

	lda	INPT4
	bpl	joy_button

	lda	#$20		; 7=right 6=left 5=down 4=up
	bit	SWCHA		; sets N/V on high bits

	bpl	joy_right
	bvc	joy_left
	beq	joy_down
	lda	#$10
	bit	SWCHA
	bne	joy_none


joy_up:
	lda	#$20
	bne	joy_done
joy_down:
	lda	#$40
	bne	joy_done
joy_left:
	lda	#$60
	bne	joy_done
joy_right:
	lda	#$90
	bne	joy_done

joy_button:
	lda	#$A0


joy_done:
	sta	COLOR
joy_none:

	ldx	#30
overscan_loop:
	sta	WSYNC
	dex
	bne	overscan_loop

	jmp	start_frame

.segment "IRQ_VECTORS"
	.word start	; NMI
	.word start	; RESET
	.word start	; IRQ


