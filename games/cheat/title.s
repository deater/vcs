; C.H.E.A.T. Title Screen

; o/~ F o/~
; that's not F


; =====================================================================
; Initialize music.
; Set tt_cur_pat_index_c0/1 to the indexes of the first patterns from
; tt_SequenceTable for each channel.
; Set tt_timer and tt_cur_note_index_c0/1 to 0.
; All other variables can start with any value.
; =====================================================================
        lda #0
        sta tt_cur_pat_index_c0
        lda #11
        sta tt_cur_pat_index_c1
        ; the rest should be 0 already from startup code. If not,
        ; set the following variables to 0 manually:
        ; - tt_timer
        ; - tt_cur_pat_index_c0
        ; - tt_cur_pat_index_c1
        ; - tt_cur_note_index_c0
        ; - tt_cur_note_index_c1


	;=========================
	; title
	;=========================

; title

title_loop:

	;=========================
	; Start Vertical Blank
	;=========================

	lda	#2			; reset beam to top of screen
	sta	VSYNC

	;================================
	; wait for 3 scanlines of VSYNC

	sta	WSYNC			; wait until end of scanline
	sta	WSYNC

	sta	WSYNC

	lda	#0			; done beam reset
	sta	VSYNC

	;===============================
	; 37 lines of vertical blank

	ldx	#36
	jsr	scanline_wait		; Leaves X zero
; 10

	;===========================
	; 36

	; apply fine adjust

	lda	#$e0
	sta     HMP0			; sprite0 + 2

	lda	#$20
	sta     HMP1			; sprite1 - 2

	nop
	nop
	nop

	sta	RESP0			; coasre sprite0

	lda	#$34			; red for the periods		; 2
	sta	COLUP0							; 3
	sta	a:COLUP1		; force extra cycle		; 4

	sta	RESP1			; coarse sprite1

        sta     WSYNC                   ;                               3
	sta	HMOVE


	;=============================
	; 37

	lda	#NUSIZ_TWO_COPIES_WIDE
	sta	NUSIZ0
	sta	NUSIZ1

	lda	#$0		; turn off delay
	sta	VDELP0
	sta	VDELP1

	sta	GRP0		; clear sprites
	sta	GRP1

	sta	PF0		; clear playfield
	sta	PF1
	sta	PF2

	sta	WSYNC

	stx	VBLANK			; turn on beam (X=0)


	;===========================
	;===========================
	; playfield
	;===========================
	;===========================
	; draw 192 lines


	;===========================
	; first 15 lines blue
	;===========================
	lda	#$72			; dark blue
	sta	COLUBK			; set playfield background

	lda	#$34			; ugly orange
	sta	COLUPF			; for later

	ldx	#14
	jsr	scanline_wait		; leaves X 0


; 10
	;=============
	; scanline 14
;	ldx	#0
	ldy	#0
	sta	WSYNC
	jmp	logo_loop

	;===========================
	; 32 lines of title
	;===========================
logo_loop:
; 3
	lda	title_playfield0_left,X					; 4+
	sta	PF0							; 3
	; must write by CPU 22 [GPU 68]
; 10
	lda	title_playfield1_left,X					; 4+
	sta	PF1							; 3
	; must write by CPU 28 [GPU 84]
; 17
	lda	title_playfield2_left,X					; 4+
	sta	PF2							; 3
	; must write by CPU 38 [GPU 116]
; 24
	cpy	#28			; 2
	bcc	blargh			; 2/3

	lda	#$30			; 2
	sta	GRP0			; 3
	sta	GRP1			; 3
	bne	blargh2			; 3
blargh:
	inc	TEMP1	; nop5		; 5
	dec	TEMP1	; nop5		; 5

blargh2:
	; 15/15

; 39
	lda	title_playfield0_right,X				; 4+
	sta	PF0                                                     ; 3
	; must write by CPU 49 [GPU 148]
; 46
	lda	title_playfield1_right,X				; 4+
	sta	PF1							; 3
	; must write by CPU 54 [GPU 164]
; 53
	lda	title_playfield2_right,X				; 4+
	sta	PF2							; 3
	; must write by CPU 65 [GPU 196]
; 60
	iny								; 2
	tya								; 2
	lsr								; 2
	tax								; 2
; 68
	cpy	#32							; 2
; 70
	sta	WSYNC
	bne	logo_loop

	; at scaline 46 here?


	;===========================
	; 46 - 74 = blank
	;===========================

	lda	#$0		; turn off periods
	sta	GRP0
	sta	GRP1

	ldx	#28
	jsr	scanline_wait


	;===========================
	; 75 - 129 = bitmap
	;===========================
	; 48-pixel sprite!!!!
	;

	;================
	; scanline 80
	;	set things up

	lda	#$1A			; yellow
	sta	COLUP0	; set sprite color
	sta	COLUP1	; set sprite color

	lda	#NUSIZ_THREE_COPIES_CLOSE
	sta	NUSIZ0
	sta	NUSIZ1

	lda	#0		; turn off sprite
	sta	GRP0
	sta	GRP1
	sta	HMP1			;			3

	lda	#1		; turn on delay
	sta	VDELP0
	sta	VDELP1

	sta	WSYNC

	;=================
	; scanline 81

	; to center exactly would want sprite0 at
	;	CPU cycle 41.3
	; and sprite1 at
	;	GPU cycle 44

	ldx	#6		;				2
