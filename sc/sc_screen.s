	;=======================================
	;=======================================
	; draw strongbad collecting the secret
	;=======================================
	;=======================================
	; arrive with cycles=11 at end overscan

;11
	lda	#0		; turn off reflect on playfield		; 2
	sta	CTRLPF							; 3
	sta	VDELP0							; 3
	sta	FRAME							; 3
; 22
	sta	WSYNC

secret_collect_frame:
; 0 / 8
	; Start Vertical Blank
.if 0
	lda	#2			; reset beam to top of screen
	sta	VSYNC

	; wait for 3 scanlines of VSYNC

	sta	WSYNC			; wait until end of scanline
	sta	WSYNC
	sta	WSYNC

	lda	#0			; done beam reset
	sta	VSYNC



.endif

	jsr	common_vblank

; 9

	;=============================
	; 37 lines of vertical blank
	;=============================

	ldx	#35
vbscs_loop:
	sta	WSYNC
	dex
	bne	vbscs_loop

	;=======================
	; in VBLANK scanline 35
	;=======================

	sta	WSYNC

	;=======================
	; in VBLANK scanline 36
	;=======================
	; scanline 36 -- align sprite
	; must follow a WSYNC
; 0
	ldx	#7		;					; 2
; 2
scad_x:
	dex			;					; 2
	bne	scad_x		;					; 2/3

	; (5*X)-1, so with X=7, 34
; 36
	nop								; 2
	nop								; 2
; 40

	; beam is at proper place
	sta	RESP0							; 3
; 43
	lda	#$F0		; fine adjust				; 2
	sta	HMP0							; 3
; 48
	sta	WSYNC
	sta	HMOVE

	;=======================
	; scanline 37 -- config
; 3
	lda	#NUSIZ_QUAD_SIZE					; 2
	sta	NUSIZ0							; 3
; 8
	lda	#0			; turn on beam			; 2
	sta	VBLANK							; 3
; 13
	lda	#$80		; set color				; 2
	sta	COLUP0							; 3
; 18
	ldy	#0							; 2
	ldx	#0							; 2
	stx	GRP0							; 3
; 25
	sta	WSYNC


	;=============================================
	;=============================================
	; draw 152 lines
	; need to race beam to draw other half of playfield
	;=============================================
	;=============================================

sc_loop:
; 0
	lda	sc_colors,X		;				; 4+
	sta	COLUPF			; set playfield color		; 3
; 7
	lda	sc_overlay_colors,X					; 4+
	sta	COLUP0							; 3
; 14
	lda	#0			; always zero			; 2
	sta	PF0			;				; 3
	; must write by CPU 22 [GPU 68]
; 19
	sta	PF1			;				; 3
	; must write by CPU 28 [GPU 84]
; 22
	lda	sc_playfield2_left,X	;				; 4+
	sta	PF2			;				; 3
	; must write by CPU 38 [GPU 116]
; 29
	; at this point we're at 29 cycles

	lda	sc_overlay,X						; 4
	sta	GRP0							; 3
; 36

	lda	sc_playfield0_right,X	;				; 4+
	sta	PF0			;				; 3
	; must write by CPU 49 [GPU 148]
; 43
	lda	sc_playfield1_right,X	;				; 4+
	sta	PF1			;				; 3
	; must write by CPU 54 [GPU 164]
; 50
	lda	#$0							; 2
	sta	PF2			;				; 3
	; must write by CPU 65 [GPU 196]
; 55
	; make secret yellow
	lda	#$1C							; 2
	sta	COLUPF							; 3
; 60

	iny								; 2
	tya								; 2
	and	#$3							; 2
	beq	scyes_inx						; 2/3
	.byte	$A5	; begin of LDA ZP				; 3
scyes_inx:
	inx		; $E8 should be harmless to load		; 2
scdone_inx:
								;===========
								; 11/11

; 71
	cpy	#(152)							; 2
	bne	sc_loop							; 2/3
; 76



; 75

done_sc_loop:

	;===================
	; prep for text
; -1
	inc	FRAME							; 5
	lda	FRAME							; 3
	and	#$40							; 2
; 9
	bne	collect							; 2/3
; 11
	ldx	#0		; offset to "SECRET"			; 2
	beq	done_which	; bra					; 3
collect:
; 12
	ldx	#10		; offset to "COLLECT"			; 2
done_which:
; 16 / 14
	ldy	#0							; 2

	lda	#$80	; always blue					; 2
	sta	COLUPF							; 3
; 23 / 21
	sta	WSYNC


	;==========================================
	;==========================================
	; Bottom text
	;==========================================
	;==========================================
	; draw 40 lines
	; need to race beam to draw other half of playfield

sctext_loop:
; 0
	lda	$80	; nop 3 					; 3
	inc	TEMP1	; nop 5						; 5
	nop								; 2
	nop								; 2
	nop								; 2
; 14
	lda	#0							; 2
	sta	PF0			;				; 3
	; must write by CPU 22 [GPU 68]
; 19
	lda	secret_playfield1_left,X	;			; 4+
	sta	PF1			;				; 3
	; must write by CPU 28 [GPU 84]
; 26
	lda	secret_playfield2_left,X	;			; 4+
	sta	PF2			;				; 3
	; must write by CPU 38 [GPU 116]
; 33

	nop				;				; 2
	lda	secret_playfield0_right,X				; 4+
	sta	PF0			;				; 3
	; must write by CPU 49 [GPU 148]
; 42
	nop				;				; 2
	lda	secret_playfield1_right,X				; 4+
	sta	PF1			;				; 3
	; must write by CPU 54 [GPU 164]
; 51
	nop								; 2
	lda	#0			;				; 2
	sta	PF2			;				; 3
	; must write by CPU 65 [GPU 196]
	nop								; 2

; 60

	iny								; 2
	tya								; 2
	and	#$3							; 2
	beq	yes_inx2						; 2/3
	.byte	$A5	; begin of LDA ZP				; 3
yes_inx2:
	inx		; $E8 should be harmless to load		; 2
done_inx2:
								;===========
								; 11/11

; 71
	cpy	#36							; 2
	bne	sctext_loop						; 2/3
; 76

; 75
done_sctext_loop:
	sta	WSYNC
	sta	WSYNC


	;==========================
	; overscan
	;==========================

	ldx	#28
	jsr	common_overscan

.if 0
	lda	#$2		; turn off beam
	sta	VBLANK

	ldx	#0
sc_overscan_loop:
	sta	WSYNC
	inx
	cpx	#28
	bne	sc_overscan_loop
.endif

; 10

	;======================
	; takes two scanlines
	jsr	update_sound

	sta	WSYNC

	lda	FRAME							; 3
	beq	done_sc							; 2/3
; 5
	jmp	secret_collect_frame
; 8

done_sc:
; 6
	; move to next level
	inc	LEVEL							; 5
; 11
	; update score by adding in time
	ldx	TIME							; 3
	lda	time_bcd,X						; 4
	sed				; set BCD mode			; 2
	clc								; 2
	adc	SCORE_LOW						; 3
	sta	SCORE_LOW						; 3
	lda	#0							; 2
	adc	SCORE_HIGH						; 3
	sta	SCORE_HIGH						; 3
	cld				; disable BCD mode		; 2

	jsr	init_level						; 6+!!!

	jmp	do_level
