	;==========================
	; Opening
	;==========================
	; potentially arrive here with an unknown number of cycles/scanlines
	; ideally VBLANK=2 (beam off)

; $70C at start
; $6A1 after removing unneeded

do_opening:
start_opening:

	sta	WSYNC

	;=================
	; start VBLANK
	;=================
	; in scanline 0

	jsr	common_vblank

; 9
	;=============================
	; 37 lines of vertical blank
	;=============================

	;========================
	; update music player
	;========================
	jsr	handle_music

	sta	WSYNC
	sta	WSYNC



	;===================
	; now scanline 35
	;===================
	; center the sprite position
	; needs to be right after a WSYNC
; 0

	; limit coarse X from roughly 2..10

	lda	FRAMEL
	lsr
	lsr
	lsr
	lsr
	and	#$7
	tax
	inx
	inx

; 7

tpad_x:
	dex			;					; 2
	bne	tpad_x		;					; 2/3
	; for X delays (5*X)-1
	; so in this case, 29
; 36
	; beam is at proper place
	sta	RESM0							; 3
	; 39 (GPU=??, want ??) +?
; 39

	lda	#$F0		; opposite what you'd think		; 2
	sta	HMM0							; 3

; 52
	sta	WSYNC
; 0
	sta	HMOVE		; adjust fine tune, must be after WSYNC
; 3

	;=======================
	; scanline 36

	sta	WSYNC

	;=======================
	; scanline 37 -- config
; 0
	ldy	#0							; 2
	ldx	#0							; 2
	stx	VBLANK			; turn on beam			; 3
	stx	GRP0			; turn off sprite0 		; 3
	stx	GRP1			; turn off sprite1		; 3
; 13
	lda	#(47*2)
	sta	COLUP0

	lda	#NUSIZ_MISSILE_WIDTH_2
	sta	NUSIZ0

; 19
	lda	#0							; 3
	sta	COLUBK							; 3
; 25
;	lda	#$4E							; 3h
	sta	WSYNC


	;=============================================
	;=============================================
	; draw opening
	;=============================================
	;=============================================

	; 
skip_loop:
	iny
	cpy	#52
	sta	WSYNC
	bne	skip_loop

opening_loop:


; 2/0
	lda	lucas_colors,X						; 4+
	sta	COLUPF		; set playfield color			; 3

; 7
	lda	lucas_playfield0_left,X		;			; 4+
	sta	PF0				;			; 3
	; must write by CPU 22 [GPU 68]
; 14
	lda	lucas_playfield1_left,X		;			; 4+
	sta	PF1				;			; 3
	; must write by CPU 27? [GPU 84]
; 21
	lda	lucas_playfield2_left,X		;			; 4+
	sta	PF2				;			; 3
	; must write by CPU 38 [GPU 116]
; 28

	lda	lucas_playfield0_right,X	;			; 4+
	sta	PF0				;			; 3
	; must write by CPU 49 [GPU 148]
; 35
	lda	lucas_playfield1_right,X	;			; 4+
	sta	PF1				;			; 3
	; must write by CPU 54 [GPU 164]
; 42
	lda	lucas_playfield2_right,X	;			; 4+
	sta	PF2				;			; 3
	; must write by CPU 65 [GPU 196]
; 49

        iny                                                             ; 2
        tya                                                             ; 2
        and     #$3                                                     ; 2
        beq     yes_inx                                                 ; 2/3
        .byte   $A5     ; begin of LDA ZP                               ; 3
yes_inx:
        inx             ; $E8 should be harmless to load                ; 2
done_inx:
                                                                ;===========
                                                                ; 11/11

; 60
	lda	#$FF	; 2
	sta	ENAM0	; 3

	nop
	nop
	nop
;	nop
;	lda	$80


; 71
	cpy	#192							; 2
	bne	opening_loop						; 2/3
; 76


done_loop:

	;===================================
	; scanline 192?
	;===================================
	; check for button or RESET
	;===================================
; 0
	lda	#0
	sta	DONE_SEGMENT

	inc	FRAMEL							; 5
	bne	no_frame_oflo
	inc	FRAMEH
no_frame_oflo:

	lda	FRAMEH
	cmp	#2
	bne	not_done_opener
	lda	FRAMEL
	cmp	#64
	bne	not_done_opener
done_opener:
	inc	DONE_SEGMENT

not_done_opener:

        sta     WSYNC



	;==========================
	; overscan for 30 scanlines
	;==========================

	ldx	#27
	jsr	common_overscan


	lda	DONE_SEGMENT
	bne	done_opening						; 2/3
	sta	WSYNC
	jmp	start_opening						; 3

done_opening:
; 2
	sta	WSYNC

delay_12_cycles:
	rts


; ...*....
; ...*....
; ..***...
; *******.
; ..***...
; ...*....
; ...*....
sparkle_sprite:
	.byte $10
	.byte $10
	.byte $38
	.byte $FE
	.byte $38
	.byte $10
	.byte $10
