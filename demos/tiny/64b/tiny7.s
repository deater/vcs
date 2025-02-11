; Attempt at 32 byte Atari 2600 demo

; by Vince `deater` Weaver

.include "../../../vcs.inc"

	; Tricky things:
	;	we don't disable beam during VBLANK or VSYNC


COUNT=$FF


demo_start:

clear_mem:

	asl			; gradually clear A to 0	; 1     2
	pha			; push on stack/zp		; 1     3
	tsx			; see if stack pointer 0	; 1     2
	bne     clear_mem					; 2     2/3

	; ZP  $80-$F6 clear, TIA clear except VSYNC, SP=$00 X=00


	;========================================
	; we want 3 lines of VSYNC here
	; based on code by Omegamatrix
	;	VSYNC set by writing 0000.0010 to VSYNC (other bits ignored)

	lda	#6
	sta	NUSIZ0

	lda	#144
	sta	COLUBK

	lda	#$ff
	sta	GRP0

do_vsync:

	inc	COUNT
	sta	RESP0

	; 0011.1000
	lda	#$38		; pattern to shift thru VSYNC	; 2	2
				; off 3 lines, on 3 lines
				; then 3 more lines of off
vsync_loop:
	sta	WSYNC		; wait a scaline		; 2	3
	sta	VSYNC		; set VSYNC			; 2	3

	lsr
	bne	vsync_loop

kernel_loop:

	sta	WSYNC		; wait a scaline		; 2	3
	sta	HMOVE

	ldx	#$10

	inc	COUNT
	lda	COUNT
	and	#$08
	bne	skip
	ldx	#$ff

skip:
	stx	HMP0		; set sprite0 fine tune Xpos (top bits matter)


	;===================================
; scanline 6 / 17 bytes

;	dex			; decrment count/color		; 1	2

;	sty	GRP0		; set sprite

	dey			; eventually 0..256 counter	; 1	2
	bne	kernel_loop

; scanline 262? / 27 bytes

	beq	do_vsync

	;====================================
	; end of loop


	demo_end:

.res 64-(demo_end-demo_start)-4,$EA     ; nops

	.word	demo_start	; RESET vector			; 2

	nop
	nop




; 64 bytes

