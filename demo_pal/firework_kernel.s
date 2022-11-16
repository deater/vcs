	;================================================
	; draws firework effect
	;================================================

firework_effect:

	;============]========================
	; scanline 38: setup X for firework0
	;====================================
; 0
	lda	SPRITE0_X						; 3
; 3
        ; spritex DIV 16

	lsr								; 2
	lsr								; 2
	lsr								; 2
	lsr								; 2

        sta	SPRITE0_X_COARSE					; 3
; 14
	; apply fine adjust
	lda	SPRITE0_X						; 3
	and	#$0f							; 2
	tax								; 2
	lda	fine_adjust_table,X					; 4+
	sta	HMP0							; 3
; 28

;	lda	SPRITE1_X						; 3
; 31
        ; spritex DIV 16

;	lsr								; 2
;	lsr								; 2
;	lsr								; 2
;	lsr								; 2

;	sta	SPRITE1_X_COARSE					; 3
; 42
;	; apply fine adjust
;	lda	SPRITE1_X						; 3
;	and	#$0f							; 2
;	tax								; 2
;	lda	fine_adjust_table,X					; 4+
;	sta	HMP1							; 3
; 56

	sta	WSYNC

	;=========================================
	; scanline 39: increment sprite0
	;=========================================
; 0
;	lda	SPRITE0_XADD						; 3
; 3
	; XADD in A
;	clc								; 2
;	adc	SPRITE0_X						; 3
;	sta	SPRITE0_X						; 3
;	cmp	#144							; 2
;	bcs	sprite0_invert_x	; bge				; 2/3
;	cmp	#16							; 2
;	bcs	done_sprite0_x		; bge				; 2/3
								;============
								; 16 worst
;sprite0_invert_x:
; 19
;	lda	SPRITE0_XADD						; 3
;	eor	#$FF							; 2
;	tay								; 2
;	iny								; 2
;	sty	SPRITE0_XADD						; 3
; 31

done_sprite0_x:

;	lda	SPRITE0_YADD						; 3
; 34
;	clc								; 2
;	adc	SPRITE0_Y						; 3
;	sta	SPRITE0_Y						; 3
;	cmp	#200							; 2
;	bcs	sprite0_invert_y	; bge				; 2/3
;	cmp	#8							; 2
;	bcs	done_sprite0_y		; bge				; 2/3
								;============
								; 16 worst

sprite0_invert_y:
; 50
;	lda	SPRITE0_YADD						; 3
;	eor	#$FF							; 2
;	tay								; 2
;	iny								; 2
;	sty	SPRITE0_YADD						; 3
;
	; make so goes behind playfield?
	; note it's not transparent color, but whether playfield drawn
	; at all
	; we'd have to reset PF0/PF1/PF2 in kernel, prob not possible :(

;	lda	#CTRLPF_PFP
;	sta	CTRLPF

; 62
done_sprite0_y:
	sta	WSYNC


	;=========================================
	; scanline 40: move sprite1
	;=========================================
; 0
;	lda	SPRITE1_XADD						; 3
;	clc								; 2
;	adc	SPRITE1_X						; 3
;	sta	SPRITE1_X						; 3
;	cmp	#144							; 2
;	bcs	sprite1_invert_x	; bge				; 2/3
;	cmp	#16							; 2
;	bcs	done_sprite1_x		; bge				; 2/3
								;============
								; 18 worst

sprite1_invert_x:
; 18
;	lda	SPRITE1_XADD						; 3
;	eor	#$FF							; 2
;	clc								; 2
;	adc	#1							; 2
;	sta	SPRITE1_XADD						; 3
; 30

done_sprite1_x:

	; TODO: change color?

	sta	WSYNC

	;=======================================================
	; scanline 41: set up sprite0 to be at proper X position
	;=======================================================
	; value will be 0..9

; 0

	ldx	a:SPRITE0_X_COARSE	; force 4-cycle version		; 4
; 4

;	cpx	#$A                                                     ; 2
;	bcs	far_right	; bge                                   ; 2/3

	nop								; 2
	nop								; 2

; 8
	inx                     ;                                       ; 2
	inx                     ;                                       ; 2
; 12 (want to be 12 here)


	; X is 2..12 here
pad_x:
	dex                     ;                                       2
	bne	pad_x           ;                                       2/3
                                ;===========================================
                                ;       5*(coarse_x+2)-1
                                ; COARSE_X is 0..9 so
				;   9 .. 54 cycles

; up to 66
        ; beam is at proper place
        sta     RESP0                                                   ; 3
; up to 69

	sta	WSYNC


	;=======================================================
	; scanline 42: set up sprite1 to be at proper X position
	;=======================================================

; 0

