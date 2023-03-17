; strongbadia

; o/~ come to the place where tropical breezes blow o/~

	lda	#120
	sta	CHEAT_Y
	lda	#50
	sta	CHEAT_X

strongbadia_loop:

	;=========================
	; Start Vertical Blank
	;=========================

	lda	#2			; reset beam to top of screen
	sta	VSYNC

	;================================
	; wait for 3 scanlines of VSYNC

	sta	WSYNC			; wait until end of scanline
	sta	WSYNC

	lda	CHEAT_DIRECTION
	sta	REFP0
	sta	REFP1

	; mirror playfield
	lda	#CTRLPF_REF
	sta	CTRLPF

	sta	WSYNC

	lda	#0			; done beam reset
	sta	VSYNC

	;===============================
	;===============================
	; 37 lines of vertical blank
	;===============================
	;===============================

	ldx	#33
	jsr	scanline_wait		; Leaves X zero
; 10

	;===========================
	; scanline 34
	;===========================
	; update cheat horizontal
update_cheat_horizontal:
; 10
	lda	CHEAT_X							; 3
; 13
	; spritex DIV 16

	lsr                                                             ; 2
	lsr                                                             ; 2
	lsr                                                             ; 2
	lsr                                                             ; 2
	sta     CHEAT_X_COARSE						; 3
; 24
	; apply fine adjust
	lda	CHEAT_X							; 3
	and	#$0f							; 2
	tax								; 2
	lda	fine_adjust_table,X					; 4+
	sta	HMP0							; 3
; 38

	lda	SHADOW_X						; 3
	lsr                                                             ; 2
	lsr                                                             ; 2
	lsr                                                             ; 2
	lsr                                                             ; 2
	sta     SHADOW_X_COARSE						; 3
; 54
	; apply fine adjust
	lda	SHADOW_X						; 3
	and	#$0f							; 2
	tax								; 2
	lda	fine_adjust_table,X					; 4+
	sta	HMP1							; 3
; 68
	sta	WSYNC

	;=======================================================
	; set up sprite0 (the cheat)  to be at proper X position
	;=======================================================
        ; now in scanline 35
; 0
	; we can do this here and the sprite will be drawn as a long
	; vertical column
	; later we only enable it for the lines we want

	ldx     a:CHEAT_X_COARSE    ; force 4-cycle version         ; 4

	cpx	#$A                                                     ; 2
	bcs	far_right       ; bge                                   ; 2/3

; 8
	inx                     ;                                       ; 2
	inx                     ;                                       ; 2
; 12 (want to be 12 here)

pad_x:
	dex                     ;                                       2
	bne	pad_x           ;                                       2/3
                                ;===========================================
                                ;       5*(coarse_x+2)-1
                                ; MAX is 9, so up to 54
; up to 66
	; beam is at proper place
	sta	RESP0                                                   ; 3
; up to 69
	sta	WSYNC                                                   ; 3
; up to 72
	jmp	done_done                                               ; 3

	; special case for when COARSE_X = 10
	; won't fit with standard loop above
far_right:
; 9
	ldx     #11                                                     ; 2

fpad_x:
	dex                     ;                                       ; 2
	bne     fpad_x          ;                                       ; 2/3
                                ; (5*X)-1 = 54
; 65
	nop                                                             ; 2
	nop                                                             ; 2
	nop                                                             ; 2

; 71
	sta     RESP0                                                   ; 3
; 74
	nop
; 76

done_done:

	sta	WSYNC

	;=======================================================
	; set up sprite1 (the cheat)  to be at proper X position
	;=======================================================
        ; now in scanline 35
; 0
	; we can do this here and the sprite will be drawn as a long
	; vertical column
	; later we only enable it for the lines we want

	ldx     a:SHADOW_X_COARSE    ; force 4-cycle version         ; 4

	cpx	#$A                                                     ; 2
	bcs	sfar_right       ; bge                                   ; 2/3

; 8
	inx                     ;                                       ; 2
	inx                     ;                                       ; 2
; 12 (want to be 12 here)

spad_x:
	dex                     ;                                       2
	bne	spad_x           ;                                       2/3
                                ;===========================================
                                ;       5*(coarse_x+2)-1
                                ; MAX is 9, so up to 54
; up to 66
	; beam is at proper place
	sta	RESP1                                                   ; 3
; up to 69
	sta	WSYNC                                                   ; 3
; up to 72
	jmp	sdone_done                                               ; 3

	; special case for when COARSE_X = 10
	; won't fit with standard loop above
sfar_right:
; 9
	ldx     #11                                                     ; 2

sfpad_x:
	dex                     ;                                       ; 2
	bne     sfpad_x          ;                                       ; 2/3
                                ; (5*X)-1 = 54
; 65
	nop                                                             ; 2
	nop                                                             ; 2
	nop                                                             ; 2

; 71
	sta     RESP0                                                   ; 3
; 74
	nop
; 76

sdone_done:


	;================================
	; scanline 36
	;================================

	lda	CHEAT_Y
	clc
	adc	#18
	sta	CHEAT_Y_END

	sta     WSYNC
        sta     HMOVE

	;=============================
	; 37
	;=============================

	lda	#NUSIZ_ONE_COPY ; NUSIZ_DOUBLE_SIZE
	sta	NUSIZ0
	sta	NUSIZ1

	lda	#$0		; turn off delay
	sta	VDELP0
	sta	VDELP1
	sta	GRP0		; turn off sprites
	sta	GRP1

	sta	PF0		; clear playfield
	sta	PF1
	sta	PF2


	lda	#$00		; black cheat
	sta	COLUP0
	lda	#$1C		; yellow cheat
	sta	COLUP1

	lda	#$AE			; blue sky
	sta	COLUBK


	sta	WSYNC

	stx	VBLANK			; turn on beam (X=0)


	;===========================
	;===========================
	; playfield
	;===========================
	;===========================
	; draw 192 lines

	ldx	#0

	;===========================
	; 60 lines of bushes
	;===========================
	; Hills?  I always thought those were bushes...
	;	(figurative)
