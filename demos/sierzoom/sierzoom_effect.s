XX_TH	=	$90
XX_TL	=	$91
YY	=	$92
YY_TH	=	$93
YY_TL	=	$94
T_L	=	$95
T_H	=	$96
SAVED	=	$97
FRAME0	=	$98
FRAME1	=	$99
FRAME2	=	$9A
FRAME3	=	$9B
FRAME4	=	$9C
FRAME5	=	$9D

	; roughly 53 cycles per iteration?

	;================================
	; Clear screen and setup graphics
	;================================
do_sierzoom:

;	lda	#0		; start with multiplier 0
;	sta	T_L		; since we are executing in zero page we
;	sta	T_H		; don't need to init these

sier_outer:

	ldx	YY
	cpx	#48
	bcc	yy_good

	ldx	#0		; YY starts at 0

	stx	YY_TL		; YY_T also starts at 0
	stx	YY_TH

	; inc T
	;	clc
	lda	T_L

	adc	#1				; next frame
	sta	T_L
	bcc	no_carry
	inc	T_H
no_carry:


yy_good:



sier_yloop:

	; calc YY_T (8.8 fixed point add)
;	clc			; save byte by ignoring carry (slightly
				; changes results but not by much)
	lda	YY_TL
	adc	T_L
	sta	YY_TL
	lda	YY_TH
	adc	T_H
	sta	YY_TH

		; YY		; plot call needs Y/2
		; Ycord is in X

	; reset XX to 0

	ldy	#0		; XX=0

	sty	XX_TL		; XX_T also 0
	sty	XX_TH

sier_xloop:

	; want (YY-(XX*T)) & (XX+(YY*T)


	; SAVED = XX+(Y*T)
;	clc			; skip setting carry to save byte

	tya			; XX lives in Y
	adc	YY_TH
	sta	SAVED		; save XX+YY_T

	; calc XX*T
;	clc			; skip setting carry to save byte

	lda	XX_TL		; XX_T=XX_T+T
	adc	T_L
	sta	XX_TL
	lda	XX_TH
	adc	T_H
	sta	XX_TH


	; calc (YY-X_T)
	txa			; YY lives in X
	sec
	sbc	XX_TH

	; want (YY-(XX*T)) & (XX+(YY*T)

	and	SAVED

	and	#$f0

	beq	green
black:
	clc
	bcc	do_plot		; bra
green:
	sec

do_plot:
	; XX value already in Y

	; PLOT

	; rotate into place

	rol	FRAME5
	rol	FRAME4
	rol	FRAME3
	rol	FRAME2
	rol	FRAME1
	rol	FRAME0

	iny		; XX
	cpy	#48
	bne	sier_xloop

	; plot whole line

	lda	FRAME0
	sta	$1000,X
	lda	FRAME1
	sta	$1080,X
	lda	FRAME2
	sta	$1100,X
	lda	FRAME3
	sta	$1180,X
	lda	FRAME4
	sta	$1200,X
	lda	FRAME5
	sta	$1280,X

	inx		; YY

	stx	YY

;	cpx	#1
;	bne	sier_yloop

	; inc T
	;	clc
;	lda	T_L

;	adc	#1				; next frame
;	sta	T_L
;	bcc	no_carry
;	inc	T_H
;no_carry:

	rts



