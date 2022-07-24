	;====================
	;====================
	;====================
	; Level Playfield
	;====================
	;====================
	;====================

; come in with 0 cycles

	;===============================
	; set up playfield (4 scanlines)
	;===============================

	jmp	blurgh3							; 3
;.align	$100

blurgh3:

	;====================================================
	; set up sprite1 (secret) to be at proper X position
	;====================================================
	; now in setup scanline 0

	; we can do this here and the sprite will be drawn as a long
	; vertical column
	; later we only enable it for the lines we want
; 3
	ldx	#0		; sprite 0 display nothing		2
	stx	GRP1		; (FIXME: this already set?)		3
; 8
	ldx	SECRET_X_COARSE	;					3
	inx			;					2
	inx			;					2
qpad_x:
	dex			;					2
	bne	qpad_x		;					2/3
				;===========================================
				;	12-1+5*(coarse_x+2)

	; beam is at proper place
	sta	RESP1							; 3
	sta	RESBL

	lda	SECRET_X_FINE
	sta	HMP1

	sta	WSYNC

	;=======================================================
	; set up sprite0 (strongbad)  to be at proper X position
	;=======================================================
	; now in setup scanline 1
; 0
	; we can do this here and the sprite will be drawn as a long
	; vertical column
	; later we only enable it for the lines we want

	ldx	a:STRONGBAD_X_COARSE	; force 4-cycle version		; 4

	cpx	#$A							; 2
	bcs	far_right	; bge					; 2/3

; 8
	inx			;					; 2
	inx			;					; 2
; 12 (want to be 12 here)

pad_x:
	dex			;					2
	bne	pad_x		;					2/3
				;===========================================
				;	5*(coarse_x+2)-1
				; MAX is 9, so up to 54
; up to 66
	; beam is at proper place
	sta	RESP0							; 3
; up to 69
	sta	WSYNC							; 3
; up to 72
	jmp	done_done						; 3

	; special case for when COARSE_X = 10
	; won't fit with standard loop above
far_right:
; 9
	ldx	#11							; 2
; 11
fpad_x:
	dex			;					; 2
	bne	fpad_x		;					; 2/3
				; (5*X)-1 = 54
; 65
	nop								; 2
	nop								; 2
	nop								; 2

; 71
	sta	RESP0							; 3
; 74
	nop
; 76

done_done:

	;==========================================
	; Hack for the HMOVE timing
	;==========================================
	; now in setup scanline two

; 0/3

	sta	WSYNC
	sta	HMOVE


	;==========================================
	; Final setup before going
	;==========================================
	; now in setup scanline 3
; 3 (from HMOVE)
	ldx	#28			; current scanline?		; 2

	lda	#$0							; 2
	sta	PF0			; disable playfield		; 3
	sta	PF1							; 3
	sta	PF2							; 3

	lda	#$C2			; green				; 2
	sta	COLUPF			; playfield color		; 3

	lda	#CTRLPF_REF|CTRLPF_BALL_SIZE2				; 2
					; reflect playfield
	sta	CTRLPF							; 3
								;===========
								;        23
; 26
	; Set up sprite data

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
	tay			; X=current block			; 2
								;============
								;	28
; 54
	sta	CXCLR	; clear collisions				; 3
; 57

	lda	(PF0_ZPL),Y		; preload PF0 value into A	; 5+

	sta	WSYNC							; 3
; 65

	;===========================================
	;===========================================
	;===========================================
	; draw playfield, 192-28-12 = 152 scanlines (38 4-line blocks)
	;===========================================
	;===========================================
	;===========================================

draw_playfield:

draw_playfield_even:

	;===================
	; draw playfield
	;===================
	; PF0 value should be in A here

; 0
	sta	PF0							; 3
	;   has to happen by 22
; 3
        lda	(PF1_ZPL),Y		;				; 5+
        sta	PF1			;				; 3
	;  has to happen by 31
; 11

	; draw blue zap if in range

	lda	ZAP_COLOR	; blue					; 3
	cpy	#9							; 2
	bcc	huge_hack						; 2/3
	cpy	#29							; 2
	bcc	yes_blue						; 2/3
not_blue:
	.byte	$2C	; bit trick, 4 cycles
yes_blue:
	sta	COLUPF							; 3


							;==================
							; 15 / 15 /15
; 26

	;  has to happen by ??
        lda	(PF2_ZPL),Y		;				; 5
        sta	PF2			;				; 3
	; has to happen by 33?

; 34

	;==============================
	; activate secret sprite

	; X = current scanline
	lda	#$F0			; load sprite data		; 2
	cpx	SECRET_Y_END						; 3
	bcs	turn_off_secret_delay5					; 2/3
	cpx	SECRET_Y_START						; 3
	bcc	turn_off_secret						; 2/3
turn_on_secret:
	sta	SECRET_ON
	jmp	after_secret						; 3
turn_off_secret_delay5:
	lda	$80			; nop3				; 2
	nop								; 2
turn_off_secret:
	lda	#0			; turn off sprite		; 2
	sta	SECRET_ON
after_secret:
								;============
								; 18 / 18 / 18

; 52
	inc	ZAP_COLOR	; increment color			; 5
	lda	ZAP_COLOR						; 3
	and	#$9F		; keep in $80-$90 range			; 2
	sta	ZAP_COLOR						; 3
; 65

	nop								; 2
; 67

	; turn playfield back to green for edge
	; this needs to happen before cycle 70
	lda	#$C2		; green					; 2
	sta	COLUPF							; 3
