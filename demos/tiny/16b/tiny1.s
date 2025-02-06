; Attempt at 16 byte Atari 2600 demo

; by Vince `deater` Weaver

; based on framework by Omegamatrix

.include "../../../vcs.inc"

.org $FF80

demo_start:
	nop
	nop
	nop
	nop
	nop
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
	; based on code by Omegamatrix
	;	VSYNC set by writing 0000.0010 to VSYNC (other bits ignored)

	; X = 0
kernel_loop:
	ldx	#2						; 2
; 7 bytes

do_vsync:
	sta	WSYNC		; wait a scaline		; 2	3
	cpy	#3						; 2
	bcc	novsync		; blt				; 2
	tsx			; X=0				; 1
; 14 bytes
novsync:
	stx	VSYNC						; 2
	iny							; 1
	sty	COLUBK						; 2
; 19 bytes
	bne	do_vsync					; 2
; 21 bytes
	; $80ff - $80 = undocumented 2-byte nop

	.word	demo_start	; RESET vector			; 2
	beq	kernel_loop	; bra				; 2

; 25 bytes
