	;==========================
	; knowthis screen
	;==========================
	; potentially arrive here with an unknown number of cycles/scanlines
	; ideally VBLANK=2 (beam off)

; should be zero from initial code

;	lda	#$0
;	sta	DONE_TITLE

start_knowthis:

	;=================
	; start VBLANK
	;=================
	; want to come in 1 scanline down
	; as this finishes old then does 3 for VSYNC

	jsr	common_vblank

; 9



	;=============================
	; 37 lines of vertical blank
	;=============================

        ldx     #23
	jsr	repeat_wsync

	;================================
	; play music -- scanlines 23..33
	;================================
	; takes 11 lines?

	lda	#3		; our bank
	jsr	do_play_music


	;====================
	; now in scanline 34
	;====================
	jsr	inc_frame
        sta     WSYNC

.if 0
	;===================
	; now scanline 35
	;===================
	; center the sprite position
	; needs to be right after a WSYNC
; 0
	; to center exactly would want sprite0 at
	;	CPU cycle 41.3
	; and sprite1 at
	;	GPU cycle 44

	ldx	#0		; sprite 0 display nothing		; 2
	stx	GRP0		;					; 3

	ldx	#6		;					; 2
; 7

tpad_x:
	dex			;					; 2
	bne	tpad_x		;					; 2/3
	; for X delays (5*X)-1
	; so in this case, 29
; 36
	; beam is at proper place
	sta	RESP0							; 3
	; 39 (GPU=??, want ??) +?
; 39
	sta	RESP1							; 3
	; 42 (GPU=??, want ??) +?
; 42

	lda	#$F0		; opposite what you'd think		; 2
	sta	HMP0							; 3
	lda	#$00							; 2
	sta	HMP1							; 3
; 52

.endif

	sta	WSYNC
; 0
;	sta	HMOVE		; adjust fine tune, must be after WSYNC
; 3

	;=======================
	; scanline 36

	sta	WSYNC

	;=======================
	; scanline 37 -- config
; 0
	ldy	#0							; 2
	ldx	#0							; 2
	stx	VBLANK			; turn on beam			; 3
	stx	GRP0							; 3
	stx	GRP1							; 3
; 13
;	lda	#$1E
;	lda	BASE_TITLE_COLOR					; 3
;	sta	TITLE_COLOR						; 3
; 19
;	lda	BACKGROUND_COLOR					; 3
	lda	#$0
	sta	COLUBK							; 3
; 25
	sta	WSYNC



	;=============================================
	;=============================================
	; draw title
	;=============================================
	;=============================================
	; draw 192 lines
	; need to race beam to draw other half of playfield
	; split across 2

title_loop:

; 0
	lda	ikt_colors,X	;					; 4
	sta	COLUPF		; set playfield color			; 3
	nop								; 2
	nop								; 2
; 11
	lda	ikt_playfield0_left,X		;			; 4
	sta	PF0				;			; 3
	nop								; 2

	; must write by CPU 22 [GPU 68]
; 20
	lda	ikt_playfield1_left,X		;			4+
	sta	PF1				;			3
	; must write by CPU 28 [GPU 84]
; 27
	lda	ikt_playfield2_left,X		;			4+
	sta	PF2				;			3
	; must write by CPU 38 [GPU 116]
; 34

	nop					;			2
	lda	ikt_playfield0_right,X	;			4+
	sta	PF0				;			3
	; must write by CPU 49 [GPU 148]
; 43
	lda	ikt_playfield1_right,X	;			4+
	sta	PF1				;			3
	; must write by CPU 54 [GPU 164]
; 50

	lda	$80				; nop3			3
	lda	ikt_playfield2_right,X	;			4+
	sta	PF2				;			3
	; must write by CPU 65 [GPU 196]
; 60


	sta	WSYNC

; 76

	; line 2


; 0
	lda	ikt_colors,X	;					; 4
	sta	COLUPF		; set playfield color			; 3
	nop								; 2
	nop								; 2
; 11
	lda	ikt_playfield0_left,X		;			; 4
	sta	PF0				;			; 3
	nop								; 2

	; must write by CPU 22 [GPU 68]
; 20
	lda	ikt_playfield1_left,X		;			4+
	sta	PF1				;			3
	; must write by CPU 28 [GPU 84]
; 27
	lda	ikt_playfield2_left,X		;			4+
	sta	PF2				;			3
	; must write by CPU 38 [GPU 116]
; 34

	nop					;			2
	lda	ikt_playfield0_right,X	;			4+
	sta	PF0				;			3
	; must write by CPU 49 [GPU 148]
; 43
	lda	ikt_playfield1_right,X	;			4+
	sta	PF1				;			3
	; must write by CPU 54 [GPU 164]
; 50

	lda	$80				; nop3			3
	lda	ikt_playfield2_right,X	;			4+
	sta	PF2				;			3
	; must write by CPU 65 [GPU 196]
; 60
	lda	$80	; nop3
	lda	$80	; nop3
	lda	$80	; nop3


; 69
        inx								; 2
	cpx	#(96)							; 2
	bne	title_loop						; 2/3

; 76


done_loop:

; 75

	;==========================
	; overscan for 30 scanlines
	;==========================

	ldx	#29
	jsr	common_overscan

	lda	FRAMEL
	cmp	#KNOWTHIS_TIME_L
	bne	not_done_knowthis
	lda     FRAMEH
	cmp     #KNOWTHIS_TIME_H
	beq     done_knowthis
not_done_knowthis:
	jmp	start_knowthis						; 3
; 18

done_knowthis:
; 16
	rts


.include "knowthis_pf.inc"
.include "ikt_face.inc"
