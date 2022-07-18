; Myst title


title_frame:

	; Start Vertical Blank

	lda	#0			; turn on beam
	sta	VBLANK

	lda	#2			; reset beam to top of screen
	sta	VSYNC

	; wait for 3 scanlines of VSYNC

	sta	WSYNC			; wait until end of scanline
	sta	WSYNC
	sta	WSYNC

	lda	#0			; done beam reset
	sta	VSYNC

	;=============================
	; 37 lines of vertical blank
	;=============================


.repeat 36
	sta	WSYNC
.endrepeat

	;=======================
	; scanline 37 -- config

	ldy	#0
	ldx	#0
	stx	GRP0
	stx	GRP1
	stx	CTRLPF

	lda	#$20
	sta	TITLE_COLOR

	sta	WSYNC


	;=============================================
	;=============================================
	; draw title
	;=============================================
	;=============================================
	; draw 192 lines
	; need to race beam to draw other half of playfield

title_loop:
	lda	TITLE_COLOR	; green	;				; 3
	sta	COLUPF			; set playfield color		; 3
	inc	TITLE_COLOR						; 5
; 11
	lda	title_playfield0_left,X	;				; 4+
	sta	PF0			;				; 3
	; must write by CPU 22 [GPU 68]
; 18
	lda	title_playfield1_left,X	;				; 4+
	sta	PF1			;				; 3
	; must write by CPU 28 [GPU 84]
; 25
	lda	title_playfield2_left,X	;				; 4+
	sta	PF2			;				; 3
	; must write by CPU 38 [GPU 116]


	nop
	nop
	lda	$80

; 32
	lda	title_playfield0_right,X	;			; 4+
	sta	PF0			;				; 3


	; must write by CPU 49 [GPU 148]
; 39

	lda	title_playfield1_right,X	;			4+
	sta	PF1			;				3
	; must write by CPU 54 [GPU 164]
; 46
	lda	title_playfield2_right,X	;			4+
	sta	PF2			;				3
	; must write by CPU 65 [GPU 196]
; 53


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
	cpy	#(192)							; 2
	bne	title_loop						; 2/3

; 76

done_loop:

;	.repeat 18
;	sta	WSYNC
;	.endrepeat


	;==========================
	; overscan
	;==========================

	lda	#$2		; turn off beam
	sta	VBLANK

	ldx	#0
overscan_loop:
	sta	WSYNC
	inx
	cpx	#30
	bne	overscan_loop

	jmp	title_frame

