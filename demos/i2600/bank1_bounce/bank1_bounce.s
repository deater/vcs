; Bouncing Cube scene

.include "../../../vcs.inc"

; zero page addresses

.include "../zp.inc"

.include "../common_routines.inc"
.include "../timing.inc"

	;=======================
        ; bounce screen
        ;=======================
do_bounce:


	;================================================
	; draws bounce effect
	;================================================
	; effects
	;	make bigger?
	;	make 2 or 3 copies
	;	move behind playfield

FOREGROUND_COLOR = $02

BOUNCE_SPRITE0_LOW = 16
BOUNCE_SPRITE1_LOW = 24
;BOUNCE_SPRITE0_HIGH = 136
;BOUNCE_SPRITE1_HIGH = 144

.include "frame1_init.s"


bounce_effect:

	;====================================
	; start VBLANK
	;====================================
	; this code takes 4 scanlines, it does a WSYNC soon after
	;       to ensure 3 scanlines total
	; this means it's really stealing one of the previous frame's lines

	jsr	common_vblank

; 9
	;====================================
	;====================================
	;====================================
	; 37 lines of VBLANK
	;====================================
	;====================================
	;====================================

	;=============================
	; scanlines 0..11 (unused)
	;=============================

	ldx	#12
	jsr	repeat_wsync
; 8
	;================================
	; play music -- scanlines 12..22
	;================================
	; takes 11 lines, doesn't WSYNC at end?

	lda	#1		; our bank
	jsr	do_play_music
	sta	WSYNC


	;===================================
	; setup effect -- scanlines 23
	;===================================
	; switch effects as needed

	ldx	WHICH_EFFECT						; 3
	lda	next_effect_l,X						; 4
	cmp	EFFECTL							; 3
	bne	same_effect						; 2/3
; 23
	lda	next_effect_h,X						; 4
	cmp	EFFECTH							; 3
	bne	same_effect						; 2/3
; 32
	inc	WHICH_EFFECT						; 5
; 37

	; start moving

	lda	WHICH_EFFECT
	cmp	#3
	bne	dont_reset_xadd

	dec	SPRITE0_XADD						; 5
	dec	SPRITE0_YADD						; 5
	dec	SPRITE1_XADD						; 5
dont_reset_xadd:

same_effect:

;	lda	EFFECTH
;	cmp	#5
;	bcs	skip_update_effect
;	sta	WHICH_EFFECT
;skip_update_effect:

	sta	WSYNC

	;===================================
	; init if necessary -- scanlines 24
	;===================================
; 0
	ldx	WHICH_EFFECT						; 3
; 3

	; update start location

	lda	sprite0_x_data,X					; 4
	bmi	dont_change_location
	sta	SPRITE0_X						; 3
	lda	sprite0_y_data,X					; 4
	sta	SPRITE0_Y						; 3
	lda	sprite1_x_data,X					; 4
	sta	SPRITE1_X						; 3
	lda	sprite1_y_data,X					; 4
	sta	SPRITE1_Y						; 3
dont_change_location:
;  31

	; adjust sprite height

	lda	sprite_height_data,X					; 4
	sta	SPRITE_HEIGHT						; 3
; 59

	sta	WSYNC

	;===================================
	; init if necessary -- scanlines 25
	;===================================
; 0
	lda	sprite_nusiz_data,X					; 4
	sta	NUSIZ0							; 3
	sta	NUSIZ1							; 3
; 10

	lda	sprite0_bounce_high_data,X
	sta	BOUNCE_SPRITE0_HIGH
	lda	sprite1_bounce_high_data,X
	sta	BOUNCE_SPRITE1_HIGH

;	lda	#CTRLPF_PFP			; behind		; 2
	lda	#0
	sta	CTRLPF							; 3
; 15

	sta	WSYNC


	;==============================
	; scaline 26 -- incremement frame
	;==============================
	jsr	inc_frame		; 48


	sta	WSYNC

	;============]============================
	; scanline 27/28/29: set SPRITE0_X
	;=========================================

	lda	SPRITE0_X
	ldx	#0		; sprite0
	jsr	set_pos_x	; takes 3 scanlines

