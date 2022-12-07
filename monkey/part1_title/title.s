	;==========================
	; Draw the title screen
	;==========================
	; asymmetric playfield
	; TODO: cloud at top?
	; descender on the I?

do_title:

title_frame:

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


	;=============================
	; now VBLANK scanline 33
	;=============================
	; do some init

	inc	FRAMEL							; 5

	ldx	#$00							; 2
	stx	CURRENT_SCANLINE	; reset scanline counter	; 3

	sta	WSYNC

	;=======================
	; now VBLANK scanline 34
	;=======================

	;====================================================
	; set up sprite1 (overlay) to be at proper X position
	;====================================================
	; now in setup scanline 0

.if 0
; 0
	nop								; 2
	nop								; 2
; 4
;	ldx	LEVEL_OVERLAY_COARSE					; 3
	inx			;					; 2
	inx			;					; 2
; 11
qpad_x:
	dex			;					; 2
	bne	qpad_x		;					; 2/3
				;===========================================
				;	(5*COASRE+2)-1

	; beam is at proper place
	sta	RESP0							; 3
	sta	RESP1							; 3

	lda	#$0			; fine adjust overlay		; 2
	sta	HMP0							; 3
	sta	HMP1							; 3
.endif

	sta	WSYNC

	;======================================
	; now vblank 35
	;=======================================
	; update pointer horizontal position
	;=======================================

	sta	WSYNC			;				3


	;=========================================
	; now vblank 36
	;==========================================
	; set up sprite0 to be at proper X position
	;==========================================
; 0
	ldx	#2
	inx			;					; 2
	inx			;					; 2
; 12

pad_x:
	dex			;					; 2
	bne	pad_x		;					; 2/3
				;===========================================
				;	12-1+5*(coarse_x+2)
;

	; beam is at proper place
	sta	RESP0							; 3
	nop
	nop
	lda	$80
	sta	RESP1							; 3

	lda	#$0			; fine adjust overlay		; 2
	sta	HMP0							; 3
	sta	HMP1							; 3

	sta	WSYNC							; 3
	sta	HMOVE		; adjust fine tune, must be after WSYNC	; 3
				; also draws black artifact on left of
				; screen

	;==========================================
	; now vblank 37
	;==========================================
	; Final setup before going
	;==========================================

; 3 (from HMOVE)

	ldx	#0			; current scanline?		; 2
	stx	PF0			; disable playfield		; 3
	stx	PF1							; 3
	stx	PF2							; 3


	lda	#NUSIZ_QUAD_SIZE					; 2
	sta	NUSIZ0							; 3
	lda	#NUSIZ_QUAD_SIZE					; 2
	sta	NUSIZ1							; 3
; 37
	lda	#CTRLPF_REF	; reflect playfield			; 2
	sta	CTRLPF		;					; 3
	ldy	#0		; current_block

; 44
	lda	title_words_bg_colors,Y		;			; 3
	sta	COLUBK		; set background color			; 3
; 50
;	lda	level_colors	; load level color in advance		; 4
; 59
	ldx	#0		; init hand visibility			; 2
; 61
	stx	VBLANK		; turn on beam				; 3
; 64

	lda	title_words_colors,Y						; 4

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

	; A has level colors

	;============================
	; draw playfield line 0 (1/4)
	;============================
; 3
	sta	COLUPF			; playfield color		; 3
; 6
	lda	title_words_bg_colors,Y					; 4
	sta	COLUBK			; background color		; 3

; 13
	lda	title_words_playfield0_left,Y	; playfield pattern 0		; 4
	sta	PF0			;				; 3
	;   has to happen by 22 (GPU 68)
; 20
	lda	title_words_playfield1_left,Y	; playfield pattern 1		; 4
	sta	PF1			;				; 3
	;  has to happen by 28 (GPU 84)

	; really want this to happen by ??

; 34
	lda	title_words_playfield2_left,Y	; playfield pattern 2		; 4
        sta	PF2							; 3
	;  has to happen by 38 (GPU 116)	;
; 41

; 49

	sta	WSYNC


	;============================
	; draw playfield line 1 (2/4)
	;============================

; 0

;	lda	title_overlay1_sprite,Y					; 4
;	sta	GRP0			; overlay pattern		; 3
; 7
;	lda	title_overlay1_colors,Y					; 4
;	sta	COLUP0							; 3
; 14

;	lda	title_overlay2_sprite,Y					; 4
;	sta	GRP1			; overlay pattern		; 3
; 21
;	lda	title_overlay2_colors,Y					; 4
;	sta	COLUP1							; 3
; 28


	sta	WSYNC

	;============================
	; draw playfield line 2 (3/4)
	;============================

	sta	WSYNC




	;=============================
	; draw playfield line 3 (4/4)
	;=============================

	iny								; 2
	lda	title_words_colors,Y						; 4

	cpy	#48		; see if hit end			; 2
	sta	WSYNC
	bne	draw_title_scanline					; 2/3
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
	cmp	#$28
	bne	not_done_title
	lda	FRAMEL
        cmp     #$80
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

	sta	WSYNC
	jmp	title_frame
done_title:
