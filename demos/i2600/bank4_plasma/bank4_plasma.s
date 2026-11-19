; e7 plasma?

.include "../../../vcs.inc"

; zero page addresses

.include "../zp.inc"

.include "../common_routines.inc"
.include "../timing.inc"


line1 = $1900
line2 = $1932
line3 = $1964
line4 = $1996
line5 = $19C8

	;=======================
        ; plasma
        ;=======================
do_plasma:

.include "frame1_init.s"

	;==========================
	; plasma screen
	;==========================
	; ideally VBLANK=2 (beam off)
	; takes 4 scanlines total

start_plasma:


	;=================
	; start VBLANK
	;=================
	; want to come in 1 scanline down
	; as this finishes old then does 3 for VSYNC

	jsr	common_vblank

; 9

	;=============================
	; 37 lines of vertical blank
	;=============================

        ldx     #23
	jsr	repeat_wsync

	;================================
	; play music -- scanlines 24..35
	;================================
	; takes 11 lines?

	lda	#4		; our bank
	jsr	do_play_music

	;====================
	; now in scanline 34
	;====================
	jsr	inc_frame
        sta     WSYNC

	;====================
	; now in scanline 35
	;====================
	; set up sierpinski


	lda	FRAMEL
	lsr
	lsr
	lsr

	sta	YY

	lda	FRAMEH
	sta	EXTRACOL

        sta     WSYNC
	;====================
	; now in scanline 36
	;====================

; goal

; 0         1         2         3
; 0123456789012345678901234567890123456789
; PPPPKKKK11112222KKKKPPPPKKKK11112222KKKK


	; setup playfield

	lda	#CTRLPF_REF			; reflecting playfield
;	lda	#CTRLPF_BALL_SIZE8
	sta	CTRLPF

	lda	#$1e				; clolor yellow?
	sta	COLUPF

	lda	#$C0				; to fit above
	sta	PF0
	lda	#$ff
	sta	PF2
	sta	PF1

	lda	#$0
	sta	COLUBK

	; set up missiles?

	lda	#NUSIZ_MISSILE_WIDTH_8
	sta	NUSIZ0
	sta	NUSIZ1

        sta     WSYNC

	;====================
	; now in scanline 37
	;====================

	ldx	#192

	lda	#0
	sta	COLUPF
	sta	VBLANK

        sta     WSYNC


	;======================================
	; playfield
	;======================================

	ldx	#15
	jsr	repeat_wsync


	sta	WSYNC

	; 20 blocks tall, each 8 lines so 160

