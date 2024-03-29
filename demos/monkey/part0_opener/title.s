	;==========================
	; the generic level engine
	;==========================
do_title:

title_frame:
	sta	WSYNC

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

;	ldx	#33
;le_vblank_loop:
;	sta	WSYNC
;	dex
;	bne	le_vblank_loop

	jsr	handle_music


	;=============================
	; now VBLANK scanline 33
	;=============================
	; do some init

	ldx	#$00							; 2
	stx	CURRENT_SCANLINE	; reset scanline counter	; 3

	sta	WSYNC

	;=======================
	; now VBLANK scanline 34
	;=======================

	;====================================================
	; ???
	;====================================================
	; now in setup scanline 0

	sta	WSYNC

	;======================================
	; now vblank 35
	;=======================================
	; update pointer horizontal position
	;=======================================



;jmp	urgh
;.align $100
;urgh:
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
	stx	ENAM0			; disable missile0		; 3
	stx	VDELP0
	stx	VDELP1

	lda	#NUSIZ_QUAD_SIZE					; 2
	sta	NUSIZ0							; 3
	lda	#NUSIZ_QUAD_SIZE					; 2
	sta	NUSIZ1							; 3
; 37
	lda	#CTRLPF_REF	; reflect playfield			; 2
	sta	CTRLPF		;					; 3
	ldy	#0		; current_block

; 44
	lda	title_bg_colors,Y		;			; 3
	sta	COLUBK		; set background color			; 3
; 50
;	lda	level_colors	; load level color in advance		; 4
; 59
	ldx	#0		; init hand visibility			; 2
; 61
	stx	VBLANK		; turn on beam				; 3
; 64

	lda	title_colors,Y						; 4

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
	lda	title_bg_colors,Y					; 4
	sta	COLUBK			; background color		; 3

; 13
	lda	title_playfield0_left,Y	; playfield pattern 0		; 4
	sta	PF0			;				; 3
	;   has to happen by 22 (GPU 68)
; 20
	lda	title_playfield1_left,Y	; playfield pattern 1		; 4
	sta	PF1			;				; 3
	;  has to happen by 28 (GPU 84)

	; really want this to happen by ??

; 34
	lda	title_playfield2_left,Y	; playfield pattern 2		; 4
        sta	PF2							; 3
	;  has to happen by 38 (GPU 116)	;
; 41

; 49

	sta	WSYNC


	;============================
	; draw playfield line 1 (2/4)
	;============================

; 0

	lda	title_overlay1_sprite,Y					; 4
	sta	GRP0			; overlay pattern		; 3
; 7
	lda	title_overlay1_colors,Y					; 4
	sta	COLUP0							; 3
; 14

	lda	title_overlay2_sprite,Y					; 4
	sta	GRP1			; overlay pattern		; 3
; 21
	lda	title_overlay2_colors,Y					; 4
	sta	COLUP1							; 3
; 28


	sta	WSYNC

	; draw playfield line 2 (3/4)
	sta	WSYNC
	; draw playfield line 3 (4/4)

	iny								; 2


	lda	FRAMEH
	cmp	#3
	bcc	skip_check

	cpy	#43		; see if hit end			; 2
	bcs	bottom_words
skip_check:
	lda	title_colors,Y						; 4
	cpy	#48
	sta	WSYNC
	bne	draw_title_scanline					; 2/3
;	beq	totally_done
	jmp	totally_done
; 76

bottom_words:
;	lda	#0
;	sta	COLUPF
;	sta	COLUBK
;
;	sta	PF0
;	sta	PF1
;	sta	PF2
;
;	sta	WSYNC
;
;	ldy	#12
;word_loop:
;	dey
;	sta	WSYNC
;	bne	word_loop

.include "text.s"


done_title_frame:
totally_done:

	;===========================
	;===========================
	; overscan (30 cycles)
	;===========================
	;===========================

	ldx	#27
	jsr	common_overscan


        ;===================================
        ; check for button or RESET
        ;===================================
; 0
        lda     #0
        sta     DONE_SEGMENT

        inc     FRAMEL                                                  ; 5
        bne     no_frame_title_oflo
        inc     FRAMEH
no_frame_title_oflo:

        lda     FRAMEH
        cmp     #5
        bne     not_done_title
        lda     FRAMEL
        cmp     #$80
        bne     not_done_title
yes_done_title:
        inc     DONE_SEGMENT
not_done_title:
	sta	WSYNC

	;==================================
	; overscan 28, update sound

;	sta	WSYNC

	;==================================
	; overscan 29, update pointer

 ;       sta     WSYNC

	;==================================
	;==================================
	; overscan 30, handle button press
	;==================================
	;==================================


	lda	DONE_SEGMENT
	bne	done_title

	sta	WSYNC
	jmp	title_frame

done_title:

	sta	WSYNC
	rts

credits_offset:
        .byte 0,27,17,9,0,0
