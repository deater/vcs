; Attempt at 16 byte Atari 2600 demo

; by Vince `deater` Weaver

; based on ideas from Omegamatrix and Wintermute

.include "../../../vcs.inc"

.org $FF81

demo_start:
	nop		; 1
	nop		; 2
	nop		; 3
	nop		; 4
	nop		; 5
	nop		; 6
	nop		; 7
	nop		; 8
	nop		; 9
	nop		; 10
	nop		; 11
	nop		; 12
	nop		; 13
	nop		; 14
	nop		; 15
	nop		; 16

	; stack pointer $FD on startup on real hardware
	; you have to configure that in stella developer mode

main_loop:

	lda	#$70
vsync_loop:
	lsr
	sta	VSYNC

	sta	WSYNC
	dey
	sty	COLUBK

	bne	vsync_loop

	; A is 0 here

	pha

	; $FF80 = $80 FF

;	.word	demo_start	; RESET vector			; 2

	; $F0EF

	beq	main_loop	; bra				; 2

	nop



