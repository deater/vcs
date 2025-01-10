	;===========================
	; draw the videlectrix title
	;===========================
	; ideally called with VBLANK disabled

	lda	#120
	sta	RUNNER_X

	lda	#9
	sta	RUNNER_STATE

	lda	#0
	sta	FRAME
	sta	FRAMEH
	sta	RUNNER_COUNT

level_frame:

	;============================
	; Start Vertical Blank
	;============================
	; actually takes 4 scanlines, clears out current then three more

	jsr	common_vblank

; 9

	;=================================
	;=================================
	; 37 lines of vertical blank
	;=================================
	;=================================

	ldx	#30
	jsr	common_delay_scanlines
; 10 cycles

	;==============================
	; now VBLANK scanline 30
	;==============================
	; update runner state

	inc	FRAME							; 5
	bne	no_oflo							; 2/3
	inc	FRAMEH							; 5
no_oflo:
	lda	FRAME							; 3
	and	#$1f							; 2
	bne	same_frame						; 2/3

	lda	RUNNER_COUNT						; 3
	cmp	#MAX_RUNNER_STATE					; 2
	bcs	same_frame						; 2/3

	inc	RUNNER_COUNT	; increment count each 32 frames (~0.5s); 5

	ldx	RUNNER_COUNT		; lookup state for new count	; 3
	lda	runner_state,X						; 4+
	sta	RUNNER_STATE						; 3

	cpx	#4		; start music after 1s?
	bne	same_frame

	ldy	#VID_THEME
	sty	NOTE_POINTER

;	ldy	#SFX_GAMEOVER
;	jsr	trigger_sound

same_frame:

	sta	WSYNC

	;==============================
	; now VBLANK scanline 31
	;==============================
	; move runner
; 0
	lda	RUNNER_COUNT						; 3
	cmp	#MAX_RUNNER_STATE					; 2
	bcs	skip_move						; 2/3

	lda	FRAME							; 3
	and	#$7							; 2
	bne	skip_move						; 2/3

	dec	RUNNER_X						; 5
skip_move:
	sta	WSYNC							; 3


	;====================================
	; position runner left sprite 32+33
	;====================================

	lda	#0							; 2
	sta	HMCLR			; clear horizontal move		; 3

	lda	RUNNER_X		; position			; 3
	ldx	#0			; 0=sprite0			; 2
	jsr	set_pos_x		; usually 2 scanlines	; needs <20

; scanline 33
; scanline 34

; 6

	;====================================
	; position runner right sprite 34+35
	;====================================
	lda	RUNNER_X		; position			; 3
	clc								; 2
	adc	#16							; 2
	ldx	#1			; 1=sprite1			; 2
; 15
	jsr	set_pos_x		; usually 2 scanlines	; needs <20

; scanline 35
; scanline 36


; 6

	;==============================
	; now VBLANK scanline 36
	;==============================
	; set up sprites
; 0

	ldx	RUNNER_STATE					; 3

; 3
	lda	runner_left,X					; 4+
	sta	RUNNER_PTR_L					; 3
	lda	runner_right,X					; 4+
	sta	RUNNER_PTR_R					; 3

	; all in same page
	lda	#>runner_data					; 2
	sta	RUNNER_PTR_LH					; 3
	sta	RUNNER_PTR_RH					; 3

	sta	WSYNC
	sta	HMOVE						; 3

	;==============================
	; now VBLANK scanline 37
	;==============================

	; setup playfield

	lda	#$0		; playfield entirely off		; 2
	sta	PF0
	sta	PF1							; 3
	sta	PF2							; 3

	sta	COLUPF		; set playfield color to black		; 3

	sta	GRP0		; turn off sprite0			; 3
	sta	GRP1		; turn off sprite1			; 3

	sta	COLUBK		; set playfield background to black	; 3

	sta	CTRLPF                                                  ; 3

	lda	#NUSIZ_DOUBLE_SIZE					; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1							; 3

	lda	#0		; 0 to turn on
	sta	VBLANK		; enable beam				; 3

	sta	WSYNC

	;==============================
	; now VBLANK scanline 37
	;==============================

	;===============================
	;===============================
	;===============================
	; visible area: 192 lines (NTSC)
	;===============================
	;===============================
	;===============================


	;===============================
	; 20 lines of black	(0..19)
	;===============================
; scanline 0
	ldx	#19
	jsr	common_delay_scanlines

	;=============================================
	; draw 44 lines of the title
	; need to race beam to draw other half of playfield
	;=============================================
; scanline 19
	lda	#$C0		; top of V pattern
	sta	PF0
	lda	#$B8
	sta	PF1

	;========================
	; top V
	; scanline 20..23

	ldx	#3			; draw 3 lines			; 2
top_v_loop:
	sta	WSYNC

; 0
	lda	#$44			; red				; 2
	sta	COLUPF							; 3
; 5
	; want to delay 20 total
	jsr	delay_20
; 25
	lda	#$C6			; green				; 2
	sta	COLUPF							; 3
; 30
	lda	#$00							; 2
	sta	COLUPF							; 3
; 35
	dex
	bpl	top_v_loop

; scanline 23

	;========================
	; middle V
	; 	24..27

	ldx	#3			; draw 3 lines			; 2
mid_v_loop:
	sta	WSYNC

