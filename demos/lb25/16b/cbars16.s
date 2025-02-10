; cbars16 -- Attempt at 16 byte Atari 2600 demo

; by Vince `deater` Weaver / dSr

; for Lovebyte 2025

; based on ideas from Omegamatrix and Wintermute

; this abuses things a bit, it's 256 scanlines (262 is optimal)
; and doesn't turn off the beam during VBLANK
;  also a glitch every 256 frames when we trigger an extreanous WSYNC

; it takes 256 frames (roughly 4 seconds) to clear registers/memory
;	so possibly some sound or artifacts on screen until
;	that happens

.include "../../../vcs.inc"

.org $FF81

main_loop:

	lda	#$70		; important part is the 0111 000 pattern
				; three 1s means 3 scanlines of VSYNC
kernel_loop:
	lsr			; shift this through the VSYNC bit
	sta	VSYNC

	sta	WSYNC		; wait until end of scanline

	dey			; counter, counts 256 times
	sty	COLUBK		; also set background color for this line
				; (draws bars on screen)

	bne	kernel_loop

	; A is 0 here

	; RESET VECTOR
	; works out to be $F048 from pha/beq

	pha		; $48	; gradually clear all of I/O and RAM region
	beq	main_loop	; $F0 	bra			; 2

	nop
