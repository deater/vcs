	;======================================
	; game over screen, with the shark bear
	;======================================
	; ideally VBLANK is off (2) when we get here

	lda	#20
	sta	TITLE_COUNTDOWN
	sta	WSYNC

game_over_loop:
	;=============================
	; start VBLANK
	;=============================

	lda	#2
	sta	VSYNC

	;================================
	; wait for 3 scanlines of VSYNC

	sta     WSYNC                   ; wait until end of scanline
	sta     WSYNC

	lda     #0                      ; done beam reset
	sta     ENABL
	sta	COLUBK
	sta     CTRLPF		; turn off reflect on playfield		; 3
	sta     VDELP0		; turn off vdelay on sprite0		; 3
	sta     VDELP1		; turn off vdelay on sprite1		; 3


	sta     WSYNC
	sta     VSYNC




; 9
	;============================
	; 37 lines of vertical blank
	;=============================


	ldx     #35
	jsr	scanline_wait

	;=============================
	; vblank scanline 35

	sta	WSYNC

	;========================================================
	; vblank scanline 36 -- align sprite (has to start at 0)
	;========================================================
; 0
	ldx	#7		;					; 2
; 2
goad_x:
	dex			;					; 2
	bne	goad_x		;					; 2/3

	; (5*X)-1
	;       so for X=7 34
; 36
	nop								; 2
	nop								; 2
; 40

	; beam is at proper place
	sta	RESP0							; 3
; 43
	lda	#$70		; fine adjust				; 2
	sta	HMP0							; 3
; 48
	sta	WSYNC							; 3
; 0
	sta	HMOVE

	;=======================
	; vblank scanline 37 -- config

; 3
	lda	#NUSIZ_QUAD_SIZE					; 2
	sta	NUSIZ0							; 3
; 8
	lda	#$1C		; yellow				; 2
	sta	COLUP0		; color of sprite			; 3

; 18
	ldy	#0		; clear sprite				; 2
	sty	GRP0							; 3
;	sty	PF0							; 3
;	sty	PF1							; 3
;	sty	PF2							; 3

; 32

	ldx	#0		; reset scanline count			; 2

	lda	#0			; turn on beam			; 2
	sta	VBLANK							; 3
; 62/64
	sta	WSYNC							; 3


	;=============================================
	;=============================================
	;
	; draw 168 lines of asymmetric playfield
	;	bear holding shark
	;==================================
	;==================================


game_over_loop_top:
; 0
	lda	#6				; grey			; 2
	sta	COLUPF				; set playfield color	; 3
; 5
	lda	#0				; left 4 always empty	; 2
	sta	PF0				;			; 3
	; must write by CPU 22 [GPU 68]
; 10
	lda	bearshark_playfield1_left,Y	;			; 4+
	sta	PF1				;			; 3
	; must write by CPU 28 [GPU 84]
; 17

	lda	bearshark_playfield2_left,Y	;			; 4+
	sta	PF2			;				; 3
	; must write by CPU 38 [GPU 116]
; 24

	; change color
	nop								; 2
; 26

	lda	#$24							; 2
	cpx	#64							; 2
	bcs	yes_bear						; 2/3
	.byte $2C		; bit					; 4
yes_bear:
	sta	COLUPF							; 3
done_bear:
	; 10 / 10

; 36

;	lda	bearshark_playfield2_left,Y	; load sprite data	; 4+
;	sta	GRP0							; 3

; 36
	; update asymmetric screen

	lda	bearshark_playfield0_right,Y	;			; 4+
	sta	PF0			;				; 3
	; must write by CPU 49 [GPU 148]
; 43
	lda	bearshark_playfield1_right,Y	;			; 4+
	sta	PF1				;			; 3
	; must write by CPU 54 [GPU 164]
; 50
	nop
	nop

	lda	bearshark_playfield2_right,Y	;			; 4+
	sta	PF2				;			; 3
	; must write by CPU 65 [GPU 196]

; 61
	inx	; 2
	txa	; 2
	lsr	; 2
	lsr	; 2
	tay	; 2

; 71
	cpx	#167							; 2
	bne	game_over_loop_top					; 2/3
; 76


; 75
	ldx	#0
	ldy	#0

	sta	WSYNC

	;=============================================
	;=============================================
	;
	; draw 24 lines of asymmetric playfield
	;	"game over"
	;==================================
	;==================================


game_over_loop_bottom:
; 0
	lda	#$C8				; light green		; 2
	sta	COLUPF				; set playfield color	; 3
; 5
	lda	game_over_playfield0_left,Y				; 4+
	sta	PF0				;			; 3
	; must write by CPU 22 [GPU 68]
; 12
	lda	game_over_playfield1_left,Y	;			; 4+
	sta	PF1				;			; 3
	; must write by CPU 28 [GPU 84]
; 19

	lda	game_over_playfield2_left,Y	;			; 4+
	sta	PF2			;				; 3
	; must write by CPU 38 [GPU 116]
; 26

	inc	TEMP1	; nop5
	dec	TEMP1	; nop5

; 36
	; update asymmetric screen

	lda	game_over_playfield0_right,Y	;			; 4+
	sta	PF0			;				; 3
	; must write by CPU 49 [GPU 148]
; 43
	lda	game_over_playfield1_right,Y	;			; 4+
	sta	PF1				;			; 3
	; must write by CPU 54 [GPU 164]
; 50
	nop
	nop

	lda	game_over_playfield2_right,Y	;			; 4+
	sta	PF2				;			; 3
	; must write by CPU 65 [GPU 196]

; 61
	inx	; 2
	txa	; 2
	lsr	; 2
	lsr	; 2
	tay	; 2

; 71
	cpx	#24							; 2
	bne	game_over_loop_bottom					; 2/3

; 76


; 75



	;============================
	; overscan
	;============================
game_overscan:
        lda     #$2             ; turn off beam
        sta     VBLANK

        ; wait 30 scanlines

	ldx	#26
	jsr	scanline_wait


	;============================
	; scanlines 27+28 handle sound (2 scanlines)
; 10
	jsr	update_sound

	sta	WSYNC


; 0
	;=================================
	; scanline 29
	;=================================
	; check input

	lda	#0							; 2
	sta	DONE_TITLE						; 3
; 5

	;===============================
	; debounce reset/keypress check

	lda	TITLE_COUNTDOWN						; 3
	beq	go_waited_enough					; 2/3
	dec	TITLE_COUNTDOWN						; 5
	jmp	go_done_check_input					; 3

go_waited_enough:
; 11

	lda	INPT4			; check if joystick button pressed
	bpl	set_done_go

	lda	SWCHB			; check if reset
	lsr				; put reset into carry
	bcc	set_done_go

go_done_check_input:

	sta	WSYNC

	jmp	game_over_loop


set_done_go:
	sta	WSYNC

	jmp	switch_bank1
