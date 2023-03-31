	;============================
	; common overscan
	;============================
	; lines in X
common_overscan_sound:
	lda	#$2		; turn off beam
	sta	VBLANK

	jsr	scanline_wait	; number in X

        ;===============================
	; 22 scanlines -- trigger sound
	;===============================

	ldy	SFX_NEW
	beq	bskip_sound
	jsr	trigger_sound           ; 52 cycles
	lda	#0
	sta	SFX_NEW
bskip_sound:
	sta	WSYNC

	;=============================
	; 23-24 scanlines -- update sound
	;=============================
	; takes two scanlines

        jsr     update_sound            ; 2 scanlines

        sta     WSYNC

	rts
