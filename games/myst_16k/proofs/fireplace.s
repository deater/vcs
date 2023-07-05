; fireplace puzzle proof of concept

.include "../../../vcs.inc"


; it's an 8x6 panel

;0123456789012345678901234567890123456789
;|||:XXX|XXX:XXX|XXX:XXX:XXX|XXX:XXX|||||
;

; $00 $EE $77 $70 $EE $07


.include "../zp.inc"
;.include "../locations.inc"


fireplace:
	sei		; disable interrupts
	cld		; clear decimal bit

	; init zero page and addresses to 0

	ldx	#0
	txa
clear_loop:
	dex
	txs
	pha
	bne	clear_loop

	; S=$FF, A=$00, X=$00, Y=??




	;=========================
	; load level
	;=========================
	; load level data for CURRENT_LOCATION
	;	put in RAM starting at $1000
	;	also update 16-bytes of ZP level data

load_level:

	;=================================
	; copy first 16 bytes to zero page

	ldy	#15							; 2
copy_zp_loop:
	lda	level_data,Y					; 4+
	sta	LEVEL_DATA,Y						; 5

	dey								; 2
	bpl	copy_zp_loop						; 2/3


	lda	#LOCATION_INSIDE_FIREPLACE
	sta	CURRENT_LOCATION



.include "level_engine.s"

load_new_level:

.include "../common_routines.s"

.include "../hand_copy.s"
.include "../hand_motion.s"
.include "../sound_update.s"
.include "../sfx_data.inc"
.include "../adjust_sprite.s"
.include "../sprite_data.inc"


.align $100
level_data:
.include "../locations/inside_fireplace_data.s"

.segment "IRQ_VECTORS"
	.word fireplace	; NMI
	.word fireplace	; RESET
	.word fireplace	; IRQ


