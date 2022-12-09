
	;=====================================
	; comes in with 12 scanlines left (?)
	; so let's say scanline 180?

; ?

	jmp	credits_bitmap
.align $100
credits_bitmap:

	ldx	#0			; turn off existing sprites	; 2
	stx	GRP0            ;                                       ; 3
	stx	GRP1							; 3
	sta	WSYNC

	;=================================
	; scaline 181
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
	; scanline 182
	;=================================
; 3
	lda     #$5A		; bright purple				; 2
        sta     COLUP0          ; set sprite color                      ; 3
        sta     COLUP1          ; set sprite color                      ; 3
; 11
        ; set to be 48 adjacent pixels

	lda	#NUSIZ_THREE_COPIES_CLOSE				; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1							; 3
; 19
	; number of lines to draw
	ldx	#16							; 2
	stx	TEMP2							; 3
; 24
	lda	FRAMEL		; only increment every 128 frames	; 3
	and	#$7F							; 2
	bne	no_credits_inc						; 2/3
; 31
	inc	CREDITS_COUNT	; which line to display			; 5
	lda	CREDITS_COUNT						; 3
	cmp	#6		; wrap at 6				; 2
	bne	no_credits_inc						; 2/3
; 43
	lda	#0		; reset count				; 2
	sta	CREDITS_COUNT						; 3
; 48

no_credits_inc:
	ldx	CREDITS_COUNT						; 3
	lda	credits_offset,X					; 4
	sta	CREDITS_OFFSET	; offset to use in credits read		; 3

	tax								; 2
; 64
	sta	WSYNC							; 3

;==============================
; the 48-pixel sprite code
;==============================

raster_spriteloop:
; 0
	lda	text_sprite0,X		; load sprite data		; 4+
	sta	GRP0			; 0->[GRP0] [GRP1 (?)]->GRP1	; 3
; 7
	lda	text_sprite1,X		; load sprite data		; 4+
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3
; 14
	lda	text_sprite2,X		; load sprite data		; 4+
	sta	GRP0			; 2->[GRP0], [GRP1 (1)]-->GRP1	; 3
; 21
	lda	text_sprite5,X					; 4+
	sta	TEMP1			; save for later		; 3
; 28
        lda	text_sprite4,X						; 4+
        tay				; save in Y			; 2
; 34
	lda	text_sprite3,X						; 4+
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
	sec								; 2
	adc	CREDITS_OFFSET						; 3
	tax				; reset X to TEMP2/2		; 2
; 70

	lda	TEMP2							; 3
; 73
	bpl	raster_spriteloop					; 2/3
        ; 76  (goal is 76)

; 75

        ;==========================
	; clear out queue at end
	lda	#0
	sta	GRP0
	sta	GRP1
	sta	GRP0
	sta	GRP1

	sta	WSYNC


