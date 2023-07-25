; Implement the linking book...

.include "../locations.inc"

	book_edge_colors 	= E7_256B_READ_ADDR
	page1_colors		= E7_256B_READ_ADDR+48
	page1_sprite		= E7_256B_READ_ADDR+96
	page2_colors		= E7_256B_READ_ADDR+144
	page2_sprite		= E7_256B_READ_ADDR+192

	;=====================
	; Linking Book
	;=====================
	; jumps here after switching to BANK6

book_common:
; ?
	lda	#20			; debounce button press		; 2
	sta	INPUT_COUNTDOWN						; 3
; 5
	; get which book we are for lookup purposes

	lda	CURRENT_LOCATION					; 3
	sec								; 2
	sbc	#8							; 2
	sta	WHICH_BOOK						; 3
; 15
	tax								; 2
; 17
	; decompress book data into RAM at $1800 write/ $1900 read

	lda	#$1							; 2
	sta	READ_WRITE_OFFSET					; 3
; 22
	lda     book_data_l,X						; 4+
	sta     ZX0_src							; 3
	lda     book_data_h,X						; 4+
	sta     ZX0_src_h						; 3
; 36


	;======================
	; setup in advance

	jsr	common_vblank

	lda	#18
	sta	T1024T



	lda	#>E7_256B_WRITE_ADDR					; 2
; 38
	jsr     zx02_full_decomp					; 6

	; hack, the generic code finishes 4 scanlines early

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC



book_frame:

	;============================
	; start VBLANK
	;============================
	; in scanline 0

	jsr	common_vblank

	;=================================
	;=================================
	; 37 lines of vertical blank
	;=================================
	;=================================

	; in VBLANK scanline 0

	ldx	#22
	jsr	common_delay_scanlines


	;=============================
	; vblank scanline 22
	;=============================
	; copy in hand sprite
	; takes 6 scanlines

	jsr	pointer_update

; 6

	;=======================
	; vblank scanline 28
	;=======================
	; inc frame
	; setup missile1 (left edge of book)
	; setup missile0 (spine of book)

; 6
	inc	FRAME							; 5
; 11
	ldx	#3							; 2
; 13
bzpad_x:
	dex			;					; 2
	bne	bzpad_x		; (X*5)-1, X=3=14			; 2/3


; 27
	sta	RESM1		; adjust missile1 location for		; 3
				; left edge of book

; 30
	inc	TEMP1							; 5
	inc	TEMP1							; 5
	nop								; 2
	nop								; 2
; 44
	sta	RESM0		; adjust missile0 location		; 3
				; for spine of book
; 47
	lda	#$60		; fine tune missile1 (book edge)	; 2
	sta	HMM1							; 3
; 52
	lda	#$E0		; fine tune missile1 (book edge)	; 2
	sta	HMM0							; 3

	sta	WSYNC							; 3


	;=============================
	; now VBLANK scanline 29
	;=============================
	; do some init
; 0
	ldx	#$00							; 2
	stx	COLUBK			; set background color to black	; 3
	stx	CURRENT_SCANLINE	; reset scanline counter	; 3
; 8

	; code to change page animation

	; always in same page
	lda	#>page1_colors
	sta	INH
	sta	OUTH

	lda	FRAME							; 3
	and	#$20							; 2
	beq	frame_odd
frame_even:
	lda	#<page1_sprite+2
	sta	INL
	lda	#<page1_colors+2
	jmp	done_update_animation

frame_odd:
	lda	#<page2_sprite+2
	sta	INL
	lda	#<page2_colors+2

done_update_animation:
	sta	OUTL

	sta	WSYNC

	;=========================
	; VBLANK scanline 30+31+32
	;=========================

	;==========================================
	; set up sprite1 to be at proper X position
	;==========================================
	; this is the right hand part of book

; 0
	lda	#96							; 2
	ldx	#POS_SPRITE1						; 2
	jsr	set_pos_x						;6+...
; 6

	;=========================================
	; vblank 33,34,35
	;==========================================
	; set up pointer (sprite0) to be at proper X position
	;==========================================

; 6
	lda	POINTER_X						; 3
	ldx	#POS_SPRITE0						; 2
	jsr	set_pos_x						;6+...

; 6

	;=========================================
	; vblank 36
	;==========================================

	sta	WSYNC							; 3
	sta	HMOVE		; adjust fine tune, must be after WSYNC	; 3
				; also draws black artifact on left of
				; screen

	;==========================================
	; now vblank 37
	;==========================================
	; Final setup before going
	;==========================================

; 3 (from HMOVE)
	lda	#$0							; 2
	sta	PF0			; disable playfield		; 3
	sta	PF1							; 3
	sta	PF2							; 3
; 14

	; setup hand sprite

	lda	#$24		; middle orange				; 2
	sta	COLUP0		; set hand color (sprite0)		; 3
; 19
	lda	#$0C		; off white				; 2
	sta	COLUP1		; set page color (sprite1)		; 3
