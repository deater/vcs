; Attempt at 16 byte Atari 2600 demo

; by Vince `deater` Weaver

; based on ideas from Omegamatrix and Wintermute

.include "../../../vcs.inc"

.org $FF81

demo_start:

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



