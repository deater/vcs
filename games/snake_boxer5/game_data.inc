.align $100

; 0=neutral, 1=block, 2=punch_left, 3=punch_right, 4=hit, 5=dead

lboxer_sprites_l:
	.byte <boxer_sprite_left,<boxer_block_left,<boxer_lpunch_left
	.byte <boxer_rpunch_left,<boxer_hit_left,<boxer_dead_left
lboxer_sprites_h:
	.byte >boxer_sprite_left,>boxer_block_left,>boxer_lpunch_left
	.byte >boxer_rpunch_left,>boxer_hit_left,>boxer_dead_left

rboxer_sprites_l:
	.byte <boxer_sprite_right,<boxer_block_right,<boxer_lpunch_right
	.byte <boxer_rpunch_right,<boxer_hit_right,<boxer_dead_right
rboxer_sprites_h:
	.byte >boxer_sprite_right,>boxer_block_right,>boxer_lpunch_right
	.byte >boxer_rpunch_right,>boxer_hit_right,>boxer_dead_right

snake_sprites_l:
	.byte <snake_sprite
snake_sprites_h:
	.byte >snake_sprite

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

;=====================================

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

boxer_dead_right_colors:
	.byte 0,0,36,36,36,36,216,30,30,30,30,30,0
boxer_dead_left_colors:
	.byte 0,0,36,36,36,36,0,0,0,0,0,0,0


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
	.byte	$00	; ........ ........	12

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
	.byte	$00	; ........ ........	; 11
	.byte	$00	; ........ ........	; 12

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
	.byte	$00	; ........ ........	; 11
	.byte	$00	; ........ ........	; 12



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
	.byte	$00	; ........ .XX.....	; 11
	.byte	$00	; ........ .XX.....	; 12
	.byte	$00	; ........ .II.....	; 13
	.byte	$00	; ........ IIII...	; 14
	.byte	$00	; ........ IIII....	; 15
	.byte	$00	; ........ .II.....	; 16

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
	.byte	$60	; ........ .XX.....	; 11
	.byte	$60	; ........ .XX.....	; 12
	.byte	$60	; ........ .II.....	; 13
	.byte	$F0	; ........ IIII...	; 14
	.byte	$F0	; ........ IIII....	; 15
	.byte	$60	; ........ .II.....	; 16



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
	.byte	$0C	; ....XX.. ........	; 11
	.byte	$0C	; ....XX.. ........	; 12
	.byte	$0C	; ....II.. ........	; 13
	.byte	$1E	; ...IIII. ........	; 14
	.byte	$1E	; ...IIII. ........	; 15
	.byte	$0C	; ....II.. ........	; 16

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
	.byte	$00	; ....XX.. ........	; 11
	.byte	$00	; ....XX.. ........	; 12
	.byte	$00	; ....II.. ........	; 13
	.byte	$00	; ...IIII. ........	; 14
	.byte	$00	; ...IIII. ........	; 15
	.byte	$00	; ....II.. ........	; 16

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
	.byte	$00	; ........ ........	12

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
	.byte	$00	; ........ ........	12



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
	.byte	$00	; ..BBBB.. ........	12
	.byte	$00	; ...BB... ........

snake_sprite:
	.byte	$00				; 0
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

snake_sprite0:
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........	; missing line (30)
	.byte $01	; .......*
	.byte $01	; .......*
	.byte $03	; ......**
	.byte $07	; .....***
	.byte $0F	; ....****
	.byte $0F	; ....****
	.byte $1F	; ...*****
	.byte $3F	; ..******
	.byte $3E	; ..*****.
	.byte $38	; ..***...
	.byte $30	; ..**....
	.byte $78	; .****...
	.byte $FF	; ********
	.byte $FE	; *******.
	.byte $E0	; ***.....
	.byte $C0	; **......
	.byte $E0	; ***.....
	.byte $F0	; ****....
	.byte $F0	; ****....
	.byte $C3	; **....**
	.byte $C3	; **....**
	.byte $E3	; ***...**
	.byte $F3	; ****..**
	.byte $F3	; ****..**
	.byte $C3	; **....**
	.byte $C3	; **....**
	.byte $E3	; ***...**
	.byte $F3	; ****..**
	.byte $F3	; ****..**
	.byte $E1	; ***....*
	.byte $C0	; **......
	.byte $E0	; ***.....
	.byte $F0	; ****....
	.byte $70	; .***....
	.byte $78	; .****...
	.byte $3C	; ..****..
	.byte $3C	; ..****..
	.byte $1F	; ...*****
	.byte $0F	; ....****
	.byte $0F	; ....****
	.byte $0F	; ....****
	.byte $07	; .....***
	.byte $01	; .......*
	.byte $01	; .......*
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........