; 72

	inx								; 2

; 74


	;=============================================
	;=============================================
	;=============================================
	; draw playfield odd
	;=============================================
	;=============================================
	;=============================================


draw_playfield_odd:

	;===================
	; draw playfield
; -2

	; enable secret if it's visible

	lda	STRONGBAD_ON				; 3
	sta	GRP0					; 3
	lda	SECRET_ON				; 3
	sta	a:GRP1					; 4

; 11

	;=======================
	; set bad stuff to blue
	; really want this to start at least cycle 10

	lda	ZAP_COLOR	; blue					; 3
	cpy	#9							; 2
	bcc	huge_hack2						; 2/3
	cpy	#29							; 2
	bcc	oyes_blue						; 2/3
onot_blue:
	.byte	$2C	; bit trick, 4 cycles
oyes_blue:
	sta	COLUPF							; 3


								;==========
								; 15 / 15 /15

	; has to happen by 30-3 but after 24-3

; 26


	; activate strongbad sprite if necessary
	lda	#$F0			; load sprite data		; 2
	; X = current scanline
	cpx	STRONGBAD_Y_END						; 3
	bcs	turn_off_strongbad_delay5				; 2/3
	cpx	STRONGBAD_Y						; 3
	bcc	turn_off_strongbad					; 2/3
turn_on_strongbad:
;	sta	GRP0			; and display it		; 3
	sta	STRONGBAD_ON
	jmp	after_sprite						; 3
turn_off_strongbad_delay5:
	inc	TEMP1							; 5
turn_off_strongbad:
	lda	#0			; turn off sprite		; 2
update_sprite:
;	sta	GRP0							; 3
	sta	STRONGBAD_ON
after_sprite:
								;============
								; 13 / 18 / 18
								; 18 / 18 / 18

; 44

	inx								; 2
	txa								; 2
	and	#$3							; 2
	beq	yes_inc4						; 2/3
	.byte	$A5     ; begin of LDA ZP				; 3
yes_inc4:
	iny             ; $E8 should be harmless to load		; 2
done_inc_block:
                                                                ;===========
                                                                ; 11/11

; 55
	lda	(PF0_ZPL),Y	; get playfield for next		; 5+
	sta	TEMP1		; store temporarily			; 3

; 63

	; this needs to happen before cycle 70
	lda	#$C2		; restore green wall			; 2
	sta	COLUPF							; 3
; 68

	lda	TEMP1		; restore playfield to A		; 3
	cpx	#168		; see if hit end			; 2
	bne	draw_playfield						; 2/3
done_playfield:
; 76

; 75
	jmp	skip

huge_hack:
	jmp	not_blue
huge_hack2:
	jmp	onot_blue

skip:
; 78



draw_playfield_bonus:

	;=================================================
	; draw playfield bonus (168-176)
	;=================================================
	; draw 8 lines at bottom, where bonus appears

; 2/3
	; enable secret if it's visible

	lda	STRONGBAD_ON				; 3
	sta	GRP0					; 3
	lda	SECRET_ON				; 3
	sta	GRP1					; 3
	lda	BALL_ON
	sta	ENABL
; 15

	lda	#$82		; blue ball		; 2
	sta	COLUPF		;			; 3

; 25

	; activate strongbad sprite if necessary
	lda	#$F0			; load sprite data		; 2
	; X = current scanline
	cpx	STRONGBAD_Y_END						; 3
	bcs	turn_off_strongbad2_delay5				; 2/3
	cpx	STRONGBAD_Y						; 3
	bcc	turn_off_strongbad2					; 2/3
turn_on_strongbad2:
;	sta	GRP0			; and display it		; 3
	sta	STRONGBAD_ON
	jmp	after_sprite2						; 3
turn_off_strongbad2_delay5:
	inc	TEMP1							; 5
turn_off_strongbad2:
	lda	#0			; turn off sprite		; 2
update_sprite2:
;	sta	GRP0							; 3
	sta	STRONGBAD_ON
after_sprite2:
								;============
								; 13 / 18 / 18
								; 18 / 18 / 18

; 43

	;==============================
	; activate secret sprite

	; X = current scanline
	lda	#$F0			; load sprite data		; 2
	cpx	SECRET_Y_END						; 3
	bcs	turn_off_secret2_delay5					; 2/3
	cpx	SECRET_Y_START						; 3
	bcc	turn_off_secret2						; 2/3
turn_on_secret2:
	sta	SECRET_ON
	jmp	after_secret2						; 3
turn_off_secret2_delay5:
	lda	$80			; nop3				; 2
	nop								; 2
turn_off_secret2:
	lda	#0			; turn off sprite		; 2
	sta	SECRET_ON
after_secret2:
								;============
								; 18 / 18 / 18


	; this needs to happen before cycle 70
	lda	#$C2		; restore green wall			; 2
	sta	COLUPF							; 3

	inx								; 2
	cpx	#176		; see if hit end			; 2
	sta	WSYNC
	bne	draw_playfield_bonus					; 2/3_bonus


	;=========================
	; 176 - 180
	;=========================
	; draw bottom 4 lines
	; FIXME: collision detection on bottom is weird

draw_bottom:
	lda	#$F0
	sta	PF0
	lda	#$FF
	sta	PF1
	lda	#$FF
	sta	PF2
	lda	#0
	sta	ENABL

	inx
	cpx	#180
	sta	WSYNC
	bne	draw_bottom

; 2
