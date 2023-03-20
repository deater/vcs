; In a pit

the_pit:

	lda	#SFX_SPEED
	sta	SFX_NEW

	lda	#30		; have the cheat fall		; 2
	sta	CHEAT_Y						; 3

	lda	#0
	sta	GRUMBLECAKE_Y
	sta	CHEATCAKE_Y
	sta	CHEATCAKE_COUNT

	lda	#76		; x pos, center			; 2
	sta	CHEATCAKE_X
	sta	GRUMBLECAKE_X

	jsr	init_level					; 6+??

pit_loop:

	;=========================
	; Start Vertical Blank
	;=========================

	lda	#2			; reset beam to top of screen
	sta	VSYNC

	;================================
	; wait for 3 scanlines of VSYNC

	sta	WSYNC			; wait until end of scanline
	sta	WSYNC

	lda	#0
	sta	REFP0
	sta	REFP1

	; mirror playfield
	lda	#CTRLPF_REF
	sta	CTRLPF

	sta	WSYNC

	lda	#0			; done beam reset
	sta	VSYNC

	;===============================
	;===============================
	; 37 lines of vertical blank
	;===============================
	;===============================

	ldx	#17
	jsr	scanline_wait		; Leaves X zero
; 10
	sta	WSYNC

	;====================
	; scanlines 18-28

	jsr	update_score
	sta	WSYNC

	;===========================
	; scanline 29
	;===========================
	; random number gen

	jsr	random16
	sta	WSYNC

	;===========================
	; scanline 30
	;===========================
	; move grumblecakes

	; if 0, not out.  randomly see if should start
; 0
	lda	GRUMBLECAKE_Y				; 3
	bne	move_gc					; 2/3

	; if 0
; 5
	lda	SEEDL					; 3
; 8
	sta	TEMP1					; 4
	and	#$7					; 2
	bne	done_move_gc				; 2/3
; 16
	clc						; 2
	lda	TEMP1					; 3
	and	#$3f					; 2
	adc	#48					; 2
	sta	GRUMBLECAKE_X				; 4
; 29
move_gc:
	inc	GRUMBLECAKE_Y				; 5
; 34
done_move_gc:

	; if too big, stop

	lda	GRUMBLECAKE_Y				; 3
	cmp	#140					; 2
	bcc	gc_good					; 2/3
; 41

	lda	#0					; 2
	sta	GRUMBLECAKE_Y				; 3
gc_good:
; 46
	sta	WSYNC

	;===========================
	; scanline 31
	;===========================
	; move cheatcakes

	; if 0, not out.  randomly see if should start
; 0
	lda	CHEATCAKE_Y				; 3
	bne	move_cc					; 2/3

	; if 0
; 5
	lda	SEEDH					; 3
; 8
	sta	TEMP1					; 4
	and	#$7					; 2
	bne	done_move_cc				; 2/3
; 16
	clc						; 2
	lda	TEMP1					; 3
	and	#$3f					; 2
	adc	#48					; 2
	sta	CHEATCAKE_X				; 4
; 29
move_cc:
	inc	CHEATCAKE_Y				; 5
; 34
done_move_cc:

	; if too big, stop

	lda	CHEATCAKE_Y				; 3
	cmp	#140					; 2
	bcc	cc_good					; 2/3
; 41

	lda	#0					; 2
	sta	CHEATCAKE_Y				; 3
cc_good:
; 46
	sta	WSYNC

	;===========================
	; scanline 32
	;===========================
	; update cheatcake
update_cheatcake_horizontal:
; 0
	lda	CHEATCAKE_X					; 3
	ldx	#3			; M1			; 2
	jsr	set_pos_x		; 2 scanlines		; 6+62
	sta	WSYNC

	;==========================
	; scanline 33
	;==========================
ccake_pos1:
	dey								; 2
	bpl	ccake_pos1	; 5-cycle loop (15 TIA color clocks)	; 2/3

	sta	RESM1							; 4
	sta	WSYNC


	;===========================
	; scanline 34
	;===========================
	; update grumblecake
update_grumblecake_horizontal:
; 0
	lda	GRUMBLECAKE_X					; 3
	ldx	#2			; M0			; 2
	jsr	set_pos_x		; 2 scanlines		; 6+62
	sta	WSYNC

	;==========================
	; scanline 35
	;==========================
gcake_pos1:
	dey								; 2
	bpl	gcake_pos1	; 5-cycle loop (15 TIA color clocks)	; 2/3

	sta	RESM0							; 4
	sta	WSYNC



	;================
	; scanline 36
	;	set things up for 48-pixel

	lda	#$0E			; white
	sta	COLUP0	; set sprite color
	sta	COLUP1	; set sprite color

	lda	#NUSIZ_THREE_COPIES_CLOSE
	sta	NUSIZ0
	sta	NUSIZ1

	lda	#0		; turn off sprite
	sta	GRP0
	sta	GRP1
	sta	HMP1			;			3

	lda	#1		; turn on delay
	sta	VDELP0
	sta	VDELP1

	sta	WSYNC

	;=================
	; scanline 37

	; to center exactly would want sprite0 at
	;	CPU cycle 41.3
	; and sprite1 at
	;	GPU cycle 44

	ldx	#6		;				2