snake_sprite1:
	.byte $38	; ..***...
	.byte $38	; ..***...
	.byte $38	; ..***...
	.byte $38	; ..***...
	.byte $38	; ..***...
	.byte $38	; ..***...
	.byte $38	; ..***...
	.byte $38	; ..***...
	.byte $38	; ..***...
	.byte $38	; ..***...
	.byte $18	; ...**...
	.byte $1C	; ...***..
	.byte $1E	; ...****.
	.byte $1E	; ...****.
	.byte $1E	; ...****.
	.byte $1E	; ...****.
	.byte $0E	; ....***.
	.byte $0E	; ....***.
	.byte $07	; .....***
	.byte $07	; .....***
	.byte $03	; ......**
	.byte $01	; .......*
	.byte $01	; .......*
	.byte $01	; .......*
	.byte $03	; ......**
	.byte $07	; .....***
	.byte $1F	; ...*****
	.byte $1F	; ...*****
	.byte $1F	; ...*****
	.byte $3F	; ..******
	.byte $F9	; *****..*	; missing line? (30)
	.byte $F9	; *****..*
	.byte $FE	; *******.
	.byte $FE	; *******.
	.byte $FE	; *******.
	.byte $00	; ........
	.byte $18	; ...**...
	.byte $38	; ..***...
	.byte $60	; .**.....
	.byte $60	; .**.....
	.byte $60	; .**.....
	.byte $60	; .**.....
	.byte $60	; .**.....
	.byte $00	; ........
	.byte $00	; ........
	.byte $3F	; ..******
	.byte $7F	; .*******
	.byte $7F	; .*******
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $E6	; ***..**.
	.byte $E6	; ***..**.
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $C7	; **...***
	.byte $C3	; **....**
	.byte $C0	; **......
	.byte $C0	; **......
	.byte $C0	; **......
	.byte $C0	; **......
	.byte $C6	; **...**.
	.byte $DE	; **.****.
	.byte $98	; *..**...
	.byte $D8	; **.**...
	.byte $39	; ..***..*
	.byte $39	; ..***..*
	.byte $39	; ..***..*
	.byte $19	; ...**..*
	.byte $19	; ...**..*
	.byte $9F	; *..*****
	.byte $9F	; *..*****
	.byte $1F	; ...*****
	.byte $1F	; ...*****
	.byte $1F	; ...*****
	.byte $0F	; ....****
	.byte $07	; .....***