; 24
	lda	#NUSIZ_DOUBLE_SIZE|NUSIZ_MISSILE_WIDTH_8		; 2
	sta	NUSIZ0							; 3
	lda	#NUSIZ_QUAD_SIZE|NUSIZ_MISSILE_WIDTH_4			; 2
	sta	NUSIZ1							; 3
; 34
	ldy	#0		; Y=current block (scanline/4)		; 2
; 36

	lda	#0							; 2
	sta	VBLANK			; turn on beam			; 3
	sta	POINTER_ON						; 3
; 44
	lda	#CTRLPF_REF		; reflect playfield		; 2
	sta	CTRLPF							; 3
; 49

	lda	#0			; bg color			; 2
	sta	COLUBK							; 3
; 54
	sta	WSYNC							; 3

	;===========================================
	;===========================================
	;===========================================
	; draw playfield, 192 scanlines
	;===========================================
	;===========================================
	;===========================================

	;==========================
	; draw top eight lines

	;==========================
	; black line (4 lines)
	;==========================

	; in playfield scanline 0
	lda	#$00		; black					; 2
	sta	COLUPF							; 3

	ldx	#4
	jsr	common_delay_scanlines

;	sta	WSYNC
	; in playfield scanline 1

;	sta	WSYNC

	; in playfield scanline 2

;	sta	WSYNC

	; in playfield scanline 3

;	sta	WSYNC

	;==========================
	; grey line (4 lines)
	;==========================

	; in playfield scanline 4
; 0
	lda	#$04		; dark grey				; 2
	sta	COLUPF							; 3
	lda	#$7F		; overhanging page			; 2
	sta	PF1							; 3
	lda	#$FF							; 2
	sta	PF2							; 3
; 15
	sta	WSYNC

	; in playfield scanline 5

	sta	WSYNC

	; in playfield scanline 6

	sta	WSYNC

	; in playfield scanline 7
; 0
	; delay things a bit so we enable towards the end of the scanline
	ldx	#6
; 2
pbook_x:
	dex			;					2
	bne	pbook_x		; (6*5)-1 = 29				2/3
; 31
	lda	#$2							; 2
	sta	ENAM0	; enable missile 0				; 3
	sta	ENAM1	; enable missile 1				; 3
; 39
	lda	#$3F		; Set playfield				; 2
	sta	PF1							; 3
	lda	#$FF							; 2
        sta	PF2							; 3
; 49



	sta	WSYNC




	jmp	book_draw_playfield_plus_3				; 3

book_draw_playfield:



	;================================
	;================================
	; draw playfield EVEN
	;================================
	;================================
	; playfield scanlines 8 .. ?

book_draw_playfield_even:

; 3
book_draw_playfield_plus_3:

	lda	#$0E		; reset book color (lgrey)		; 2
	sta	COLUPF		; store playfield color			; 3
; 8
	lda	book_edge_colors+2,Y					; 4
	sta	COLUP1		; set edge colors (missile1)		; 3
; 15


	;==============================
	; update sprite1

	lda	(INL),Y	; load sprite1 data				; 5+
	sta	GRP1		;					; 3
; 23

	; activate hand sprite if necessary
	lda	#$f							; 2
	ldx	CURRENT_SCANLINE					; 3
	cpx	POINTER_Y						; 3
	bne	no_activate_hand					; 2/3
	sta	POINTER_ON						; 3
	jmp	done_activate_hand					; 3
no_activate_hand:
	inc	TEMP1			; nop5				; 5
done_activate_hand:
								;===========
								; 16 / 16

; 39
	lda	(OUTL),Y						; 5+
; 44

	ldx	#$F8		; change color to tan			; 2
	stx	COLUPF		; store playfield color			; 3
	; want this to happen around 49..50
; 49
	sta	COLUP1		; set page color (sprite1)		; 3
; 52

	inc	CURRENT_SCANLINE					; 5
; 57

	sta	WSYNC

	;====================
	;====================
	; draw playfield ODD
	;====================
	;====================
; 0
	lda	#$0E		; reset book color (lgrey)		; 2
	sta	COLUPF		; store playfield color			; 3
; 5
	lda	book_edge_colors+2,Y					; 4
	sta	COLUP1							; 3

; 12

	;==================
	; draw pointer
	;==================

	ldx	POINTER_ON						; 3
	beq	no_pointer						; 2/3
	lda	HAND_SPRITE,X						; 4
	sta	GRP0							; 3
	dec	POINTER_ON						; 5
	jmp	done_pointer						; 3
no_pointer:
	inc	TEMP1		; nop5					; 5
	inc	TEMP1		; nop5					; 5
	nop			;					; 2
	nop								; 2

done_pointer:
								;===========
								; 20 / 6
; 32
	inc	TEMP1	; nop5						; 5
; 37
	lda	(OUTL),Y						; 5
	sta	COLUP1		; set page color (sprite1)		; 3
