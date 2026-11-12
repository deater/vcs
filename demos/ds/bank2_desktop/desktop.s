	;==========================
	; desktop intro
	;==========================
	; potentially arrive here with an unknown number of cycles/scanlines
	; ideally VBLANK=2 (beam off)

; 31 (exit) + 3 (bank set) + 6 (jsr) = 40


	ldx	#0
krg_loop:
	lda	teapot_high,X
	sta	$1800,X			; 256 byte write destination
	inx
	bne	krg_loop


;	lda	#<$1900			; 256 byte source destination
;	sta	ZX0_src
;	lda	#>$1900
;	sta	ZX0_src+1

	lda	#2			; we're bank2
	sta	PAGE_SAVE

	lda     #$4
        sta     READ_WRITE_OFFSET

        lda     #<E7_256B_READ_ADDR
        sta     ZX0_src
        lda     #>E7_256B_READ_ADDR
        sta     ZX0_src_h

        lda     #>E7_BANK_BASE
        jsr     zx02_full_decomp


	; now need to copy from 1k RAM to 256-byte RAM

	ldx	#0
	ldy	#0
	lda	#2			; bank to return to
	jsr	bank7_to_256_copy

start_desktop:

	;=================
	; start VBLANK
	;=================
	; this code takes 4 scanlines, it does a WSYNC soon after
	;       to ensure 3 scanlines total
	; this means it's really stealing one of the previous frame's lines

	jsr	common_vblank

; 9

	;=============================
	;=============================
	;=============================
	; 37 lines of vertical blank
	;=============================
	;=============================
	;=============================


	;=============================
	; scanlines 0..21 (unused)
	;=============================

        ldx     #22
	jsr	repeat_wsync
; 8


	;================================
	; play music -- scanlines 22..33
	;================================
	; takes 11 lines, doesn't WSYNC

	lda	#2		; our bank
	jsr	do_play_music
	sta	WSYNC

	;====================
	; now in scanline 34
	;====================

	jsr	inc_frame

	; switch which teapot shown
	lda	FRAMEL
	lsr
	lsr
	lsr
	lsr
	and	#$3
	tax
	sta	E7_SET_256_BANK0,X

        sta     WSYNC


	;===================
	; now scanline 35
	;===================
	; center the sprite position
	; needs to be right after a WSYNC
; 0

	sta	WSYNC


	;=======================
	; scanline 36

	sta	WSYNC

	;=======================
	; scanline 37 -- config
; 0
	ldx	#0							; 2
	lda	#$A8
	sta	COLUBK							; 3

	; try to do this early enough to avoid on-screen arifact
	stx	VBLANK			; turn on beam			; 3

	stx	GRP0							; 3
	stx	GRP1							; 3
	stx	CTRLPF		; unreflect playfield			; 3
	stx	REFP1		; don't reflect sprite1			; 3

	ldy	#0							; 2

; ??
	sta	WSYNC



	;=============================================
	;=============================================
	; draw desktop
	;=============================================

	;=============================================
	; draw 112 lines first

irix_loop:
; 0
	lda	irix_colors,X	;					; 4
	sta	COLUPF		; set playfield color			; 3
	nop								; 2
	nop								; 2
; 11
	lda	irix_playfield0_left,X		;			; 4
	sta	PF0				;			; 3
	nop								; 2

	; must write by CPU 22 [GPU 68]
; 20
	lda	irix_playfield1_left,X		;			4+
	sta	PF1				;			3
	; must write by CPU 28 [GPU 84]
; 27
	lda	irix_playfield2_left,X		;			4+
	sta	PF2				;			3
	; must write by CPU 38 [GPU 116]
; 34

	nop					;			2
	lda	irix_playfield0_right,X	;			4+
	sta	PF0				;			3
	; must write by CPU 49 [GPU 148]
; 43
	lda	irix_playfield1_right,X	;			4+
	sta	PF1				;			3
	; must write by CPU 54 [GPU 164]
; 50

	lda	$80				; nop3			3
	lda	irix_playfield2_right,X	;			4+
	sta	PF2				;			3
	; must write by CPU 65 [GPU 196]
; 60

        iny                                                             ; 2
;        tya                                                             ; 2
;        and     #$3                                                     ; 2
;        beq     yes_inx                                                 ; 2/3
;        .byte   $A5     ; begin of LDA ZP                               ; 3
yes_inx:
        inx             ; $E8 should be harmless to load                ; 2
done_inx:
                                                                ;===========
                                                                ; 11/11

	nop
	nop
	lda	$80

; 71
	cpy	#112							; 2
	bne	irix_loop						; 2/3

; 76

	jmp	oof
.align $100
oof:

	;===========================================================
	;===========================================================
	; draw 38*2 = 76 lines of sprites
	;===========================================================
	;===========================================================

	;===========================
	; scanline 112 -- configure
	;===========================
	; configure 48-pixel sprite code

	; make playfield black
	nop
	lda	#$00		; black					; 2
	sta	COLUPF		; playfield color			; 3
	sta	GRP0		; turn off sprites			; 3
	sta	GRP1		;					; 3
	sta	PF0		; turn off playfield so don't collide	; 3
	sta	PF1		;					; 3

	lda	#CTRLPF_REF
	sta	CTRLPF

	lda	#$fc
	sta	PF2		;					; 3

