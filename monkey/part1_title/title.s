	;==========================
	; Draw the title screen
	;==========================
	; asymmetric playfield
	; TODO: cloud at top?

do_title:
	lda	#124
	sta	CLOUD_X

title_frame:

	sta	WSYNC				; try to avoid glitch

	;============================
	; start VBLANK
	;============================
	; in scanline 0

	jsr	common_vblank

	;=================================
	;=================================
	; 37 lines of vertical blank
	;=================================
	;=================================

; in VBLANK scanline 0

	jsr	handle_music


	;======================================
	; now vblank 35
	;=======================================
	; update pointer horizontal position
	;=======================================

	lda	CLOUD_X							; 3

	lsr								; 2
	lsr								; 2
	lsr								; 2
	lsr								; 2
	sta	CLOUD_X_COARSE						; 3

	; apply fine adjust
	lda	CLOUD_X							; 3
	and	#$0f							; 2
	tax								; 2
	lda	fine_adjust_table,X					; 4+
	sta	HMP0
	sta	HMP1

	sta	WSYNC			;				3



	;=============================
	; now VBLANK scanline 33
	;=============================
	; do some init

        ldx     CLOUD_X_COARSE ;                                       3
        inx                     ;                                       2
        inx                     ;                                       2

zpad_x:
        dex                     ;                                       2
        bne     zpad_x          ;                                       2/3
                                ;===========================================
                                ;       5*(coarse_x+2)-1
                                ; max is 9, so worst case is 54

        nop
        sta     RESP0
        sta     RESP1


	sta	WSYNC
	sta	HMOVE
	;=======================
	; now VBLANK scanline 34
	;=======================
	; nothing right now

	lda	FRAMEL
	and	#$3f
	bne	no_move_cloud
	dec	CLOUD_X
no_move_cloud:
	sta	WSYNC




	;=========================================
	; now vblank 36
	;==========================================
	; set up sprite0 to be at proper X position
	;==========================================


	sta	WSYNC			;				3

	;==========================================
	; now vblank 37
	;==========================================
	; Final setup before going
	;==========================================

	ldx	#0			; current scanline?		; 2
	stx	PF0			; disable playfield		; 3
	stx	PF1							; 3
	stx	PF2							; 3
	stx	GRP0
	stx	GRP1
	stx	VDELP0
	stx	VDELP1

	lda	#$04			; cloud is grey			; 2
	sta	COLUP0							; 3
	lda	#$06
	sta	COLUP1							; 3

	lda	#NUSIZ_THREE_COPIES_CLOSE				; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1							; 3
; 37
	lda	#CTRLPF_REF	; reflect playfield			; 2
	sta	CTRLPF		;					; 3
	ldy	#0		; current_block

; 44
	lda	top_title_words_bg_colors,Y		;			; 3
	sta	COLUBK		; set background color			; 3
; 50
	lda	top_title_words_colors,Y						; 4
; 59

	stx	VBLANK		; turn on beam				; 3
; 64

	sta	WSYNC							; 3

	jmp	draw_title_scanline					; 3

	;===========================================
	;===========================================
	;===========================================
	; draw playfield, 192 scanlines
	;===========================================
	;===========================================
	;===========================================

draw_title_scanline:

	; Y should be 0

	;========================================
	;========================================
	; Top 6 lines (24 scanlines) are mirrored
	;========================================
	;========================================
title_top_kernel:

; 3
        sta     COLUPF                  ; playfield color               ; 3
; 6
	lda	top_title_words_bg_colors,Y                                 ; 4
	sta	COLUBK                  ; background color              ; 3

; 13
	lda     top_title_words_playfield0_left,Y ; playfield pattern 0           ; 4
	sta     PF0                     ;                               ; 3
        ;   has to happen by 22 (GPU 68)
; 20
        lda     top_title_words_playfield1_left,Y ; playfield pattern 1           ; 4
        sta     PF1                     ;                               ; 3
        ;  has to happen by 28 (GPU 84)
; 27
        lda     top_title_words_playfield2_left,Y ; playfield pattern 2           ; 4
        sta     PF2                                                     ; 3
        ;  has to happen by 38 (GPU 116)        ;
; 34

        sta     WSYNC

	lda	cloud_data,Y
	sta	GRP0
	sta	GRP1

        sta     WSYNC

        sta     WSYNC

	iny                                                             ; 2
        lda     top_title_words_colors,Y                                          ; 4

        cpy     #6             ; see if hit end                        ; 2
        sta     WSYNC
        bne     title_top_kernel                                     ; 2/3

; 2

	;============================
	;============================
	; draw middle kernel
	;============================
	;============================
; 2
	lda	#$00							; 2
	sta	PF0							; 3
	sta	PF1							; 3
	sta	PF2							; 3
; 13
	sta	COLUBK							; 3
	sta	CTRLPF		; no-reflect playfield			; 3
; 19

	;=======================
	; set things up

; 0
	ldx	#2
; 12

pad_x:
	dex			;					; 2
	bne	pad_x		;					; 2/3
				;===========================================
				;	12-1+5*(coarse_x+2)
;

	; beam is at proper place
	sta	RESP0							; 3

	lda	#$D0			; fine adjust overlay		; 2
	sta	HMP0							; 3

	ldx	#4
