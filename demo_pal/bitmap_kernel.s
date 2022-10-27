
	;================================================
	; draws bitmap effect
	;================================================

bitmap_effect:

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
jmp bbb
.align $100
bbb:
	sta	WSYNC


	        ; center the sprite position
        ; needs to be right after a WSYNC
; 0
        ; to center exactly would want sprite0 at
        ;       CPU cycle 41.3
        ; and sprite1 at
        ;       GPU cycle 44

        ldx     #0              ; sprite 0 display nothing              ; 2
        stx     GRP0            ;                                       ; 3

        ldx     #6              ;                                       ; 2
; 7

tpad_x:
        dex                     ;                                       ; 2
        bne     tpad_x          ;                                       ; 2/3
        ; for X delays (5*X)-1
        ; so in this case, 29
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
        sta     WSYNC
; 0
        sta     HMOVE           ; adjust fine tune, must be after WSYNC
; 3



	;=================================
	; VBLANK scanline 45
	;=================================
; 3
	lda	#0							; 2
	sta	VBLANK                  ; turn on beam			; 3
; 8
	lda	#0			; black bg			; 2
        sta	COLUBK							; 3
; 13
	lda     #$E		; bright white                          ; 3
        sta     COLUP0          ; set sprite color                      ; 3
        sta     COLUP1          ; set sprite color                      ; 3
; 22
        ; set to be 48 adjacent pixels

        lda     #NUSIZ_THREE_COPIES_CLOSE                               ; 2
        sta     NUSIZ0                                                  ; 3
        sta     NUSIZ1                                                  ; 3
; 30
        ; turn on delay

        lda     #1                                                      ; 2
        sta     VDELP0                                                  ; 3
        sta     VDELP1                                                  ; 3
; 38
        ; number of lines to draw
        ldx     #228                                                   ; 2
	stx	TEMP2


; 40
;	lda	#0							; 2
;	sta	VDELP0							; 3
;	sta	VDELP1		; turn off delay			; 3
; 48

;	lda	#NUSIZ_QUAD_SIZE|NUSIZ_MISSILE_WIDTH_8			; 2
;	sta	NUSIZ0							; 3
;	lda	#NUSIZ_QUAD_SIZE|NUSIZ_MISSILE_WIDTH_8			; 2
;	sta	NUSIZ1							; 3
; 58

;	lda	#2							; 2
;	sta	COLUPF			; fg, dark grey			; 3

; 63
	ldy	#0							; 2
	ldx	#114							; 2
	sta	WSYNC							; 3
; 70


	;=========================
	;=========================
	; kernel
	;=========================
	;=========================
	; 228 scanlines (192 on NTSC)

spriteloop:
; 0
	lda	lady_sprite0+13,X		; load sprite data		; 4+
	sta	GRP0			; 0->[GRP0] [GRP1 (?)]->GRP1	; 3
; 7
	lda	lady_sprite1+13,X		; load sprite data		; 4+
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3
; 14
	lda	lady_sprite2+13,X		; load sprite data		; 4+
	sta	GRP0			; 2->[GRP0], [GRP1 (1)]-->GRP1	; 3
; 21
	lda	lady_sprite5+13,X						; 4+
	sta	TEMP1			; save for later		; 3
; 28
        lda	lady_sprite4+13,X						; 4+
        tay				; save in Y			; 2
; 34
	lda	lady_sprite3+13,X						; 4+
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

        ; need 5 cycles of nops
	nop
	lda	TEMP1

; 65
        dec     TEMP2                                                   ; 5
        lda     TEMP2                   ; decrement count               ; 3
	lsr								; 2
	tax								; 2
	lda	TEMP2
; 73
	bne	spriteloop                                        ; 2/3
        ; 76  (goal is 76)


; 75
        ;====================




;	ldx	#0
;draw_bitmap:

;	sta	WSYNC							; 3
;	inx
;	cpx	#100
;	bne	draw_bitmap


done_bitmap_kernel:

	sta	WSYNC

	;===========================
	;===========================
	; overscan (36 cycles) (30 on NTSC)
	;===========================
	;===========================

	; turn off everything
;	lda	#0							; 2
;	sta	GRP0							; 3
; 1
	lda	#2		; we do this in common
	sta	VBLANK		; but want it to happen in hblank


	lda	#0
	sta	GRP1
	sta	GRP0
	sta	GRP1							; 3

	sta	PF0							; 3
	sta	PF1							; 3
	sta	PF2							; 3
; 13

	jmp	effect_done

.align $100
.include "bitmap.inc"
