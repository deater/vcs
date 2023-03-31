	;======================================
	; you win screen
	;======================================
	; ideally VBLANK is off (2) when we get here
you_win:
	lda	#20
	sta	TITLE_COUNTDOWN
	sta	WSYNC

you_win_loop:
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
ywad_x:
	dex			;					; 2
	bne	ywad_x		;					; 2/3

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

;	ldx	#0		; reset scanline count			; 2

	lda	#0			; turn on beam			; 2
	sta	VBLANK							; 3
; 62/64
	sta	WSYNC							; 3


	;===================================
	;===================================
	;
	; draw 80 lines of nothing (TODO: fireworks?)
	;
	;==================================
	;==================================


you_win_loop_top:
	ldx	#80
	jsr	scanline_wait

	;===========================
	;===========================
	; 80 - 134 = 49 lines of cheat
	;===========================
	;===========================

	jsr	draw_the_cheat


	;===========================
	;===========================
	; 135 - 144 = you_win text
	;===========================
	;===========================
	; 48-pixel sprite!!!!
	;

	;================
	; scanline 135
	;	set things up

	lda	#$0e			; white
	sta	COLUP0	; set sprite color
	sta	COLUP1	; set sprite color

;	lda	#NUSIZ_THREE_COPIES_CLOSE
;	sta	NUSIZ0
;	sta	NUSIZ1

	; delay and sprite offsets already set previously

;	lda	#0		; turn off sprite
;	sta	GRP0
;	sta	GRP1
;	sta	HMP1			;			3

;	lda	#1		; turn on delay
;	sta	VDELP0
;	sta	VDELP1

	ldx	#7		; init X
	stx	TEMP2

	sta	WSYNC

	;================================
	; scanline 136 - 144

yw_spriteloop:
	; 0
	lda	you_win_sprite0,X	; load sprite data		; 4+
	sta	GRP0			; 0->[GRP0] [GRP1 (?)]->GRP1	; 3
	; 7
	lda	you_win_sprite1,X	; load sprite data		; 4+
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3
	; 14
	lda	you_win_sprite2,X	; load sprite data		; 4+
	sta	GRP0			; 2->[GRP0], [GRP1 (1)]-->GRP1	; 3
	; 21

	lda	you_win_sprite5,X					; 4+
	sta	TEMP1							; 3
	; 28
	lda	you_win_sprite4,X					; 4+
	tay								; 2
	; 34
	lda	you_win_sprite3,X	;				; 4+
	ldx	a:TEMP1			; force extra cycle		; 4
	; 42

	sta	GRP1			; 3->[GRP1], [GRP0 (2)]-->GRP0	; 3
	; 45 (need this to be 44 .. 46)

	sty	GRP0			; 4->[GRP0], [GRP1 (3)]-->GRP1	; 3
	; 48 (need this to be 47 .. 49)
	stx	GRP1			; 5->[GRP1], [GRP0 (4)]-->GRP0	; 3
	; 51 (need this to be 50 .. 51)

	sty	GRP0			; ?->[GRP0], [GRP1 (5)]-->GRP1 	; 3
	; 54 (need this to be 52 .. 54)

	; delay 11

	inc	TEMP1	; 5
	nop
	nop
	nop

;	lda	TEMP1	; 3
;	lda	TEMP1	; 3


	; 65

	dec	TEMP2							; 5
	ldx	TEMP2							; 3
	bpl	yw_spriteloop						; 2/3
	; 76  (goal is 76)

; 75
	ldy	#0		; clear out sprites			; 2
; 1
	sty	GRP1							; 3
	sty	GRP0							; 3
	sty	GRP1							; 3
; 10

	;============================
	; score 145 - 153
	;============================
; wants to be at 10 here? or 8?
	sty	VDELP0
	sta	WSYNC
	sty	VDELP1

	jsr	draw_score


	;============================
	; pad 154 - 191

	ldx	#39
	jsr	scanline_wait

	;============================
	; overscan
	;============================
you_win_overscan:
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
	beq	yw_waited_enough					; 2/3
	dec	TITLE_COUNTDOWN						; 5
	jmp	yw_done_check_input					; 3

yw_waited_enough:
; 11

	lda	INPT4			; check if joystick button pressed
	bpl	set_done_yw

	lda	SWCHB			; check if reset
	lsr				; put reset into carry
	bcc	set_done_yw

yw_done_check_input:

	sta	WSYNC

	jmp	you_win_loop


set_done_yw:
	sta	WSYNC

;	jmp	switch_to_bank1_and_start_strongbadia

	jmp	the_cheat_start