cpad_x:
	dex			;				2
	bne	cpad_x		;				2/3
	; 3 + 5*X each time through

	lda	$80		; nop 6
	lda	$80


	; beam is at proper place
	sta	RESP0						; 3
	; 41 (GPU=123, want 124) +1
	sta	RESP1						; 3
	; 44 (GPU=132, want 132) 0

	lda	#$F0		; opposite what you'd think
	sta	HMP0			;			3
	lda	#$00
	sta	HMP1			;			3

	sta	WSYNC
	sta	HMOVE		; adjust fine tune, must be after WSYNC

	sta	VBLANK		; turn on beam (A=0)

	ldx	#23		; init X
	stx	TEMP2



	;===========================
	;===========================
	; playfield
	;===========================


	;===========================
	; draw 24 lines of message
	;===========================
	; 48-pixel sprite!!!!
	;


	;===============================
	; scanline 0

	lda	CHEAT_Y
	cmp	#124
	bcs	cheat_on_ground
	inc	CHEAT_Y
	inc	CHEAT_Y
cheat_on_ground:

	jmp	over_align2
.align $100
over_align2:
	sta	WSYNC

	;================================
	; scanline 1

spriteloop_cheat:
	; 0
	lda	avoid_sprite0,X	; load sprite data		; 4+
	sta	GRP0			; 0->[GRP0] [GRP1 (?)]->GRP1	; 3
	; 7
	lda	avoid_sprite1,X	; load sprite data		; 4+
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3
	; 14
	lda	avoid_sprite2,X	; load sprite data		; 4+
	sta	GRP0			; 2->[GRP0], [GRP1 (1)]-->GRP1	; 3
	; 21

	lda	avoid_sprite5,X					; 4+
	sta	TEMP1							; 3
	; 28
	lda	avoid_sprite4,X					; 4+
	tay								; 2
	; 34
	lda	avoid_sprite3,X	;				; 4+
	ldx	a:TEMP1			; force extra cycle		; 4
	; 42

	sta	GRP1			; 3->[GRP1], [GRP0 (2)]-->GRP0	; 3
	; 45 (need this to be 44 .. 46)

	sty	GRP0			; 4->[GRP0], [GRP1 (3)]-->GRP1	; 3
	; 48 (need this to be 47 .. 49)
	stx	GRP1			; 5->[GRP1], [GRP0 (4)]-->GRP0	; 3
	; 51 (need this to be 50 .. 51)

	sty	GRP0			; ?->[GRP0], [GRP1 (5)]-->GRP1 	; 3
	; 54 (need this to be 52 .. 54)

	; delay 11

	inc	TEMP1	; 5
	lda	TEMP1	; 3
	lda	TEMP1	; 3


	; 65

	dec	TEMP2							; 5
	ldx	TEMP2							; 3
	bpl	spriteloop_cheat					; 2/3
	; 76  (goal is 76)

	ldy	#0		; clear out sprites
	sty	GRP1
	sty	GRP0
	sty	GRP1

	sta	WSYNC


	;===========================
	; scanline 23
	;===========================
	; update cheat horizontal
pupdate_cheat_horizontal:
; 0
	lda	CHEAT_X						; 3
	ldx	#0						; 2
	jsr	set_pos_x		; 2 scanlines		; 6+62
	sta	WSYNC

	;==========================
	; scanline 24
	;==========================
pwait_pos1:
	dey								; 2
	bpl	pwait_pos1	; 5-cycle loop (15 TIA color clocks)	; 2/3

	sta	RESP0							; 4
	sta	WSYNC

	;==========================
	; scanline 25
	;==========================
; 0
	lda	SHADOW_X						; 3
	ldx	#1							; 2
	jsr	set_pos_x		; 2 scanlines			; 6+62
	sta	WSYNC

	;==========================
	; scanline 26
	;==========================
pwait_pos2:
	dey                                                             ; 2
	bpl	pwait_pos2	; 5-cycle loop (15 TIA color clocks)    ; 2/3

	sta	RESP1							; 4
	sta	WSYNC


	;================================
	; scanline 27
	;================================

	lda	CHEAT_Y
	clc
	adc	#18
	sta	CHEAT_Y_END

	sta     WSYNC
        sta     HMOVE

	;=============================
	; 28
	;=============================

	lda	#NUSIZ_ONE_COPY|NUSIZ_MISSILE_WIDTH_2
	sta	NUSIZ0
	sta	NUSIZ1

	lda	#$0		; turn off delay
	sta	VDELP0
	sta	VDELP1
	sta	GRP0		; turn off sprites
	sta	GRP1

	sta	PF0		; clear playfield
	sta	PF1
	sta	PF2

	lda	#$00		; black cheat
	sta	COLUP0
	lda	#$1C		; yellow cheat
	sta	COLUP1

	ldx	#0
	stx	SCANLINE


	lda	CHEAT_DIRECTION
	sta	REFP0
	sta	REFP1

	sta	WSYNC


	;===========================
	; scanline 29
	;===========================

	; draw 192 - 28 - 8 (156) / 3 = 39

	lda	#$00		; black
	sta	COLUBK

	lda	#$04		; grey
	sta	COLUPF

	ldy	#0

	sta	WSYNC


	jmp	pit_bg_loop

	;===========================
	; 164 lines of title
	;===========================
