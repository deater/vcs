	; Level 1 Playfield


	;===============================
	; set up playfield (4 scanlines)
	;===============================

	jmp	blurgh3
.align	$100

blurgh3:

	; now in setup scanline 0
	; WE CAN DO STUFF HERE


	;==========================================
	; set up sprite1 to be at proper X position
	;==========================================
	; now in setup scanline 0

	; we can do this here and the sprite will be drawn as a long
	; vertical column
	; later we only enable it for the lines we want
; 3
	ldx	#0		; sprite 0 display nothing		2
	stx	GRP1		; (FIXME: this already set?)		3
; 8
	ldx	#6		;					3
	inx			;					2
	inx			;					2
qpad_x:
	dex			;					2
	bne	qpad_x		;					2/3
				;===========================================
				;	12-1+5*(coarse_x+2)
				; FIXME: describe better what's going on

	; beam is at proper place
	sta	RESP1							; 3


	sta	WSYNC

	;=======================================
	; update strongbad horizontal position
	;=======================================
	; now in setup scanline 1

	; do this separately as too long to fit in with left/right code

	jsr	spr0_moved_horizontally	;				6+49
	sta	WSYNC			;				3
					;====================================
					;				58

	;==========================================
	; set up sprite to be at proper X position
	;==========================================
	; now in setup scanline 2

	; we can do this here and the sprite will be drawn as a long
	; vertical column
	; later we only enable it for the lines we want

	ldx	#0		; sprite 0 display nothing		2
	stx	GRP0		; (FIXME: this already set?)		3

	ldx	STRONGBAD_X_COARSE	;				3
	inx			;					2
	inx			;					2
pad_x:
	dex			;					2
	bne	pad_x		;					2/3
				;===========================================
				;	12-1+5*(coarse_x+2)
				; FIXME: describe better what's going on

	; beam is at proper place
	sta	RESP0							; 3

	lda	#$0							; 2
	sta	PF0			; disable playfield		; 3
	sta	PF1							; 3
	sta	PF2							; 3


	sta	WSYNC							; 3
	sta	HMOVE		; adjust fine tune, must be after WSYNC	; 3
				; also draws black artifact on left of
				; screen


	;==========================================
	; Final setup before going
	;==========================================
	; now in setup scanline 3
; 3 (from HMOVE)
	ldy	#28							; 2


	lda	#$C2			; green				; 2
	sta	COLUPF			; playfield color		; 3

	lda	#CTRLPF_REF		; reflect playfield		; 2
	sta	CTRLPF							; 3
								;===========
								;        23
; 26
	; reset back to strongbad sprite

	lda	#$40		; dark red				; 2
	sta	COLUP0		; set strongbad color (sprite0)		; 3

	lda	#$1E		; yellow				; 2
	sta	COLUP1		; set secret color (sprite1)		; 3

	lda	#NUSIZ_ONE_COPY						; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1							; 3

	lda	#0							; 2
	sta	VDELP0							; 3
	sta	VDELP1							; 3
	tax			; X=current block			; 2
								;============
								;	28
; 54
	; update zap color
	; FIXME: slow this down?
	inc	ZAP_COLOR						; 5
	lda	ZAP_COLOR						; 3
	cmp	#$A0							; 2
	bcc	zap_ok							; 2/3
	lda	#$80							; 2
	sta	ZAP_COLOR						; 3
zap_ok:
								;============
								; 17 worse case
; 71
	sta	CXCLR	; clear collisions				; 3
; 74

	sta	WSYNC							; 3
								;============
								;============
								;	77

	;===========================================
	;===========================================
	;===========================================
	; draw playfield, 192-28-12 = 152 scanlines (38 4-line blocks)
	;===========================================
	;===========================================
	;===========================================

draw_playfield:


draw_playfield_even:
	;=============================================
	; we get 23 cycles in HBLANK, use them wisely

; 0
	;===================
	; draw playfield

	lda	playfield0_left,X	;				; 4+
        sta	PF0			;				; 3
	;   has to happen by 22
; 7

        lda	playfield1_left,X	;				; 4+
        sta	PF1			;				; 3
	;  has to happen by 31
