; e7 plasma?

.include "../../../vcs.inc"

; zero page addresses

.include "../zp.inc"

.include "../common_routines.inc"
.include "../timing.inc"

	;=======================
        ; plasma
        ;=======================
do_plasma:

	;==========================
	; title screen
	;==========================
	; potentially arrive here with an unknown number of cycles/scanlines
	; ideally VBLANK=2 (beam off)

; should be zero from initial code

;	lda	#$0
;	sta	DONE_TITLE

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
        sta     WSYNC
	;====================
	; now in scanline 36
	;====================

; goal

; 0         1         2         3
; 0123456789012345678901234567890123456789
; PPPPKKKK11112222KKKKPPPPKKKK11112222KKKK


	lda	#CTRLPF_REF
;	lda	#CTRLPF_BALL_SIZE8
	sta	CTRLPF

	lda	#$1e
	sta	COLUPF

	lda	#$C0
	sta	PF0
	lda	#$ff
	sta	PF2
	sta	PF1

	lda	#$0
	sta	COLUBK

;	lda	#66
;	sta	COLUP0

;	lda	#98
;	sta	COLUP1

;	lda	#$ff
;	sta	GRP0
;	sta	GRP1
;	lda	#$2
;	sta	ENAM0
;	sta	ENAM1
;	sta	ENABL



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

looper:
	jsr	line1
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

	jsr	line6
	jsr	line6
	jsr	line6
	jsr	line6
	jsr	line6
	jsr	line6
	jsr	line6
	jsr	line6

	jsr	line7
	jsr	line7
	jsr	line7
	jsr	line7
	jsr	line7
	jsr	line7
	jsr	line7
	jsr	line7

	jsr	line8
	jsr	line8
	jsr	line8
	jsr	line8
	jsr	line8
	jsr	line8
	jsr	line8
	jsr	line8

	jsr	line9
	jsr	line9
	jsr	line9
	jsr	line9
	jsr	line9
	jsr	line9
	jsr	line9
	jsr	line9

	jsr	line10
	jsr	line10
	jsr	line10
	jsr	line10
	jsr	line10
	jsr	line10
	jsr	line10
	jsr	line10

	ldx	#80
	jsr	repeat_wsync

	ldx	#16
	jsr	repeat_wsync


	;==========================
	; overscan for 30 scanlines
	;==========================

	ldx	#29
	jsr	common_overscan

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



; comes in 6 cycles in
line1:
; 6
	lda	$80	; 3
	lda	$80	; 3
	lda	$80	; 3
	nop		; 2
	nop		; 2


; 19

	; want to wait until 22.66 cpu clocks?
							; cpu pixel pf 
	lda	#$0e					; 2
	sta	COLUPF					; 3	15  3.75
	lda	#$1e					; 2
	sta	COLUPF					; 3	30  7.5
	lda	#$2e					; 2
	sta	COLUPF					; 3	45  
	lda	#$3e					; 2
	sta	COLUPF					; 3	60
	lda	#$4e					; 2
	sta	COLUPF					; 3	75
	lda	#$5e					; 2
	sta	COLUPF					; 3	90
	lda	#$6e
	sta	COLUPF
	lda	#$7e
	sta	COLUPF
	lda	#$8e
	sta	COLUPF
	lda	#$9e
	sta	a:COLUPF

; 70
	rts
; 6


; comes in 6 cycles in
line2:
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


; comes in 6 cycles in
line3:
; 6
	lda	$80	; 3
	lda	$80	; 3
	lda	$80	; 3
	nop		; 2
	nop		; 2


; 19

	; want to wait until 22.66 cpu clocks?
							; cpu pixel pf 
	lda	#$2e					; 2
	sta	COLUPF					; 3	15  3.75
	lda	#$3e					; 2
	sta	COLUPF					; 3	30  7.5
	lda	#$4e					; 2
	sta	COLUPF					; 3	45  
	lda	#$5e					; 2
	sta	COLUPF					; 3	60
	lda	#$6e					; 2
	sta	COLUPF					; 3	75
	lda	#$7e					; 2
	sta	COLUPF					; 3	90
	lda	#$8e
	sta	COLUPF
	lda	#$9e
	sta	COLUPF
	lda	#$ae
	sta	COLUPF
	lda	#$be
	sta	a:COLUPF

; 70
	rts
; 6

; comes in 6 cycles in
line4:
; 6
	lda	$80	; 3
	lda	$80	; 3
	lda	$80	; 3
	nop		; 2
	nop		; 2


; 19

	; want to wait until 22.66 cpu clocks?
							; cpu pixel pf 
	lda	#$3e					; 2
	sta	COLUPF					; 3	15  3.75
	lda	#$4e					; 2
	sta	COLUPF					; 3	30  7.5
	lda	#$5e					; 2
	sta	COLUPF					; 3	45  
	lda	#$6e					; 2
	sta	COLUPF					; 3	60
	lda	#$7e					; 2
	sta	COLUPF					; 3	75
	lda	#$8e					; 2
	sta	COLUPF					; 3	90
	lda	#$9e
	sta	COLUPF
	lda	#$ae
	sta	COLUPF
	lda	#$be
	sta	COLUPF
	lda	#$ce
	sta	a:COLUPF

; 70
	rts
; 6

; comes in 6 cycles in
line5:
; 6
	lda	$80	; 3
	lda	$80	; 3
	lda	$80	; 3
	nop		; 2
	nop		; 2


; 19

	; want to wait until 22.66 cpu clocks?
							; cpu pixel pf 
	lda	#$4e					; 2
	sta	COLUPF					; 3	15  3.75
	lda	#$5e					; 2
	sta	COLUPF					; 3	30  7.5
	lda	#$6e					; 2
	sta	COLUPF					; 3	45  
	lda	#$7e					; 2
	sta	COLUPF					; 3	60
	lda	#$8e					; 2
	sta	COLUPF					; 3	75
	lda	#$9e					; 2
	sta	COLUPF					; 3	90
	lda	#$ae
	sta	COLUPF
	lda	#$be
	sta	COLUPF
	lda	#$ce
	sta	COLUPF
	lda	#$de
	sta	a:COLUPF

; 70
	rts
; 6

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




