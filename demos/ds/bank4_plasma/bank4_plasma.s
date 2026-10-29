; e7 plasma?

.include "../../../vcs.inc"

; zero page addresses

.include "../zp.inc"

.include "../common_routines.inc"


	;=======================
        ; plasma
        ;=======================
do_plasma:

	;==========================
	; title screen
	;==========================
	; potentially arrive here with an unknown number of cycles/scanlines
	; ideally VBLANK=2 (beam off)

; should be zero from initial code

;	lda	#$0
;	sta	DONE_TITLE

start_plasma:

.if 0

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

        ldx     #33
	jsr	repeat_wsync

	;====================
	; now in scanline 34
	;====================
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

title_loop:
; 0
	lda	title_colors,X	;					; 4
	sta	COLUPF		; set playfield color			; 3
	nop								; 2
	nop								; 2
; 11
	lda	title_playfield0_left,X		;			; 4
	sta	PF0				;			; 3
	nop								; 2

	; must write by CPU 22 [GPU 68]
; 20
	lda	title_playfield1_left,X		;			4+
	sta	PF1				;			3
	; must write by CPU 28 [GPU 84]
; 27
	lda	title_playfield2_left,X		;			4+
	sta	PF2				;			3
	; must write by CPU 38 [GPU 116]
; 34

	nop					;			2
	lda	title_playfield0_right,X	;			4+
	sta	PF0				;			3
	; must write by CPU 49 [GPU 148]
; 43
	lda	title_playfield1_right,X	;			4+
	sta	PF1				;			3
	; must write by CPU 54 [GPU 164]
; 50

	lda	$80				; nop3			3
	lda	title_playfield2_right,X	;			4+
	sta	PF2				;			3
	; must write by CPU 65 [GPU 196]
; 60

        iny                                                             ; 2
;        tya                                                             ; 2
;        and     #$3                                                     ; 2
;        beq     yes_inx                                                 ; 2/3
;        .byte   $A5     ; begin of LDA ZP                               ; 3
yes_inx:
        inx             ; $E8 should be harmless to load                ; 2
done_inx:
                                                                ;===========
                                                                ; 11/11

	nop
	nop
	lda	$80

; 71
	cpy	#(192)							; 2
	bne	title_loop						; 2/3

; 76

done_loop:

; 75

	;==========================
	; overscan for 30 scanlines
	;==========================

	ldx	#29
	jsr	common_overscan

; 10
	lda	DONE_TITLE						; 3
	bne	done_title						; 2/3
; 15
.endif
	jmp	start_plasma						; 3
; 18

done_plasma:
; 16



	rts

