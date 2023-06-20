	;================================================
	; draws bitmap effect
	;================================================

.ifdef VCS_NTSC
BO = 32
.else
BO = 14	; bitmap offset
.endif

bitmap_effect:

	; 37

	sta	WSYNC

	; 38

	sta	WSYNC

	; 39

	sta	WSYNC

	; 40

	sta	WSYNC

	;=========================
	; 41 -- do bright effect
	;=========================

	lda	FRAMEL
	bpl	skip_bright_bg

	lda	#$ff

	bne	done_bright_bg		; bra

skip_bright_bg:
	lda	#$00

done_bright_bg:
	sta	PF1
	sta	PF2


	sta	WSYNC

	;===============================================
	; VBLANK scanline 42 -- setup animated sidebars
	;===============================================

; 0
	lda	#CTRLPF_REF	; reflect playfield			; 2
	sta	CTRLPF							; 3
; 5
	lda	TITLE_COLOR	; get color				; 3
	sta	COLUPF							; 3
; 11
	lda	FRAMEL		; every 8 frames inc color		; 3
	and	#$3							; 2
	bne	no_color						; 2/3
	inc	TITLE_COLOR						; 5
no_color:
; 23 (worst case)

	lda	FRAMEL							; 3
	lsr								; 2
	lsr								; 2
	lsr								; 2
	and	#$7							; 2
	tax								; 2
; 36
	lda	pattern,X		; get pattern			; 4
	sta	PF0			; and set left/right		; 3
; 43
skip_sidebar:
	sta	WSYNC


;jmp bbb
;.align $100
;bbb:


	;===============================================
	; VBLANK scanline 43 -- ???
	;===============================================

	sta	WSYNC

	;===============================================
	; VBLANK scanline 44 -- ???
	;===============================================

	; center the sprite position
	; needs to be right after a WSYNC
; 0
	; to center exactly would want sprite0 at
	;       CPU cycle 41.3
	; and sprite1 at
	;       GPU cycle 44

	ldx	#0              ; sprite 0 display nothing              ; 2
	stx	GRP0            ;                                       ; 3

	ldx	#6              ;                                       ; 2
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

	lda	#NUSIZ_THREE_COPIES_CLOSE				; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1							; 3
; 30
        ; turn on delay

	lda	#1							; 2
	sta	VDELP0							; 3
	sta	VDELP1							; 3
; 38
	; number of lines to draw

.ifdef	VCS_NTSC
	ldx	#190							; 2
.else
	ldx	#226							; 2
.endif
	stx	TEMP2							; 3

; 43
	ldy	#0							; 2

.ifdef VCS_NTSC
	ldx	#95							; 2
.else
	ldx	#113							; 2
.endif

	sta	WSYNC							; 3
;


	;=========================
	;=========================
	; kernel
	;=========================
	;=========================
	; 228 scanlines (192 on NTSC)

spriteloop:
; 0
	lda	lady_sprite0+BO,X	; load sprite data		; 4+
	sta	GRP0			; 0->[GRP0] [GRP1 (?)]->GRP1	; 3
; 7
	lda	lady_sprite1+BO,X	; load sprite data		; 4+
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3
; 14
	lda	lady_sprite2+BO,X	; load sprite data		; 4+
	sta	GRP0			; 2->[GRP0], [GRP1 (1)]-->GRP1	; 3
; 21
	lda	lady_sprite5+BO,X					; 4+
	sta	TEMP1			; save for later		; 3
; 28
        lda	lady_sprite4+BO,X					; 4+
        tay				; save in Y			; 2
; 34
	lda	lady_sprite3+BO,X					; 4+
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
;	nop
	lda	TEMP1

; 58
        dec     TEMP2                                                   ; 5
        lda     TEMP2                   ; decrement count               ; 3
	lsr								; 2
	tax				; reset X to TEMP2/2		; 2
	lda	TEMP2							; 3
	cmp	#2
; 73
	bne	spriteloop                                        ; 2/3
        ; 76  (goal is 76)



	;
	; draws 113 lines?
	; so 15 unused?

; 75
        ;====================


	lda	#0
	sta	GRP1
	sta	GRP0
	sta	GRP1							; 3

	sta	WSYNC
	sta	WSYNC

done_bitmap_kernel:

	sta	WSYNC

	jmp	effect_done


	; pattern for the side bars
pattern:
	.byte $80,$40,$20,$10,$10,$20,$40,$80

;.align $100
;.include "bitmap.inc"
