; game over screen, with the duck

        lda     #0              ; turn off reflect on playfield
        sta     CTRLPF
        sta     VDELP0
        sta     FRAME

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

	lda	#$B0		; fine adjust				; 2
	sta	HMP0

	sta	WSYNC
	sta	HMOVE

	;=======================
	; scanline 37 -- config

	lda	#NUSIZ_QUAD_SIZE
	sta	NUSIZ0

	lda	#$1C		; yellow		; set color
	sta	COLUP0
	sta	COLUPF

	ldy	#0
	sty	GRP0

	ldx	#0

	inc	FRAME
	lda	FRAME
	and	#$20
	bne	beak_closed
beak_open:
	lda	#<game_overlay
	sta	INL
	lda	#>game_overlay
	jmp	beak_done
beak_closed:
	lda	#<game_overlay2
	sta	INL
	lda	#>game_overlay2
beak_done:
	sta	INH


	sta	WSYNC


	;=============================================
	;=============================================
	;=============================================
	;=============================================

	; draw 192 lines
	; need to race beam to draw other half of playfield

game_over_loop:
	lda	go_colors,Y		;				; 4+
	sta	COLUPF			; set playfield color		; 3
; 7
	lda	go_playfield0_left,Y	;				; 4+
	sta	PF0			;				; 3
	; must write by CPU 22 [GPU 68]
; 14
	lda	go_playfield1_left,Y	;				; 4+
	sta	PF1			;				; 3
	; must write by CPU 28 [GPU 84]

; 21

	lda	go_playfield2_left,Y	;				; 4+
	sta	PF2			;				; 3
	; must write by CPU 38 [GPU 116]

; 28
	lda	(INL),Y							; 5
;	lda	game_overlay,X						; 4
	sta	GRP0							; 3
; 36

	; at this point we're at 28 cycles
	lda	go_playfield0_right,Y	;				; 4+
	sta	PF0			;				; 3
	; must write by CPU 49 [GPU 148]
; 43
;	nop								; 2
	lda	go_playfield1_right,Y	;				; 4+
	sta	PF1			;				; 3
	; must write by CPU 54 [GPU 164]
; 50
	lda	$80							; 3
	lda	go_playfield2_right,Y	;				; 4+
	sta	PF2			;				; 3
	; must write by CPU 65 [GPU 196]

; 60
	inx                                                             ; 2
	txa                                                             ; 2
	and	#$3                                                     ; 2
	beq	yes_iny                                                 ; 2/3
	.byte	$A5     ; begin of LDA ZP                               ; 3
yes_iny:
	iny		; $E8 should be harmless to load                ; 2
done_iny:
                                                                ;===========
                                                                ; 11/11

; 71
	cpx	#192							; 2
	bne	game_over_loop						; 2/3


go_done_loop:



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
