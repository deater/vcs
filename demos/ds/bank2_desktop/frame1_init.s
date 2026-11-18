	;=======================================================
	;=======================================================
	; setup frame 1
	;=======================================================
	;=======================================================
setup_desktop_1:
	;=============================
	jsr	common_vblank
; 9
	;================================
	; play music -- scanlines 0..10
	;================================
        ; takes 11 lines?

	lda	#2		; our bank
	jsr	do_play_music
	sta	WSYNC

	;=========================== now 11

	ldx	#37-11
	jsr	repeat_wsync

	;============================ now 0


	; load compressed data into RAM

	lda	#<teapot_high
	sta	INL
	lda	#>teapot_high
	sta	INH

	ldx	#0
	jsr	rom_to_256_copy

	;============================ now 51


	lda	#2			; we're bank2
	sta	PAGE_SAVE

	lda     #$4
        sta     READ_WRITE_OFFSET

        lda     #<E7_256B_READ_ADDR
        sta     ZX0_src
        lda     #>E7_256B_READ_ADDR
        sta     ZX0_src_h

        lda     #>E7_BANK_BASE
        jsr     zx02_full_decomp


	; now need to copy from 1k RAM to 256-byte RAM

	lda	#2			; bank to return to
	jsr	bank7_to_256_copy


	;===============================

	ldx	#191-51
	jsr	repeat_wsync



	;=========================== now 191

	lda	#0
	sta	EFFECTL
	sta	EFFECTH
	sta	WHICH_EFFECT


	sta	WSYNC

	;=========================== now 192

	ldx	#29
	jsr	common_overscan

	; debug
	jmp	setup_desktop_1