ipad_x:
	dex			;					; 2
	bne	ipad_x		;					; 2/3
				;===========================================
				;	12-1+5*(coarse_x+2)
	sta	RESP1							; 3


	lda	#$C0			; fine adjust overlay		; 2
	sta	HMP1							; 3

	sta	WSYNC							; 3
	sta	HMOVE		; adjust fine tune, must be after WSYNC	; 3
				; also draws black artifact on left of
				; screen

	;==============================


	lda	#$5A			; purple			; 2
	sta	COLUPF			; playfield color		; 3
	sta	COLUP0
	sta	COLUP1

	lda	#NUSIZ_QUAD_SIZE					; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1

; 24
	ldx	#24							; 2
	ldy	#0							; 2
; 28
	sta	WSYNC



title_middle_kernel:
	nop
	nop
	lda	$E8
; 7
	lda	title_words_playfield0_left,Y	;			; 4+
	sta	PF0				;			; 3
	; must write by CPU 22 [GPU 68]
; 14
	lda	title_words_playfield1_left,Y	;			; 4+
	sta	PF1				;			; 3
	; must write by CPU 27? [GPU 84]
; 21
	lda	title_words_playfield2_left,Y	;			; 4+
	sta	PF2				;			; 3
	; must write by CPU 38 [GPU 116]
; 28
	lda	title_words_playfield0_right,Y	;			; 4+
	sta	PF0				;			; 3
	; must write by CPU 49 [GPU 148]
; 35
	lda	title_words_playfield1_right,Y	;			; 4+
	sta	PF1				;			; 3
	; must write by CPU 54 [GPU 164]
; 42
	lda	title_words_playfield2_right,Y	;			; 4+
	sta     PF2				;			; 3
	; must write by CPU 65 [GPU 196]
; 49
	inx                                                             ; 2
	txa                                                             ; 2
	and     #$3                                                     ; 2
	beq     tyes_inx                                                ; 2/3
	.byte   $A5     ; begin of LDA ZP                               ; 3
tyes_inx:
        iny             ; $E8 should be harmless to load                ; 2
tdone_inx:
                                                                ;===========
                                                                ; 11/11

; 60


; ??
	cpy	#30							; 2
	sta	WSYNC
	bne	title_middle_kernel					; 2/3
; 2

	;============================
	;============================
	; draw bottom kernel
	;============================
	;============================

; 3
	lda	#$00							; 2
	sta	PF0							; 3
	sta	PF1							; 3
	sta	PF2							; 3
; 13
	sta	COLUBK							; 3
; 16
	lda	#CTRLPF_REF	; reflect playfield			; 2
	sta	CTRLPF		;					; 3

	ldy	#1		; skip a line to make up for 4 skips	; 2


	lda	left_sprite
	sta	GRP0

	lda	right_sprite
	sta	GRP1

	lda	bottom_title_words_colors,Y				; 4

	sta	WSYNC

	sta	WSYNC

	;================================
	; draw bottom 10 lines (mirrored)
	;================================
title_bottom_kernel:
; 3
	sta	COLUPF			; playfield color		; 3
; 6
	lda	bottom_title_words_bg_colors,Y					; 4
	sta	COLUBK			; background color		; 3
; 13
	lda	bottom_title_words_playfield0_left,Y	; playfield pattern 0	; 4
	sta	PF0			;				; 3
	;   has to happen by 22 (GPU 68)
; 20
	lda	bottom_title_words_playfield1_left,Y	; playfield pattern 1	; 4
	sta	PF1			;				; 3
	;  has to happen by 28 (GPU 84)
; 34
	lda	bottom_title_words_playfield2_left,Y	; playfield pattern 2	; 4
        sta	PF2							; 3
	;  has to happen by 38 (GPU 116)	;
; 41
	lda	left_sprite,Y
	sta	GRP0

	lda	right_sprite,Y
	sta	GRP1

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC

	iny								; 2
	lda	bottom_title_words_colors,Y					; 4

	cpy	#12		; see if hit end			; 2
	sta	WSYNC
	bne	title_bottom_kernel					; 2/3
; 76



done_draw_title:
; 74


	;===========================
	;===========================
	; overscan (30 cycles)
	;===========================
	;===========================

	ldx	#25
	jsr	common_overscan

	;==================================
	; overscan 27, general stuff
	sta	WSYNC

	;==================================
	; overscan 28, update sound

	sta	WSYNC

	;==================================
	; overscan 29, update frame
	;==================================

	lda	#0
	sta	DONE_SEGMENT

	inc	FRAMEL                                                  ; 5
	bne	no_frame_title_oflo
	inc	FRAMEH
no_frame_title_oflo:
	lda	FRAMEH
	cmp	#$17
	bne	not_done_title
	lda	FRAMEL
        cmp     #$00
	bne	not_done_title
yes_done_title:
	inc	DONE_SEGMENT
not_done_title:
	sta	WSYNC


	;==================================
	;==================================
	; overscan 30, handle button press
	;==================================
	;==================================
; 0
	lda	DONE_SEGMENT
	bne	done_title
; 5
	sta	WSYNC
	jmp	title_frame


cloud_data:
	.byte $00,$7e,$ff,$ff,$7e,$00

done_title:
	sta	WSYNC