; 22
	; set color

	lda	#$1E		; bright white				; 2
	sta	COLUP0		; set sprite color			; 3
	sta	COLUP1		; set sprite color			; 3
; 31
	; set to be 48 adjacent pixels

	lda	#NUSIZ_THREE_COPIES_CLOSE				; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1							; 3
; 39
	; turn on delay

	lda	#1							; 2
	sta	VDELP0							; 3
	sta	VDELP1							; 3
; 47
	; number of lines to draw
	ldx	#36
	stx	SPRITE_OFFSET
	ldx	#72							; 2
	stx	SPRITE_LENGTH							; 3
; 52
	sta	WSYNC							; 3

	;====================================
	; now scanline 113 -- center sprite
	;====================================
	; center the sprite position
	; needs to be right after a WSYNC
; 0
	; to center exactly would want sprite0 at
	;	CPU cycle 41.3
	; and sprite1 at
	;	GPU cycle 44

	ldx	#0		; sprite 0 display nothing		; 2
	stx	GRP0		;					; 3

	ldx	#6		;					; 2
; 7

tpad_x:
	dex			;					; 2
	bne	tpad_x		;					; 2/3
	; for X delays (5*X)-1
	; so in this case, 29
; 36
	; beam is at proper place
	sta	RESP0							; 3
	; 39 (GPU=??, want ??) +?
; 39
	sta	RESP1							; 3
	; 42 (GPU=??, want ??) +?
; 42

	lda	#$E0		; opposite what you'd think		; 2
	sta	HMP0							; 3
	lda	#$F0							; 2
	sta	HMP1							; 3
; 52
	sta	WSYNC
; 0
	sta	HMOVE		; adjust fine tune, must be after WSYNC
; 3


	;===================
	; now scanline 114
	;===================

	ldx	SPRITE_OFFSET	; restore sprite offset

	sta	WSYNC

	;===================
	; now scanline 115
	;===================
	; 76 scalines of frameloop

title_spriteloop:
; 0
	lda	$1900,X			; load sprite0 data		; 4+
	sta	GRP0			; 0->[GRP0] [GRP1 (?)]->GRP1	; 3
; 7
	lda	$1924,X			; load sprite1 data		; 4+
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3
; 14
	lda	$1948,X			; load sprite2 data		; 4+
	sta	GRP0			; 2->[GRP0], [GRP1 (1)]-->GRP1	; 3
; 21

	lda	$19B4,X			; sprite5			; 4+
	sta	TEMP1			; save for later		; 3
; 28
	lda	$1990,X			; sprite4			; 4+
	tay				; save in Y			; 2
; 34
	lda	$196c,X			; sprite3			; 4+
	ldx	TEMP1			; restore saved value		; 3
; 41

	sta	GRP1			; 3->[GRP1], [GRP0 (2)]-->GRP0	; 3
	; (need this to be 44 .. 46)
; 44
	sty	GRP0			; 4->[GRP0], [GRP1 (3)]-->GRP1	; 3
	; (need this to be 47 .. 49)
; 47
	stx	GRP1			; 5->[GRP1], [GRP0 (4)]-->GRP0	; 3
	; (need this to be 50 .. 51)
; 50
	sty	GRP0			; ?->[GRP0], [GRP1 (5)]-->GRP1 	; 3
	; (need this to be 52 .. 54)
; 53

	; need 12 cycles of nops
;	inc	TEMP1		; nop5					; 5
;	inc	TEMP1		; nop5					; 5
	nop								; 2

; 65

	dec	SPRITE_LENGTH						; 5
;	ldx	SPRITE_LENGTH		; decrement count		; 3
;
	lda	SPRITE_LENGTH						; 3
	lsr								; 2
	sta	SPRITE_OFFSET						; 3
	tax								; 2
	lda	SPRITE_LENGTH		; check for zero

; 73
	bpl	title_spriteloop					; 2/3
	; 76  (goal is 76)


; 75


	;===========================
	; scanline 115+76 = 191
	;===========================

	;=========================
	; done drawing line

	ldy	#0		; clear out sprite data			; 2
	sty	GRP1							; 3
	sty	GRP0							; 3
	sty	GRP1							; 3

	lda	#$0		; end the black window
	sta	PF2

	sta	WSYNC


	;=============================
	; draw bottom 4 lines

	ldx	#3
	jsr	repeat_wsync

	lda	#0		 ; avoid uneven line at bottom
	sta	COLUBK

done_loop:

; 75

	;==========================
	; overscan for 30 scanlines
	;==========================

	ldx	#29
	jsr	common_overscan

	lda	FRAMEL
	cmp	#DESKTOP_TIME_L
	bne	not_done_desktop
	lda	FRAMEH
	cmp	#DESKTOP_TIME_H
	beq	done_desktop

not_done_desktop:
        jmp     start_desktop						; 3

done_desktop:

	rts


.include "irix_pf.inc"
;.include "teapot0.inc"

teapot_high:
.incbin "teapot_high.zx02"
