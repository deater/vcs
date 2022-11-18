	;================================================
	; draws fireworks effect
	;================================================

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
	lda	SPRITE0_COLOR						; 3
	and	#$0e							; 2
	asl								; 2
	asl								; 2
	sta	FIREWORK_PROGRESS0					; 3
; 18

	lda	SPRITE1_COLOR						; 3
	and	#$0e							; 2
	asl								; 2
	asl								; 2
	sta	FIREWORK_PROGRESS1					; 3
; 30

	; other init

	; E C A 8 6 4 2 0

	ldy	#0							; 2
	lda	SPRITE0_COLOR						; 3
	and	#$E							; 2
	bne	set_bg							; 2/3
	ldy	#$12							; 2
set_bg:
; 41
        sty	COLUBK							; 3
; 44
	sta	VDELP0							; 3
	sta	VDELP1		; turn off delay			; 3
; 50
	lda	#NUSIZ_DOUBLE_SIZE					; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1							; 3

; 57

;	lda	#NUSIZ_ONE_COPY						; 2
;	sta	NUSIZ1							; 3


	sta	WSYNC
	sta	HMOVE		; finalize fine adjust

	;=================================
	; VBLANK scanline 45
	;=================================
; 3
	lda	#0							; 2
	sta	VBLANK                  ; turn on beam			; 3
; 8

	lda	#0							; 2
	sta	COLUPF			; fg, black			; 3
	sta	GRP0			; sprite 0			; 3
	sta	GRP1			; sprite 1			; 3
	sta	PF0			;				; 3
	sta	PF1			;				; 3
	sta	PF2							; 3
; 23
	ldy	#0							; 2
	ldx	#0							; 2
;	txa			; needed so top line is black		; 2


; 27
	lda	#CTRLPF_REF		; reflect playfield		; 2
	sta	CTRLPF							; 3
; 32
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
	ldx	#99
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



; 4

credits_bitmap:

	sta	WSYNC
	nop

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


done_firework:

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


.include "adjust_sprites.s"
