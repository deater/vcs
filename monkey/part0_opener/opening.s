	;==========================
	; Opening
	;==========================
	; potentially arrive here with an unknown number of cycles/scanlines
	; ideally VBLANK=2 (beam off)


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
	; set up X position for spark

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
	stx	GRP0			; turn off sprite0 		; 3
	stx	GRP1			; turn off sprite1		; 3
	stx	VBLANK			; turn on beam			; 3

; 13
	lda	#(47*2)			; color of spark		; 2
	sta	COLUP0							; 3
; 18
	lda	#NUSIZ_MISSILE_WIDTH_2	; set missile size		; 2
	sta	NUSIZ0							; 3
; 23
	stx	ENAM0			; disable missile		; 3
	stx	COLUBK							; 3

	lda	#100
	sta	MISSILE_Y

; 29
	lda	#$4E
	sta	COLUPF

	sta	WSYNC


	;=============================================
	;=============================================
	; draw opening
	;=============================================
	;=============================================



	;=============================================
	;=============================================
	; top 52 lines
	;=============================================
	;=============================================

skip_loop:
	iny								; 2
	cpy	#51							; 2
	sta	WSYNC							; 3
	bne	skip_loop						; 2/3


	;=============================================
	;=============================================
	; turn missile on if needed
	;=============================================
	;=============================================
; 2
	lda	FRAMEH			; only turn on during FRAMEH=1	; 3
	cmp	#1							; 2
	bne	no_missile						; 2/3
	lda	FRAMEL							; 3
	cmp	#$78							; 2
	bcs	no_missile						; 2/3
	lda	#$ff							; 2
	sta	ENAM0			; actually enable missile	; 3

no_missile:
	iny				; increment row			; 2
	sta	WSYNC


	;=============================================
	;=============================================
	; main kernel
	;=============================================
	;=============================================
	; asymmetric


;	lda	lucas_colors,X						; 4+
;	sta	COLUPF		; set playfield color			; 3


opening_loop:

; 3/0

	cpy	#140							; 2
	bcs	ending_loop						; 2/3
	nop								; 2

; 9
	lda	lucas_playfield0_left,X		;			; 4+
	sta	PF0				;			; 3
	; must write by CPU 22 [GPU 68]
; 16
	lda	lucas_playfield1_left,X		;			; 4+
	sta	PF1				;			; 3
	; must write by CPU 27? [GPU 84]
; 23
	lda	lucas_playfield2_left,X		;			; 4+
	sta	PF2				;			; 3
	; must write by CPU 38 [GPU 116]

; 30

	lda	lucas_playfield0_right,X	;			; 4+
	sta	PF0				;			; 3
	; must write by CPU 49 [GPU 148]
; 37
	lda	lucas_playfield1_right,X	;			; 4+
	sta	PF1				;			; 3
	; must write by CPU 54 [GPU 164]
; 44
	lda	lucas_playfield2_right,X	;			; 4+
	sta	PF2				;			; 3
	; must write by CPU 65 [GPU 196]
; 51

	iny								; 2
	tya								; 2
	and	#$3							; 2
	beq	yes_inx							; 2/3
	.byte	$A5	; begin of LDA ZP				; 3
yes_inx:
	inx		; $E8 should be harmless to load		; 2
done_inx:
								;===========
								; 11/11

; 62

	; see if enable missile

	; don't use sec, too many cycles
	;sec
	tya			; get Y value into A			; 2
	sbc	MISSILE_Y	; subtract Missile Y			; 3
	cmp	#4		; if 0..3 turn on			; 2
	lda	#$ff		; get FF to enable			; 2
	adc	#$00		; clever, if carry set from cmp make 0	; 2
	sta	ENAM0							; 3
								;==========
								; 	14

; 76

	jmp	opening_loop						; 3

ending_loop:

; 5

	;=============================================
	;=============================================
	; bottom 52 lines
	;=============================================
	;=============================================
	; disable everything

	lda	#0							; 2
	sta	PF0		; disable playfield			; 3
	sta	PF1							; 3
	sta	PF2							; 3

	sta	ENAM0		; disable missile			; 3

	iny			; advance row				; 2
	sta	WSYNC

	;=====================================
	; repeat until end of screen

skip_loop2:
	iny								; 2
	cpy	#192							; 2
	sta	WSYNC
	bne	skip_loop2						; 2/3



done_loop:

	;===================================
	; scanline 192?
	;===================================
	; check for button or RESET
	;===================================
; 2
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
;sparkle_sprite:
;	.byte $10
;	.byte $10
;	.byte $38
;	.byte $FE
;	.byte $38
;	.byte $10
;	.byte $10
