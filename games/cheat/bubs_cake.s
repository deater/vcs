	;======================================
	; Big Bubs
	;======================================
	;
	; o/~ King Bubsgonzola Supreme o/~
	;

big_bubs:
	lda	#20
	sta	TITLE_COUNTDOWN
	sta	WSYNC

big_bubs_loop:
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
	sta     VDELP0		; turn off vdelay on sprite0		; 3
	sta     VDELP1		; turn off vdelay on sprite1		; 3

	lda	#CTRLPF_REF
	sta     CTRLPF		; turn on reflect on playfield		; 3


	sta     WSYNC
	sta     VSYNC




; 9
	;============================
	; 37 lines of vertical blank
	;=============================


	ldx     #34
	jsr	scanline_wait

	;========================================================
	; vblank scanline 34-35 -- align sprite
	;========================================================

	lda	#74
	ldx	#0
	jsr	calc_pos_x
	sta	WSYNC

	;========================================================
	; vblank scanline 36 -- align sprite
	;========================================================
wait_pos_99:
	dey
	bpl	wait_pos_99
	sta	RESP0
	sta	WSYNC
	sta	HMOVE

	;=======================
	; vblank scanline 37 -- config

; 3
	lda	#NUSIZ_DOUBLE_SIZE					; 2
	sta	NUSIZ0							; 3
; 8
;	lda	#$1C		; yellow				; 2
;	sta	COLUP0		; color of sprite			; 3

; 18
	ldy	#0		; clear sprite				; 2
	sty	GRP0							; 3

; 32

	ldx	#0		; reset scanline count			; 2

	lda	#0			; turn on beam			; 2
	sta	VBLANK							; 3
; 62/64
	sta	WSYNC							; 3


	;==================================
	;==================================
	; draw 136 lines of bubs
	;==================================
	;==================================

	lda	big_bubs_colors		; 			; 4+

big_bubs_loop_top:
; 0
	sta	COLUPF				; set playfield color	; 3
; 7
	lda	#0				; left 4 always empty	; 2
	sta	PF0				;			; 3
	; must write by CPU 22 [GPU 68]
; 12
	sta	PF1				;			; 3
	; must write by CPU 28 [GPU 84]
; 15

	lda	big_bubs_playfield2_left,Y	;			; 4+
	sta	PF2			;				; 3
	; must write by CPU 38 [GPU 116]
; 22

;	sec				; 0    8  50      		; 2
	txa				; -8   8   8			; 2
	sbc	#12	;37		; -8   0  42			; 2
	cmp	#24	; 37						; 2
; 30
	bcs	not_face						; 2/3
; 32
	lda	bubs_face_sprite-13,X					; 4+
	sta	GRP0							; 3
; 39
	lda	bubs_face_colors-13,X					; 4+
	sta	COLUP0							; 3
; 48

not_face:

	inx	; 2				; set Y to X/4
	txa	; 2
	lsr	; 2
	lsr	; 2
	tay	; 2

	lda	big_bubs_colors,Y		; 			; 4+

; 71
	cpx	#135							; 2
	sta	WSYNC
	bne	big_bubs_loop_top					; 2/3
; 76


; 75
;	ldx	#0
;	ldy	#0

	sta	WSYNC

	;===========================
	; scanline 136
	;	set things up

	lda	#$0e			; white
	sta	COLUP0	; set sprite color
	sta	COLUP1	; set sprite color

	lda	#NUSIZ_THREE_COPIES_CLOSE
	sta	NUSIZ0
	sta	NUSIZ1

	lda	#0		; turn off sprite
	sta	GRP0
	sta	GRP1
;	sta	HMP0
	sta	HMP1			;			3

	lda	#1		; turn on delay
	sta	VDELP0
	sta	VDELP1

	sta	WSYNC

	;=================
	; scanline 137

	; to center exactly would want sprite0 at
	;	CPU cycle 41.3
	; and sprite1 at
	;	GPU cycle 44

	ldx	#6		;				2
bcpad_x:
	dex			;				2
	bne	bcpad_x		;				2/3
	; 3 + 5*X each time through

	lda	$80		; nop 6
	lda	$80


	; beam is at proper place
	sta	RESP0						; 3
	; 41 (GPU=123, want 124) +1
	sta	RESP1						; 3
	; 44 (GPU=132, want 132) 0

	lda	#$F0		; opposite what you'd think
	sta	HMP0			;			3

	sta	WSYNC
	sta	HMOVE		; adjust fine tune, must be after WSYNC

	;===============================
	; scanline 138

	ldx	#6		; init X
	stx	TEMP2

	sta	WSYNC

	;================================
	; scanline 139

cakemessage_loop:
	; 0
	lda	cake_message_sprite0,X	; load sprite data		; 4+
	sta	GRP0			; 0->[GRP0] [GRP1 (?)]->GRP1	; 3
	; 7
	lda	cake_message_sprite1,X	; load sprite data		; 4+
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3
	; 14
	lda	cake_message_sprite2,X	; load sprite data		; 4+
	sta	GRP0			; 2->[GRP0], [GRP1 (1)]-->GRP1	; 3
	; 21

	lda	cake_message_sprite5,X					; 4+
	sta	TEMP1							; 3
	; 28
	lda	cake_message_sprite4,X					; 4+
	tay								; 2
	; 34
	lda	cake_message_sprite3,X	;				; 4+
	ldx	a:TEMP1			; force extra cycle		; 4
	; 42
;	nop

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
	lda	TEMP1	; 3
	lda	TEMP1	; 3


	; 65

	dec	TEMP2							; 5
	ldx	TEMP2							; 3
	bpl	cakemessage_loop					; 2/3
	; 76  (goal is 76)

	ldy	#0		; clear out sprites
	sty	GRP1
	sty	GRP0
	sty	GRP1

	sta	WSYNC


	;=============================================
	;=============================================
	;
	; draw 43 lines of nothing
	;==================================
	;==================================


big_bubs_loop_bottom:
; 0

	inx
; 71
	sta	WSYNC
	cpx	#44							; 2
	bne	big_bubs_loop_bottom					; 2/3

; 76


; 75



	;============================
	;============================
	; overscan
	;============================
	;============================

big_bubs_overscan:

        ; wait 30 scanlines

	ldx	#26
	jsr	common_overscan_sound

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

	jmp	big_bubs_loop


set_done_go:
	lda	CHEAT_X			; make sure X preserved
	ldy	#DESTINATION_BUBS
	sta	WSYNC

	jmp	bubs_start