;	ldx	a:SPRITE1_X_COARSE	; force 4-cycle version		; 4
; 4

;	cpx	#$A                                                     ; 2
;	bcs	far_right	; bge                                   ; 2/3

;	nop								; 2
;	nop								; 2

; 8
;	inx                     ;                                       ; 2
;	inx                     ;                                       ; 2
; 12 (want to be 12 here)


pad_x1:
;	dex                     ;                                       2
;	bne	pad_x1           ;                                       2/3
                                ;===========================================
                                ;       5*(coarse_x+2)-1
                                ; COARSE_X is 0..9 so
				;   9 .. 54 cycles
; up to 66
        ; beam is at proper place
;	sta     RESP1                                                   ; 3
; up to 69

	sta	WSYNC
	sta	HMOVE		; finalize fine adjust

	;================================================
	; VBLANK scanline 43 -- adjust green and blue rasterbar
	;================================================
; 3
;	lda	RASTER_G_YADD						; 3
; 6
;	clc								; 2
;	adc	RASTER_G_Y						; 3
;	sta	RASTER_G_Y						; 3
;	cmp	#PLAYFIELD_MAX						; 2
;	bcs	raster_g_invert_y	; bge				; 2/3
;	cmp	#0							; 2
;	bcs	done_raster_g_y		; bge				; 2/3
								;============
								; 16 worst
;raster_g_invert_y:
; 22
;	lda	RASTER_G_YADD						; 3
;	eor	#$FF							; 2
;	clc								; 2
;	adc	#1							; 2
;	sta	RASTER_G_YADD						; 3
; 34

done_raster_g_y:

	;=========================
	; blue rasterbar
; 34
;	lda	RASTER_B_YADD						; 3
; 37
;	clc								; 2
;	adc	RASTER_B_Y						; 3
;	sta	RASTER_B_Y						; 3
;	cmp	#PLAYFIELD_MAX						; 2
;	bcs	raster_b_invert_y	; bge				; 2/3
;	cmp	#0							; 2
;	bcs	done_raster_b_y		; bge				; 2/3
								;============
								; 16 worst case
raster_b_invert_y:
; 53
;	lda	RASTER_B_YADD						; 3
;	eor	#$FF							; 2
;	clc								; 2
;	adc	#1							; 2
;	sta	RASTER_B_YADD						; 3
; 65

done_raster_b_y:
	sta	WSYNC



	;================================================
	; VBLANK scanline 44 -- adjust red rasterbar
	;================================================
; 0
;	lda	RASTER_R_YADD						; 3
; 3
;	clc								; 2
;	adc	RASTER_R_Y						; 3
;	sta	RASTER_R_Y						; 3
;	cmp	#PLAYFIELD_MAX						; 2
;	bcs	raster_r_invert_y	; bge				; 2/3
;	cmp	#0							; 2
;	bcs	raster_r_done_y		; bge				; 2/3
								;============
								; 16
; 19
;raster_r_invert_y:
;	lda	RASTER_R_YADD						; 3
;	eor	#$FF							; 2
;	clc								; 2
;	adc	#1							; 2
;	sta	RASTER_R_YADD						; 3
; 31
;raster_r_done_y:

	; other init

; 31
	lda	#$86							; 2
	sta	COLUP0							; 3
; 38
;	lda	#$7E							; 2
;	sta	COLUP1							; 3
; 43
	lda	#$00							; 2
        sta	COLUBK							; 3
	sta	VDELP0							; 3
	sta	VDELP1		; turn off delay			; 3
; 54
	lda	#NUSIZ_ONE_COPY						; 2
	sta	NUSIZ0							; 3
; 59
	lda	#NUSIZ_ONE_COPY						; 2
	sta	NUSIZ1							; 3
; 64
	sta	WSYNC

	;=================================
	; VBLANK scanline 45
	;=================================
; 0
	lda	#0							; 2
	sta	VBLANK                  ; turn on beam			; 3
; 5

	lda	#0							; 2
	sta	COLUPF			; fg, black			; 3
	sta	GRP0			; sprite 1			; 3
; 13

	lda	#$00							; 2
	sta	PF0			;				; 3
	sta	PF1			;				; 3
	sta	PF2							; 3
	sta	GRP1			; sprite 2			; 3

; 58
	ldy	#0							; 2
	ldx	#0							; 2
	txa			; needed so top line is black		; 2
; 64
	lda	#50
	sta	SPRITE0_X
	lda	#50
	sta	SPRITE0_Y

	lda	#CTRLPF_REF
	sta	CTRLPF

	sta	WSYNC							; 3
; 67


	;=========================
	;=========================
	; kernel
	;=========================
	;=========================
	; 228 scanlines (192 on NTSC)


	;=========================
	; sky
	;=========================
	; 98 scanlines
