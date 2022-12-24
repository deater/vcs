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

; modified to break up across multiple frames

;ZP=$80

;offset          = ZP+0
;ZX0_src         = ZP+2
;ZX0_dst         = ZP+4
;bitr            = ZP+6
;pntr            = ZP+7

            ; Initial values for offset, source, destination and bitr
;zx0_ini_block:
;           .byte $00, $00, <comp_data, >comp_data, <out_addr, >out_addr, $80

;--------------------------------------------------
; Decompress ZX0 data (6502 optimized format)

zx02_full_decomp:

	sta	ZX0_dst+1	; page to output to in A

;=======================================
;=======================================
; START VMW
;=======================================
;=======================================
	; turn off everything

;	lda	#0
;	sta	PF0
;	sta	PF1
;	sta	PF2

	; fire up counter to trigger

	jsr	common_vblank

;	ldx	#37
;zx_vblank:
;	sta	WSYNC
;	dex
;	bne	zx_vblank

	; want to delay around 192 scanlines
	;       192*76 = 14592 / 1024 = 14.25

	lda	#18
where_set:
	sta	T1024T



;              ; Get initialization block
;             ldy #7
;
;copy_init:     lda zx0_ini_block-1, y
;              sta offset-1, y
;              dey
;              bne copy_init



;=======================================
;=======================================
; STOP VMW
;=======================================
;=======================================

	ldy	#$80
	sty	bitr
	ldy	#0
	sty	offset
	sty	offset+1
	sty	ZX0_dst		; always on even page

; Decode literal: Ccopy next N bytes from compressed file
;    Elias(length)  byte[1]  byte[2]  ...  byte[N]
decode_literal:
              jsr   get_elias

cop0:         lda   (ZX0_src), y
              inc   ZX0_src
              bne   plus1
              inc   ZX0_src+1
plus1:             sta   (ZX0_dst),y
              inc   ZX0_dst
              bne   plus2
              inc   ZX0_dst+1
plus2:             dex
              bne   cop0

              asl   bitr
              bcs   dzx0s_new_offset

; Copy from last offset (repeat N bytes from last offset)
;    Elias(length)
              jsr   get_elias
dzx0s_copy:
              lda   ZX0_dst
              sbc   offset  ; C=0 from get_elias
              sta   pntr
              lda   ZX0_dst+1
              sbc   offset+1
;======
	;================================
	; VMW -- code to handle that read/write different addresses
	clc
	adc	READ_WRITE_OFFSET
;======
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
              jsr   get_elias
              beq   exit  ; Read a 0, signals the end
              ; Decrease and divide by 2
              dex
              txa
              lsr   ; @
              sta   offset+1

              ; Get low part of offset, a literal 7 bits
              lda   (ZX0_src), y
              inc   ZX0_src
              bne   plus5
              inc   ZX0_src+1
plus5:
              ; Divide by 2
              ror   ; @
              sta   offset

              ; And get the copy length.
              ; Start elias reading with the bit already in carry:
              ldx   #1
              jsr   elias_skip1

              inx
              bcc   dzx0s_copy

; Read an elias-gamma interlaced code.
; ------------------------------------
get_elias:

	;=======================
	;=======================
	;=======================
	; added for split load
	;=======================
	;=======================
	;=======================
blug:
	ldx	INTIM
	bne	done_vmw

check_here:

	; need to save A and Y
	pha
	tya
	pha

	; 188 scanlines in?

;	sta	WSYNC
;	sta	WSYNC
;	sta	WSYNC


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
	;=======================
	;=======================

	; Initialize return value to #1
	ldx	#1
	bne	elias_start

elias_get:    ; Read next data bit to result
              asl   bitr
              rol   ; @
              tax

elias_start:
              ; Get one bit
              asl   bitr
              bne   elias_skip1

              ; Read new bit from stream
              lda   (ZX0_src), y
              inc   ZX0_src
              bne   plus6
              inc   ZX0_src+1
plus6:             ;sec   ; not needed, C=1 guaranteed from last bit
              rol   ;@
              sta   bitr

elias_skip1:

	txa
	bcs	elias_get

	; Got ending bit, stop reading

	rts		; debug


exit:

	;========================================
	; If we finish before timer expires...
	;========================================
check_timer:
	ldx	INTIM			; see if 192 scanline counter done
	bne	check_timer		; if not, loop

;	sta	WSYNC
;	sta	WSYNC
;	sta	WSYNC
;
	ldx	#29			; do the overscan
	jsr	common_overscan
uyat:
	rts