plasma_loop:
	sta	E7_SET_256_BANK0					; 4
	jsr	line1+2		; skip 4 cycles
	jsr	line1
	jsr	line1
	jsr	line1
	jsr	line1
	jsr	line1
	jsr	line1
	jsr	line1

	jsr	line2
	jsr	line2
	jsr	line2
	jsr	line2
	jsr	line2
	jsr	line2
	jsr	line2
	jsr	line2

	jsr	line3
	jsr	line3
	jsr	line3
	jsr	line3
	jsr	line3
	jsr	line3
	jsr	line3
	jsr	line3

	jsr	line4
	jsr	line4
	jsr	line4
	jsr	line4
	jsr	line4
	jsr	line4
	jsr	line4
	jsr	line4

	jsr	line5
	jsr	line5
	jsr	line5
	jsr	line5
	jsr	line5
	jsr	line5
	jsr	line5
	jsr	line5

	sta	E7_SET_256_BANK1					; 4

	jsr	line1+2		; skip 4 cycles
	jsr	line1
	jsr	line1
	jsr	line1
	jsr	line1
	jsr	line1
	jsr	line1
	jsr	line1

	jsr	line2
	jsr	line2
	jsr	line2
	jsr	line2
	jsr	line2
	jsr	line2
	jsr	line2
	jsr	line2

	jsr	line3
	jsr	line3
	jsr	line3
	jsr	line3
	jsr	line3
	jsr	line3
	jsr	line3
	jsr	line3

	jsr	line4
	jsr	line4
	jsr	line4
	jsr	line4
	jsr	line4
	jsr	line4
	jsr	line4
	jsr	line4

	jsr	line5
	jsr	line5
	jsr	line5
	jsr	line5
	jsr	line5
	jsr	line5
	jsr	line5
	jsr	line5

	sta	E7_SET_256_BANK2					; 4

	jsr	line1+2		; skip 4 cycles
	jsr	line1
	jsr	line1
	jsr	line1
	jsr	line1
	jsr	line1
	jsr	line1
	jsr	line1

	jsr	line2
	jsr	line2
	jsr	line2
	jsr	line2
	jsr	line2
	jsr	line2
	jsr	line2
	jsr	line2

	jsr	line3
	jsr	line3
	jsr	line3
	jsr	line3
	jsr	line3
	jsr	line3
	jsr	line3
	jsr	line3

	jsr	line4
	jsr	line4
	jsr	line4
	jsr	line4
	jsr	line4
	jsr	line4
	jsr	line4
	jsr	line4

	jsr	line5
	jsr	line5
	jsr	line5
	jsr	line5
	jsr	line5
	jsr	line5
	jsr	line5
	jsr	line5

	lda	#0
	sta	COLUPF
	sta	WSYNC

	ldx	#6
	jsr	repeat_wsync

	ldx	#0
	jsr	sierpinski_third

	ldx	#1
	jsr	sierpinski_third


	;==========================
	; overscan for 30 scanlines
	;==========================

	ldx	#5
	jsr	common_overscan

	;========================
	;
	;========================
	;

	ldx	#2
	jsr	sierpinski_third

	sta	WSYNC

	lda	FRAMEL
	cmp	#PLASMA_TIME_L
	bne	not_done_plasma
	lda	FRAMEH
	cmp	#PLASMA_TIME_H
	beq	done_plasma

not_done_plasma:
	jmp	start_plasma						; 3
; 18

done_plasma:
; 16



	rts

;================================================================
;================================================================
;================================================================
;================================================================
;================================================================


.if 0
; comes in 6 cycles in
line6:
; 6
	lda	$80	; 3
	lda	$80	; 3
	lda	$80	; 3
	nop		; 2
	nop		; 2


; 19

	; want to wait until 22.66 cpu clocks?
							; cpu pixel pf 
	lda	#$5e					; 2
	sta	COLUPF					; 3	15  3.75
	lda	#$6e					; 2
	sta	COLUPF					; 3	30  7.5
	lda	#$7e					; 2
	sta	COLUPF					; 3	45  
	lda	#$8e					; 2
	sta	COLUPF					; 3	60
	lda	#$9e					; 2
	sta	COLUPF					; 3	75
	lda	#$ae					; 2
	sta	COLUPF					; 3	90
	lda	#$be
	sta	COLUPF
	lda	#$ce
	sta	COLUPF
	lda	#$de
	sta	COLUPF
	lda	#$ee
	sta	a:COLUPF

; 70
	rts
; 6

; comes in 6 cycles in
line7:
; 6
	lda	$80	; 3
	lda	$80	; 3
	lda	$80	; 3
	nop		; 2
	nop		; 2


; 19

	; want to wait until 22.66 cpu clocks?
							; cpu pixel pf 
	lda	#$6e					; 2
	sta	COLUPF					; 3	15  3.75
	lda	#$7e					; 2
	sta	COLUPF					; 3	30  7.5
	lda	#$8e					; 2
	sta	COLUPF					; 3	45  
	lda	#$9e					; 2
	sta	COLUPF					; 3	60
	lda	#$ae					; 2
	sta	COLUPF					; 3	75
	lda	#$be					; 2
	sta	COLUPF					; 3	90
	lda	#$ce
	sta	COLUPF
	lda	#$de
	sta	COLUPF
	lda	#$ee
	sta	COLUPF
	lda	#$fe
	sta	a:COLUPF