; 45

	lda	#$F8		; change color to tan			; 2
	sta	COLUPF		; store playfield color			; 3
	; want this to happen around 49..50
; 50

	lda	CURRENT_SCANLINE					; 3
	and	#$1							; 2
	beq	yes_inc4						; 2/3
	.byte	$A5     ; begin of LDA ZP				; 3
yes_inc4:
	iny             ; $E8 should be harmless to load		; 2
done_inc_block:
                                                                ;===========
                                                                ; 10/10

; 60
	cpy	#44		; see if hit end			; 2
; 62
	sta	WSYNC
; 0
	bne	book_draw_playfield					; 2/3


book_done_playfield:


; 2

	;==========================
	; bottom grey line

	lda	#$04		; dark grey				; 2
	sta	COLUPF							; 3
	lda	#$7F		; overhanging page			; 2
	sta	PF1							; 3
; 12

	lda	#$0							; 2
	sta	ENAM0	; disable missile 0				; 3
	sta	ENAM1	; disable missile 1				; 3
	sta	GRP1							; 3
; 23

	ldx	#4
	jsr	common_delay_scanlines

;	sta	WSYNC
;	sta	WSYNC
;	sta	WSYNC
;	sta	WSYNC


	;==========================
	; black line
; 0
	lda	#$00		;					; 2
	sta	PF0		; turn off playfield			; 3
	sta	PF1							; 3
	sta	PF2							; 3
	sta	COLUPF		; color black				; 3
; 14
	sta	WSYNC

	;===========================
	;===========================
	; overscan (30 cycles)
	;===========================
	;===========================

	ldx	#27
	jsr	common_overscan

	;==================================
	; overscan 27+28, update sound

	; why is this disabled?
;	jsr	update_sound

	sta	WSYNC
	sta	WSYNC

	;==================================
	; overscan 29, update pointer

	lda	#POINTER_TYPE_POINT					; 2
	sta	POINTER_TYPE						; 3

	lda	POINTER_X						; 3
	cmp	#88
	bcc	not_in_window
	cmp	#128
	bcs	not_in_window
	lda	POINTER_Y
	cmp	#35
	bcs	not_in_window
	cmp	#8
	bcc	not_in_window
	lda	#POINTER_TYPE_GRAB
	sta	POINTER_TYPE
not_in_window:
	sta	WSYNC

	;==================================
	; overscan 30, see if at end

	lda	INPUT_COUNTDOWN						; 3
	beq	waited_enough_book					; 2/3
	dec     INPUT_COUNTDOWN						; 5
	jmp     book_keep_going						; 3

waited_enough_book:


	lda	INPT4			; check if joystick button pressed
	bpl	book_clicked

book_keep_going:
	sta	WSYNC
	jmp	book_frame

book_clicked:
	; WHICH_BOOK = CURRENT_LOCATION - 8
	; if 0..1 (red/blue) any click stays same place
	; if 2/4 (green / dni myst book) grab links, click backs off
	; if 3 (myst book start game) grab links

	ldx	WHICH_BOOK
	cpx	#3
	beq	myst_book_start_game

	cpx	#2
	bcc	exit_no_link_noise	; brother book, just exit

	; books where you link or back off
green_book:
	lda	POINTER_TYPE
	cmp	#POINTER_TYPE_GRAB
	bne	exit_no_link_noise

	; we clicked in window

	cpx	#4
	beq	were_going_to_library

were_going_to_dni:
	lda	#LOCATION_DNI_N
	sta	LINK_DESTINATION
	bne	exit_yes_link		; bra

were_going_to_library:
	lda	#LOCATION_LIBRARY_UP
	sta	LINK_DESTINATION
	bne	exit_yes_link		; bra

	; start of game, so no way to back off
myst_book_start_game:
	lda	POINTER_TYPE
	cmp	#POINTER_TYPE_GRAB
	bne	book_keep_going


exit_yes_link:
	; start linking noise
	ldy	#SFX_LINK
	sty	SFX_PTR

	ldy	LINK_DESTINATION
	sty	CURRENT_LOCATION

exit_no_link_noise:
	rts


book_data_l:
	.byte <red_book_data_zx02		; red
	.byte <blue_book_data_zx02		; blue
	.byte <green_book_data_zx02		; green
	.byte <myst_book_data_zx02		; star void myst
	.byte <myst_book_data_zx02		; atrus myst

book_data_h:
	.byte >red_book_data_zx02
	.byte >blue_book_data_zx02
	.byte >green_book_data_zx02
	.byte >myst_book_data_zx02
	.byte >myst_book_data_zx02

myst_book_data_zx02:
.incbin "myst_book_data.zx02"
red_book_data_zx02:
.incbin "red_book_data.zx02"
blue_book_data_zx02:
.incbin "blue_book_data.zx02"
green_book_data_zx02:
.incbin "green_book_data.zx02"

