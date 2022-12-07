	;==========================
	; Trials
	;==========================
	; potentially arrive here with an unknown number of cycles/scanlines
	; ideally VBLANK=2 (beam off)

part1_trials:

	; =========================
	; Initialize music.
	; Set tt_cur_pat_index_c0/1 to the indexes of the first patterns from
	; tt_SequenceTable for each channel.
	; Set tt_timer and tt_cur_note_index_c0/1 to 0.
	; All other variables can start with any value.
	; =========================

	lda	#0
	sta	tt_cur_pat_index_c0
	sta	tt_timer
	sta	tt_cur_note_index_c0
	sta	tt_cur_note_index_c1
	lda	#1
	sta	tt_cur_pat_index_c1





;	lda	#$E
;	sta	DEBOUNCE_COUNTDOWN

	; comes in at ?? cycles from bottom of loop
start_trials:
	sta	WSYNC

	;=================
	; start VBLANK
	;=================
	; in scanline 0

	jsr	common_vblank

; 9

	jsr	handle_music_chapter

	; now vblank scanline 33

	;=============================
	; 4 lines of vertical blank
	;=============================

	ldx	#4
tvbsc_loop:
	sta	WSYNC
	dex								; 2
	bne	tvbsc_loop						; 2/3

	;=======================
	; scanline 37 -- config
; 4
	ldy	#0							; 2
	ldx	#0							; 2
	stx	VBLANK			; turn on beam			; 3
	stx	GRP0			; turn off sprite0 		; 3
	stx	GRP1			; turn off sprite1		; 3
; 17

	sta	WSYNC


	;=============================================
	;=============================================
	; draw trials
	;=============================================
	;=============================================


trials_loop:


; 0
	lda	trials_colors,X						; 4+
	sta	COLUPF		; set playfield color			; 3

; 7
	lda	trials_playfield0_left,X	;			; 4+
	sta	PF0				;			; 3
	; must write by CPU 22 [GPU 68]
; 14
	lda	trials_playfield1_left,X	;			; 4+
	sta	PF1				;			; 3
	; must write by CPU 27? [GPU 84]
; 21
	lda	trials_playfield2_left,X	;			; 4+
	sta	PF2				;			; 3
	; must write by CPU 38 [GPU 116]
; 28

	lda	trials_playfield0_right,X	;			; 4+
	sta	PF0				;			; 3
	; must write by CPU 49 [GPU 148]
; 35
	lda	trials_playfield1_right,X	;			; 4+
	sta	PF1				;			; 3
	; must write by CPU 54 [GPU 164]
; 42

	lda	trials_playfield2_right,X	;			; 4+
	sta	PF2				;			; 3
	; must write by CPU 65 [GPU 196]
; 49

	iny								; 2
	tya								; 2
	and	#$3							; 2
	beq	tyes_inx						; 2/3
	.byte	$A5     ; begin of LDA ZP				; 3
tyes_inx:
        inx             ; $E8 should be harmless to load		; 2
tdone_inx:
                                                                ;===========
                                                                ; 11/11

; 60
	nop
	nop
	nop
	nop
	lda	$80


; 71
	cpy	#192							; 2
	bne	trials_loop						; 2/3
; 76


	;==========================
	; overscan for 30 scanlines
	;==========================

	ldx	#28
	jsr	common_overscan

	;==========================
	; overscan 29
	;==========================

; 10
	lda	#0
	sta	DONE_SEGMENT

	inc	FRAMEL                                                  ; 5
	bne	no_frame_trials_oflo
	inc	FRAMEH
no_frame_trials_oflo:
	lda	FRAMEH
	cmp	#$2C
	bne	not_done_trials
	lda	FRAMEL
	cmp	#$40
	bne	not_done_trials
yes_done_trials:
	inc	DONE_SEGMENT
not_done_trials:
        sta	WSYNC


	;=========================
	; overscan 30
	;=========================
; 0

	lda     DONE_SEGMENT
	bne     done_trials

	sta     WSYNC
	jmp	start_trials						; 3

done_trials:
; 16