; 70
	rts
; 6

; comes in 6 cycles in
line8:
; 6
	lda	$80	; 3
	lda	$80	; 3
	lda	$80	; 3
	nop		; 2
	nop		; 2


; 19

	; want to wait until 22.66 cpu clocks?
							; cpu pixel pf 
	lda	#$7e					; 2
	sta	COLUPF					; 3	15  3.75
	lda	#$8e					; 2
	sta	COLUPF					; 3	30  7.5
	lda	#$9e					; 2
	sta	COLUPF					; 3	45  
	lda	#$ae					; 2
	sta	COLUPF					; 3	60
	lda	#$be					; 2
	sta	COLUPF					; 3	75
	lda	#$ce					; 2
	sta	COLUPF					; 3	90
	lda	#$de
	sta	COLUPF
	lda	#$ee
	sta	COLUPF
	lda	#$0e
	sta	COLUPF
	lda	#$1e
	sta	a:COLUPF

; 70
	rts
; 6

; comes in 6 cycles in
line9:
; 6
	lda	$80	; 3
	lda	$80	; 3
	lda	$80	; 3
	nop		; 2
	nop		; 2


; 19

	; want to wait until 22.66 cpu clocks?
							; cpu pixel pf 
	lda	#$8e					; 2
	sta	COLUPF					; 3	15  3.75
	lda	#$9e					; 2
	sta	COLUPF					; 3	30  7.5
	lda	#$ae					; 2
	sta	COLUPF					; 3	45  
	lda	#$be					; 2
	sta	COLUPF					; 3	60
	lda	#$ce					; 2
	sta	COLUPF					; 3	75
	lda	#$de					; 2
	sta	COLUPF					; 3	90
	lda	#$ee
	sta	COLUPF
	lda	#$fe
	sta	COLUPF
	lda	#$0e
	sta	COLUPF
	lda	#$1e
	sta	a:COLUPF

; 70
	rts
; 6

; comes in 6 cycles in
line10:
; 6
	lda	$80	; 3
	lda	$80	; 3
	lda	$80	; 3
	nop		; 2
	nop		; 2


; 19

	; want to wait until 22.66 cpu clocks?
							; cpu pixel pf 
	lda	#$1e					; 2
	sta	COLUPF					; 3	15  3.75
	lda	#$2e					; 2
	sta	COLUPF					; 3	30  7.5
	lda	#$3e					; 2
	sta	COLUPF					; 3	45  
	lda	#$4e					; 2
	sta	COLUPF					; 3	60
	lda	#$5e					; 2
	sta	COLUPF					; 3	75
	lda	#$6e					; 2
	sta	COLUPF					; 3	90
	lda	#$7e
	sta	COLUPF
	lda	#$8e
	sta	COLUPF
	lda	#$9e
	sta	COLUPF
	lda	#$ae
	sta	a:COLUPF

; 70
	rts
; 6
.endif

.align $100
draw_routine1:
.incbin "draw_routine.bin"


	;=====================
	; sierpinksi third
	;=====================
	; roughly 27 scanlines?
	;==========================
	; YY set previously
	; X is which bank

sierpinski_third:

	sta	E7_SET_256_BANK0,X

	lda	#<$1800
	sta	OUTL
	lda	#>$1800
	sta	OUTH


	ldy	#9

	ldx	#5
sier_row_loop:

	lda	#10
	sta	XX

sier_col_loop:

	lda	XX
	and	YY
	clc
	adc	EXTRACOL
	sta	(OUTL),Y

	iny
	iny
	iny
	iny

;	inc	XX
;	lda	XX
	dec	XX
;	cmp	#10
	bne	sier_col_loop

	ldy	#9
	lda	OUTL
	clc
	adc	#50
	sta	OUTL

	inc	YY
	dex
	bne	sier_row_loop

	rts