pit_bg_loop:


	;============================
	; line 0

; 3
	lda	#0							; 2
	sta	PF0							; 3
	; must write by CPU 22 [GPU 68]
; 8

	; activate cheat sprite

	lda	SCANLINE
	cmp	CHEAT_Y                                                 ; 2
	bne	pdone_activate_cheat					; 2/3
pactivate_cheat:
	ldy	#10                                                     ; 2
pdone_activate_cheat:
	; 6/5

; 14
	lda	pit_playfield1_left,X					; 4+
	sta	PF1							; 3
	; must write by CPU 28 [GPU 84]
; 21

	; put sprite
	lda	cheat_sprite_black,Y					; 4+
	sta	GRP0							; 3
; 28
	lda	pit_playfield2_left,X					; 4+
	sta	PF2							; 3
	; must write by CPU 38 [GPU 116]
; 35

	lda	cheat_sprite_yellow,Y					; 4
	sta	GRP1							; 3

	tya								; 2
	beq	plevel_no_cheat						; 2/3
	dey								; 2
plevel_no_cheat:
	; 6/5

	inc	SCANLINE
	sta	WSYNC

	;============================
	; line 1

; 0

	lda	SCANLINE
	cmp	CHEATCAKE_Y
	bcc	disable_cc1
	sec	; not needed
	sbc	#4
	cmp	CHEATCAKE_Y
	bcs	disable_cc1
enable_cc1:
	lda	#$2		; enable grumblecake
	bne	put_cc		; bra
disable_cc1:
	lda	#$0
put_cc:
	sta	ENAM1

	inc	SCANLINE
	sta	WSYNC

	;============================
	; line 2

; 0
	; activate cheat sprite

	lda	SCANLINE
	cmp	CHEAT_Y                                                 ; 2
	bne	qdone_activate_cheat					; 2/3
qactivate_cheat:
	ldy	#10                                                     ; 2
qdone_activate_cheat:

; 6
	; put sprite

	lda	cheat_sprite_black,Y					; 4+
	sta	GRP0							; 3
; 13
	lda	cheat_sprite_yellow,Y					; 4+
	sta	GRP1							; 3
; 20
	tya								; 2
	beq	qlevel_no_cheat						; 2/3
	dey								; 2
qlevel_no_cheat:
	; 6/5

; 0
	;==============================
	; line 3

	lda	SCANLINE
	cmp	GRUMBLECAKE_Y
	bcc	disable_gc1
	sec			; not needed
	sbc	#4
	cmp	GRUMBLECAKE_Y
	bcs	disable_gc1
enable_gc1:
	lda	#$2		; enable grumblecake
	bne	put_gc		; bra
disable_gc1:
	lda	#$0
put_gc:
	sta	ENAM0

	inc	SCANLINE
	sta	WSYNC


	inc	SCANLINE
	inx
	cpx	#38							; 2

	sta	WSYNC
	bne	pit_bg_loop



	;======================
	; draw score
	;======================
	; 8 scanlines

	jsr	draw_score

	;============================
	; overscan
	;============================
pit_overscan:
	lda	#$2             ; turn off beam
	sta	VBLANK

	; wait 30 scanlines

	ldx	#21
	jsr	scanline_wait


	;==================
	; 25

	lda	CXM0P		; see if if grumblecake hit us
	and	#$C0
	beq	no_gc_collision

	lda	#0
	sta	GRUMBLECAKE_Y

	; trigger sound
	lda	#SFX_ZAP
	sta	SFX_NEW

no_gc_collision:

	lda	CXM1P		; see if cheatcake hit us
	and	#$C0
	beq	no_cc_collision

	lda	#0
	sta	CHEATCAKE_Y

	inc	CHEATCAKE_COUNT

	; trigger sound
	lda	#SFX_COLLECT
	sta	SFX_NEW

no_cc_collision:

	sta	CXCLR		; clear collisions

	sta	WSYNC

	;==================
	; 23


	ldy	SFX_NEW
	beq	skip_pit_sound
	jsr	trigger_sound		; 52 cycles
	lda	#0
	sta	SFX_NEW
skip_pit_sound:
	sta	WSYNC

	jsr	update_sound		; 2 scanlines
	sta	WSYNC



	;==================
	; 26

	jsr	common_movement

	sta	WSYNC                   ;                               ; 3


	;==================
	; 26

	lda	CHEATCAKE_COUNT
	cmp	#5
	bcs	done_pit

	sta	WSYNC

	jmp	pit_loop


done_pit:
	ldy	#DESTINATION_STRONGBADIA		; FIXME: last_level
	lda	#80
	sta	NEW_X
	lda	#100
	sta	CHEAT_Y
	jmp	done_level
