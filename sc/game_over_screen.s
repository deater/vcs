; game over screen, with the duck

        lda     #0
        sta     CTRLPF		; turn off reflect on playfield
        sta     VDELP0		; turn off vdelay on sprite0
        sta     FRAME		; reset frame counter

go_frame:

	; Start Vertical Blank

	lda	#0			; turn on beam
	sta	VBLANK

	lda	#2			; reset beam to top of screen
	sta	VSYNC

	; wait for 3 scanlines of VSYNC

	sta	WSYNC			; wait until end of scanline
	sta	WSYNC
	sta	WSYNC

	lda	#0			; done beam reset
	sta	VSYNC

	;=============================
	; 37 lines of vertical blank
	;=============================


	ldx     #35
vbgo_loop:
        sta     WSYNC
        dex
        bne     vbgo_loop

; in vblank 35?

	sta	WSYNC

	;=======================
	; scanline 36 -- align sprite

	ldx	#7		;					; 2
goad_x:
	dex			;					; 2
	bne	goad_x		;					; 2/3

	; 2+1 + 5*X each time through
	;       so 18+7+9=38

	nop
	nop

	; beam is at proper place
	sta	RESP0

	lda	#$70		; fine adjust				; 2
	sta	HMP0

	sta	WSYNC
	sta	HMOVE

	;=======================
	; scanline 37 -- config

; 3
	lda	#NUSIZ_QUAD_SIZE					; 2
	sta	NUSIZ0							; 3
; 8
	lda	#$C8		; light green				; 2
	sta	COLUPF		; color of playfield			; 3
	lda	#$1C		; yellow				; 2
	sta	COLUP0		; color of sprite			; 3

; 18
	ldy	#0		; clear sprite				; 2
	sty	GRP0							; 3
	sty	PF0							; 3
	sty	PF1							; 3
	sty	PF2							; 3

; 32

	ldx	#0		; reset scanline count			; 2

	inc	FRAME		; update frame				; 5
	lda	FRAME							; 3
	and	#$20							; 2
; 44

	bne	beak_closed						; 2/3
beak_open:
; 46
	lda	#<game_overlay						; 2
	sta	INL							; 3
	lda	#>game_overlay						; 2
	jmp	beak_done						; 3
; 56
beak_closed:
; 47
	lda	#<game_overlay2						; 2
	sta	INL							; 3
	lda	#>game_overlay2						; 2
; 54
beak_done:
; 54/56
	sta	INH							; 3
; 57/59

	sta	WSYNC							; 3


	;=============================================
	;=============================================
	;=============================================
	;=============================================
	;
	; draw 156 (192 - 36) lines of just the sprite

	; need to race beam to draw other half of playfield

game_over_loop_top:
; 0
	lda	(INL),Y		; load proper sprite data		; 5
	sta	GRP0							; 3
; 8
	inx			; increment scanline (X)		; 2
	txa                     ; keep Y as X/4				; 2
	and	#$3							; 2
	beq	yes_iny							; 2/3
	.byte	$A5     ; begin of LDA ZP				; 3
yes_iny:
	iny		; $E8 should be harmless to load		; 2
done_iny:
                                                                ;===========
                                                                ; 11/11
; 19

	cpx	#156							; 2
	sta	WSYNC
	bne	game_over_loop_top					; 2/3

; 2

	;==================================
	;==================================


game_over_loop_bottom:
; 0
	nop
	nop
	lda	$80
;	lda	go_colors,Y		;				; 4+
;	sta	COLUPF			; set playfield color		; 3
; 7
	lda	go_playfield0_left-39,Y	;				; 4+
	sta	PF0			;				; 3
	; must write by CPU 22 [GPU 68]
; 14
	lda	go_playfield1_left-39,Y	;				; 4+
	sta	PF1			;				; 3
	; must write by CPU 28 [GPU 84]

; 21

	lda	go_playfield2_left-39,Y	;				; 4+
	sta	PF2			;				; 3
	; must write by CPU 38 [GPU 116]

; 28
	lda	(INL),Y			; load proper sprite data	; 5
	sta	GRP0							; 3
; 36
	; update asymmetric screen

	nop				; nop				; 2
	lda	#$0			; always 0			; 2
	sta	PF0			;				; 3
	; must write by CPU 49 [GPU 148]
; 43
	lda	go_playfield1_right-39,Y	;			; 4+
	sta	PF1				;			; 3
	; must write by CPU 54 [GPU 164]
; 50
	lda	$80				; nop3			; 3
	lda	go_playfield2_right-39,Y	;			; 4+
	sta	PF2				;			; 3
	; must write by CPU 65 [GPU 196]

; 60
	inx				; increment scanline (X)	; 2
	txa								; 2
	and	#$3			; make sure Y=X/4		; 2
	beq	yes_iny2						; 2/3
	.byte	$A5     ; begin of LDA ZP				; 3
yes_iny2:
	iny		; $E8 should be harmless to load		; 2
done_iny2:
                                                                ;===========
                                                                ; 11/11

; 71
	cpx	#192							; 2
	bne	game_over_loop_bottom					; 2/3

; 76

go_done_loop:

; 75


	;==========================
	; overscan (30 scanlines)
	;==========================

	lda	#$2		; turn off beam
	sta	VBLANK

	ldx	#0
go_overscan_loop:
	sta	WSYNC
	inx
	cpx	#27
	bne	go_overscan_loop

	;=================================
	; check input to go back to title

	lda	INPT4			; check if joystick button pressed
	bpl	set_done_go

	lda	SWCHB			; check if reset
	lsr				; put reset into carry
	bcc	set_done_go

	sta	WSYNC



	;============================
	; handle sound (2 scanlines)

	jsr	update_sound

	jmp	go_frame


set_done_go:
	jmp	restart_game
