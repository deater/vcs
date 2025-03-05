; Attempt at 32 byte Atari 2600 demo

; by Vince `deater` Weaver

.include "../../../vcs.inc"

	; Tricky things:
	;	we don't disable beam during VBLANK or VSYNC

.org $FF20

demo_start:

	; stack pointer $FD on startup on real hardware
	; 	you have to configure that in stella developer mode
	;	sadly on my real hardware+harmony cart
	;	 this isn't true so the output isn't always great

	;=================================================
	; clear out registers

	; based on code by Omegamatrix

	; note we skip doing SEI (in theory VCS can't make interrupts)
	; we skip CLD (decimal flag), which is only necessary if we adc/sbc

clear_mem:
	asl			; gradually clear A to 0	; 1	2
	pha			; push on stack/zp		; 1	3
	stx	HMP0		; set sprite0 fine tune Xpos (top bits matter)
;	stx	NUSIZ0
	tsx			; see if stack pointer 0	; 1	2
	bne	clear_mem					; 2	2/3
								; 5

; scanline ?, 5 bytes

	; ZP  $80-$F6 clear, TIA clear except VSYNC, SP=$00 X=00


	;========================================
	; we want 3 lines of VSYNC here
	; based on code by Omegamatrix
	;	VSYNC set by writing 0000.0010 to VSYNC (other bits ignored)

do_vsync:
;	dex			; scroll color

;	dex
;	nop

	; 0011.1000
	lda	#$38		; pattern to shift thru VSYNC	; 2	2
				; off 3 lines, on 3 lines
				; then 3 more lines of off

;	sta	NUSIZ0

;	sta	HMP0		; set sprite0 fine tune Xpos (top bits matter)

vsync_loop:
	sta	VSYNC		; set VSYNC			; 2	3

kernel_loop:
	sta	WSYNC		; wait a scaline		; 2	3
	sta	HMOVE

;	inc	HMP0		; set sprite0 fine tune Xpos (top bits matter)

	; A is 1 here at end, so set things to 1 here

	lsr			; shift pattern right		; 1	2
	bne	vsync_loop	; end when all 0		; 2	2/3

	; A is 0 here so can set things to 0 here

	;===================================
; scanline 6 / 17 bytes

	dex			; decrment count/color		; 1	2
	stx	COLUBK		; set color			; 2	3

	stx	HMP0

	stx	GRP0		; set sprite

	dey			; eventually 0..256 counter	; 1	2
	bne	kernel_loop

; scanline 262? / 27 bytes


	;====================================
	; end of loop

	; must be 4 before end
; 60 bytes
	; $80/$FF  ($80 is undocumented 2-byte nop)

	; 0,1,2 probably fine

	; $00=BRK,$20=JSR,$40=RTI,$60=RTS,$80=NOP2,$A0=LDY#N,$C0=CPY#N,$E0=CPX#N
	; $01=ORA,$21=AND,$41=EOR,$61=ADC,$81=STA,$A1=LDA,$C1=CMP,$E1=SBC
	; $02=HLR,$22=HLT,$42=HLT,$62=HLT,$82=HLT,$A2=LDX#N,$C2=HLT,$E2=HLT

	; address can be any $F0..FF, $D0..DF
	; F8=SED

	; $CA=DEX

	; $EE if try to shove branch into here

	.byte	$80
	.byte	$F0


;	.word	clear_mem	; RESET vector			; 2

	; 1E/FF

	beq	do_vsync	; bra				; 2

	; 37/FF



; 32 bytes