sky_playfield:
	ldx	#0
sky_loop:

	ldy	#$0							; 2
	txa								; 2
	sbc	SPRITE0_Y						; 3
	cmp	#16							; 2
	bcs	no_sprite0						; 2/3
	ldy	#$FF							; 2
no_sprite0:
	sty	GRP0							; 3
								;==========
								; 16 worst
	sta	WSYNC
	inx
	cpx	#99
	bne	sky_loop

	;=========================
	; mountains
	;=========================
	; 16 scanlines
mountain_playfield:
	ldx	#16
mountain_loop:
	lda	sunset_colors,X
	sta	COLUBK
	lda	#$2
	sta	COLUPF


	txa
	lsr
	tay
	lda	mountain_left,Y
	sta	PF0
	lda	mountain_center,Y
	sta	PF1
	lda	mountain_right,Y
	sta	PF2

	sta	WSYNC
	dex
	bne	mountain_loop

	;=========================
	; ground
	;=========================
	; 100 scanlines
ground_playfield:
	ldx	#100
ground_loop:
	lda	#$50
	sta	COLUBK
	lda	#$00
	sta	PF0
	sta	PF1
	sta	PF2


	sta	WSYNC
	dex
	bne	ground_loop

.if 0
firework_playfield:
	; comes in at 3 cycles

; 3
	; color is already in A
	sta	COLUPF							; 3


; 6
	;============================
	; set sprite size
	;============================

	ldy	#$0							; 2
	txa								; 2
	sbc	SPRITE0_Y						; 3
	cmp	#16							; 2
	bcs	no_sprite0						; 2/3
	ldy	#$FF							; 2
no_sprite0:
	sty	GRP0							; 3
								;==========
								; 16 worst
; 22

	;============================
	; setup raster bars
	;============================
; 22
	; raster red

	txa								; 2
	sec								; 2
	sbc	RASTER_R_Y						; 3
	cmp	#8							; 2
	bcs	no_raster_red						; 2/3
; 33
	asl								; 2
	adc	#$50							; 2
	bne	done_raster_color			; bra		; 3
; 40

no_raster_red:
; 34
	; raster green

	txa								; 2
	sec								; 2
	sbc	RASTER_G_Y						; 3
	cmp	#8							; 2
	bcs	no_raster_green						; 2/3
; 45
	asl								; 2
	adc	#$60							; 2
	bne	done_raster_color			; bra		; 3
; 52

no_raster_green:
; 46

	; raster blue

	txa								; 2
	sec								; 2
	sbc	RASTER_B_Y						; 3
	cmp	#8							; 2
	bcs	no_raster_blue						; 2/3
; 57
	asl								; 2
	adc	#$B0							; 2
	bne	done_raster_color			; bra		; 3
; 64

no_raster_blue:
; 64
	lda	#$0							; 2
done_raster_color:
; R=40, G=52, B=58 none=66

; 66 worst case

	inx								; 2
	cpx	#214							; 2
; 70
	sta	WSYNC							; 3
; 73/0
; NOTE: this is worst case
;	max overlapping bars is 2 so always 4 less than this? (check)

	bne	firework_playfield					; 2/3
.endif


credits_bitmap:

	;=================================
	; scaline 217
	;=================================

; 2
	; to center exactly would want sprite0 at
	;       CPU cycle 41.3
	; and sprite1 at
	;       GPU cycle 44

	ldx	#0              ; sprite 0 display nothing              ; 2
	stx	GRP0            ;                                       ; 3
	stx	GRP1							; 3
; 10
	ldx	#5		;					; 2
; 12

stpad_x:
	dex                     ;                                       ; 2
	bne	stpad_x		;                                       ; 2/3
	; for X delays (5*X)-1
	; so in this case, 24
; 36
	; beam is at proper place
	sta     RESP0                                                   ; 3
	; 39 (GPU=??, want ??) +?
; 39
	sta     RESP1                                                   ; 3
	; 42 (GPU=??, want ??) +?
; 42

	lda     #$F0            ; opposite what you'd think             ; 2
	sta     HMP0                                                    ; 3
	lda     #$00                                                    ; 2
	sta     HMP1                                                    ; 3
; 52

	; turn on delay

	lda	#1							; 2
	sta	VDELP0							; 3
	sta	VDELP1							; 3
; 60
	lda	#0			; black bg			; 2
        sta	COLUBK							; 3
	sta	GRP0							; 3
	sta	GRP1							; 3
; 71
	sta     WSYNC
; 0
	sta     HMOVE           ; adjust fine tune, must be after WSYNC
; 3

	;=================================
	; scanline 218
	;=================================
; 3

;	sta	GRP0							; 3
;	sta	GRP1							; 3

