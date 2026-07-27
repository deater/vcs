	;============================================
	;============================================
	; center_string
	;============================================
	;============================================

	; comes in likely +12 cycles

center_string:

	;===================
	; now scanline 0
	;===================
	; center the sprite position
	; needs to be right after a WSYNC
; 6
	; to center exactly would want
	;	sprite0: ??
	;	sprite1: ??

	ldx	#3		;					; 2
; 2

pspad_x:
	dex			;					; 2
	bne	pspad_x		;					; 2/3

	; (5*X)-1 each time through
	;	so if X=3 then 14

	; X should be 0 here
; 16
	stx	VDELP0		; turn off delay			; 3
	stx	VDELP1							; 3
; 22

;	lda	LEVEL_COLOR	; orange by default			; 3
;	sta	COLUPF  	; set playfield color			; 3
;	lda	$80		; nop3					; 3

; 37

	; want to be 37 here

	; beam is at proper place
	sta	RESP0							; 3
	; 40 (GPU=120, want ??) +?
	sta	RESP1							; 3
	; 43 (GPU=129, want ??) +?

; 43

	lda	#$90		; opposite what you'd think		; 2
	sta	HMP0							; 3
	lda	#$A0							; 2
	sta	HMP1							; 3
; 53

	; set color of sprite

	lda	#$0E	; bright white					; 2
	sta	COLUP0	; set sprite color				; 3
	sta	COLUP1	; set sprite color				; 3

; 61

	; set to be 32 adjacent pixels

;	lda	#NUSIZ_TWO_COPIES_CLOSE					; 2
;	sta	NUSIZ0							; 3
;	sta	NUSIZ1							; 3

; 69

	sta	WSYNC							; 3

	;===================
	; now scanline 1
	;===================
; 0
	sta	HMOVE	; adjust fine tune, must be after WSYNC		; 3

	rts

; exits with +9
