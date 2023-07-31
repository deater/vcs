; moved to BANK6 due to lack of room
; can't touch anything in RAM while running

; entry points:
;	do_clicked_grab
;	restore_page (????)
; exit points:
;	start_new_level (sets BANK7)
;	done_check_level_input (sets BANK7)

	;==========================
	; clicked grab
	;==========================

do_clicked_grab:

; 28
	ldx	CURRENT_LOCATION					; 3
	cpx	#8			; if level >8 not switch	; 2
	bcc	handle_switch						; 2/3
; 35

	; set up jump table fakery
handle_special:
	lda	grab_dest_h-8,X						; 4+
	pha								; 3
	lda	grab_dest_l-8,X						; 4+
	pha								; 3
	rts				; jump to location		; 6
; 55


	;===============================
	;===============================
	; handle switch
	;===============================
	;===============================

handle_switch:
; 36
	ldy	#SFX_CLICK		; play sound			; 2
	sty	SFX_PTR							; 3
; 41
	; toggle switch
	lda	SWITCH_STATUS						; 3
	tay			; save for comparison			; 2
	eor	powers_of_two,X						; 4+
	sta	SWITCH_STATUS						; 3
; 53

	; Switch to white page if switch from $FF to $7F
	cpy	#$ff		; be sure all are set			; 2
	bne	done_handle_grab_29					; 2/3
; 57
	cmp	#$7f		; be sure it's dock one flipped		; 2
	bne	done_handle_grab_29					; 2/3
; 61

	; handle white page

	jsr	restore_page						; 6+40
; 107
	lda	#POINTER_COLOR_WHITE					; 2
	sta	POINTER_COLOR						; 3
	bne	done_handle_grab		; bra			; 3
; 116

	;=================================
	; done handle grab
	;=================================
	; should we exit more directly?
done_handle_grab_29:
	sta	WSYNC

done_handle_grab:

	jmp	done_check_level_input


	;=========================
	;=========================
	; giving atrus the page
	;=========================
	;=========================
grab_atrus:
; 55
	lda	WHITE_PAGE_COUNT					; 3
	beq	havent_given_page_yet					; 2/3

	; myst linking book instead
; 60
	sta	WSYNC							; 3
	jmp	handle_book						; 3

havent_given_page_yet:
; 63
	; if have white page, goto good ending
	lda	POINTER_COLOR						; 3
	cmp	#POINTER_COLOR_WHITE					; 2
; 68
	bne	trapped_with_atrus					; 2/3

	;=========================
	; "good" ending
	;=========================
	; destroy book pages/book (make erase mask $00 not $f8)
	; make it so can't pick up pages
; 70

trapped_on_myst:
	; destroy the books
	ldx	#$00							; 2
	stx	LIBRARY_PAGE_MASK					; 3
	dex				; $FF				; 2
	stx	RED_PAGES_TAKEN						; 3
	stx	BLUE_PAGES_TAKEN					; 3
; 83
	; give white page to atrus
	inc	WHITE_PAGE_COUNT					; 5
	lda	#0			; drop page			; 2
	sta	POINTER_COLOR						; 3
; 93

	lda	#LOCATION_YOU_WIN					; 2
	jmp	start_new_level						; 3
; 81

	;================================
	; "bad" ending
	;================================
	; no white page, trapped forever
	;	in D'NI

trapped_with_atrus:
	; else, trapped
	lda	#LOCATION_TRAPPED					; 3
; 74
	jmp	start_new_level						; 3
; 77?  This is cutting close but I guess OK?

	;==========================
	; grabbed the clock puzzle
	;==========================
grab_clock_puzzle:

	; fall through to fireplace

	;==============================
	; grabbed the fireplace puzzle
	;==============================
grab_fireplace:
; 55
	inc	WAS_CLICKED		; set flag to handle later	; 5
	bne	done_handle_grab_29	; bra				; 3
; 63


	;==============================
	; grabbed close door painting
	;==============================
grab_close_painting:
; 55
	lda	BARRIER_STATUS						; 3

	; if open, make grind noise and close
	; if already open, make beep
	and	#BARRIER_LIBRARY_DOOR_CLOSED				; 2
; 60
	beq	close_door						; 2/3


common_door_same:
; 62 / 63
	ldy	#SFX_CLICK		; play sound			; 2
	sty	SFX_PTR							; 3
