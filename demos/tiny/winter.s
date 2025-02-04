.include "../../vcs.inc"

; reset vector at OFFSET - 4
OFFSET = 31

.org $f3c1

; upon reset expected: SP = $fd
; also expected: mirroring every 32 bytes

; Look, ma, no init routine! 
;
; Except not really, of course. I'm doing HW init in one pha at the bottom of the screen loop.
; This is a trade-off: I get only one zero-byte per screen in exchange for four extra bytes
; of machine code that I (desperately) need, especially since I also need to cld in order to
; be able to use adc #1 (which takes one more byte than inx, iny).
;
; Depending on the initial state, the demo may show nonsense during the first ~4 seconds. This
; can be random garbage in PF0, a strange background color, a sprite or anything else. It's
; surprisingly rare at least in Stella with random initial state, though.

	.byte $e0
screen:
   lda   #$3b              ;  0 -- Bit of luck: this pattern looks nice in PF1,2 and works well
   sta   PF1               ;  2 -- in CTRLPF: reflect | score | unimportant stuff. Weirdly, even
   sta   PF2               ;  4 -- the usually frustrating mirroring of PF1 that makes horizontal
   sta   CTRLPF            ;  6 -- scrolling such a pain works to my advantage.
   	 		   ;       Feel free to try other patterns. It's only important that
			   ;       SCORE is set, PFP is not set, and possibly that three consecutive
			   ;       bits are set so that the sync block works, although I'm unsure
			   ;       of the exact semantics there. It works in Stella with #$0b, which
			   ;       kinda surprised me.
sync:
   lsr                     ;  8 -- this part inspired by (lifted from) SvOlli
   sta   WSYNC             ;  9
   sta   VSYNC             ; 11
   bne   sync              ; 13 -- Reset vector no longer here, though; this points between
                           ;       instructions now. See below.

   tsx                     ; 15 -- S doubles as counter for the right topmost color.
line:
	dex                     ; 16 -- Walk through the rainbow, one color every line.
	dey                     ; 17 -- Variation: iny instead of dey here. I like dey better. iny
                           ;       feels like inconsistent shadows to me.
	sta	WSYNC             ; 18
	sty	COLUP0            ; 20 -- set new colors
	stx	COLUP1            ; 22
	cld		; 24 -- Having cld close to the adc instruction keeps
			;	 the invalid region for the reset vector small.
			;	Doesn't matter that it's execd often.
	adc	#1	; 25 -- A from 0 to 0, carry set at outset => 255
			;	scanlines per screen.
			;       This means that Y increases by 1 each screen
			;	(dey 255 times)
	bne	line	; 27 -- doubles as reset vector (f3d0), happens to
			;	point at 15: tsx.  Any instruction except
			;	the adc would be fine, though. The reason
			;       adc is not fine is that the CPU could be in
			;	BCD mode after reset
			;       On that note, whoever invented BCD ought
			;	to be clipped round the ear.
	pha		; 29 -- A is 0 here, so this will eventually init hw.
;	beq	screen	; 30
	.byte	$F0
