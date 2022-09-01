	;==========================
	; title screen
	;==========================
	; potentially arrive here with an unknown number of cycles/scanlines
	; ideally VBLANK=2 (beam off)


	; the init code sets everything to 0

;	lda	#0							; 2
;	sta	FRAME							; 3
;	sta	BACKGROUND_COLOR					; 3

	lda	#$28							; 2
	sta	BASE_TITLE_COLOR					; 3

	lda	#$0E							; 2
	sta	TEXT_COLOR						; 3
	sta	TITLE_COUNTDOWN						; 3

	; comes in at 14 cycles from bottom of loop
start_title:

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
vbsc_loop:
        sta     WSYNC
        dex
        bne     vbsc_loop

	;====================
	; now in scanline 34
	;====================
        sta     WSYNC

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
	sta	WSYNC
; 0
	sta	HMOVE		; adjust fine tune, must be after WSYNC
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
	lda	BASE_TITLE_COLOR					; 3
	sta	TITLE_COLOR						; 3
; 19
	lda	BACKGROUND_COLOR					; 3
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
	lda	TITLE_COLOR	;					; 3
	sta	COLUPF		; set playfield color			; 3
	inc	TITLE_COLOR	; increment for next line		; 5
	nop			;					; 2
; 13
	nop								; 2
	lda	#0	; always black					; 2
	sta	PF0				;			; 3
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
	cpy	#(120)							; 2
	bne	title_loop						; 2/3

; 76

done_loop:

; 75
	;================
	; scanline 120

	sta	WSYNC		; padding

	;===============
	; scanline 121

	sta	WSYNC

	;===============
	; scanline 122
; 0
	nop								; 2
; 2
	;=========================================
	;=========================================
	; draw Videlectrix Logo sprite (11 lines)
	;=========================================
	;=========================================

	; assume coming in 2 cycles after WSYNC (why??)

	;========================
	; Still in scanline 122
	;========================
	; configure 48-pixel sprite code

	; make playfield black
	lda	#$00		; black					; 2
	sta	COLUPF		; playfield color			; 3
	sta	PF0		; turn off playfield so don't collide	; 3
	sta	PF1		;					; 3
	sta	PF2		;					; 3
	sta	GRP0		; turn off sprites			; 3
	sta	GRP1		;					; 3
; 22
	; set color

	lda	TEXT_COLOR	; bright white				; 3
	sta	COLUP0		; set sprite color			; 3
	sta	COLUP1		; set sprite color			; 3
; 31
	; set to be 48 adjacent pixels

	lda	#NUSIZ_THREE_COPIES_CLOSE				; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1							; 3
; 39
	; turn on delay

	lda	#1							; 2
	sta	VDELP0							; 3
	sta	VDELP1							; 3
; 47
	; number of lines to draw
	ldx	#48							; 2
	stx	TEMP2							; 3
; 52
	sta	WSYNC							; 3

	;===================
	; now scanline 123
	;===================

	sta	WSYNC

	;===================
	; now scanline 124
	;===================

	ldx	TEMP2		; restore length of sprite

	sta	WSYNC

	;===================
	; now scanline 125
	;===================

title_spriteloop:
; 0
	lda	title_bitmap0,X		; load sprite data		; 4+
	sta	GRP0			; 0->[GRP0] [GRP1 (?)]->GRP1	; 3
; 7
	lda	title_bitmap1,X		; load sprite data		; 4+
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3
; 14
	lda	title_bitmap2,X		; load sprite data		; 4+
	sta	GRP0			; 2->[GRP0], [GRP1 (1)]-->GRP1	; 3
; 21

	lda	title_bitmap5,X						; 4+
	sta	TEMP1			; save for later		; 3
; 28
	lda	title_bitmap4,X						; 4+
	tay				; save in Y			; 2
; 34
	lda	title_bitmap3,X	;					; 4+
	ldx	TEMP1			; restore saved value		; 3
; 41

	sta	GRP1			; 3->[GRP1], [GRP0 (2)]-->GRP0	; 3
	; (need this to be 44 .. 46)
; 44
	sty	GRP0			; 4->[GRP0], [GRP1 (3)]-->GRP1	; 3
	; (need this to be 47 .. 49)
; 47
	stx	GRP1			; 5->[GRP1], [GRP0 (4)]-->GRP0	; 3
	; (need this to be 50 .. 51)
; 50
	sty	GRP0			; ?->[GRP0], [GRP1 (5)]-->GRP1 	; 3
	; (need this to be 52 .. 54)
; 53

	; need 12 cycles of nops
	inc	TEMP1		; nop5					; 5
	inc	TEMP1		; nop5					; 5
	nop								; 2

; 65

	dec	TEMP2							; 5
	ldx	TEMP2			; decrement count		; 3
; 73
	bpl	title_spriteloop					; 2/3
	; 76  (goal is 76)


; 75
	;=========================
	; done drawing line

	ldy	#0		; clear out sprite data			; 2
	sty	GRP1							; 3
	sty	GRP0							; 3
	sty	GRP1							; 3

	sta	WSYNC

	;===================================
	; scanline 173?
	;===================================
	; check for button or RESET
	;===================================
; 0
	lda	#0							; 2
	sta	DONE_TITLE		; init as not done title	; 3
; 5
	;===============================
	; debounce reset/keypress check

	lda	TITLE_COUNTDOWN						; 3
	beq	waited_enough						; 2/3
	dec	TITLE_COUNTDOWN						; 5
	jmp	done_check_input					; 3

waited_enough:
; 11
	lda	INPT4			; check joystick button pressed	; 3
	bpl	set_done_title						; 2/3

; 16
	lda	SWCHB			; check if reset pressed	; 3
	lsr				; put reset into carry		; 2
	bcc	set_done_title						; 2/3

	jmp	done_check_input					; 3

set_done_title:
; 17 / 24
	inc	DONE_TITLE		; we are done			; 5
done_check_input:
; 25 / 22 / 29

	;=========================
	; screensaver
; 29
	inc	FRAME							; 5
	lda	FRAME							; 3
; 37
	and	#$3f			; only every 64 (~1s)		; 2
	bne	no_rotate_color						; 2/3

; 41
	clc								; 2
	lda	BASE_TITLE_COLOR					; 3
	adc	#$17							; 2
	sta	BASE_TITLE_COLOR					; 3
; 51
	clc								; 2
	lda	BACKGROUND_COLOR					; 3
	adc	#$10							; 2
	sta	BACKGROUND_COLOR					; 3
; 61
	clc								; 2
	lda	TEXT_COLOR						; 3
	adc	#$10							; 2
	sta	TEXT_COLOR						; 3

; 71
no_rotate_color:
; 42 / 71

	ldx     #17
; 45 / 73
endtitle_loop:
        sta     WSYNC
        dex
        bne     endtitle_loop

	;========================================
	; scanline 190?  shouldn't we be at 192?
	;========================================


	;==========================
	; overscan for 30 scanlines
	;==========================

	ldx	#29
	jsr	common_overscan

; 10
	lda	DONE_TITLE						; 3
	bne	done_title						; 2/3
; 15
	jmp	start_title						; 3
; 18

done_title:
; 16
