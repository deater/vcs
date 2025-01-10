.align $100

; 0=neutral, 1=block, 2=punch_left, 3=punch_right, 4=hit, 5=dead

lboxer_sprites_l:
	.byte <boxer_sprite_left,<boxer_block_left,<boxer_lpunch_left
	.byte <boxer_rpunch_left,<boxer_hit_left,<boxer_dead_left
lboxer_colors_l:
	.byte <boxer_sprite_left_colors,<boxer_block_left_colors
	.byte <boxer_lpunch_left_colors,<boxer_rpunch_left_colors
	.byte <boxer_hit_left_colors,<boxer_dead_left_colors

rboxer_sprites_l:
	.byte <boxer_sprite_right,<boxer_block_right,<boxer_lpunch_right
	.byte <boxer_rpunch_right,<boxer_hit_right,<boxer_dead_right
rboxer_colors_l:
	.byte <boxer_sprite_right_colors,<boxer_block_right_colors
	.byte <boxer_lpunch_right_colors,<boxer_rpunch_right_colors
	.byte <boxer_hit_right_colors,<boxer_dead_right_colors

; 0 = normal, 1=coiled, 2=injured, 3=strike

snake_sprites_l:
	.byte <snake_sprite,<snake_coiled,<snake_injured,<snake_strike
snake_sprites_h:
	.byte >snake_sprite,>snake_coiled,>snake_injured,>snake_strike

snake_colors:
	.byte	98*2	; 0 = dark green
	.byte	$BC	; 1 = cyan green
	.byte	$9C	; 2 = light blue
	.byte	$34	; 3 = red
	.byte	$26	; 4 = orange
	.byte	$44	; 5 = magenta
	.byte	$1C	; 6 = yellow
	.byte	$72	; 7 = medium blue
	.byte	$66	; 8 = blue grey
	.byte	$80	; 9 = dark blue
	.byte	$A2	; 10 = dark green
	.byte	$C8	; 11 = light green
	.byte	$BC	; 12 = cyan green
	.byte	$34	; 13 = red
	.byte	$56	; 14 = purple
	.byte	$48	; 15 = magenta
	.byte	$08	; 16 = grey
	.byte	$0E	; 17 = white
	.byte	$5A	; 18 = lavendar
	.byte	$56	; 19 = purple
	.byte	$00	; 20+ = black

	; assumes max is 3
mans_max_lookup:
	.byte 20,30,46,64

;================================================================
; Boxer data
;	must all fit in one page as we don't save high pointers
;================================================================

.align $100

boxer_data:

boxer_hit_left:
	.byte	$40	; .I...... .....I..	; 0
	.byte	$E0	; III..... ....III.	; 1
	.byte	$F0	; IIII.... ...IIII.	; 2
	.byte	$60	; .II..... ....II..	; 3
	.byte	$3B	; ..XXX.XX X.XXX...	; 4
	.byte	$17	; ...X.XXX XX.X....	; 5
	.byte	$17	; ...X.XXX XX.X....	; 6
	.byte	$07	; .....XXX XX......	; 7
	.byte	$07	; .....XXX XX......	; 8
	.byte	$01	; .......X ........	; 9
	.byte	$00	; ........ ........	; 10
;	.byte	$00	; ........ ........	; 11
;	.byte	$00	; ........ ........	; 12

boxer_dead_left:
	.byte	$00	; ........ ........	0
	.byte	$00	; ........ ........	1
	.byte	$3F	; ..BBBBBB BBBBB..B	2
	.byte	$7F	; .BBBBBBB BBB....B	3
	.byte	$7E	; .BBBBBB. BB.....B	4
	.byte	$FE	; BBBBBBB. B......B	5
	.byte	$01	; .......G .L     L	6
	.byte	$0A	; ....Y.Y. .L..LL.L	7
	.byte	$15	; ...Y.Y.Y .L.LL..L	8
	.byte	$0E	; ....YYY. .L.....L	9
	.byte	$15	; ...Y.Y.Y ..L...L.	10
	.byte	$0A	; ....Y.Y. ...LLL..	11
	.byte	$00	; ........ ........	12

boxer_hit_right:
	.byte	$04	; .I...... .....I..	; 0
	.byte	$0E	; III..... ....III.	; 1
	.byte	$1E	; IIII.... ...IIII.	; 2
	.byte	$0C	; .II..... ....II..	; 3
	.byte	$B8	; ..XXX.XX X.XXX...	; 4
	.byte	$D0	; ...X.XXX XX.X....	; 5
	.byte	$D0	; ...X.XXX XX.X....	; 6
	.byte	$C0	; .....XXX XX......	; 7
	.byte	$C0	; .....XXX XX......	; 8
	.byte	$00	; .......X ........	; 9
	.byte	$00	; ........ ........	; 10
