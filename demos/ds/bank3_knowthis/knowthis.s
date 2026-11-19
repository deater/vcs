	;==========================
	; knowthis screen
	;==========================
	; ideally VBLANK=2 (beam off)


start_knowthis:

	;=================
	; start VBLANK
	;=================
	; this takes 4 scalines

	jsr	common_vblank

; 9

	;=============================
	;=============================
	;=============================
	; 37 lines of vertical blank
	;=============================
	;=============================
	;=============================


	;================================
	; scanlines 0..20 unused
	;================================

        ldx     #19
	jsr	repeat_wsync

	;================================
	; play music -- scanlines 21..31
	;================================
	; takes 11 lines?

	lda	#3		; our bank
	jsr	do_play_music
	sta	WSYNC

	;====================
	; now in scanline 32
	;====================
	jsr	inc_frame		; 48

	lda	#$aa
	sta	GRP0			; sprite 0

;	lda	#$1e
;	sta	COLUP0

	lda	#NUSIZ_DOUBLE_SIZE
	sta	NUSIZ0

        sta     WSYNC


	;=======================
	; now scanline 33/34/35
	;=======================

	lda	#119
	ldx	#0			; sprite 0
	jsr	set_pos_x

	sta	WSYNC
	sta	HMOVE


	;=======================
	; scanline 36

	sta	WSYNC

	;=======================
	; scanline 37 -- config
; 0
	ldy	#0							; 2
	ldx	#0							; 2
	stx	VBLANK			; turn on beam			; 3
	stx	PF0
	stx	PF1
	stx	PF2

	stx	GRP0							; 3
	stx	GRP1							; 3
	stx	CTRLPF			; reset playfield


	lda	FRAMEL
	lsr
	lsr
	lsr
	lsr
	and	#$7
	tax
	lda	bg_range,X
	sta	COLUBK							; 3

	ldx	#0

	sta	WSYNC





	;=============================================
	;=============================================
	; draw title
	;=============================================
	;=============================================
	; draw 192 lines
	; need to race beam to draw other half of playfield
	; split across 2

title_loop:

; 0
	lda	ikt_colors,X	;					; 4
	sta	COLUPF		; set playfield color			; 3
	nop								; 2
	nop								; 2
	nop								; 2
; 13
	lda	ikt_playfield0_left,X		;			; 4
	sta	PF0				;			; 3

	; must write by CPU 22 [GPU 68]
; 20
	lda	ikt_playfield1_left,X		;			4+
	sta	PF1				;			3
	; must write by CPU 28 [GPU 84]
; 27
	lda	ikt_playfield2_left,X		;			4+
	sta	PF2				;			3
	; must write by CPU 38 [GPU 116]
; 34

	nop					;			2
	lda	ikt_playfield0_right,X	;			4+
	sta	PF0				;			3
	; must write by CPU 49 [GPU 148]
; 43
	lda	ikt_playfield1_right,X	;			4+
	sta	PF1				;			3
	; must write by CPU 54 [GPU 164]
; 50

	lda	$80				; nop3			3
	lda	ikt_playfield2_right,X	;			4+
	sta	PF2				;			3
	; must write by CPU 65 [GPU 196]
; 60

	lda	ikt_face_overlay_colors,X				; 4
	sta	COLUP0							; 3
; 67
	ldy	ikt_face_overlay_sprite,X				; 4






	sta	WSYNC

; 76

	; line 2


; 0
	lda	ikt_colors,X	;					; 4
	sta	COLUPF		; set playfield color			; 3
	sty	GRP0							; 3

	lda	$80		; nop3
;	nop								; 2
;	nop								; 2
;	nop								; 2
; 13
	lda	ikt_playfield0_left,X		;			; 4
	sta	PF0				;			; 3


	; must write by CPU 22 [GPU 68]
; 20
	lda	ikt_playfield1_left,X		;			4+
	sta	PF1				;			3
	; must write by CPU 28 [GPU 84]
; 27
	lda	ikt_playfield2_left,X		;			4+
	sta	PF2				;			3
	; must write by CPU 38 [GPU 116]
; 34

	nop					;			2
	lda	ikt_playfield0_right,X	;			4+
	sta	PF0				;			3
	; must write by CPU 49 [GPU 148]
; 43
	lda	ikt_playfield1_right,X	;			4+
	sta	PF1				;			3
	; must write by CPU 54 [GPU 164]
; 50

	lda	$80				; nop3			3
	lda	ikt_playfield2_right,X	;			4+
	sta	PF2				;			3
	; must write by CPU 65 [GPU 196]
; 60
;	lda	$80	; nop3
;	lda	$80	; nop3
;	lda	$80	; nop3

	nop
	nop

	lda	#168			; 2
	sta	COLUPF			; 3


; 69
        inx								; 2
	cpx	#(96)							; 2
	bne	title_loop						; 2/3

; 76


done_loop:

; 75

	;==========================
	; overscan for 30 scanlines
	;==========================

	ldx	#29
	jsr	common_overscan

	lda	FRAMEL
	cmp	#KNOWTHIS_TIME_L
	bne	not_done_knowthis
	lda     FRAMEH
	cmp     #KNOWTHIS_TIME_H
	beq     done_knowthis
not_done_knowthis:
	jmp	start_knowthis						; 3
; 18

done_knowthis:
; 16
	rts


.include "knowthis_pf.inc"
.include "ikt_face.inc"

bg_range:
;	.byte 0,0,112,0,0,224,0,0
	.byte 0,0,0,0,0,0,0,0
