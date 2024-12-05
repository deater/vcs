; Snake Boxer5

; based on the Videlectrix game

; by Vince `deater` Weaver <vince@deater.net>

.include "../../vcs.inc"

; zero page addresses

FRAME	=	$80

INL	=	$84
INH	=	$85

TEMP1	=	$90
TEMP2	=	$91

start:
	sei		; disable interrupts
	cld		; clear decimal bit


restart_game:

	; init zero page and addresses to 0

	ldx	#0
	txa
clear_loop:
	dex
	txs
	pha
	bne	clear_loop

	; S=$FF, A=$00, X=$00, Y=??

title_frame_loop:

	;============================================
	; Start Vertical Blank (with one extra WSYNC)
	;============================================

	jsr	common_vblank


	;============================
	; 37 lines of vertical blank
	;=============================

	ldx	#35
	jsr	common_delay_scanlines

	;=======================
	; scanline 36 -- align sprite

	ldx	#7		;					; 2
scad_x:
	dex			;					; 2
	bne	scad_x		;					; 2/3

	; 2+1 + 5*X each time through
	;       so 18+7+9=38

	nop
	nop

	; beam is at proper place
	sta	RESP0

	lda	#$B0		; fine adjust				; 2
	sta	HMP0

	sta	WSYNC
	sta	HMOVE

	;=======================
	; scanline 37 -- config

	lda	#NUSIZ_QUAD_SIZE
	sta	NUSIZ0

	lda	#$0		; yellow		; set color
	sta	COLUP0
	sta	COLUPF

	ldy	#0
	sty	VBLANK		; re-enable VBLANK

;	sty	GRP0



	ldx	#0

;	inc	FRAME
;	lda	FRAME
;	and	#$20
;	bne	beak_closed
;beak_open:
;	lda	#<game_overlay
;	sta	INL
;	lda	#>game_overlay
;	jmp	beak_done
;beak_closed:
;	lda	#<game_overlay2
;	sta	INL
;	lda	#>game_overlay2
;beak_done:
;	sta	INH


	sta	WSYNC


	;=============================================
	;=============================================
	; title screen, 192 lines
	;=============================================
	;=============================================

	; draw 112 lines of the title
	; need to race beam to draw other half of playfield

title_loop:
	lda	left_colors,Y		;				; 4+
	sta	COLUPF			; set playfield color		; 3
; 7
	lda	playfield0_left,Y	;				; 4+
	sta	PF0			;				; 3
	; must write by CPU 22 [GPU 68]
; 14
	lda	playfield1_left,Y	;				; 4+
	sta	PF1			;				; 3
	; must write by CPU 28 [GPU 84]

; 21
	lda	playfield2_left,Y	;				; 4+
	sta	PF2			;				; 3
	; must write by CPU 38 [GPU 116]

; 28
	; at this point we're at 28 cycles
	lda	playfield0_right,Y	;				; 4+
	sta	PF0			;				; 3
	; must write by CPU 49 [GPU 148]
; 35
	lda	playfield1_right,Y	;				; 4+
	sta	PF1			;				; 3
	; must write by CPU 54 [GPU 164]
; 42
	lda	$80							; 3
	lda	playfield2_right,Y	;				; 4+
	sta	PF2			;				; 3
	; must write by CPU 65 [GPU 196]

; 52

	lda	right_colors,Y		;				; 4+
;	force 4-cycle store
	sta	a:COLUPF						; 4

; 60
	inx                                                             ; 2
	txa                                                             ; 2
	and	#$3                                                     ; 2
	beq	yes_iny                                                 ; 2/3
	.byte	$A5     ; begin of LDA ZP                               ; 3
yes_iny:
	iny		; $E8 should be harmless to load                ; 2
done_iny:
                                                                ;===========
                                                                ; 11/11

; 71
	cpx	#112						; 2
	bne	title_loop					; 2/3


	ldx	#80
	jsr	common_delay_scanlines

done_loop:



	;==========================
	; overscan
	;==========================

	ldx	#29
	jsr	common_overscan


	 ;============================
        ; Overscan scanline 30
        ;============================
        ; check for button
        ; we used to check for RESET too, but we'd need to debounce it
        ;       and in theory it would be sorta pointless to RESET at title
        ;============================

waited_enough:
        lda     INPT4                   ; check if joystick button pressed
        bpl     done_title


done_check_input:

        jmp     title_frame_loop        ; bra

done_title:

        rts


.align $100

.include "title.inc"
.include "common_routines.s"

.segment "IRQ_VECTORS"
	.word start	; NMI
	.word start	; RESET
	.word start	; IRQ