; 67
;	nop	; force cross scanline
;
	bne	done_handle_grab	; bra				; 3
; 70


close_door:
; 63
	lda	BARRIER_STATUS						; 3
	ora	#BARRIER_LIBRARY_DOOR_CLOSED				; 2
; 68
	bne	common_door_change		; bra			; 3

	;==============================
	; grabbed open door painting
	;==============================
grab_open_painting:
; 55
	lda	BARRIER_STATUS						; 3
	and	#BARRIER_LIBRARY_DOOR_CLOSED				; 2
; 60
	beq	common_door_same					; 2/3


open_door:
; 62
	lda	BARRIER_STATUS						; 3
	and	#<(~BARRIER_LIBRARY_DOOR_CLOSED)			; 2
; 67

common_door_change:
; 71 / 67
	sta	BARRIER_STATUS						; 3
ready_to_rumble:
	ldy	#SFX_RUMBLE		; play sound			; 2
	sty	SFX_PTR							; 3
; 65 / 75
	bne	done_handle_grab	; bra				; 3
; 68 / 78



	;======================
	; grab tower rotation
	;======================
	; TODO: animation?  track rotation?
grab_tower_rotation:
; 55
	jmp	ready_to_rumble						 ; 3
; 58

	;========================
	; grab red book
	;========================
grab_red_book:
; 55
	lda	#HOLDING_RED_PAGE					; 2
	ldx	#0							; 2
	beq	common_red_blue_book_grab	; bra			; 3
; 62

	;========================
	; grab blue book
	;========================
grab_blue_book:
; 55
	lda	#HOLDING_BLUE_PAGE					; 2
	ldx	#1							; 2
; 59

	;========================
	; common_red_blue_book_grab
	;========================
common_red_blue_book_grab:
; 62 (red) / 59 (blue)
	ldy	#OCTAGON_PAGE						; 2
	sty	CURRENT_PAGE						; 3
; 67
	ldy	POINTER_X						; 3
	cpy	#92			; $5c = 92			; 2
; 72
	bcc	handle_book		; if to left, clicked on book	; 2/3

	;========================
	; common_grab_page
	;========================
	; picks up a red/blue page
	; A is HOLDING_RED_PAGE/HOLDING_BLUE_PAGE here
	; and X should reflect that

common_grab_page:
; 74 / 74
	; need to make sure page is gone permanently
	sta	TEMP1							; 3

	lda	RED_PAGES_TAKEN,X	; get current page taken status	; 4
	and	CURRENT_PAGE		; check if it is taken		; 3
; 84
	bne	done_handle_grab	; if it is we can't grab it	; 2/3
; 86
	lda	TEMP1			; get hold_red/hold_blue	; 3
	ora	CURRENT_PAGE		; set page taken		; 3
	pha				; save for later		; 3
; 95
	lda	CURRENT_PAGE		; mark page taken		; 3
	ora	RED_PAGES_TAKEN,X					; 4
	sta	RED_PAGES_TAKEN,X					; 4
; 106
	lda	page_colors,X		; set pointer color		; 4+
	sta	POINTER_COLOR						; 3
; 113
	jsr	restore_page		; restore old page		;6+40
; 159
	pla								; 4
	sta	HOLDING_PAGE						; 3
; 166
	jmp	done_handle_grab					; 3

	;========================
	; grab green book
	;========================
	; if top, handle book
	; if bottom, check if it's red or blue page
grab_green_book:
; 55
	ldy	#FINAL_PAGE						; 2
	sty	CURRENT_PAGE						; 3
; 60
	ldy	POINTER_Y						; 3
	cpy	#24			;				; 2
	bcc	handle_book		; if above, clicked on book	; 2/3

; 62
	cpy	#37							; 2
	bcs	green_book_red_page					; 2/3

green_book_blue_page:
; 66
	lda	#HOLDING_BLUE_PAGE					; 2
	ldx	#1							; 2
	bne	common_grab_page	; bra				; 3
; 73

green_book_red_page:
; 67
	lda	#HOLDING_RED_PAGE					; 2
	ldx	#0							; 2
	beq	common_grab_page	; bra				; 3
; 74


handle_book:
; 75 (red/blue) / 65 (green)
	;===========================
	; handle book being clicked
	;===========================
	; three cases
	;	1. holding no page (goto do_book)
	;	2. holding page of different color (goto do_book)
	;	3. holding page of same color (make noise, inc count)
	;		if page count==2 then game over

	; X has red/blue already