; 6

	;============]============================
	; scanline 30/31/32: set SPRITE1_X
	;=========================================

	lda	SPRITE1_X
	ldx	#1		; sprite1
	jsr	set_pos_x

; 6



	;=========================================
	; scanline 33: move sprite0
	;=========================================
; 6
	lda	SPRITE0_XADD						; 3
; 9
	; XADD in A
	clc								; 2
	adc	SPRITE0_X						; 3
	sta	SPRITE0_X						; 3
	cmp	BOUNCE_SPRITE0_HIGH					; 3
	bcs	sprite0_invert_x	; bge				; 2/3
	cmp	#BOUNCE_SPRITE0_LOW					; 2
	bcs	done_sprite0_x		; bge				; 2/3
								;============
								; 17 worst
sprite0_invert_x:
; 25
	lda	SPRITE0_XADD						; 3
	eor	#$FF							; 2
	tay								; 2
	iny								; 2
	sty	SPRITE0_XADD						; 3
; 37

done_sprite0_x:

	lda	SPRITE0_YADD						; 3
; 40
	clc								; 2
	adc	SPRITE0_Y						; 3
	sta	SPRITE0_Y						; 3
	cmp	#164							; 2

	bcs	sprite0_invert_y	; bge				; 2/3
	cmp	#8							; 2
	bcs	done_sprite0_y		; bge				; 2/3
								;============
								; 16 worst

sprite0_invert_y:
; 56
	lda	SPRITE0_YADD						; 3
	eor	#$FF							; 2
	tay								; 2
	iny								; 2
	sty	SPRITE0_YADD						; 3

	; make so goes behind playfield?

;	lda	#CTRLPF_PFP
;	sta	CTRLPF

; 68
done_sprite0_y:
	sta	WSYNC


	;=========================================
	; scanline 34: move sprite1
	;=========================================
; 0
	lda	SPRITE1_XADD						; 3
	clc								; 2
	adc	SPRITE1_X						; 3
	sta	SPRITE1_X						; 3
	cmp	BOUNCE_SPRITE1_HIGH					; 3
	bcs	sprite1_invert_x	; bge				; 2/3
	cmp	#BOUNCE_SPRITE1_LOW					; 2
	bcs	done_sprite1_x		; bge				; 2/3
								;============
								; 19 worst

sprite1_invert_x:
; 18
	lda	SPRITE1_XADD						; 3
	eor	#$FF							; 2
	clc								; 2
	adc	#1							; 2
	sta	SPRITE1_XADD						; 3
; 30

done_sprite1_x:

	; TODO: change color?

	sta	WSYNC
	sta	HMOVE		; finalize fine adjust

	;================================================
	; VBLANK scanline 35/36 -- init sprites
	;================================================

	; various init

	lda	#$56		; medium purple				; 2
	sta	COLUP0		; set sprite0 color			; 3
	sta	COLUP1		; set sprite1 color			; 3

	lda	#$00							; 2
	sta	COLUBK		; black background			; 3
	sta	VDELP0							; 3
	sta	VDELP1		; turn off delay			; 3

	; reflect sprite 1

	lda	#$8							; 2
	sta	REFP1							; 3

	sta	WSYNC
	sta	WSYNC

	;=================================
	; VBLANK scanline 37
	;=================================
; 0

	lda	#0							; 2
	sta	GRP0			; sprite 1			; 3
	sta	GRP1			; sprite 2			; 3

; 13

	; stripes

        lda     #$55
        ldy     #$aa
        sta     PF0
        sta     PF2
        sty     PF1

;	lda	#$4
;	sta	COLUPF			; fg, black			; 3

; 29

; 34
	ldy	#0							; 2
	ldx	#0							; 2
	txa			; needed so top line is black		; 2
; 40

	stx	VBLANK                  ; turn on beam			; 3

	sta	WSYNC							; 3
; 67



	;========================================================
	;========================================================
	; kernel
	;========================================================
	;========================================================
	; 192 scanlines

bounce_jmp:
	ldy	WHICH_EFFECT
	lda	bounce_jump_h,Y
	pha
	lda	bounce_jump_l,Y
	pha
	rts

done_bounce_kernel:

; 2
	;=============================================
	;=============================================
	; overscan (30 scanlines)
	;=============================================
	;=============================================

	ldx	#29
	jsr	common_overscan						; 10

; 10
	lda	FRAMEL							; 3
	cmp	#BOUNCE_TIME_L						; 2
	bne	not_done_bounce						; 2/3
; 17
	lda	FRAMEH							; 3
	cmp	#BOUNCE_TIME_H						; 2
	beq	done_bounce						; 2/3

; 18 / 24
not_done_bounce:
	jmp	bounce_effect

; 25
done_bounce:
	rts
; 31









sprite_data:
	.byte	$06	; .... .**.
	.byte	$1E	; ...* ***.
	.byte	$3A	; ..** *.*.
	.byte	$62	; .**. ..*.
	.byte	$3A	; ..** *.*.
	.byte	$CC	; **.. **..
	.byte	$E7	; ***. .***
	.byte	$BB	; *.** *.**
	.byte	$8C	; *... **..
	.byte	$B3	; *.** ..**
	.byte	$E6	; ***. .**.
	.byte	$CE	; **.. ***.
	.byte 	$3A	; ..** *.*.
	.byte	$62	; .**. ..*.
	.byte	$3A	; ..** *.*.
	.byte	$0E	; .... ***.
	.byte	$02	; .... ..*.


; 192-68=124/2=62  192-34=158/2=79 192-17=175/2=87

; 160-32 = 128/2 = 64
; 160-16 = 144/2 = 72
sprite0_x_data:
	.byte	48,64,72,$ff,$ff
sprite1_x_data:
	.byte	80,80,80,$ff,$ff
sprite0_y_data:
sprite1_y_data:
	.byte	62,79,87,$ff,$ff

;sprite0_xadd_data:
;	.byte	00,00,00,$ff,$ff
;sprite0_yadd_data:
;	.byte	00,00,00,$ff,$ff
;sprite1_xadd_data:
;	.byte	00,00,00,$ff,$ff
sprite_height_data:
	.byte	17*4,17*2,17,17,17
sprite_nusiz_data:
	.byte	NUSIZ_QUAD_SIZE,NUSIZ_DOUBLE_SIZE
	.byte	NUSIZ_ONE_COPY,NUSIZ_ONE_COPY
	.byte	NUSIZ_TWO_COPIES_MED

sprite0_bounce_high_data:
	.byte	136,136,136,136,110
sprite1_bounce_high_data:
	.byte	144,144,144,144,118





;BOUNCE_SPRITE0_HIGH = 136
;BOUNCE_SPRITE1_HIGH = 144

;	NUSIZ_ONE_COPY          		; default
;	lda	#NUSIZ_TWO_COPIES_CLOSE		; OK
;	lda	#NUSIZ_TWO_COPIES_MED		; BETTER
;	lda	#NUSIZ_THREE_COPIES_CLOSE	; OK
;	lda	#NUSIZ_TWO_COPIES_WIDE		; too far away
;	lda	#NUSIZ_DOUBLE_SIZE		; would need to adjust height
;	lda	#NUSIZ_THREE_COPIES_MED		; unexciting
	lda	#NUSIZ_QUAD_SIZE		; unexciting






; jump table

bounce_jump_l:
	.byte <(bounce_kernel_4-1),<(bounce_kernel_2-1)
	.byte <(bounce_kernel_1-1),<(bounce_kernel_1-1)
	.byte <(bounce_kernel_1-1),<(bounce_kernel_1-1)

bounce_jump_h:
	.byte >(bounce_kernel_4-1),>(bounce_kernel_2-1)
	.byte >(bounce_kernel_1-1),>(bounce_kernel_1-1)
	.byte >(bounce_kernel_1-1),>(bounce_kernel_1-1)


.include "bounce_kernel_4.s"
.include "bounce_kernel_2.s"
.include "bounce_kernel_1.s"


; EFFECTS!
;  0 -- large cube	                0:00 - 0:94
;  1 -- medium cube                     0:44 - 1:52
;  2 -- small cube                      1:52 - 2:80
;  3 -- small bounce                    2:80 - 3:c0
;  4 -- double bounce                   3:c0 - f:ff


next_effect_l:
        .byte   $94,$52,$80,$c0,$00
next_effect_h:
        .byte   $00,$01,$02,$03,$ff

