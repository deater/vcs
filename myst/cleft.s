; The star-fissure

	;================================
	; cleft
	;================================
	; arrive here with unknown number of cycles
	; hopefully VBLANK=2 (beam is off)

	lda	#0							; 2
	sta	FRAME							; 3

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

	ldx	#36							; 2
vcleft_loop:
	sta	WSYNC							; 3
	dex								; 2
	bne	vcleft_loop						; 2/3

; 4
	;==============================
	; VBLANK scanline 37 -- config
	;==============================
; 4
	inc	FRAME							; 5

	ldy	#0							; 2
	ldx	#0							; 2
	stx	GRP0							; 3
	stx	GRP1							; 3
	stx	CTRLPF							; 3
	stx	VBLANK			; re-enable beam		; 3

	lda	#$2
	sta	ENABL

	sta	RESBL
	lda	#$70
	sta	HMBL

	lda	#0							; 2
	sta	PF1			; playfield 1 is always 0	; 3
;

	jmp	skip

.align $100

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
	tya								; 2
	and	#$f							; 2
	bne	not8							; 2/3
	lda	#2							; 2
	jmp	done8							; 3
not8:
	lda	#0							; 2
	nop
done8:
	sta	ENABL							; 3
								;===========
								; 14 / 12

; 36
	inc	TEMP1	; nop5						; 5

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

	ldx	#30			; turn off beam and wait 29 scanlines
	jsr	common_overscan

	;============================
	; Overscan scanline 30
	;============================
	; check for button or RESET
        ;============================

	 ;===============================
        ; debounce reset/keypress check

	lda	INPUT_COUNTDOWN						; 3
	beq	waited_enough_cleft					; 2/3
	dec	INPUT_COUNTDOWN						; 5
	jmp	done_check_cleft_input					; 3

waited_enough_cleft:
	lda	INPT4			; check if joystick button pressed
	bpl	set_done_cleft

	lda	SWCHB			; check if reset
	lsr				; put reset into carry
	bcc	set_done_cleft

	jmp     done_check_cleft_input

set_done_cleft:
	jmp	done_cleft
done_check_cleft_input:

	jmp	cleft_frame_loop

done_cleft:

