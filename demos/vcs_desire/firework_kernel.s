	;================================================
	; draws fireworks effect
	;================================================

sunset_colors:

.ifdef VCS_NTSC
	.byte 0,0
	.byte  31*2, 31*2,127*2,127*2
	.byte 126*2,125*2, 21*2, 20*2
	.byte  35*2, 42*2, 50*2, 49*2
	.byte  65*2, 64*2
.else
	.byte 0,0
	.byte 15*2+16,15*2+16,14*2+16,14*2+16
	.byte 13*2+16,12*2+16,28*2+16,27*2+16
	.byte 43*2+16,58*2+16,73*2+16,89*2+16
	.byte 97*2+16,96*2+16 ;,0*2+16,0
.endif



mountain_left:
	.byte $F0,$F0,$E0,$C0,$00,$00,$00,$00
mountain_center:
	.byte $FF,$FF,$FF,$FF,$FE,$00,$00,$00
mountain_right:
	.byte $0f,$07,$03,$00,$00,$00,$00,$00

firework7:
	.byte $10,$44,$00,$82,$00,$44,$10,$00
firework6:
	.byte $10,$44,$00,$82,$00,$44,$10,$00
firework5:
	.byte $10,$44,$00,$82,$00,$44,$10,$00
firework4:
	.byte $10,$44,$00,$82,$00,$44,$10,$00

firework3:
	.byte $10,$44,$00,$82,$00,$44,$10,$00
firework2:
	.byte $00,$10,$28,$44,$28,$10,$00,$00
firework1:
	.byte $00,$00,$10,$28,$10,$00,$00,$00
firework0:
	.byte $00,$00,$00,$10,$00,$00,$00,$00

firework_effect:
; 26
	sta	WSYNC

	;=========================================
	; scanline 39: update firework0
	;=========================================
; 0
	lda	SPRITE0_COLOR						; 3
	and	#$f							; 2
	bne	not_new_firework					; 2/3
new_firework:
; 7
	; new firework color
	ldx	FRAMEL							; 3
	lda	$F000,X							; 4
	ora	#$0F							; 2
	and	#$FE							; 2
	sta	SPRITE0_COLOR						; 3
; 21
	; new X
	lda	$F100,X			; sorta random			; 4
	and	#$7F			; 0..127			; 2
	sta	SPRITE0_X						; 3
; 30
	; new Y
	lda	$F200,X			; sorta random			; 4
	and	#$3F			; 0..127			; 2
	sta	SPRITE0_Y						; 3
; 39

not_new_firework:
	lda	FRAMEL							; 3
	and	#$7							; 2
	bne	skip_progress						; 2/3
; 46
	dec	SPRITE0_COLOR						; 5
	dec	SPRITE0_COLOR						; 5
; 56
skip_progress:
	lda	SPRITE0_COLOR						; 3
	sta	COLUP0							; 3

; 62
	sta	WSYNC

	;=========================================
	; scanline 40: update firework1
	;=========================================
; 0
	lda	SPRITE1_COLOR						; 3
	and	#$f							; 2
	bne	not_new_firework1					; 2/3
new_firework1:
; 7
	; new firework color
	ldx	FRAMEL							; 3
	lda	$F300,X							; 4
	ora	#$0F							; 2
	and	#$FE							; 2
	sta	SPRITE1_COLOR						; 3
; 21
	; new X
	lda	$F400,X			; sorta random			; 4
	and	#$7F			; 0..127			; 2
	sta	SPRITE1_X						; 3
; 30
	; new Y
	lda	$F500,X			; sorta random			; 4
	and	#$3F			; 0..127			; 2
	sta	SPRITE1_Y						; 3
; 39

not_new_firework1:
	lda	FRAMEL							; 3
	and	#$7							; 2
	bne	skip_progress1						; 2/3
; 46
	dec	SPRITE1_COLOR						; 5
	dec	SPRITE1_COLOR						; 5
; 56
skip_progress1:
	lda	SPRITE1_COLOR						; 3
	sta	COLUP1							; 3

; 62
	sta	WSYNC

	;=========================================
	; scanline 41/42/43
	;=========================================

	jsr	adjust_sprites

; 6


	;============]========================
	; scanline 44: setup firework progress
	;====================================
; 6
	;	E C A 8  6  4  2  0
	;               24 16  8  0

	; firework0 progress
	lda	SPRITE0_COLOR						; 3
	and	#$0e							; 2
	asl								; 2
	asl								; 2
	sta	FIREWORK_PROGRESS0					; 3
; 18
	; firework1 progress
	lda	SPRITE1_COLOR						; 3
	and	#$0e							; 2
	asl								; 2
	asl								; 2
	sta	FIREWORK_PROGRESS1					; 3
; 30
	;==================================
	; set sky color

	ldy	SKY_COLOR						; 3
	lda	sky_colors,Y						; 4
	tay								; 2
	bne	set_bg			; only if dark			; 2/3
	lda	SPRITE0_COLOR						; 3
	and	#$E			; if exploding make bright	; 2
	bne	set_bg							; 2/3
	ldy	#$12							; 2
set_bg:
        sty	COLUBK							; 3
; 53
	sta	VDELP0							; 3
	sta	VDELP1		; turn off delay			; 3
; 59
	lda	#NUSIZ_DOUBLE_SIZE					; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1							; 3
; 67


	sta	WSYNC
	sta	HMOVE		; finalize fine adjust

	;=================================
	; VBLANK scanline 45
	;=================================
; 3
	lda	#0							; 2
	sta	VBLANK                  ; turn on beam			; 3
; 8

;	lda	#0							; 2
	sta	COLUPF			; fg, black			; 3
	sta	PF0			;				; 3
	sta	GRP0			; sprite 0			; 3
	sta	GRP1			; sprite 1			; 3
	sta	PF1			;				; 3
	sta	PF2							; 3
; 26
;	ldy	#0							; 2
;	ldx	#0							; 2


; 27
	lda	#CTRLPF_REF		; reflect playfield		; 2
	sta	CTRLPF							; 3
; 32
	; darken the sky
	lda	SKY_COLOR						; 3
	cmp	#6							; 2
	beq	sky_fine						; 2/3
; 39
	lda	FRAMEL							; 3
	and	#$7f							; 2
	bne	sky_fine						; 2/3
; 48
	inc	SKY_COLOR						; 5
; 53

sky_fine:


	sta	WSYNC							; 3



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
; 2/3
	; X = 100, SPRITE_Y = 100, 0
	; X = 99, SPRITE_Y = 100, -1
	; X = 101, SPRITE_Y= 100, 1
	; X = 116, SPRITE_Y= 100, 16

	ldy	#$0							; 2
	txa								; 2
	sbc	SPRITE0_Y						; 3
	cmp	#32							; 2
	bcs	no_firework0						; 2/3
	lsr								; 2
	lsr								; 2
	clc								; 2
	adc	FIREWORK_PROGRESS0					; 2
	tay								; 2
	lda	firework7,Y						; 4
	tay								; 2
no_firework0:
	sty	GRP0							; 3
								;==========
								; 30 worst


	ldy	#$0							; 2
	txa								; 2
	sbc	SPRITE1_Y						; 3
	cmp	#32							; 2
	bcs	no_firework1						; 2/3
	lsr								; 2
	lsr								; 2
	clc								; 2
	adc	FIREWORK_PROGRESS1					; 2
	tay								; 2
	lda	firework7,Y						; 4
	tay								; 2
no_firework1:
	sty	GRP1							; 3
								;==========
								; 30 worst

	inx								; 2
	cpx	#99							; 2
	sta	WSYNC

	bne	sky_loop						; 2/3

	;=========================
	; mountains
	;=========================
	; 16 scanlines
mountain_playfield:
	ldx	#15							; 2
mountain_loop:
; 5 worst case
	lda	sunset_colors,X			; sunset background	; 4
	sta	COLUBK							; 3
; 12
	lda	#$2				; mountain fg		; 2
	sta	COLUPF							; 3