;	.byte	$00	; ........ ........	; 11
;	.byte	$00	; ........ ........	; 12

boxer_dead_right:
	.byte	$00	; ........ ........	0
	.byte	$00	; ........ ........	1
	.byte	$F9	; ..BBBBBB BBBBB..B	2
	.byte	$E1	; .BBBBBBB BBB....B	3
	.byte	$C1	; .BBBBBB. BB.....B	4
	.byte	$81	; BBBBBBB. B......B	5
	.byte	$41	; .......G .L.....L	6
	.byte	$4D	; ....Y.Y. .L..LL.L	7
	.byte	$59	; ...Y.Y.Y .L.LL..L	8
	.byte	$41	; ....YYY. .L.....L	9
	.byte	$22	; ...Y.Y.Y ..L...L.	10
	.byte	$1C	; ....Y.Y. ...LLL..	11
;	.byte	$00	; ........ ........	12

boxer_rpunch_left:
	.byte	$00	; ........ ........	; 0
	.byte	$0C	; ....XX.. ........	; 1
	.byte	$1B	; ...XX.XX X.......	; 2
	.byte	$37	; ..XX.XXX XX......	; 3
	.byte	$37	; ..XX.XXX XX.X....	; 4
	.byte	$37	; ..XX.XXX XX.X....	; 5
	.byte	$33	; ..II..XX X.XX....	; 6
	.byte	$79	; .IIII..X .XXX....	; 7
	.byte	$78	; .IIII... .XX.....	; 8
	.byte	$30	; ..II.... .XX.....	; 9
	.byte	$00	; ........ .XX.....	; 10
;	.byte	$00	; ........ .II.....	; 11
;	.byte	$00	; ........ IIII...	; 12

boxer_rpunch_right:
	.byte	$00	; ........ ........	; 0
	.byte	$00	; ....XX.. ........	; 1
	.byte	$80	; ...XX.XX X.......	; 2
	.byte	$C0	; ..XX.XXX XX......	; 3
	.byte	$D0	; ..XX.XXX XX.X....	; 4
	.byte	$D0	; ..XX.XXX XX.X....	; 5
	.byte	$B0	; ..II..XX X.XX....	; 6
	.byte	$70	; .IIII..X .XXX....	; 7
	.byte	$60	; .IIII... .XX.....	; 8
	.byte	$60	; ..II.... .XX.....	; 9
	.byte	$60	; ........ .XX.....	; 10
	.byte	$60	; ........ .II.....	; 11
	.byte	$F0	; ........ IIII...	; 12

boxer_block_left:
	.byte	$00	; ........ ........	0
	.byte	$00	; ........ ........	1
	.byte	$03	; ......XX X.......	2
	.byte	$07	; .....XXX XX......	3
	.byte	$17	; ...X.XXX XX.X....	4
	.byte	$17	; ...X.XXX XX.X....	5
	.byte	$1B	; ...XX.XX X.XX....	6
	.byte	$1D	; ...XXX.X .XXX....	7
	.byte	$0F	; ....XIII IIX.....	8
	.byte	$0F	; ....IIII III.....	9
	.byte	$0F	; ....IIII III.....	10
	.byte	$06	; .....II. II......	11
;	.byte	$00	; ........ ........	12

boxer_lpunch_left:
	.byte	$00	; ........ ........	; 0
	.byte	$00	; ........ .XX.....	; 1
	.byte	$03	; ......XX X.XX....	; 2
	.byte	$07	; .....XXX XX.XX...	; 3
	.byte	$17	; ...X.XXX XX.XX...	; 4
	.byte	$17	; ...X.XXX XX.XX...	; 5
	.byte	$1B	; ...XX.XX X..II...	; 6
	.byte	$1D	; ...XXX.X ..IIII..	; 7
	.byte	$0C	; ....XX.. ..IIII..	; 8
	.byte	$0C	; ....XX.. ...II...	; 9
	.byte	$0C	; ....XX.. ........	; 10
	.byte	$0C	; ....II.. ........	; 11
	.byte	$1E	; ...IIII. ........	; 12



boxer_block_right:
	.byte	$00	; ........ ........	0
	.byte	$00	; ........ ........	1
	.byte	$80	; ......XX X.......	2
	.byte	$C0	; .....XXX XX......	3
	.byte	$D0	; ...X.XXX XX.X....	4
	.byte	$D0	; ...X.XXX XX.X....	5
	.byte	$B0	; ...XX.XX X.XX....	6
	.byte	$70	; ...XXX.X .XXX....	7
	.byte	$E0	; ....XIII IIX.....	8
	.byte	$E0	; ....IIII III.....	9
	.byte	$E0	; ....IIII III.....	10
	.byte	$C0	; .....II. II......	11
;	.byte	$00	; ........ ........	12

boxer_lpunch_right:
	.byte	$00	; ........ ........	; 0
	.byte	$60	; ........ .XX.....	; 1
	.byte	$B0	; ......XX X.XX....	; 2
	.byte	$D8	; .....XXX XX.XX...	; 3
	.byte	$D8	; ...X.XXX XX.XX...	; 4
	.byte	$D8	; ...X.XXX XX.XX...	; 5
	.byte	$98	; ...XX.XX X..II...	; 6
	.byte	$3C	; ...XXX.X ..IIII..	; 7
	.byte	$3C	; ....XX.. ..IIII..	; 8
	.byte	$18	; ....XX.. ...II...	; 9
	.byte	$00	; ....XX.. ........	; 10
;	.byte	$00	; ....II.. ........	; 11
;	.byte	$00	; ...IIII. ........	; 12

boxer_sprite_left:
	.byte	$00	; ........ ........	0
	.byte	$00	; ........ ........	1
	.byte	$03	; ......XX X.......	2
	.byte	$37	; ..XX.XXX XX.XX...	3
	.byte	$37	; ..XX.XXX XX.XXX..	4
	.byte	$37	; ..XX.XXX XX.XXX..	5
	.byte	$37	; ..XX.XXX XX..XX..	6
	.byte	$21	; ..X....X ...XX...	7
	.byte	$30	; ..XX.... .BBB....	8
	.byte	$38	; ..BBB... BBBB....	9
	.byte	$3c	; ..BBBB.. BBBB....	10
	.byte	$3c	; ..BBBB.. .BB.....	11
	.byte	$18	; ...BB... ........	12

boxer_sprite_right:
	.byte	$00	; ........ ........	0
	.byte	$00	; ........ ........	1
	.byte	$80	; ......XX X.......	2
	.byte	$D8	; ..XX.XXX XX.XX...	3
	.byte	$DC	; ..XX.XXX XX.XXX..	4
	.byte	$DC	; ..XX.XXX XX.XXX..	5
	.byte	$CC	; ..XX.XXX XX..XX..	6
	.byte	$18	; ..X....X ...XX...	7
	.byte	$70	; ..XX.... .BBB....	8
	.byte	$F0	; ..BBBB.. BBBB....	9
	.byte	$F0	; ..BBBB.. BBBB....	10
	.byte	$60	; ..BBBB.. .BB.....	11
;	.byte	$00	; ...BB... ........	12

boxer_sprite_left_colors:
	.byte 0,0,78,78,78,78,78,78,78,64,64,64,64
boxer_sprite_right_colors:
	.byte 0,0,78,78,78,78,78,78,64,64,64,64;,0

boxer_block_left_colors:
boxer_block_right_colors:
;	.byte 0,0,78,78,78,78,78,78,64,64,64,64,0
	.byte 0,0,78,78,78,78,78,78,64,64,64,64;,0


boxer_lpunch_right_colors:
	.byte 0,78,78,78,78,78,54,64,64,64,0,0;,0
boxer_rpunch_left_colors:
	.byte 0,78,78,78,78,78,54,54,64,64,0;,0,0
boxer_rpunch_right_colors:
boxer_lpunch_left_colors:
;	.byte 0,0,78,78,78,78,78,78,78,78,78,78,64
	.byte 0,0,78,78,78,78,78,78,78,78,78,78,64

boxer_hit_left_colors:
boxer_hit_right_colors:
;	.byte 50,50,50,50,54,54,54,54,54,54,0,0,0
	.byte 50,50,50,50,54,54,54,54,54,54,0;,0,0

boxer_dead_right_colors:
	.byte 0,0,36,36,36,36,0,0,0,0,0;,0,0
boxer_dead_left_colors:
	.byte 0,0,36,36,36,36,216,30,30,30,30,30,0


.align $100

;======================================================
; snake sprites
;======================================================

snake_sprite:
	.byte	$00	; .... ....		; 0
	.byte	$14	; ...X .X..		; 1
	.byte	$08	; .... X...		; 2
	.byte	$08	; .... X...		; 3
	.byte	$1C	; ...X XX..		; 4
	.byte	$2A	; ..X. X.X.		; 5
	.byte	$2A	; ..X. X.X.		; 6
	.byte	$3E	; ..XX XXX.		; 7
	.byte	$3E	; ..XX XXX.		; 8
	.byte	$1C	; ...X XX..		; 9
	.byte	$3C	; ..XX XX..		; 10
	.byte	$3C	; ..XX XX..		; 11
	.byte	$70	; .XXX ....		; 12
	.byte	$70	; .XXX ....		; 13
	.byte	$60	; .XX. ....		; 14
	.byte	$60	; .XX. ....		; 15
	.byte	$30	; ..XX ....		; 16
	.byte	$10	; ...X ....		; 17
	.byte	$08	; .... X...		; 18
	.byte	$08	; .... X...		; 19
	.byte	$01	; ...X ....		; 20

snake_coiled:
	.byte	$00	; .... ....		; 0
	.byte	$00	; .... ....		; 1
	.byte	$00	; .... ....		; 2
	.byte	$00	; .... ....		; 3
	.byte	$00	; .... ....		; 4
	.byte	$00	; .... ....		; 5
	.byte	$00	; .... ....		; 6
	.byte	$00	; .... ....		; 7
	.byte	$00	; .... ....		; 8
	.byte	$08	; .... X...		; 9
	.byte	$1C	; ...X XX..		; 10
	.byte	$2A	; ..X. X.X.		; 11
	.byte	$2A	; ..X. X.X.		; 12
	.byte	$3E	; ..XX XXX.		; 13
	.byte	$7E	; .XXX XXX.		; 14
	.byte	$FC	; XXXX XX..		; 15
	.byte	$C0	; XX.. ....		; 16
	.byte	$70	; .XXX ....		; 17
	.byte	$1C	; ...X XX..		; 18
	.byte	$24	; ..X. .X..		; 19
	.byte	$18	; ...X X...		; 20

snake_injured:
	.byte	$00	; .... ....		; 0
	.byte	$00	; .... ....		; 1
	.byte	$00	; .... ....		; 2
	.byte	$00	; .... ....		; 3
	.byte	$00	; .... ....		; 4
	.byte	$00	; .... ....		; 5
	.byte	$00	; .... ....		; 6
	.byte	$00	; .... ....		; 7
	.byte	$00	; .... ....		; 8
	.byte	$38	; ..XX X...		; 9
	.byte	$7E	; .XXX XXX.		; 10
	.byte	$BF	; X.XX XXXX		; 11
	.byte	$FF	; XXXX XXXX		; 12
	.byte	$D6	; XX.X .XX.		; 13
	.byte	$6C	; .XX. XX..		; 14
	.byte	$98	; X..X X...		; 15
	.byte	$59	; .X.X X..X		; 16
	.byte	$0E	; .... XXX.		; 17
	.byte	$00	; .... ....		; 18
	.byte	$00	; .... ....		; 19
	.byte	$00	; .... ....		; 20

snake_strike:
	.byte	$54	; .X.X .X..		; 0
	.byte	$54	; .X.X .X..		; 1
	.byte	$7C	; .XXX XX..		; 2
	.byte	$7C	; .XXX XX..		; 3
	.byte	$3C	; ..XX XX..		; 4
	.byte	$1E	; ...X XXX.		; 5
	.byte	$1E	; ...X XXX.		; 6
	.byte	$0E	; .... XXX.		; 7
	.byte	$0E	; .... XXX.		; 8
	.byte	$0C	; .... XX..		; 9
	.byte	$1C	; ...X XX..		; 10
	.byte	$38	; ..XX X...		; 11
	.byte	$30	; ..XX ....		; 12
	.byte	$60	; .XX. ....		; 13
	.byte	$60	; .XX. ....		; 14
	.byte	$60	; .XX. ....		; 15
	.byte	$30	; ..XX ....		; 16
	.byte	$08	; .... X...		; 17
	.byte	$08	; .... X...		; 18
	.byte	$10	; ...X ....		; 19
	.byte	$20	; ..X. ....		; 20





; original game had 20 hitpoints snake, 10 for you
; a lot easier here to have 16/8?
; full width 40/20?
; compromise centered 20/10


; PF0  PF1      PF2      PF0  PF1      PF2
; 4567 76543210 01234567 4567 76543210 01234567
;            XX XXXXXXXX XXXX XXXXXX

; 21 entries each

; 8,8,4,8,8,4



health_pf1_l:
	.byte	$00,$02,$03,$03,$03,$03,$03,$03,$03,$03		; 0..9
	.byte	$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03	; 10..20

health_pf2_l:
	.byte	$00,$00,$00,$01,$03,$07,$0f,$1f,$3f,$7f		; 0..9
	.byte	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff	; 10..20

health_pf0_r:
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; 0..9
	.byte	$00,$10,$30,$70,$f0,$f0,$f0,$f0,$f0,$f0,$f0	; 10..20

health_pf1_r:
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; 0..9
	.byte	$00,$00,$00,$00,$00,$80,$c0,$e0,$f0,$f8,$fc	; 10..20


.align $100

ko_sprite0:
	.byte $00
	.byte $A9	; *.*.*..*
	.byte $A9	; *.*.*..*
	.byte $AB	; *.*.*.**
	.byte $CB	; **..*.**
	.byte $CD	; **..**.*
	.byte $AD	; *.*.**.*
	.byte $A9	; *.*.*..*
	.byte $A9	; *.*.*..*

ko_sprite1:
	.byte $00
	.byte $23	; ..*...**
	.byte $54	; .*.*.*..
	.byte $54	; .*.*.*..
	.byte $54	; .*.*.*..
	.byte $54	; .*.*.*..
	.byte $54	; .*.*.*..
	.byte $54	; .*.*.*..
	.byte $23	; ..*...**

ko_sprite2:
	.byte $00
	.byte $52	; .*.*..*.
	.byte $55	; .*.*.*.*
	.byte $55	; .*.*.*.*
	.byte $65	; .**..*.*
	.byte $65	; .**..*.*
	.byte $55	; .*.*.*.*
	.byte $55	; .*.*.*.*
	.byte $52	; .*.*..*.

ko_sprite3:
	.byte $00
	.byte $22	; ..*...*.
	.byte $52	; .*.*..*.
	.byte $52	; .*.*..*.
	.byte $52	; .*.*..*.
	.byte $52	; .*.*..*.
	.byte $52	; .*.*..*.
	.byte $52	; .*.*..*.
	.byte $57	; .*.*.***

ko_sprite4:
	.byte $00
	.byte $60	; .**.....
	.byte $14	; ...*.*..
	.byte $14	; ...*.*..
	.byte $10	; ...*....
	.byte $20	; ..*.....
	.byte $44	; .*...*..
	.byte $44	; .*...*..
	.byte $30	; ..**....

;ko_sprite5:
;	.byte $00
;	.byte $72	; .***..*.
;	.byte $45	; .*...*.*
;	.byte $45	; .*...*.*
;	.byte $22	; ..*...*.
;	.byte $32	; ..**..*.
;	.byte $15	; ...*.*.*
;	.byte $15	; ...*.*.*
;	.byte $62	; .**...*.

score_zeros:    .byte $22,$55,$55,$55,$55,$55,$55,$22
score_ones:     .byte $22,$66,$22,$22,$22,$22,$22,$77
score_twos:     .byte $22,$55,$11,$22,$22,$44,$44,$77
score_threes:   .byte $22,$55,$11,$22,$22,$11,$55,$22
score_fours:    .byte $55,$55,$55,$77,$77,$11,$11,$11

; --****** ----**-- --****** ----**-- ----**--
; --**---- --**--** ------** --**--** --**--**
; --**---- --**---- ------** --**--** --**--**
; --****-- --****-- ----**-- ----**-- --**--**
; ------** --**--** ----**-- ----**-- ----****
; ------** --**--** --**---- --**--** ------**
; --**--** --**--** --**---- --**--** --**--**
; ----**-- ----**-- --**---- ----**-- ----**--

score_fives:    .byte $77,$44,$44,$66,$11,$11,$55,$22
score_sixes:    .byte $22,$55,$44,$66,$55,$55,$55,$22
score_sevens:   .byte $77,$11,$11,$22,$22,$44,$44,$44
score_eights:   .byte $22,$55,$55,$22,$22,$55,$55,$22
score_nines:    .byte $22,$55,$55,$55,$33,$11,$55,$22
score_blank:	.byte $00,$00,$00,$00,$00,$00,$00,$00







