; The star-fissure

	;================================
	; cleft
	;================================
	; arrive here with unknown number of cycles
	; hopefully VBLANK=2 (beam is off)

	lda	#0							; 2
	sta	FRAME							; 3
	sta	FALL_COUNT

				; unmirrored playfield
	lda	#CTRLPF_PFP	; playfield has priority over sprites	; 2
	sta	CTRLPF							; 3

	lda	#30
	sta	INPUT_COUNTDOWN

cleft_frame_loop:

	;=======================
	; Start Vertical Blank
	;=======================

	jsr	common_vblank

	;=============================
	; 37 lines of vertical blank
	;=============================

	ldx	#33							; 2
vcleft_loop:
	sta	WSYNC							; 3
	dex								; 2
	bne	vcleft_loop						; 2/3

; 4
	;==============================
	; VBLANK scanline 34 -- frame
	;==============================
; 4
	inc	FRAME							; 5
; 9
	lda	FRAME							; 3
	and	#$3f							; 2
	bne	not_a_second						; 2/3
; 16
	inc	FALL_COUNT						; 5
; 21
	; set up scale
	lda	#$0							; 2
	ldx	FALL_COUNT						; 3
	cpx	#4							; 2
	bcs	scale3							; 2/3
	cpx	#2							; 2
	bcs	scale2							; 2/3
scale1:
	eor	#$5							; 2
scale2:
	eor	#$2							; 2
scale3:
	eor	#$7							; 2
done_scale:
	sta	NUSIZ0							; 3
								; 22 worst case
; 43

	lda	FALL_COUNT
	cmp	#3
	bcs	copy_book

	ldx	#0							; 2
copy_falling_loop:
	lda	falling_sprite,X					; 4
	sta	HAND_SPRITE,X						; 4
	inx								; 2
	cpx	#8							; 2
	bne	copy_falling_loop					; 2/3
	; 2+(15*8)-1 = 121

	jmp	done_second

copy_book:

	ldx	#7
	lda	#$0F
copy_book_loop:
	sta	HAND_SPRITE,X
	dex
	bpl	copy_book_loop
	bmi	two_a_second

not_a_second:
	sta	WSYNC
two_a_second:
	sta	WSYNC
done_second:
	sta	WSYNC



	;==============================
	; VBLANK scanline 37 -- config
	;==============================
; 0
	nop
	nop
; 4
	inc	TEMP1
;	inc	FRAME							; 5
; 9
	ldy	#0							; 2
	ldx	#0							; 2
	stx	GRP0							; 3
	stx	GRP1							; 3
	stx	CTRLPF							; 3
	stx	VBLANK			; re-enable beam		; 3
; 25
	lda	#$2			; enable ball (for stars)	; 2
	sta	ENABL							; 3
; 30
	sta	RESBL			; set ball location		; 3
	lda	#$70							; 2
	sta	HMBL							; 3
; 38
	lda	$80		; nop3 CRITICAL TIMING			; 3
	sta	RESP0							; 3
; 44	(MUST BE 44)

	lda	#$02		; sprite0 (falling) color		; 2
	sta	COLUP0							; 3
; 49

	lda	#0							; 2
	sta	PF1			; playfield 1 is always 0	; 3
; 54

;	jmp	skip

	; bit of a hack, can store 32B here?

;.align $100

skip:
	;=============================================
	;=============================================
	; draw cleft playfield
	;=============================================
	;=============================================
	; draw 192 lines
	; need to race beam to draw other half of playfield

cleft_playfield_loop:
	sta	WSYNC							; 3
	sta	HMOVE							; 3
; 3
	lda	cleft_colors,X						; 4
	sta	COLUPF							; 3
; 10
	lda	#0			; always black			; 2
	sta	PF0			;				; 3
	; must write by CPU 22 [GPU 68]
; 15
	lda	cleft_playfield2_left,X	;				; 4+
	sta	PF2			;				; 3
	; must write by CPU 38 [GPU 116]
; 22

.if 0
	;====================
	; do the star effect

	tya								; 2
	and	#$f							; 2
	bne	not8							; 2/3
	lda	#2							; 2
	jmp	done8							; 3
not8:
	lda	#0							; 2
	nop								; 2
done8:
	sta	ENABL							; 3
								;===========
								; 14 / 12

; 36
	inc	TEMP1	; nop5						; 5
.endif

	;==================
	; draw sprite
	;==================
; 22
	cpy	#90							; 2
	bcc	no_fall_delay_13					; 2/3
	cpy	#99							; 2
	bcs	no_fall_delay_9						; 2/3
	lda	HAND_SPRITE-90,Y					; 4
	sta	GRP0							; 3
	jmp	no_fall
no_fall_delay_13:
	nop
	nop
no_fall_delay_9:
	lda	$80
	lda	$80
	lda	$80
no_fall:

								;============
								; 5 / 9 / 18
; want 19





; 41
	lda	cleft_playfield0_right,X	;			; 4+
	sta	PF0			;				; 3


	; must write by CPU 49 [GPU 148]
; 48

	lda	#0			; always black			; 2
	sta	PF2			;				; 3
	; must write by CPU 65 [GPU 196]
; 53

	nop				;				; 2
	nop				;       			; 2

; 57

        iny								; 2
        tya								; 2
        and     #$3							; 2
        beq     yes_in2x						; 2/3
        .byte   $A5     ; begin of LDA ZP                               ; 3
yes_in2x:
        inx             ; $E8 should be harmless to load		; 2
done_in2x:
                                                                ;===========
                                                                ; 11/11

; 68
	cpy	#192							; 2
	bne	cleft_playfield_loop					; 2/3

; 73 (+3 in WSYNC ABOVE)

done_cleft_playfield:

; -1
	;==========================
	; overscan
	;==========================

	ldx	#28			; turn off beam and wait 29 scanlines
	jsr	common_overscan

	;============================
	; Overscan scanline 30
	;============================
	; check for button or RESET
        ;============================
; ?
	;===============================
	; debounce reset/keypress check

	lda	FALL_COUNT		; decrement falling count	; 3
	cmp	#5			; 5 steps			; 2
	beq	done_cleft						; 2/3
; +7

	lda	INPUT_COUNTDOWN		; check debounce		; 3
	beq	waited_enough_cleft					; 2/3
; +12
	dec	INPUT_COUNTDOWN		; dec debounce			; 5
	jmp	done_check_cleft_input					; 3

waited_enough_cleft:
; +13
	lda	INPT4			; check if joystick button	; 3
	bpl	set_done_cleft						; 2/3
; +18
	lda	SWCHB			; check if reset		; 3
	lsr				; put reset into carry		; 2
	bcc	set_done_cleft						; 2/3
; +25
	bcs	done_check_cleft_input	; bra				; 3

set_done_cleft:
; + 19/26
	jmp	done_cleft
done_check_cleft_input:

	; hit here if we're staying

	sta	WSYNC
	jmp	cleft_frame_loop

done_cleft:
; +22/29
	lda	#0							; 2
	sta	ENABL			; disable ball			; 3