snake_sprite2:
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $01	; .......*
	.byte $03	; ......**
	.byte $03	; ......**
	.byte $07	; .....***
	.byte $0E	; ....***.
	.byte $1C	; ...***..
	.byte $1C	; ...***..
	.byte $38	; ..***...
	.byte $30	; ..**....
	.byte $70	; .***....
	.byte $60	; .**.....
	.byte $40	; .*......
	.byte $40	; .*......
	.byte $C0	; **......
	.byte $C0	; **......
	.byte $C0	; **......
	.byte $C0	; **......
	.byte $E0	; ***.....
	.byte $F0	; ****....
	.byte $F0	; ****....
	.byte $FC	; ******..
	.byte $FC	; ******..
	.byte $FC	; ******..
	.byte $E7	; ***..***	; missing line (30)
	.byte $E7	; ***..***
	.byte $1B	; ...**.**
	.byte $1B	; ...**.**
	.byte $13	; ...*..**
	.byte $04	; .....*..
	.byte $0C	; ....**..
	.byte $0C	; ....**..
	.byte $18	; ...**...
	.byte $18	; ...**...
	.byte $1B	; ...**.**
	.byte $1B	; ...**.**
	.byte $1B	; ...**.**
	.byte $03	; ......**
	.byte $03	; ......**
	.byte $F0	; ****....
	.byte $F8	; *****...
	.byte $F8	; *****...
	.byte $FC	; ******..
	.byte $FC	; ******..
	.byte $7F	; .*******
	.byte $7F	; .*******
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $FC	; ******..
	.byte $FC	; ******..
	.byte $38	; ..***...
	.byte $38	; ..***...
	.byte $18	; ...**...
	.byte $1C	; ...***..
	.byte $04	; .....*..
	.byte $03	; ......**
	.byte $43	; .*....**
	.byte $E3	; ***...**
	.byte $F0	; ****....
	.byte $F8	; *****...
	.byte $F8	; *****...
	.byte $FC	; ******..
	.byte $FC	; ******..
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $FF	; ********

.align $100

snake_sprite3:
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $3F	; ..******
	.byte $7F	; .*******
	.byte $F0	; ****....
	.byte $E0	; ***.....
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $01	; .......*
	.byte $01	; .......*
	.byte $01	; .......*
	.byte $03	; ......**
	.byte $03	; ......**
	.byte $03	; ......**
	.byte $07	; .....***
	.byte $07	; .....***
	.byte $0F	; ....****
	.byte $0F	; ....****
	.byte $0F	; ....****
	.byte $3F	; ..******
	.byte $3E	; ..*****.
	.byte $3E	; ..*****.
	.byte $FF	; ********	; missing line (30)
	.byte $FF	; ********
	.byte $F8	; *****...
	.byte $F8	; *****...
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $3F	; ..******
	.byte $3E	; ..*****.
	.byte $3E	; ..*****.
	.byte $0F	; ....****
	.byte $0F	; ....****
	.byte $0F	; ....****
	.byte $C3	; **....**
	.byte $C3	; **....**
	.byte $E1	; ***....*
	.byte $F0	; ****....
	.byte $F0	; ****....
	.byte $3F	; ..******
	.byte $3F	; ..******
	.byte $0F	; ....****
	.byte $0F	; ....****
	.byte $8F	; *...****
	.byte $C7	; **...***
	.byte $C3	; **....**
	.byte $E0	; ***.....
	.byte $F0	; ****....
	.byte $F0	; ****....
	.byte $3E	; ..*****.
	.byte $3F	; ..******
	.byte $1F	; ...*****
	.byte $0F	; ....****
	.byte $0F	; ....****
	.byte $0F	; ....****
	.byte $0F	; ....****
	.byte $3F	; ..******
	.byte $3F	; ..******
	.byte $3F	; ..******
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $3F	; ..******
	.byte $3F	; ..******
	.byte $3F	; ..******
	.byte $3F	; ..******
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $FE	; *******.
	.byte $FC	; ******..

snake_sprite4:
	.byte $70	; .***....
	.byte $70	; .***....
	.byte $70	; .***....
	.byte $70	; .***....
	.byte $70	; .***....
	.byte $F0	; ****....
	.byte $F0	; ****....
	.byte $70	; .***....
	.byte $70	; .***....
	.byte $70	; .***....
	.byte $70	; .***....
	.byte $70	; .***....
	.byte $70	; .***....
	.byte $70	; .***....
	.byte $70	; .***....
	.byte $F0	; ****....
	.byte $F0	; ****....
	.byte $F8	; *****...
	.byte $FC	; ******..
	.byte $FC	; ******..
	.byte $FE	; *******.
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $01	; .......*
	.byte $00	; ........
	.byte $00	; ........
	.byte $FC	; ******..		; missing line (30)
	.byte $FE	; *******.
	.byte $07	; .....***
	.byte $07	; .....***
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $01	; .......*
	.byte $01	; .......*
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $80	; *.......
	.byte $80	; *.......
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $38	; ..***...
	.byte $38	; ..***...
	.byte $BF	; *.******
	.byte $BF	; *.******
	.byte $FF	; ********
	.byte $F8	; *****...
	.byte $F8	; *****...
	.byte $7F	; .*******
	.byte $7F	; .*******
	.byte $3F	; ..******
	.byte $38	; ..***...
	.byte $38	; ..***...
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $FF	; ********
	.byte $F8	; *****...
	.byte $B8	; *.***...
	.byte $BF	; *.******
	.byte $BF	; *.******
	.byte $BF	; *.******
	.byte $BF	; *.******
	.byte $BF	; *.******
	.byte $BF	; *.******
	.byte $FE	; *******.
	.byte $FC	; ******..
	.byte $F8	; *****...
	.byte $F0	; ****....
	.byte $C0	; **......
	.byte $80	; *.......
	.byte $80	; *.......
	.byte $00	; ........
	.byte $00	; ........