; 17

	txa								; 2
	lsr								; 2
	tay				; Y is X/2			; 2
	lda	mountain_left,Y						; 4
	sta	PF0							; 3
	lda	mountain_center,Y					; 4
	sta	PF1							; 3
	lda	mountain_right,Y					; 4
	sta	PF2							; 3

	sta	WSYNC
	dex
	bne	mountain_loop

	;=========================
	; ground
	;=========================
	; 100 scanlines (64 on NTSC)
ground_playfield:

.ifdef VCS_NTSC
	ldx	#49
.else
	ldx	#85
.endif

ground_loop:

.ifdef VCS_NTSC
;	lda	#(96*2)		; dark green
	lda	#(104*2)	; dark green
.else
	lda	#$50		; dark green
.endif
	sta	COLUBK

	lda	#$00
	sta	PF0
	sta	PF1
	sta	PF2


	sta	WSYNC
	dex
	bne	ground_loop



; 4

credits_bitmap:

	ldx	#0
	stx	GRP0            ;                                       ; 3
	stx	GRP1							; 3
	sta	WSYNC

	;=================================
	; scaline 217
	;=================================

; 0
	; to center exactly would want sprite0 at
	;       CPU cycle 41.3
	; and sprite1 at
	;       GPU cycle 44

	stx	COLUBK							; 3
	nop								; 2
	inc	TEMP1		; nop5					; 5

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
	lda     #$E		; bright white                          ; 2
        sta     COLUP0          ; set sprite color                      ; 3
        sta     COLUP1          ; set sprite color                      ; 3
; 11
        ; set to be 48 adjacent pixels

	lda	#NUSIZ_THREE_COPIES_CLOSE				; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1							; 3
; 19
	; number of lines to draw
	ldx	#24							; 2
	stx	TEMP2							; 3
; 24
	lda	FRAMEL		; only increment every 128 frames	; 3
	and	#$7F							; 2
	bne	no_credits_inc						; 2/3
; 31
	inc	CREDITS_COUNT	; which line to display			; 5
	lda	CREDITS_COUNT						; 3
	cmp	#4		; wrap at 5				; 2
	bne	no_credits_inc						; 2/3
; 43
	lda	#0		; reset count				; 2
	sta	CREDITS_COUNT						; 3
; 48

no_credits_inc:
	ldx	CREDITS_COUNT						; 3
	lda	credits_offset,X					; 4
	sta	CREDITS_OFFSET	; offset to use in credits read		; 3
; 58
;	clc								; 2
;	adc	#6							; 2
	tax								; 2
; 64
	sta	WSYNC							; 3

;==============================
; the 48-pixel sprite code
;==============================

raster_spriteloop:
; 0
	lda	credits_sprite0,X		; load sprite data		; 4+
	sta	GRP0			; 0->[GRP0] [GRP1 (?)]->GRP1	; 3
; 7
	lda	credits_sprite1,X		; load sprite data		; 4+
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3
; 14
	lda	credits_sprite2,X		; load sprite data		; 4+
	sta	GRP0			; 2->[GRP0], [GRP1 (1)]-->GRP1	; 3
; 21
	lda	credits_sprite5,X					; 4+
	sta	TEMP1			; save for later		; 3
; 28
        lda	credits_sprite4,X						; 4+
        tay				; save in Y			; 2
; 34
	lda	credits_sprite3,X						; 4+
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
	bpl	raster_spriteloop					; 2/3
        ; 76  (goal is 76)

; 75

        ;====================

	lda	#0
	sta	GRP0
	sta	GRP1
	sta	GRP0
	sta	GRP1

	sta	WSYNC


done_firework:

	jmp	effect_done

credits_offset:
	.byte 1,19,13,7

sky_colors:
.ifdef VCS_NTSC
	.byte (48*2),(48*2),(64*2),(72*2),2,2,0
.else
	.byte (96*2)+16,(96*2)+16,(88*2)+16,(80*2)+16,2+16,2+16,0
.endif

.include "adjust_sprites.s"
