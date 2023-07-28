; Myst title screen

	;================================
	; title screen
	;================================
	; arrive here with unknown number of cycles
do_title:

	lda	#2			; disable VBLANK?
	sta	VBLANK

	; are these needed?  intro starts after start of game
	; where all zero page set to 0...

;	lda	#0							; 2
;	sta	FRAME			; reset frame			; 3
;	sta	CTRLPF			; no-reflect			; 3

	lda	#$20			; gold/brown			; 2
	sta	TITLE_COLOR						; 3

	lda	#$24	; skip this?
	sta	LEVEL_HAND_COLOR	; hand color for book
					; should be $24, $20 is close?

title_frame_loop:

	;=============================================
	; Start Vertical Blank (with one extra WSYNC)
	;=============================================

	jsr	common_vblank

	;=============================
	; 37 lines of vertical blank
	;=============================

	ldx	#36							; 2
	jsr	common_delay_scanlines
; 10
	;==============================
	; VBLANK scanline 37 -- config
	;==============================
; 10
	inc	FRAME							; 5
	lda	FRAME							; 3
	and	#$f			; every 2/16 frame (~.5s)	; 2
	bne	no_rotate_title						; 2/3
	inc	TITLE_COLOR						; 5
no_rotate_title:

; 27
	ldy	#0							; 2
	sty	VBLANK			; re-enable beam		; 3

; all of these should be 0 coming in?
;	sty	CTRLPF			; no-mirror			; 3
;	sty	PF0							; 3
;	sty	PF1							; 3
;	sty	PF2							; 3
;	sty	GRP0							; 3
;	sty	GRP1							; 3

; 50
	sta	WSYNC
; 53

	;=============================================
	;=============================================
	; draw title playfield
	;=============================================
	;=============================================
	; draw 192 lines
	; need to race beam to draw other half of playfield


	; first we have 17*4 blank lines
	ldx	#67
	jsr	common_delay_scanlines
; 10

	; the above routine sets X to 0 for free
;	ldx	#0			; reset scanlines		; 2

	sta	WSYNC			; need next line to start at 0

	;===================================
	; actual main title kernel
	;===================================
	; 11*4 lines with logo

title_playfield_loop:
; 0
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
; 37
	nop								; 2
	nop								; 2
; 41
	lda	#0			; always zero			; 2
	sta	PF0			;				; 3
; 46

	; must write by CPU 49 [GPU 148]
; 46

	lda	title_playfield1_right,X	;			; 4+
	sta	PF1			;				; 3
	; must write by CPU 54 [GPU 164]
; 53
	lda	title_playfield2_right,X	;			; 4+
	sta	PF2			;				; 3
	; must write by CPU 65 [GPU 196]
; 60

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

; 71
	cpy	#44							; 2
	bne	title_playfield_loop					; 2/3

; 76

done_loop:

	; then 20*4 blank lines
; -1
	ldx	#0			; clear playfield		; 2
	stx	PF0							; 3
	stx	PF1							; 3
	stx	PF2							; 3
	clc								; 2
	lda	TITLE_COLOR						; 3
	adc	#4			; 4 is best?			; 2
	sta	TITLE_COLOR						; 3
	sta	WSYNC							; 3

	; now we have 20*4 blank lines
	ldx	#79
	jsr	common_delay_scanlines
; 10

	;==========================
	; overscan
	;==========================

	ldx	#29			; turn off beam and wait 29 scanlines
	jsr	common_overscan

	;============================
	; Overscan scanline 30
	;============================
	; check for button or RESET
        ;============================

waited_enough:
	lda	INPT4			; check if joystick button pressed
	bpl	done_title

	lda	SWCHB			; check if reset
	lsr				; put reset into carry
	bcc	done_title

done_check_input:

;	jmp	title_frame_loop
	bcs	title_frame_loop	; bra

done_title:

