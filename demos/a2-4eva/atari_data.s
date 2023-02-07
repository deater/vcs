;.align $100

atari_row_lookup:
.byte	 0, 0,15,15
.byte	14,13,12,12
.byte	12,12,12,11
.byte	11,10, 9, 9
.byte	 8, 7, 7, 7
.byte	 6, 5, 5, 5
.byte	 4, 4, 4, 4
.byte	 4, 3, 2, 2
.byte	 2, 2, 2, 2
.byte	 2, 2, 2, 2

atari_playfield1_left:
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$01,$03,$07,$07,$07,$07,$06

atari_playfield2_left:
	.byte $00,$A0,$B0,$B8,$98,$9C,$9E,$8E
	.byte $8F,$8F,$87,$87,$83,$81,$80,$80


