; atari part of the code


atari_code:

	;=========================
	; Start Vertical Blank
	;=========================

	lda	#2			; reset beam to top of screen
	sta	VSYNC

	; wait for 3 scanlines of VSYNC

	sta	WSYNC			; wait until end of scanline
	sta	WSYNC

	dec	MAIN_COLOR		; rotate colors
	lda	MAIN_COLOR		; copy over main color
	sta	LINE_COLOR

	sta	WSYNC

	lda	#0			; done beam reset
	sta	VSYNC

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

	sta	RESP0			; coasre sprite0

	lda	#$40			; red
	sta	COLUP0
	sta	COLUP1

	ldx	#6
atari_right_loop:
	dex
	bne	atari_right_loop

	nop								; 2
	lda	$00			; nop3				; 3

	sta	RESP1			; coarse sprite1

        sta     WSYNC                   ;                               3
	sta	HMOVE


	;=============================
	; 37

	lda	#<music_len		; set up music pointer
	sta	MUSIC_PTR_L
	lda	#>music_len
	sta	MUSIC_PTR_H

	jsr	inc_frame				; 6+18

	sta	WSYNC

	stx	VBLANK			; turn on beam (X=0)


	;===========================
	;===========================
	; playfield
	;===========================
	;===========================
	; draw 192 lines


	;===========================
	; first 20 lines black
	;===========================

;	stx	COLUPF			; set playfield color black (needed?)
	ldx	#19
	jsr	scanline_wait		; leaves X 0


; 10

	;=====================
	; final init

	; X is 0 here
	stx	PF0		; clear leftmost playfield

	ldx	#74		; we count down 148

	lda	#CTRLPF_REF	; mirror playfield
	sta	CTRLPF

	lda	FRAMEH		; don't draw X yet
	cmp	#2
	bcc	not_yet
;	beq	not_yet

	lda	#$ff
	sta	GRP0			; set sprite
	sta	GRP1			; set sprite
not_yet:
	sta	WSYNC



atari_colorful_loop:
; 3
	lda	LINE_COLOR		; get color			; 3
	sta	COLUPF			; set playfield color		; 3
	and	#$10			; set side colors
	sta	PF0
; 9
	ldy	#1
	cpx	#36
	bcs	its1
	ldy	atari_row_lookup,X	; get which playfield lookup	; 4+
its1:

; 13
	lda	atari_playfield1_left,Y	;				; 4+
	sta	PF1			;				; 3
	; has to happen by 28
; 20
	lda	atari_playfield2_left,Y	;				; 4+
	sta	PF2			;				; 3
	; has to happen by 38
; 27

	inc	LINE_COLOR						; 5
	inc	LINE_COLOR						; 5
; 37
	; 74...0, frame 0...255
	stx	FRAME2
	lda	#74
	sbc	FRAME2
	cmp	FRAME
	bcc	no_draw_x
	lda	#$00
	sta	GRP0			; set sprite
	sta	GRP1			; set sprite

no_draw_x:

	dex				; dec X				; 2

; 39

	sta	WSYNC			;				; 3
	sta	HMOVE
	sta	WSYNC			;				; 3
; 75/76
	bne	atari_colorful_loop	;				; 2/3

	;=================
	; done!

	;================
	; scanline 168
	;	do nothing until end

	; X is zero here
;	lda	#$00
	stx	GRP0			; set sprite
	stx	GRP1			; set sprite

	ldx	#23
oog_loop:
	sta	WSYNC
	dex
	bne	oog_loop


	;============================
	; overscan
	;============================

	lda	#$2		; turn off beam
	sta	VBLANK

	; wait 30 scanlines

	ldx	#29
	jsr	scanline_wait

	;=======================
	; 29

	jsr	play_music

	sta	WSYNC

	lda	FRAMEH
	cmp	#4
;	beq	done_atari_code
	beq	blah

	jmp	atari_code

done_atari_code:

