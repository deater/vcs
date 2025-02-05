; Attempt at 32 byte Atari 2600 demo

; by Vince `deater` Weaver

.include "../../../vcs.inc"

	; Tricky things:
	;	we don't disable beam during VBLANK or VSYNC

.org $FF80

demo_start:

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
								; 6
; scanline ?, 6 bytes

	; ZP  $80-$F6 clear, TIA clear, SP=$FF

;	dex
;	stx	GRP0

	;========================================
	; we want 3 lines of VSYNC here
	; based on code by Omegamatrix
	;	VSYNC set by writing 0000.0010 to VSYNC (other bits ignored)

do_vsync:
	; 0011.1000
	lda	#$38		; pattern to shift thru VSYNC	; 2	2
				; off 3 lines, on 3 lines
				; then 3 more lines of off
vsync_loop:
	sta	WSYNC		; wait a scaline		; 2	3
	sta	VSYNC		; set VSYNC			; 2	3

	; A is 1 here at end, so set things to 1 here

	lsr			; shift pattern right		; 1	2
	bne	vsync_loop	; end when all 0		; 2	2/3

	; A is 0 here so can set things to 0 here

	;===================================
; scanline 6 / 17 bytes

;	sta	GRP0

	sta	RESP0
	stx	HMP0

;	dex			; scroll color and shape

main_kernel:
	sta	WSYNC		; wait for scanline end		; 2	3
	sta	HMOVE		; move sprite			; 2	3

	dex			; decrment count/color		; 1	2
	stx	COLUBK		; set bg color			; 2	3


	;======================================

	dey			; eventually 0..256 counter	; 1	2
	bne	main_kernel	; loop				; 2	2/3
; scanline 262? / 27 bytes

	;====================================
	; end of loop

;demo_end:
;.res 64-(demo_end-demo_start)-4,$EA	; nops

	; must be 4 before end
; 28 bytes

	; 00 FF -- brk
	; 20 FF -- jsr
	; 40 FF -- rti
	; 60 FF -- rts
	; 80 FF -- ??? (undocumented, nop imm)
	; A0 FF -- ldy imm
	; C0 FF	-- cpy imm
	; E0 FF -- cpx imm

	.word	demo_start	; RESET vector			; 2
	beq	do_vsync	; bra				; 2

; 32 bytes