bushes_top_loop:
; 3
;	lda	bushes_bg_colors,X					; 4+
	sta	COLUBK							; 3
; 6
	lda	bushes_colors,X						; 4+
	sta	COLUPF							; 3
; 13
	lda	bushes_playfield0_left,X				; 4+
	sta	PF0							; 3
	; must write by CPU 22 [GPU 68]
; 20
	lda	bushes_playfield1_left,X				; 4+
	sta	PF1							; 3
	; must write by CPU 28 [GPU 84]
; 27
	lda	bushes_playfield2_left,X				; 4+
	sta	PF2							; 3
	; must write by CPU 38 [GPU 116]
; 34


	inx								; 2
	lda	bushes_bg_colors,X					; 4+
	cpx	#60							; 2
; 70
	sta	WSYNC
	bne	bushes_top_loop

	ldx	#0

	;===========================
	; 48 lines of strongbadia
	;===========================
strongbadia_top_loop:
; 3
	lda	#$D4							; 2
	sta	COLUBK							; 3
; 8
	lda	strongbadia_colors,X					; 4+
	sta	COLUPF							; 3
; 15
	lda	#$00							; 2
	sta	PF0							; 3
	; must write by CPU 22 [GPU 68]
; 20
	lda	strongbadia_playfield1_left,X				; 4+
	sta	PF1							; 3
	; must write by CPU 28 [GPU 84]
; 27
	lda	strongbadia_playfield2_left,X				; 4+
	sta	PF2							; 3
	; must write by CPU 38 [GPU 116]
; 34

	inx								; 2
	cpx	#48							; 2
; 70
	sta	WSYNC
	bne	strongbadia_top_loop

	;===========================
	; bottom of screen
	;===========================
	; at scanline 112

	ldy	#0
	ldx	#112
bottom_loop:

	; activate cheat sprite if necessary
;	lda     #$FF		; load sprite data			; 2
;	; X = current scanline
;	cpx	CHEAT_Y_END						; 3
;	bcs     turn_off_cheat						; 2/3
;	cpx	CHEAT_Y							; 3
;	bcc	turn_off_cheat						; 2/3
;	bcs	draw_cheat
;turn_off_cheat:
;	lda	#$00
;draw_cheat:
;	sta	GRP0

	cpx	CHEAT_Y
	beq	activate_cheat
	jmp	done_activate_cheat
activate_cheat:
	ldy	#10
done_activate_cheat:

	tya
	beq	level_no_cheat

	lda	cheat_sprite_black,Y
	sta	GRP0
	lda	cheat_sprite_yellow,Y
	sta	GRP1

	dey

level_no_cheat:

	inx

	sta	WSYNC



	inx
	cpx	#192
	sta	WSYNC
	bne	bottom_loop



	;============================
	; overscan
	;============================
strongbadia_overscan:
	lda	#$2		; turn off beam
	sta	VBLANK

	; wait 30 scanlines

	ldx	#26
	jsr	scanline_wait

	;=============================
	; now at VBLANK scanline 27
	;=============================
	; handle down being pressed
; 0
	lda	#$20			; check down			; 2
	bit	SWCHA                   ;				; 3
	bne	after_check_down        ;				; 2/3
down_pressed:
        inc	CHEAT_Y
        inc	CHEAT_Y

after_check_down:
	sta	WSYNC                   ;                               ; 3

	;=============================
	; now at VBLANK scanline 28
	;=============================
	; handle up being pressed
; 0
	lda	#$10			; check up			; 2
	bit	SWCHA                   ;				; 3
	bne	after_check_up		;				; 2/3
up_pressed:
        dec	CHEAT_Y
        dec	CHEAT_Y

after_check_up:
	sta	WSYNC                   ;                               ; 3


	;=============================
	; now at VBLANK scanline 29
	;=============================
	; handle left being pressed
; 0
	lda	#$40                    ; check left                    ; 2
	bit	SWCHA                   ;                               ; 3
	bne	after_check_left        ;                               ; 2/3
left_pressed:
        dec	CHEAT_X

	lda	#$0
	sta	CHEAT_DIRECTION

	sec
	lda	CHEAT_X
	sbc	#2
	sta	SHADOW_X


after_check_left:
	sta	WSYNC                   ;                               ; 3

	;=============================
	; now at VBLANK scanline 30
	;=============================
	; handle right being pressed
; 0
	lda	#$80			; check right                    ; 2
	bit	SWCHA			;                               ; 3
	bne	after_check_right	;                               ; 2/3
right_pressed:
	inc	CHEAT_X
	lda	#$8
	sta	CHEAT_DIRECTION

	clc
	lda	CHEAT_X
	adc	#2
	sta	SHADOW_X


after_check_right:
	sta	WSYNC                   ;                               ; 3




	jmp	strongbadia_loop


cheat_sprite_yellow:
	.byte $00
	.byte $00
	.byte $7D
	.byte $3F
	.byte $7E
	.byte $7F
	.byte $7D
	.byte $7F
	.byte $3E
	.byte $57
	.byte $FC

cheat_sprite_black:
	.byte $00
	.byte $00
	.byte $0A
	.byte $00
	.byte $04
	.byte $01
	.byte $0B
	.byte $02
	.byte $04
	.byte $A2
	.byte $04
