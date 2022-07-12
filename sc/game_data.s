
; Various game data
; we need to align this carefully so it doesn't cross a page boundary
; otherwise it can take an extra cycle to load which will throw
; off all of our calculations

.align	$100

; Level 1 Playfield data

playfield0_left:
	.byte	$F0,$10,$10,$10,$10,$10,$10,$10
	.byte	$10,$10,$10,$10,$10,$10,$10,$10
	.byte	$10,$10,$10,$10,$10,$10,$10,$10
	.byte	$10,$10,$10,$10,$10,$10,$10,$10
	.byte	$10,$10,$10,$10,$10,$F0
playfield1_left:
	.byte	$FF,$00,$00,$00,$00,$7f,$7f,$7f
	.byte	$7f,$18,$18,$18,$18,$18,$18,$18
	.byte	$18,$18,$18,$18,$18,$18,$18,$18
	.byte	$18,$18,$18,$18,$18,$7f,$7f,$7f
	.byte	$7f,$00,$00,$00,$00,$FF
playfield2_left:
	.byte	$FF,$00,$00,$00,$00,$1f,$1f,$1f
	.byte	$1f,$00,$00,$00,$00,$00,$fe,$fe
	.byte	$1e,$02,$02,$02,$02,$1e,$fe,$fe
	.byte	$00,$00,$00,$00,$00,$1f,$1f,$1f
	.byte	$1f,$00,$00,$00,$00,$FF

.align	$100


;===================
; videlectrix logo

vid_bitmap0:	.byte	$18,$24,$24,$5A,$DB,$A5,$42,$C3
vid_bitmap1:	.byte	$00,$4e,$52,$4e,$02,$42,$80,$80
vid_bitmap2:	.byte	$00,$74,$a5,$95,$74,$04,$00,$00
vid_bitmap3:	.byte	$00,$e7,$48,$28,$e6,$00,$00,$00
vid_bitmap4:	.byte	$00,$34,$44,$44,$f7,$40,$00,$00
vid_bitmap5:	.byte	$00,$29,$26,$A6,$09,$20,$00,$00


fine_adjust_table:
	; left
	.byte $70
	.byte $60
	.byte $50
	.byte $40
	.byte $30
	.byte $20
	.byte $10
	.byte $00

	; right
	.byte $F0	; -1
	.byte $E0	; -2
	.byte $D0	; -3
	.byte $C0	; -4
	.byte $B0	; -5
	.byte $A0	; -6
	.byte $90	; -7
	.byte $80	; -8 (?)

.if 0
bargraph_lookup_p0:
	.byte $f0,$e0,$c0,$80,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00

bargraph_lookup_p1:
	.byte $ff,$ff,$ff,$ff,$7f,$3f,$1f,$0f
	.byte $07,$03,$01,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00

bargraph_lookup_p2:
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$fe,$fc,$f8,$f0
	.byte $e0,$c0,$80,$00
.endif


bargraph_lookup_p0:
	.byte $f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0
	.byte $f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0
	.byte $f0,$70,$30,$10,$00

bargraph_lookup_p1:
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$fe,$fc,$f8,$f0,$e0,$c0,$80
	.byte $00,$00,$00,$00,$00

bargraph_lookup_p2:
	.byte $ff,$7f,$3f,$1f,$0f,$07,$03,$01
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00


score_bitmap0:
	.byte $22,$55,$55,$55,$55,$55,$22
score_bitmap1:
;	.byte $AA,$55,$AA,$55,$AA,$55,$AA
	.byte $22,$55,$55,$55,$55,$55,$22
score_bitmap2:
	.byte $22,$55,$55,$55,$55,$55,$22
;	.byte $AA,$AA,$AA,$AA,$55,$55,$55
score_bitmap3:
	.byte $22,$55,$55,$55,$55,$55,$22
;	.byte $F0,$0F,$F0,$0F,$F0,$0F,$F0

mans_bitmap0:
	.byte $88,$D8,$AA,$AA,$8B,$8A,$8A,$00
mans_bitmap1:
	.byte $88,$4C,$2A,$29,$e8,$28,$28,$00
mans_bitmap2:
	.byte $9E,$A0,$A0,$9C,$82,$82,$BC,$00
mans_bitmap3:
	.byte $02,$86,$82,$02,$82,$82,$07,$00

