; Attempt at 64 byte Atari 2600 demo

; by Vince `deater` Weaver

.include "../../../vcs.inc"

	; Tricky things:
	;	we don't disable beam during VBLANK or VSYNC

.org $FF80

demo_start:
	nop	; 1
	nop	; 2
	nop	; 3
	nop	; 4
	nop	; 5
	nop	; 6
	nop	; 7
	nop	; 8
	nop	; 9
	nop	; 10
	nop	; 11
	nop	; 12
	nop	; 13
	nop	; 14
	nop	; 15
	nop	; 16
	nop	; 17
	nop	; 18
	nop	; 19
	nop	; 20
	nop	; 21
	nop	; 22
	nop	; 23
	nop	; 24
	nop	; 25
	nop	; 26
	nop	; 27
	nop	; 28
	nop	; 29
	nop	; 30
	nop	; 31
;	nop	; 32


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

;	sta	RESP0		; set consistent starting xpos for sprite0

; scanline ?, 6 bytes

	; ZP  $80-$F6 clear, TIA clear except VSYNC, SP=$00 X=00


	;========================================
	; we want 3 lines of VSYNC here
	; based on code by Omegamatrix
	;	VSYNC set by writing 0000.0010 to VSYNC (other bits ignored)

do_vsync:
	dex			; scroll color

;	stx	HMP0		; set sprite0 fine tune Xpos (top bits matter)

	; 0011.1000
	lda	#$38		; pattern to shift thru VSYNC	; 2	2
				; off 3 lines, on 3 lines
				; then 3 more lines of off

	sta	RESP0		; set consistent starting xpos for sprite0

	stx	HMP0		; set sprite0 fine tune Xpos (top bits matter)
;	sta	HMOVE

vsync_loop:
	sta	VSYNC		; set VSYNC			; 2	3
oog_loop:
	sta	WSYNC		; wait a scaline		; 2	3
	sta	HMOVE

	; A is 1 here at end, so set things to 1 here

	lsr			; shift pattern right		; 1	2
	bne	vsync_loop	; end when all 0		; 2	2/3

	; A is 0 here so can set things to 0 here

	;===================================
; scanline 6 / 17 bytes

;	sta	RESP0		; set consistent starting xpos for sprite0







main_kernel:
;	sta	WSYNC		; wait for scanline end		; 2	3
;	sta	HMOVE		; adjust xpos

	dex			; decrment count/color		; 1	2
	stx	COLUBK		; set color			; 2	3

	sty	GRP0		; set sprite

	dey			; eventually 0..256 counter	; 1	2
;	bne	main_kernel	; loop				; 2	2/3

	bne	oog_loop

; scanline 262? / 27 bytes


	;====================================
	; end of loop

	; must be 4 before end
; 60 bytes
	; $80/$FF  ($80 is undocumented 2-byte nop)
	.word	demo_start	; RESET vector			; 2
	beq	do_vsync	; bra				; 2

; 64 bytes