snake_sprite5:
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $80	; *.......
	.byte $80	; *.......
	.byte $80	; *.......
	.byte $C0	; **......
	.byte $C0	; **......
	.byte $E0	; ***.....
	.byte $60	; .**.....
	.byte $60	; .**.....
	.byte $60	; .**.....	; missing line (30)
	.byte $60	; .**.....
	.byte $E0	; ***.....
	.byte $F0	; ****....
	.byte $F0	; ****....
	.byte $F0	; ****....
	.byte $F0	; ****....
	.byte $F0	; ****....
	.byte $F0	; ****....
	.byte $F0	; ****....
	.byte $F0	; ****....
	.byte $F8	; *****...
	.byte $F8	; *****...
	.byte $1C	; ...***..
	.byte $1E	; ...****.
	.byte $FE	; *******.
	.byte $FE	; *******.
	.byte $FE	; *******.
	.byte $0E	; ....***.
	.byte $0E	; ....***.
	.byte $FE	; *******.
	.byte $FE	; *******.
	.byte $FE	; *******.
	.byte $0E	; ....***.
	.byte $0E	; ....***.
	.byte $FE	; *******.
	.byte $FE	; *******.
	.byte $FE	; *******.
	.byte $0E	; ....***.
	.byte $0E	; ....***.
	.byte $FE	; *******.
	.byte $FE	; *******.
	.byte $FE	; *******.
	.byte $3E	; ..*****.
	.byte $3C	; ..****..
	.byte $F8	; *****...
	.byte $F0	; ****....
	.byte $F0	; ****....
	.byte $E0	; ***.....
	.byte $C0	; **......
	.byte $80	; *.......
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
; Using background color $00

.align $100

left_colors:
	.byte $00,$9A,$9A,$9A,$AC,$AE,$0E,$EE
	.byte $2C,$1C,$0E,$0E,$0E,$00,$00,$0E
	.byte $EE,$1C,$2C,$28,$0E,$0E,$AE,$AC
	.byte $9A,$40,$40,$40

;	.byte $40,$D8,$D8,$D8
;	.byte $D8,$C0,$D8,$D8,$D4,$D8,$D8,$D8
;	.byte $1E,$D8,$D8,$D8,$1E,$1E,$1E,$1E


right_colors:
	.byte $00,$9A,$9A,$D8,$D8,$D8,$D8,$D8
	.byte $D8,$D8,$D8,$DC,$DC,$DC,$DC,$DC
	.byte $DC,$EE,$0E,$0E,$0E,$0E,$0E,$0E
	.byte $40,$40,$40,$40

;	.byte $40,$D8,$D8,$D8
;	.byte $D8,$C0,$D8,$D8,$D4,$D8,$D8,$D8
;	.byte $1E,$D8,$D8,$D8,$1E,$1E,$1E,$1E

.align $100

playfield0_left:
	.byte $00,$00,$00,$00,$80,$80,$C0,$80
	.byte $80,$00,$00,$80,$80,$00,$00,$C0
	.byte $C0,$C0,$C0,$C0,$80,$80,$80,$80
	.byte $80,$00,$00,$00

