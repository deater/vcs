; The star-fissure

	;================================
	; cleft
	;================================
	; arrive here with unknown number of cycles
	; hopefully VBLANK=2 (beam is off)

	lda	#0							; 2
	sta	FRAME							; 3

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
;

	sta	WSYNC


	;=============================================
	;=============================================
	; draw cleft playfield
	;=============================================
	;=============================================
	; draw 192 lines
	; need to race beam to draw other half of playfield

cleft_playfield_loop:
	lda	TITLE_COLOR		;				; 3
	and	#$2F			; keep it gold			; 2
	sta	COLUPF			; set playfield color		; 3
	sta	TITLE_COLOR						; 3

; 11
	lda	title_playfield0_left,X	;				; 4+
	sta	PF0			;				; 3
	; must write by CPU 22 [GPU 68]
; 18
	lda	title_playfield1_left,X	;				; 4+
	sta	PF1			;				; 3
	; must write by CPU 28 [GPU 84]
; 25
	lda	title_playfield2_left,X	;				; 4+
	sta	PF2			;				; 3
	; must write by CPU 38 [GPU 116]
; 32


	inc	TITLE_COLOR		; advance color			; 5
	nop								; 2

; 39
	lda	title_playfield0_right,X	;			; 4+
	sta	PF0			;				; 3


	; must write by CPU 49 [GPU 148]
; 46

	lda	title_playfield1_right,X	;			4+
	sta	PF1			;				3
	; must write by CPU 54 [GPU 164]
; 53
	lda	title_playfield2_right,X	;			4+
	sta	PF2			;				3
	; must write by CPU 65 [GPU 196]
; 60

        iny                                                             ; 2
        tya                                                             ; 2
        and     #$3                                                     ; 2
        beq     yes_in2x                                                 ; 2/3
        .byte   $A5     ; begin of LDA ZP                               ; 3
yes_in2x:
        inx             ; $E8 should be harmless to load                ; 2
done_in2x:
                                                                ;===========
                                                                ; 11/11

; 71
	cpy	#192							; 2
	bne	cleft_playfield_loop					; 2/3

; 76

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