; 75
	lda	POINTER_TYPE						; 3
	cmp	#POINTER_TYPE_PAGE					; 2
	bne	really_do_book						; 2/3

	; need to compare to make sure red page in red book
	;	or blue page in blue book
	;		X had 0=red 1=blue
	;		HOLDING_PAGE has $80 if red, $40 if blue
; 82
	lda	HOLDING_PAGE						; 3
	and	#$C0							; 2
	cmp	which_book,X						; 4
; 91
	bne	really_do_book						; 2/3

put_page_in_book:
; 93
	inc	RED_PAGE_COUNT,X					; 6
; 99
	lda	#0							; 2
	sta	HOLDING_PAGE						; 3
	sta	POINTER_COLOR						; 3
; 107
	lda	RED_PAGE_COUNT,X					; 4
	cmp	#2							; 2
; 113
	bne	still_more_pages					; 2/3
; 115
	lda	#LOCATION_TRAPPED					; 3
	jmp	start_new_level

still_more_pages:
; 116
	jmp	done_handle_grab

really_do_book:
; 83 / 94
	jsr	book_common

	lda	CURRENT_LOCATION
	jmp	start_new_level


	;===========================
	;===========================
	; restore page
	;===========================
	;===========================
	; if get new page need to put
	; back current, if any
restore_page:
; 0
	ldx	#0							; 2
	lda	HOLDING_PAGE						; 3
	and	#$C0							; 2
; 7

	beq	done_restore_page		; not holding page	; 2/3
; 9

	cmp	#$C0							; 2
	beq	restore_white_page					; 2/3

; 13

	cmp	#HOLDING_RED_PAGE					; 2
	beq	restore_page_common	; default is red		; 2/3

; 17
	inx				; make it blue			; 2

; 18/19

restore_page_common:
	lda	HOLDING_PAGE						; 3
	and	#$3F							; 2
	eor	#$FF							; 2
	and	RED_PAGES_TAKEN,X					; 4
	sta	RED_PAGES_TAKEN,X					; 4
; 33/34
restore_page_common_done:
	rts								; 6
; 39/40

	; try to equalize timing better to make cycle counting
	; not as horrible

done_restore_page:
; 10
	nop
	nop

restore_white_page:
; 14
	jsr	restore_page_common_done	; nop12
	nop	; 2
	nop	; 2
	nop	; 2
	nop	; 2

; 34
	rts
; 40




	;============================
	; grabbed the clock controls
	;============================
grab_clock_controls:
; 55
	lda	#LOCATION_CLOCK_PUZZLE					; 2
	jmp	start_new_level_29					; 3

	;============================
	; pushed the elevator button
	;============================
grab_elevator_button:
; 55
	lda	#LOCATION_HINT						; 2
	jmp	start_new_level_29					; 3






which_book:
	.byte $80,$40,$C0

page_colors:
	.byte POINTER_COLOR_RED,POINTER_COLOR_BLUE


grab_dest_l:

	.byte	<(grab_red_book-1)		; 8
	.byte	<(grab_blue_book-1)		; 9
	.byte	<(grab_green_book-1)		; 10
	.byte	<(grab_green_book-1)		; 11	placeholder

	.byte	<(grab_atrus-1)			; 12
	.byte	<(grab_tower_rotation-1)	; 13

	.byte	<(grab_fireplace-1)		; 14
	.byte	<(grab_clock_controls-1)	; 15
	.byte	<(grab_close_painting-1)	; 16
	.byte	<(grab_open_painting-1)		; 17
	.byte	<(grab_clock_puzzle-1)		; 18
	.byte	<(grab_elevator_button-1)	; 19 elevator

grab_dest_h:
	.byte	>(grab_red_book-1)		; 8
	.byte	>(grab_blue_book-1)		; 9
	.byte	>(grab_green_book-1)		; 10
	.byte	>(grab_green_book-1)		; 11	placeholder

	.byte	>(grab_atrus-1)			; 12
	.byte	>(grab_tower_rotation-1)	; 13

	.byte	>(grab_fireplace-1)		; 14
	.byte	>(grab_clock_controls-1)	; 15
	.byte	>(grab_close_painting-1)	; 16
	.byte	>(grab_open_painting-1)		; 17
	.byte	>(grab_clock_puzzle-1)		; 18
	.byte	>(grab_elevator_button-1)	; 19 elevator
