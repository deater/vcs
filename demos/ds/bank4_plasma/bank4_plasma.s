; e7 plasma?

.include "../../../vcs.inc"

; zero page addresses

.include "../zp.inc"

.include "../common_routines.inc"


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

        ldx     #33
	jsr	repeat_wsync

	;====================
	; now in scanline 34
	;====================
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


	ldx	#152
	jsr	repeat_wsync

	ldx	#16
	jsr	repeat_wsync


	;==========================
	; overscan for 30 scanlines
	;==========================

	ldx	#29
	jsr	common_overscan

; 10
	lda	DONE_TITLE						; 3
	bne	done_plasma						; 2/3
; 15

	jmp	start_plasma						; 3
; 18

done_plasma:
; 16



	rts



; comes in 6 cycles in
line1:
; 6
	lda	$80	; 3
	lda	$80	; 3
	nop		; 2
	nop		; 2
	lda	$80
;	nop		; 2
;	nop		; 2

; 16

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
; 66

; 70
	rts
; 6