; 14
	lda     #$E		; bright white                          ; 2
        sta     COLUP0          ; set sprite color                      ; 3
        sta     COLUP1          ; set sprite color                      ; 3
; 22
        ; set to be 48 adjacent pixels

	lda	#NUSIZ_THREE_COPIES_CLOSE				; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1							; 3
; 30
	; number of lines to draw
	ldx	#9							; 2
	stx	TEMP2							; 3
; 35
	lda	FRAMEL							; 3
	and	#$7F							; 2
	bne	no_credits_inc						; 2/3
; 42
	inc	CREDITS_COUNT						; 5
	lda	CREDITS_COUNT						; 3
	cmp	#3							; 2
	bne	no_credits_inc						; 2/3
; 54
	lda	#0							; 2
	sta	CREDITS_COUNT						; 3
; 59

no_credits_inc:
	ldx	CREDITS_COUNT						; 3
	lda	credits_offset,X					; 4
	sta	CREDITS_OFFSET						; 3
; 69
	clc
	adc	#4
	tax
;	inx
;	ldy	#0							; 2
;	ldx	#4							; 2
; 73
	sta	WSYNC							; 3

;==============================
; the 48-pixel sprite code
;==============================

raster_spriteloop:
; 0
	lda	lady_sprite0,X		; load sprite data		; 4+
	sta	GRP0			; 0->[GRP0] [GRP1 (?)]->GRP1	; 3
; 7
	lda	lady_sprite1,X		; load sprite data		; 4+
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3
; 14
	lda	lady_sprite2,X		; load sprite data		; 4+
	sta	GRP0			; 2->[GRP0], [GRP1 (1)]-->GRP1	; 3
; 21
	lda	lady_sprite5,X					; 4+
	sta	TEMP1			; save for later		; 3
; 28
        lda	lady_sprite4,X						; 4+
        tay				; save in Y			; 2
; 34
	lda	lady_sprite3,X						; 4+
	ldx	TEMP1                   ; restore saved value		; 3
; 41

        sta     GRP1                    ; 3->[GRP1], [GRP0 (2)]-->GRP0  ; 3
        ; (need this to be 44 .. 46)
; 44
        sty     GRP0                    ; 4->[GRP0], [GRP1 (3)]-->GRP1  ; 3
        ; (need this to be 47 .. 49)
; 47
        stx     GRP1                    ; 5->[GRP1], [GRP0 (4)]-->GRP0  ; 3
        ; (need this to be 50 .. 51)
; 50
        sty     GRP0                    ; ?->[GRP0], [GRP1 (5)]-->GRP1  ; 3
        ; (need this to be 52 .. 54)
; 53

        dec     TEMP2                                                   ; 5
        lda     TEMP2                   ; decrement count               ; 3
; 61
	lsr								; 2
	clc								; 2
	adc	CREDITS_OFFSET						; 3
	tax				; reset X to TEMP2/2		; 2
; 70

	lda	TEMP2							; 3
; 73
	bpl	raster_spriteloop                                        ; 2/3
        ; 76  (goal is 76)

; 75

        ;====================

	lda	#0
	sta	GRP0
	sta	GRP1
	sta	GRP0
	sta	GRP1

	sta	WSYNC


done_raster:

	;===========================
	;===========================
	; overscan (36 cycles) (30 on NTSC)
	;===========================
	;===========================
; 0
	; turn off everything
	lda	#0							; 2
	sta	GRP0							; 3
; 5
	lda	#2		; we do this in common			; 2
	sta	VBLANK		; but want it to happen in hblank	; 3
; 10
	lda	#0
	sta	GRP1							; 3
	sta	PF0							; 3
	sta	PF1							; 3
	sta	PF2							; 3
; 22

	jmp	effect_done


;raster_color:
;	.byte $00
;raster_color_red:
;	.byte $60,$62,$64,$66,$68,$6A,$6C,$6E
;raster_color_green:
;	.byte $50,$52,$54,$56,$58,$5A,$5C,$5E
;raster_color_blue:
;	.byte $B0,$B2,$B4,$B6,$B8,$BA,$BC,$BE

credits_offset:
	.byte 0,5,10
sunset_colors:
	.byte 22*2+16,20*2+16,27*2+16,26*2+16
	.byte 42*2+16,41*2+16,59*2+16,57*2+16
	.byte 83*2+16,97*2+16,96*2+16,90*2+16
	.byte 89*2+16,88*2+16,2*2+16,0

mountain_left:
	.byte $F0,$F0,$E0,$C0,$00,$00,$00,$00
mountain_center:
	.byte $FF,$FF,$FF,$FF,$FE,$00,$00,$00
mountain_right:
	.byte $0f,$07,$03,$00,$00,$00,$00,$00

