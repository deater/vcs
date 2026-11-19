	;=======================================================
	;=======================================================
	; setup frame 2
	;=======================================================
	;=======================================================
setup_desktop_2:
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

	;=========================== at line 11

	lda	#18             ; this sets up timer for (18-1)*1024
	sta	T1024T		; which is 229 scanlines and the decompress
				; code will make sure we do the right thing
				; at 262


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

	; debug
;	jmp	setup_desktop_2