cpad_x:
	dex			;				2
	bne	cpad_x		;				2/3
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
;	lda	#$00
;	sta	HMP1			;			3

	sta	WSYNC
	sta	HMOVE		; adjust fine tune, must be after WSYNC

	ldx	#49		; init X
	stx	TEMP2

	;===============================
	; scanline 82

	jmp	over_align2
.align $100
over_align2:
	sta	WSYNC

	;================================
	; scanline 83

spriteloop_cheat:
	; 0
	lda	cheat_title0,X	; load sprite data		; 4+
	sta	GRP0			; 0->[GRP0] [GRP1 (?)]->GRP1	; 3
	; 7
	lda	cheat_title1,X	; load sprite data		; 4+
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3
	; 14
	lda	cheat_title2,X	; load sprite data		; 4+
	sta	GRP0			; 2->[GRP0], [GRP1 (1)]-->GRP1	; 3
	; 21

	lda	cheat_title5,X					; 4+
	sta	TEMP1							; 3
	; 28
	lda	cheat_title4,X					; 4+
	tay								; 2
	; 34
	lda	cheat_title3,X	;				; 4+
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
	lda	TEMP1	; 3
	lda	TEMP1	; 3


	; 65

	dec	TEMP2							; 5
	ldx	TEMP2							; 3
	bpl	spriteloop_cheat						; 2/3
	; 76  (goal is 76)

	ldy	#0		; clear out sprites
	sty	GRP1
	sty	GRP0
	sty	GRP1

	sta	WSYNC


	;===========================
	; 129 - 170 = rest
	;===========================

	lda	#$72			; dark blue
	sta	COLUBK			; set playfield background

	ldx	#43
	jsr	scanline_wait

	;===========================
	;===========================
	; 171 - 191 = bottom logo
	;===========================
	;===========================
	; 48-pixel sprite!!!!
	;

	;================
	; scanline 172
	;	set things up


	lda	#$9A			; light blue
	sta	COLUBK			; set playfield background

	lda	#$C2			; dark green 97*2=194  C2
	sta	COLUP0	; set sprite color
	sta	COLUP1	; set sprite color

	lda	#NUSIZ_THREE_COPIES_CLOSE
	sta	NUSIZ0
	sta	NUSIZ1

	; delay and sprite offsets already set previously

;	lda	#0		; turn off sprite
;	sta	GRP0
;	sta	GRP1
;	sta	HMP1			;			3

;	lda	#1		; turn on delay
;	sta	VDELP0
;	sta	VDELP1

	ldx	#16		; init X
	stx	TEMP2

	sta	WSYNC

	;===============================
	; scanline 173

;	jmp	over_align
;.align $100
;over_align:
	sta	WSYNC

	;================================
	; scanline 175

spriteloop:
	; 0
	lda	vid_sprite0,X	; load sprite data		; 4+
	sta	GRP0			; 0->[GRP0] [GRP1 (?)]->GRP1	; 3
	; 7
	lda	vid_sprite1,X	; load sprite data		; 4+
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3
	; 14
	lda	vid_sprite2,X	; load sprite data		; 4+
	sta	GRP0			; 2->[GRP0], [GRP1 (1)]-->GRP1	; 3
	; 21

	lda	vid_sprite5,X					; 4+
	sta	TEMP1							; 3
	; 28
	lda	vid_sprite4,X					; 4+
	tay								; 2
	; 34
	lda	vid_sprite3,X	;				; 4+
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
	lda	TEMP1	; 3
	lda	TEMP1	; 3


	; 65

	dec	TEMP2							; 5
	ldx	TEMP2							; 3
	bpl	spriteloop						; 2/3
	; 76  (goal is 76)

	ldy	#0		; clear out sprites
	sty	GRP1
	sty	GRP0
	sty	GRP1

	sta	WSYNC



	;============================
	; overscan
	;============================
common_overscan:
	lda	#$2		; turn off beam
	sta	VBLANK



	;=======================
	; 29

	; fallthrough

	lda	#12
	sta	TIM64T

	lda	tt_cur_pat_index_c0
	cmp	#11
	bcc	do_play_music

	lda	#0
	sta	AUDV0
	sta	AUDV1
	beq	done_music


do_play_music:
	jsr	play_music
done_music:

	; Measure player worst case timing
;	lda     #12           ; TIM_VBLANK
;	sec
;	sbc	INTIM
;	cmp	player_time_max
;	bcc	no_new_max
;	sta	player_time_max
;no_new_max:

wait_for_vblank:
	lda	INTIM
	bne	wait_for_vblank


	; wait 30 scanlines

	ldx	#19
	jsr	scanline_wait

	;===================================
	; check for button or RESET
	;===================================
; 0
;	lda	#0                                                      ; 2
;	sta	DONE_TITLE		; init as not done title	; 3
; 5
	;===============================
	; debounce reset/keypress check

	lda	TITLE_COUNTDOWN						; 3
	beq	waited_enough						; 2/3
	dec	TITLE_COUNTDOWN						; 5
	jmp	done_check_input					; 3

waited_enough:
; 11
	lda	INPT4			; check joystick button pressed ; 3
	bpl	done_title                                          ; 2/3

; 16
	lda	SWCHB			; check if reset pressed        ; 3
	lsr				; put reset into carry          ; 2
	bcc	done_title                                          	; 2/3

;	jmp	title_loop						; 3

done_check_input:
; 25 / 22 / 29

	sta	WSYNC

	; empty, makes us match better the game

	jmp	title_loop

; 27
done_title:

	; turn off music

	lda	#0							; 2
	sta	AUDV0							; 3
	sta	AUDV1							; 3

;	jmp	switch_bank1						; 3
; 38

