; title screen

.include "../../../vcs.inc"

; zero page addresses

.include "../zp.inc"

.include "../common_routines.inc"
.include "../timing.inc"

	;=======================
        ; title screen
        ;=======================

do_title:

; ? / 24
start_title:

	;=================
	; start VBLANK
	;=================
	; this code takes 4 scanlines, it does a WSYNC soon after
	;	to ensure 3 scanlines total
	; this means it's really stealing one of the previous frame's lines

	jsr	common_vblank
; 9

	;=============================
	;=============================
	; 37 lines of vertical blank
	;=============================
	;=============================


	;=============================
	; scanlines 0..21 (unused)
	;=============================
        ldx     #22
	jsr	repeat_wsync

; 8
	;===============================
	; scanlines 22-33 -- play music
	;===============================
	; takes 11 lines, doesn't WSYNC at end

	lda	#0		; our bank
	jsr	do_play_music
	sta	WSYNC


	;====================
	; now in scanline 34
	;====================
	; increment frame

	jsr	inc_frame
        sta     WSYNC


	;===================
	; now scanline 35
	;===================
	; more init

	lda	#0
	sta	PF0
	sta	PF1
	sta	PF2


	sta	WSYNC


	;=======================
	; scanline 36
	;=======================
	; does nothing

	sta	WSYNC

	;=======================
	; scanline 37 -- config
	;=======================
; 0
	ldy	#0							; 2
	ldx	#0							; 2
	stx	GRP0							; 3
	stx	GRP1							; 3
	stx	CTRLPF			; reset playfield		; 3

; 13
;	lda	#$1E
;	lda	BASE_TITLE_COLOR					; 3
;	sta	TITLE_COLOR						; 3
; 19
;	lda	BACKGROUND_COLOR					; 3
	lda	#$0
	sta	COLUBK							; 3
	sta	VBLANK			; turn on beam			; 3

; 25
	sta	WSYNC



	;=============================================
	;=============================================
	;=============================================
	; draw logo
	;=============================================
	;=============================================
	;=============================================
	; draw 192 lines
	; need to race beam to draw other half of playfield



	;=============================================
	; draw 74 lines of nothing
	;=============================================
	ldx	#74
	jsr	repeat_wsync

; 8
	; clean WSYNC for alignment

	sta	WSYNC

	;=============================================
	; draw 41 lines of logo
	;=============================================



title_loop:
; 0
	lda	#$2E
;	lda	desire1_colors,X	;				; 4
	sta	COLUPF			; set playfield color		; 3
	nop								; 2
	nop								; 2
	nop
; 11
	lda	desire1_playfield0_left,X	;			; 4
	sta	PF0				;			; 3
	nop								; 2

	; must write by CPU 22 [GPU 68]
; 20
	lda	desire1_playfield1_left,X	;			4+
	sta	PF1				;			3
	; must write by CPU 28 [GPU 84]
; 27
	lda	desire1_playfield2_left,X		;			4+
	sta	PF2				;			3
	; must write by CPU 38 [GPU 116]
; 34

	nop					;			2
	lda	desire1_playfield0_right,X	;			4+
	sta	PF0				;			3
	; must write by CPU 49 [GPU 148]
; 43
	lda	desire1_playfield1_right,X	;			4+
	sta	PF1				;			3
	; must write by CPU 54 [GPU 164]
; 50

	lda	$80				; nop3			3
	lda	desire1_playfield2_right,X	;			4+
	sta	PF2				;			3
	; must write by CPU 65 [GPU 196]
; 60

        iny                                                             ; 2
;        tya                                                             ; 2
;        and     #$3                                                     ; 2
;        beq     yes_inx                                                 ; 2/3
;        .byte   $A5     ; begin of LDA ZP                               ; 3
yes_inx:
        inx             ; $E8 should be harmless to load                ; 2
done_inx:
                                                                ;===========
                                                                ; 11/11

	nop
	nop
	lda	$80

; 71
	cpy	#41							; 2
	bne	title_loop						; 2/3

; 76

done_loop:

; 75

	;===================
	; scanline 75+41
	;===================
	; clear playfield

	lda	#0
	sta	PF0
	sta	PF1
	sta	PF2
	sta	WSYNC


	;=============================================
	; draw 75 lines of nothing
	;=============================================
	ldx	#75
	jsr	repeat_wsync


	;==========================
	;==========================
	;==========================
	; overscan for 30 scanlines
	;==========================
	;==========================
	;==========================

	ldx	#29
	jsr	common_overscan						; 10

; 10
	lda	FRAMEL							; 3
	cmp	#TITLE_TIME_L						; 2
	bne	not_done_title						; 2/3
; 17
	lda	FRAMEH							; 3
	cmp	#TITLE_TIME_H						; 2
	beq	done_title						; 2/3

; 21
not_done_title:

	jmp	start_title						; 3
done_title:
; 25
	rts

; 31

.include "checkers.s"

.include "desire_pf.inc"
