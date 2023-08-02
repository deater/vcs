; De-compressor for ZX02 files
; ----------------------------
;
; Decompress ZX02 data (6502 optimized format), optimized for speed and size
;  138 bytes code, 58.0 cycles/byte in test file.
;
; Compress with:
;    zx02 input.bin output.zx0
;
; (c) 2022 DMSC
; Code under MIT license, see LICENSE file.

;=============================================================
; VMW -- made changes for use on Atari 2600 with E7 Cartridge
;=============================================================
; When called, page to output to is in A

; Change to allow read/write from different offsets
;	In many compression routines, you can index into previously
;	decompressed data as a source of information.  On the E7
;	cartridge the read address is different from the write address
;	due to the lack of a R/W line.  The code has been modified so
;	you can specify an offset to be added to the high address
;	of the ptr read to account for this.

; Decompression taking too long
;	On the Atari 2600 you have to be constantly redrawing the screen
;	manually.  If you go more than 262 scanlines without drawing a
;	screen your display might glitch out or otherwise get unhappy.
;	Decoding our data can take longer than this, so we set up a timer
;	that counts down 242 scanlines.  We periodically poll this in the
;	often-called get_elias() routine.  If we notice we are getting
;	close to running out, we stop, carefully wait until the end
;	of the screen, properly do the work to show a valid (empty) screen,
;	then pick up again.

;zx0_ini_block:
;           .byte $00, $00, <comp_data, >comp_data, <out_addr, >out_addr, $80

;--------------------------------------------------
; Decompress ZX0 data (6502 optimized format)

; Before calling, the T1024 timer is set up to
;	count for 18 times, or 18432 cycles / 76 = 242.5 scanlines
; Note we finish 3 scanlines short of 262 scanlines (so other code
;	in caller can run) so you might have to wait 3 yourself
zx02_full_decomp:




;=== Start VMW =================================

	; set up the initial values in ther zero page

	ldy	#$80
	sty	bitr
	ldy	#0
	sty	offset		; location of compressed data
	sty	offset+1
	sty	ZX0_dst		; we assume always start at beginning
				; of page
	sta	ZX0_dst+1	; page to output is in A

;=== End VMW =================================


; Decode literal: Ccopy next N bytes from compressed file
;    Elias(length)  byte[1]  byte[2]  ...  byte[N]
decode_literal:
	jsr	get_elias
cop0:
	lda	(ZX0_src), Y
	inc	ZX0_src
	bne	plus1
	inc	ZX0_src+1
plus1:
	sta	(ZX0_dst),Y
	inc	ZX0_dst
	bne	plus2
	inc	ZX0_dst+1
plus2:
	dex
	bne	cop0

	asl	bitr
	bcs	dzx0s_new_offset

; Copy from last offset (repeat N bytes from last offset)
;    Elias(length)

	jsr	get_elias
dzx0s_copy:
	lda	ZX0_dst
	sbc	offset  	; C=0 from get_elias
	sta	pntr
	lda	ZX0_dst+1
	sbc	offset+1

;=== Start VMW =================================
	; code to handle that read/write different addresses

	clc
	adc	READ_WRITE_OFFSET
;=== End VMW =================================

	sta   pntr+1

cop1:
	lda	(pntr), Y
	inc	pntr
	bne	plus3
	inc	pntr+1
plus3:
	sta	(ZX0_dst), Y
	inc	ZX0_dst
	bne	plus4
	inc	ZX0_dst+1
plus4:
	dex
	bne	cop1

	asl	bitr
	bcc	decode_literal

; Copy from new offset (repeat N bytes from new offset)
;    Elias(MSB(offset))  LSB(offset)  Elias(length-1)
dzx0s_new_offset:

	; Read elias code for high part of offset
	jsr	get_elias
	beq	exit		; Read a 0, signals the end

	; Decrease and divide by 2
	dex
	txa
	lsr			; @
	sta	offset+1

	; Get low part of offset, a literal 7 bits
	lda	(ZX0_src), Y
	inc	ZX0_src
	bne	plus5
	inc	ZX0_src+1
plus5:
	; Divide by 2
	ror			; @
	sta	offset

	; And get the copy length.
	; Start elias reading with the bit already in carry:
	ldx	#1
	jsr	elias_skip1

	inx
	bcc	dzx0s_copy

; Read an elias-gamma interlaced code.
; ------------------------------------
get_elias:

;=== Start VMW =================================
; addded to detect if we're taking too long

vmw_check_timer:
	ldx	INTIM			; load current timer countdown val
	cpx	#1			; see if we've hit #1
					; we don't wait for 0 because
					;   after hitting 0 it will
					;   wrap to 255 and count once-per-cycle
					; an that's harder to recover from

	bne	done_vmw		; if not at 1, keep decompressing

hanle_timer_out:

	; save A and Y on stack as they need to be preserved
	pha
	tya
	pha

	; now wait until counter finishes counting down to 0
force_expire:
	ldx	INTIM			; repeat until we hit 0
	bne	force_expire		; if not, loop

	ldx	#29
	jsr	common_overscan

	jsr	common_vblank

	lda	#18				; 14 * 1024 = 14336
	sta	T1024T				; which is roughly 188.6 lines

	; restore A and Y
	pla
	tay
	pla

done_vmw:

;=== Stop VMW =================================

	; Initialize return value to #1
	ldx	#1
	bne	elias_start

elias_get:
	; Read next data bit to result
	asl	bitr
	rol			; @
	tax

elias_start:
	; Get one bit
	asl	bitr
	bne	elias_skip1

	; Read new bit from stream
	lda	(ZX0_src), Y
	inc	ZX0_src
	bne	plus6
	inc	ZX0_src+1
plus6:
	;sec   			; not needed, C=1 guaranteed from last bit
	rol			; @
	sta	bitr

elias_skip1:

	txa
	bcs	elias_get

	; Got ending bit, stop reading

	rts		; debug


exit:
;=== Start VMW =================================

	;========================================
	; If we finish before timer expires...
	;========================================
check_timer:
	ldx	INTIM			; see if 192 scanline counter done
	bne	check_timer		; if not, loop

	; 3 scanlines less because we copy 16 bytes in load_level

	ldx	#26			; do the overscan
	jsr	common_overscan

	rts