; 14


	;=======================
	; set bad stuff to blue

	cpx	#9							; 2
	bcc	not_blue_waste12					; 2/3
	cpx	#29							; 2
	bcs	not_blue_waste8						; 2/3
	lda	ZAP_COLOR	; blue					; 3
	sta	COLUPF							; 3
	jmp	done_blue						; 3
not_blue_waste12:
	nop
	nop
not_blue_waste8:
	nop
	nop
	nop
	nop
done_blue:
								;============
								;  5 / 9 / 17

	; has to happen by 30-3
; 31

	;  has to happen by
        lda	playfield2_left,X	;				; 4+
        sta	PF2			;				; 3
	; has to happen by 42
; 38

	;==============================
	; activate secret sprite

	; Y = current scanline
	lda	#$F0			; load sprite data		; 2
	cpy	#80							; 2
	bcs	turn_off_secret_delay4					; 2/3
	cpy	#72							; 2
	bcc	turn_off_secret						; 2/3
turn_on_secret:
	sta	GRP1			; and display it		; 3
	jmp	after_secret						; 3
turn_off_secret_delay4:
	nop								; 2
	nop								; 2
turn_off_secret:
	lda	#0			; turn off sprite		; 2
	sta	GRP1							; 3
after_secret:
								;============
								; 12 / 16 / 16

; 54
	inc	TEMP1							; 5
	nop								; 2
; 61


	iny								; 2

; 63


	; this needs to happen before cycle 70
	lda	#$C2							; 2
	sta	COLUPF							; 3

; 68

	inc	TEMP1	; nop5						; 5
	lda	TEMP1	; nop3						; 3

; 76

	;=============================================
	;=============================================
	;=============================================
	; draw playfield odd
	;=============================================
	;=============================================
	;=============================================


draw_playfield_odd:
	;=============================================
	; we get 23 cycles in HBLANK, use them wisely

	;===================
	; draw playfield

	inc	TEMP1					; 5
	inc	TEMP1					; 5
	nop						; 2
						;============
						;	12
; 23

	;=======================
	; set bad stuff to blue

	cpx	#9							; 2
	bcc	onot_blue_waste12					; 2/3
	cpx	#29							; 2
	bcs	onot_blue_waste8					; 2/3
	lda	ZAP_COLOR	; blue					; 3
	sta	COLUPF							; 3
	jmp	odone_blue						; 3
onot_blue_waste12:
	nop								; 2
	nop								; 2
onot_blue_waste8:
	nop								; 2
	nop								; 2
	nop								; 2
	nop								; 2
odone_blue:
								;============
								;  5 / 9 / 17

	; has to happen by 30-3 but after 24-3

; 29

	; activate strongbad sprite if necessary

	; Y = current scanline
	lda	#$F0			; load sprite data		; 2
	cpy	STRONGBAD_END_Y						; 3
	bcs	turn_off_strongbad_delay5				; 2/3
	cpy	STRONGBAD_Y						; 3
	bcc	turn_off_strongbad					; 2/3
turn_on_strongbad:
	sta	GRP0			; and display it		; 3
	jmp	after_sprite						; 3
turn_off_strongbad_delay5:
	inc	TEMP1							; 5
turn_off_strongbad:
	lda	#0			; turn off sprite		; 2
	sta	GRP0							; 3
after_sprite:
								;============
								; 13 / 18 / 18

; 47

	nop								; 2
	nop								; 2


; 51

	iny			; increase scanline			; 2
	tya			; see if multiple of 4			; 2
	and	#$3							; 2
	bne	no_inc_block						; 2/3
yes_inc4:
	inx			; increment block			; 2
	jmp	done_inc_block						; 3
no_inc_block:
	nop								; 2
	nop								; 2
done_inc_block:
								;===========
								; 13 / 13

; 64

	; this needs to happen before cycle 70
	lda	#$C2		; restore green wall			; 2
	sta	COLUPF							; 3
	cpy	#180		; see if hit end			; 2
	bcs	done_playfield						; 2/3
	jmp	draw_playfield						; 3
done_playfield:
								;=============
								; 12 / 12

; 76
