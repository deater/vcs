LOGO_SIZE=33

.ifdef VCS_NTSC
LOGO_BOUNCE_TOP	= 14
LOGO_BOUNCE_BOTTOM = (177-LOGO_SIZE*2-1)
.else
; this is 32 / 128 so from 32 - 194    228-192 = 36
LOGO_BOUNCE_TOP	= 32
LOGO_BOUNCE_BOTTOM = (195-LOGO_SIZE*2-1)
.endif

	;================================================
	; draws logo effect
	;================================================
	; comes in with 8 cycles left in VBLANK

logo_effect:

	; FIXME: make this a loop

	; 37
	sta	WSYNC
	; 38
	sta	WSYNC
	; 39
	sta	WSYNC
	; 40
	sta	WSYNC
	; 41
	sta	WSYNC
	; 42
	sta	WSYNC

	;===============================
	; line 43 -- check if move logo
	;===============================
	; start it at 1:80

	lda	FRAMEL							; 3
	cmp	#$80							; 2
	bne	no_start_logo						; 2/3
	lda	FRAMEH							; 3
	cmp	#1							; 2
	bne	no_start_logo						; 2/3

	inc	LOGO_YADD						; 5

no_start_logo:

	; stop if at 2:a#
	lda	FRAMEL
	cmp	#$A3
	bne	no_stop_logo
	lda	FRAMEH
	cmp	#2
	bne	no_stop_logo

	lda	#0
	sta	LOGO_YADD

no_stop_logo:

	sta	WSYNC


	;================================================
	; VBLANK scanline 44 -- adjust Y
	;================================================
; 0
	lda	LOGO_YADD					; 3
	clc							; 2
	adc	LOGO_Y						; 3
        sta	LOGO_Y						; 3
        cmp	#LOGO_BOUNCE_BOTTOM				; 2
; 13
        bcs	logo_invert_y			; bge		; 2/3
        cmp	#LOGO_BOUNCE_TOP				; 2
        bcs	logo_done_y			; bge		; 2/3
logo_invert_y:
	lda	LOGO_YADD					; 3
	eor	#$FF						; 2
	clc							; 2
	adc	#1						; 2
	sta	LOGO_YADD					; 3

logo_done_y:
        sta     WSYNC


	;=================================
	; VBLANK scanline 45
	;=================================
; 0
	lda	#0							; 2
	sta	VBLANK                  ; turn on beam			; 3
; 5

	; update bg color
	lda	FRAMEL							; 3
	lsr								; 2
	lsr								; 2
	lsr								; 2
	and	#$7							; 2
	tax								; 2
	lda	bg_colors,X						; 4+
        sta	COLUBK							; 3
	sta	SAVED_COLUBK
; 25
	lda	#0							; 2
	sta	VDELP0							; 3
	sta	VDELP1		; turn off delay			; 3
; 33

;	lda	#NUSIZ_QUAD_SIZE|NUSIZ_MISSILE_WIDTH_8			; 2
;	sta	NUSIZ0							; 3
;	lda	#NUSIZ_QUAD_SIZE|NUSIZ_MISSILE_WIDTH_8			; 2
;	sta	NUSIZ1							; 3
; 43
	; move the logo

	clc								; 2
	lda	LOGO_Y							; 3
	adc	LOGO_YADD						; 3
	sta	LOGO_Y							; 3
; 54

	ldy	#0							; 2
	ldx	#0							; 2
; 58
	sta	WSYNC							; 3
; 61


	;=========================
	;=========================
	; kernel
	;=========================
	;=========================
	; 228 scanlines (192 on NTSC)

	; comes in at 3 cycles

	jmp	start_ahead						; 3

draw_playfield:
; 3

draw_logo:
	sta	WSYNC
; 0
	sta	COLUBK							; 3
; 3
	lda	desire_colors,Y						; 4
	sta	COLUPF							; 3
; 10
	lda	desire_playfield0_left,Y	; playfield pattern 0	; 4
	sta	PF0			;				; 3
	;   has to happen by 22 (GPU 68)
; 17
	lda	desire_playfield1_left,Y	; playfield pattern 1	; 4
	sta	PF1			;				; 3
        ;  has to happen by 28 (GPU 84)
; 24
	lda	desire_playfield2_left,Y	; playfield pattern 2	; 4
	sta	PF2							; 3
        ;  has to happen by 38 (GPU 116)	;
; 31
	lda	desire_playfield0_right,Y	; left pf pattern 0     ; 4
	sta	PF0				;                       ; 3
	; has to happen 28-49 (GPU 84-148)
; 38
	lda	desire_playfield1_right,Y	; left pf pattern 1	; 4
	sta	PF1				;			; 3
	; has to happen 38-56 (GPU 116-170)
; 45
	lda	desire_playfield2_right,Y	; left pf pattern 2	; 4
	sta	PF2				;			; 3
	; has to happen 49-67 (GPU148-202)
; 52
	inx		; inc scanline					; 2
	txa								; 2
	lsr		; divide by 2					; 2
; 58
	bcc	noc	; skip if odd					; 2/3
	dey					; decrement logo count	; 2
	beq	done_logo						; 2/3
; 64
noc:
; 64 / 61
	lda	desire_bg_colors,Y					; 4
; 68
done_logo:
;	sta	WSYNC							; 3
	bne	draw_logo						; 2/3


; 2/3
draw_nothing:

	inx				; inc current scanline		; 2

start_ahead:
; 5 / 54

	lda	SAVED_COLUBK
	sta	COLUBK

	; see if line equals Y location?
	cpx	LOGO_Y							; 2
	bne	not_logo_start						; 2/3
	ldy	#LOGO_SIZE		; set logo height		; 2
not_logo_start:
; 5

	; finish 1 early so time to clear up
.ifdef VCS_NTSC
	cpx	#190							; 2
.else
	cpx	#226							; 2
.endif

	bcs	done_playfield						; 2/3
; 9
	lda	desire_bg_colors+LOGO_SIZE
	cpy	#0
; 67
	bne	draw_logo		; if so, draw it		; 2/3
	sta	WSYNC							; 3
	beq	draw_nothing		; otherwise draw nothing	; 2/3





done_playfield:

done_kernel:

	sta	WSYNC

	;===========================
	;===========================
	; overscan (36 cycles) (30 on NTSC)
	;===========================
	;===========================

	; turn off everything
	lda	#0							; 2
	sta	GRP0							; 3
; 1
	lda	#2		; we do this in common
	sta	VBLANK		; but want it to happen in hblank


	lda	#0
	sta	GRP1							; 3
	sta	PF0							; 3
	sta	PF1							; 3
	sta	PF2							; 3
; 13

	jmp	effect_done



bg_colors:

.ifdef VCS_NTSC
	; ntsc
	.byte $60,$90,$70,$A0, $A0,$70,$90,$60
.else
	; pal
	.byte $D0,$C0,$B0,$A0, $A0,$B0,$C0,$D0
.endif