;	.byte $00,$00,$00,$00
;	.byte $00,$00,$00,$00,$00,$00,$00,$00
;	.byte $00,$00,$00,$00,$00,$00,$00,$00

playfield1_left:
	.byte $00,$40,$60,$E5,$ED,$EF,$CF,$8F
	.byte $8B,$C9,$CD,$84,$00,$00,$00,$C7
	.byte $E7,$EF,$EF,$AF,$A9,$C9,$EF,$66
	.byte $C0,$00,$00,$00

;	.byte $00,$00,$00,$00
;	.byte $00,$00,$00,$00,$00,$00,$00,$00
;	.byte $00,$00,$00,$00,$00,$00,$00,$00

playfield2_left:
	.byte $00,$00,$00,$6C,$6E,$EE,$EE,$EE
	.byte $EA,$AE,$2A,$09,$00,$00,$00,$14
	.byte $D4,$B6,$BF,$BD,$89,$9D,$9C,$94
	.byte $00,$00,$00,$00
;	.byte $C0,$E0,$F0,$B8
;	.byte $B8,$D8,$F0,$90,$E8,$58,$D8,$70
;	.byte $F0,$E0,$C0,$C0,$C0,$E0,$E0,$E0

playfield0_right:
	.byte $00,$00,$00,$D0,$D0,$D0,$D0,$D0
	.byte $C0,$D0,$D0,$00,$00,$00,$00,$B0
	.byte $B0,$B0,$B0,$90,$B0,$10,$10,$30
	.byte $00,$00,$00,$00

;	.byte $30,$70,$E0,$F0
;	.byte $F0,$E0,$F0,$F0,$E0,$50,$20,$E0
;	.byte $F0,$F0,$F0,$F0,$70,$70,$70,$70



playfield1_right:
	.byte $00,$00,$00,$C1,$81,$81,$81,$03
	.byte $83,$03,$83,$03,$07,$07,$00,$E0
	.byte $E0,$F0,$F0,$A0,$C0,$E1,$A3,$A7
	.byte $07,$0E,$1E,$38

;	.byte $80,$00,$00,$C0
;	.byte $C0,$40,$C0,$C0,$C0,$40,$C0,$C0
;	.byte $80,$80,$80,$00,$00,$00,$00,$00

playfield2_right:
	.byte $00,$00,$00,$1F,$1F,$1F,$01,$00
	.byte $04,$06,$07,$07,$06,$06,$06,$06
	.byte $06,$07,$07,$07,$03,$03,$03,$03
	.byte $00,$00,$00,$00
;	.byte $00,$00,$00,$00
;	.byte $00,$00,$00,$00,$00,$00,$00,$00
;	.byte $00,$00,$00,$00,$00,$00,$00,$00
; Using background color $00
;snake_pf_colors:
;	.byte $40,$00,$00,$00
;	.byte $40,$00,$00,$00,$00,$40,$40,$40
;	.byte $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E

	; 0 1 2 3 4 5 6 7 | 7 6 5 4 3 2 1 0

snake_pf2_left:
	.byte $00
	.byte $E0,$E0,$E0,$E0	; wide bottom
	.byte $E0,$E0,$E0,$E0
	.byte $E0,$E0,$E0,$E0
	.byte $E0,$E0,$E0,$E0

	.byte $C0,$C0,$C0,$C0	; narrow
	.byte $C0,$C0,$C0,$C0
	.byte $C0,$C0,$C0,$C0
	.byte $C0,$C0

	.byte $A0,$A0		; fork

	.byte $40,$40,$40,$40	; tongue
	.byte $40,$40,$40,$40
	.byte $40,$40,$40,$40

	.byte $00,$00,$00,$00
	.byte $00,$00,$00,$00
	.byte $00,$00,$00,$00
	.byte $00,$00,$00,$00

	.byte $A0,$A0,$A0,$A0	; eyes

	.byte $00,$00,$00,$00
	.byte $00,$00,$00,$00
	.byte $00,$00,$00,$00
;	.byte $FF,$FF,$FF,$FF
;	.byte $08,$08,$08,$08	; drip off fangs

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







