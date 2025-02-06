; Attempt at 16 byte Atari 2600 demo

; by Vince `deater` Weaver

; based on framework by Omegamatrix

.include "../../../vcs.inc"

.org $FF80

demo_start:
;	nop
;	nop
;	nop
;	nop
;	nop
	nop
	nop

	; stack pointer $FD on startup on real hardware
	; you have to configure that in stella developer mode

	;=================================================
	; clear out registers

	; based on code by Omegamatrix

	; note we skip doing SEI (in theory VCS can't make interrupts)
	; we skip CLD (decimal flag), which is only necessary if we adc/sbc

clear_mem:
	asl			; gradually clear A to 0	; 1	2
	pha			; push on stack/zp		; 1	3
	tsx			; see if stack pointer 0	; 1	2
	bne	clear_mem					; 2	2/3
								;=====
								; 5
; scanline ?, 5 bytes

	; ZP  $80-$F6 clear, TIA clear, VSYNC=? SP=$00

	;========================================
	; we want 3 lines of VSYNC here

	; 262*76 = 19912 / 256 = 77R200

	; want 228 cycles of VSYNC

big_loop:
	ldy	#0
	lda	#2

outer_loop:
	tsx

	cpy	#1
	bcc	inner_loop
	lda	#0

inner_loop:
	;=====================
	sta	VSYNC

	;=====================

	dex
	bne	inner_loop

	;=====================
	sty	COLUBK

	dey
	bne	outer_loop

	.word	demo_start	; RESET vector			; 2
	beq	big_loop	; bra				; 2

; 25 bytes