; 0
	lda	#$44			; red				; 2
	sta	COLUPF							; 3
; 5
	; want to delay 16
	jsr	delay_16
; 21
	ldy	#$C6			; load green in avance		; 2
	lda	#$84			; blue				; 2
	sta	COLUPF			; set blue			; 3
	sty	a:COLUPF		; quickly set green		; 4
; 32
	lda	#$00			; set black			; 2
	sta	COLUPF							; 3
	dex
	bpl	mid_v_loop

	;========================
	; bottom V

	ldx	#3							; 2
bottom_v_loop:
	sta	WSYNC

; 0
	lda	#$84			; set blue			; 2
	sta	COLUPF							; 3
; 5
	; want to delay 26
	jsr	delay_26
; 31
	lda	#$00							; 2
	sta	COLUPF							; 3
; 36
	dex								; 2
	bpl	bottom_v_loop						; 2/3

	;========================
	; set up for title loop

	ldy	#0
	ldx	#12

	jmp	titl_align
.align $100

titl_align:
	sta	WSYNC

vid_title_loop:
	lda	#$84		; medium blue				; 2
	sta	COLUPF		; set playfield color			; 3
; 5
	lda	vplayfield0_left,Y	;				; 4+
	sta	PF0			;				; 3
	; must write by CPU 22 [GPU 68]
; 12
	lda	vplayfield1_left,Y	;				; 4+
	sta	PF1			;				; 3
	; must write by CPU 28 [GPU 84]
; 19
	lda	vplayfield2_left,Y	;				; 4+
	sta	PF2			;				; 3
	; must write by CPU 38 [GPU 116]
; 26
	nop
; 28
	lda	#$0e		; white					; 2
	sta	a:COLUPF						; 4
; 34

	lda	$80		; nop3

; 37
	; at this point we're at 28 cycles
	lda	vplayfield0_right,Y	;				; 4+
	sta	PF0			;				; 3
	; must write by CPU 49 [GPU 148]
; 44
	lda	vplayfield1_right,Y	;				; 4+
	sta	PF1			;				; 3
	; must write by CPU 54 [GPU 164]
; 51
	nop
	lda	vplayfield2_right,Y	;				; 4+
	sta	PF2			;				; 3
	; must write by CPU 65 [GPU 196]

; 60

	inx								; 2
	txa								; 2
	and	#$3							; 2
	beq	vyes_iny						; 2/3
	.byte	$A5     ; begin of LDA ZP                               ; 3
vyes_iny:
	iny		; $E8 should be harmless to load                ; 2
vdone_iny:
                                                                ;===========
                                                                ; 11/11

; 71
	cpx	#44						; 2
	bne	vid_title_loop					; 2/3


	;==================================
	; black for 64..95
	;==================================
	lda	#$0
	sta	COLUPF

	ldx	#32
	jsr	common_delay_scanlines

;scanline 96

	lda	#$0e		; white color				; 2
	sta	COLUP0							; 3
	sta	COLUP1							; 3

	; unused?

	ldy	#17							; 2
	ldx	#100							; 2

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
; scanline 100

	;===============================
	; 36 lines of runner (100..135)
	;===============================
	; runner each pixel is 2 high

runner_loop:
	lda	(RUNNER_PTR_L),Y
	sta	GRP0			; set left sprite		; 3
	lda	(RUNNER_PTR_R),Y	; load right sprite data	; 5+
	sta	GRP1			; set right sprite		; 3

	sta	WSYNC

	dey
	sta	WSYNC
	bne	runner_loop

	lda	#0		; turn off sprites
	sta	GRP0
	sta	GRP1

	;==================
	;==================
	; 136-191 delay
	;==================
	;==================

	ldx	#56
	jsr	common_delay_scanlines


	;==================================
	;==================================
	;==================================
	; overscan 30, handle end
	;==================================
	;==================================
	;==================================
	;==================================

	ldx	#24
	jsr	common_overscan

	;=============================
	; now at VBLANK scanline 25+26
	;=============================
	; update sound
        ; takes two scanlines

;	jsr	update_sound		; 2 scanlines

	jsr	play_note

	sta	WSYNC
	sta	WSYNC

	;=============================
	; now at VBLANK scanline 27
	;=============================
	; handle down being pressed
; 0

after_check_down:
	sta	WSYNC


	;=============================
	; now at VBLANK scanline 28
	;=============================
	; handle button being pressed
; 0
	; debounce
	lda	BUTTON_COUNTDOWN					; 3
	beq	waited_button_enough					; 2/3
	dec	BUTTON_COUNTDOWN					; 5
	jmp	done_check_button					; 3

waited_button_enough:

	lda	INPT4		; check joystick button pressed         ; 3
	bmi	done_check_button					; 2/3

	inc	LEVEL_OVER
	lda	#20
	sta	BUTTON_COUNTDOWN

done_check_button:
	sta	WSYNC

	;=============================
	; now at VBLANK scanline 29
	;=============================
	; Handle end

	lda	FRAMEH
	cmp	#3
	beq	done_vid

	lda	LEVEL_OVER		; see if level over set
	bne	done_vid		; then exit

	sta	WSYNC


	;==================================
	; overscan 30, handle end
	;==================================
	;


after_check_right:

	jmp	level_frame

done_vid:
	lda	#0
	sta	LEVEL_OVER

