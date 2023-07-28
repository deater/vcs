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

; 22
	ldx	CURRENT_LOCATION					; 3
	cpx	#8			; if level >8 not switch	; 2
	bcc	handle_switch						; 2/3
; 29

	; set up jump table fakery
handle_special:
	lda	grab_dest_h-8,X						; 4+
	pha								; 3
	lda	grab_dest_l-8,X						; 4+
	pha								; 3
	rts				; jump to location		; 6
; 49


	;===============================
	;===============================
	; handle switch
	;===============================
	;===============================

handle_switch:
; 30
	ldy	#SFX_CLICK		; play sound			; 2
	sty	SFX_PTR							; 3
; 35
	; toggle switch
	lda	powers_of_two,X						; 4+
	eor	SWITCH_STATUS						; 3
	sta	SWITCH_STATUS						; 3
; 45

	; Switch to white page if switch from $FF to $7F

	cmp	#$7f							; 2
	bne	done_handle_grab					; 2/3
; 49

	jsr	restore_page

	lda	#POINTER_COLOR_WHITE					; 2
	sta	POINTER_COLOR						; 3
; 54

done_handle_grab:

	sta	WSYNC	 ;FIXME: should we?

	jmp	done_check_level_input


	;=========================
	;=========================
	; giving atrus the page
	;=========================
	;=========================
grab_atrus:
; 49
	lda	WHITE_PAGE_COUNT
	beq	havent_given_page_yet

	; myst linking book instead
	jmp	handle_book

havent_given_page_yet:
	; if have white page, goto good ending
	lda	POINTER_COLOR
	cmp	#POINTER_COLOR_WHITE
	bne	trapped_with_atrus

	;=========================
	; "good" ending
	;=========================
	; TODO: destroy book pages
	;	put count high?
	;	change the erase mask to $00 not $f8

trapped_on_myst:

	; give white page to atrus
	inc	WHITE_PAGE_COUNT
	lda	#0
	sta	POINTER_COLOR

	lda	#LOCATION_YOU_WIN
	jmp	start_new_level

trapped_with_atrus:
	; else, trapped
	lda	#LOCATION_TRAPPED
	jmp	start_new_level


	;==========================
	; grabbed the clock puzzle
	;==========================
grab_clock_puzzle:
;	jmp	done_handle_grab

	;==============================
	; grabbed the fireplace puzzle
	;==============================
grab_fireplace:
; 49
	inc	WAS_CLICKED		; set flag to handle later	; 5
	bne	done_handle_grab		; bra			; 3
; 57

	;============================
	; grabbed the clock controls
	;============================
grab_clock_controls:
; 49
	lda	#LOCATION_CLOCK_PUZZLE
	jmp	start_new_level


	;==============================
	; grabbed close door painting
	;==============================
grab_close_painting:
; 49
	lda	BARRIER_STATUS						; 3
	ora	#BARRIER_LIBRARY_DOOR_CLOSED				; 2
	bne	common_painting		; bra				; 3

	;==============================
	; grabbed open door painting
	;==============================
grab_open_painting:
; 49
	lda	BARRIER_STATUS						; 3
	and	#<(~BARRIER_LIBRARY_DOOR_CLOSED)			; 2
; 54

common_painting:
; 57 / 54
	sta	BARRIER_STATUS						; 3
	ldy	#SFX_RUMBLE		; play sound			; 2
	sty	SFX_PTR							; 3
; 65

	bne	done_handle_grab	; bra				; 3
; 68



	;======================
	; grab tower rotation
	;======================
	; FIXME: share code with above somehow
grab_tower_rotation:
; 49
	sta	BARRIER_STATUS						; 3
	ldy	#SFX_RUMBLE		; play sound			; 2
	sty	SFX_PTR							; 3

	bne	done_handle_grab	; bra				; 3


	;========================
	; grab red book
	;========================
grab_red_book:
	lda	#HOLDING_RED_PAGE
	ldx	#0
	beq	common_red_blue_book_grab

	;========================
	; grab blue book
	;========================
grab_blue_book:
	lda	#HOLDING_BLUE_PAGE
	ldx	#1

	;========================
	; common_red_blue_book_grab
	;========================
common_red_blue_book_grab:
	ldy	#OCTAGON_PAGE
	sty	CURRENT_PAGE

	ldy	POINTER_X
	cpy	#92			; $5c = 92
	bcc	handle_book		; if to left, clicked on book

	;========================
	; common_grab_book
	;========================
	; A is HOLDING_RED_PAGE/HOLDING_BLUE_PAGE here
	; and X should reflect that

common_grab_book:

	; need to make sure page is gone permanently
	sta	TEMP1

	lda	RED_PAGES_TAKEN,X	; get current page taken status
	and	CURRENT_PAGE		; check if it is taken
	bne	done_handle_grab	; if it is we can't grab it

	lda	TEMP1			; get hold_red/hold_blue
	ora	CURRENT_PAGE		; set page taken
	pha				; save for later

	lda	CURRENT_PAGE		; mark page taken
	ora	RED_PAGES_TAKEN,X
	sta	RED_PAGES_TAKEN,X

	lda	page_colors,X		; set pointer color
	sta	POINTER_COLOR

	jsr	restore_page		; restore old page

	pla
	sta	HOLDING_PAGE

	jmp	done_handle_grab

	;========================
	; grab green book
	;========================
grab_green_book:
	ldy	#FINAL_PAGE
	sty	CURRENT_PAGE

	ldy	POINTER_Y
	cpy	#24			;
	bcc	handle_book		; if above, clicked on book

	cpy	#37
	bcs	green_book_red_page
green_book_blue_page:
	lda	#HOLDING_BLUE_PAGE
	ldx	#1
	bne	common_grab_book

green_book_red_page:
	lda	#HOLDING_RED_PAGE
	ldx	#0
	beq	common_grab_book

; 49

handle_book:
	;===========================
	; handle book being clicked
	;===========================
	; three cases
	;	1. holding no page (goto do_book)
	;	2. holding page of different color (goto do_book)
	;	3. holding page of same color (make noise, inc count)
	;		if page count==2 then game over

	; X has red/blue already

	lda	POINTER_TYPE
	cmp	#POINTER_TYPE_PAGE
	bne	really_do_book

	; need to compare to make sure red page in red book
	;	or blue page in blue book
	;		X had 0=red 1=blue
	;		HOLDING_PAGE has $80 if red, $40 if blue
	lda	HOLDING_PAGE
	and	#$C0
	cmp	which_book,X
	bne	really_do_book

put_page_in_book:

	inc	RED_PAGE_COUNT,X

	lda	#0
	sta	HOLDING_PAGE
	sta	POINTER_COLOR

	lda	RED_PAGE_COUNT,X
	cmp	#2
	bne	still_more_pages

	lda	#LOCATION_TRAPPED
	jmp	start_new_level

still_more_pages:
	jmp	done_handle_grab

really_do_book:

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
	ldx	#0
	lda	HOLDING_PAGE
	and	#$C0
	beq	done_restore_page		; not holding page

	cmp	#$C0
	beq	restore_white_page

	cmp	#HOLDING_RED_PAGE
	beq	restore_page_common	; default is red

	inx				; make it blue

restore_page_common:
	lda	HOLDING_PAGE
	and	#$3F
	eor	#$FF
	and	RED_PAGES_TAKEN,X
	sta	RED_PAGES_TAKEN,X

restore_white_page:

done_restore_page:
	rts

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
	; grab_elevator?			; 19

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
	; grab_elevator?			; 19
