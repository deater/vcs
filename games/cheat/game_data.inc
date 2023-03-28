cake_message_sprite5:
	.byte $00	; ........
	.byte $20	; ..*.....
	.byte $80	; *.......
	.byte $20	; ..*.....
	.byte $20	; ..*.....
	.byte $A0	; *.*.....
	.byte $00	; ........


bubs_face_sprite:
	.byte $60,$60,$60
	.byte $46,$46,$66,$66,$60,$60,$00,$00
	.byte $06,$06,$1E,$1E,$FF,$FF,$FF,$FF
	.byte $7E,$7E,$7E,$18;,$00

big_bubs_colors:
	.byte $00,$AA,$AA,$AA,$AA,$AA,$AA,$34
	.byte $34,$34,$34,$34,$34,$34,$34,$34
	.byte $34,$34,$34,$C6,$C6,$06,$06,$06
	.byte $06,$06,$06,$06,$06,$06,$06,$06
	.byte $06;,$00

big_bubs_playfield2_left:
	.byte $00,$80,$80,$C0,$C0,$C0,$C0,$E0
	.byte $E0,$F8,$F8,$FC,$FC,$FE,$FE,$F6
	.byte $F6,$F2,$F2,$F0,$F0,$F0,$F0,$F0
	.byte $F0,$E0,$E0,$60,$60,$40,$40,$60
	.byte $60,$00

.align $100

bushes_bg_colors:
	.byte $AE,$AE,$AE,$AE,$AE,$AE,$0E,$0E
	.byte $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
	.byte $0E,$AE,$AE,$AE,$AE,$AE,$AE,$AE
	.byte $AE,$AE,$AE,$AE,$C2,$C2,$C2,$C2
	.byte $C2,$C2,$C2,$C2,$C2,$C2,$C2,$C2
	.byte $C2,$C2,$C2,$C2,$C2,$C2,$C2,$C2
	.byte $C2,$C2,$C2,$C2,$D0,$D0,$D0,$D0
	.byte $D0,$D0,$D0,$C2

bushes_colors:
	.byte $0E,$0E,$0E,$0E,$0E,$0E,$AE,$AE
	.byte $AE,$AE,$AE,$AE,$AE,$AE,$AE,$AE
	.byte $AE,$0E,$00,$00,$00,$00,$00,$00
	.byte $C2,$C2,$C2,$C2,$AE,$AE,$AE,$AE
	.byte $AE,$AE,$AE,$AE,$AE,$AE,$AE,$AE
	.byte $AE,$AE,$AE,$AE,$00,$D0,$D0,$D0
	.byte $D0,$D0,$D0,$D0,$00,$00,$00,$C2
	.byte $C2,$C2,$C2,$00

strongbadia_colors:
	.byte $0E,$0E,$0E,$0E
	.byte $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
	.byte $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
	.byte $0E,$0E,$00,$F0,$F0,$F0,$F0,$F0
	.byte $F0,$00,$20,$20,$20,$20,$20,$20
	.byte $20,$00,$30,$30,$30,$30,$30,$30
	.byte $30,$30,$00,$00


bushes_playfield0_left:
	.byte $80,$80,$C0,$C0,$E0,$E0,$00,$00
	.byte $00,$80,$80,$80,$C0,$C0,$C0,$E0
	.byte $E0,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$E0,$E0,$E0,$E0
	.byte $C0,$C0,$C0,$C0,$C0,$C0,$40,$40
	.byte $40,$00,$00,$00,$00,$00,$00,$40
	.byte $40,$40,$40,$E0,$00,$00,$00,$80
	.byte $C0,$C0,$E0,$00

below_fence_colors:
	.byte $00
	.byte $00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$0E,$0A,$08,$08,$06,$06,$06
	.byte $00,$00,$00

; 4 bytes here...

.align $100

bushes_playfield1_left:
	.byte $F9,$FF,$FF,$FF,$FF,$BF,$F0,$F0
	.byte $F8,$F9,$F9,$F9,$FF,$FF,$FF,$FF
	.byte $FF,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$DF,$DF,$8F,$8E
	.byte $8E,$8C,$84,$84,$84,$84,$84,$84
	.byte $04,$04,$04,$04,$00,$01,$01,$09
	.byte $89,$89,$8F,$9F,$00,$00,$00,$8F
	.byte $DF,$FF,$FF,$00

strongbadia_playfield1_left:
	.byte $00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$03,$03,$03,$03,$03,$03
	.byte $03,$07,$07,$07,$07,$07,$07,$07
	.byte $07,$0F,$0F,$0F,$0F,$0F,$0F,$0F
	.byte $0F,$0F,$00,$00 ;,$00,$00,$00,$00

bushes_playfield2_left:
	.byte $0F,$1F,$1F,$3F,$3F,$7F,$86,$0F
	.byte $0F,$1F,$1F,$1F,$3F,$3F,$3F,$7F
	.byte $7F,$80,$00,$00,$00,$00,$00,$00
	.byte $C0,$C0,$C0,$C0,$3F,$1E,$1E,$0C
	.byte $0C,$0C,$0C,$0C,$0C,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$02,$42
	.byte $42,$CB,$CB,$EB,$00,$00,$00,$01
	.byte $03,$FF,$FF,$00

strongbadia_playfield2_left:
	.byte $F8,$F8,$F8,$F8
	.byte $F8,$F8,$F8,$F8,$F8,$F8,$F8,$F8
	.byte $F8,$F8,$F8,$F8,$F8,$F8,$F8,$F8
	.byte $F8,$F8,$FF,$FF,$FF,$FF,$FF,$FF
	.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	.byte $FF,$FF,$00,$00;,$00,$00,$00 ;,$00


sbadia_overlay_colors:
	.byte $00
	.byte $40,$40,$0E,$0E,$f0,$f0,$12,$12
	.byte $12,$12,$12,$12,$12,$12,$12,$12
	.byte $12,$12,$12



sbadia_overlay_sprite:
	.byte $00
	.byte $FF,$FF,$E7,$E7,$FB,$FF,$80,$80
	.byte $80,$40,$40,$40,$40,$40,$80,$80
	.byte $80,$80,$80

.align $100

below_fence_sprite:
	.byte $00
	.byte $00,$00,$00,$3C,$7E
	.byte $77,$E7,$EF,$FE,$7E,$3C,$00,$00
	.byte $00,$1E,$21,$41,$99,$81,$42,$7D
	.byte $00 ;,$00,$00

stick_overlay_colors:
	.byte $00
	.byte $00,$22,$22,$22
	.byte $22,$22,$22,$22
	.byte $22,$22,$22,$22
	.byte $22,$22,$22,$22
	.byte $22,$C0 ;,$00,$00

stick_overlay_sprite:
	.byte $00
	.byte $00,$04,$04,$04
	.byte $0C,$04,$04,$04
	.byte $05,$06,$44,$2C
	.byte $2C,$18,$08,$08
	.byte $08,$3E;,$00,$00

pit_playfield1_left:
	;.byte $00,$00,
	.byte $00,$00,$00,$00,$FF,$FF
	.byte $FF,$FF,$FF,$7F,$7F,$3F,$3F,$3F
	.byte $3F,$3F,$3F,$3F,$3F,$1F,$1F,$1F
	.byte $1F,$1F,$1F,$1F,$0F,$0F,$0F,$0F
	.byte $07,$07,$03,$01,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00;,$00,$00

cheat_sprite_yellow:
	.byte $00
	.byte $00
	.byte $7D
	.byte $3F
	.byte $7E
	.byte $7F
	.byte $7D
	.byte $7F
	.byte $3E
	.byte $57
	.byte $FC

cheat_sprite_black:
	.byte $00
	.byte $00
	.byte $0A
	.byte $00
	.byte $04
	.byte $01
	.byte $0B
	.byte $02
	.byte $04
	.byte $A2
	.byte $04


pit_playfield2_left:
	;.byte $00,$00,
	.byte $00,$00,$00,$00,$FF,$FF
	.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	.byte $FF,$FF,$FF,$FF,$FF,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00

avoid_sprite0:
	.byte $00	; ........
	.byte $00	; ........
	.byte $65	; .**..*.*
	.byte $65	; .**..*.*
	.byte $95	; *..*.*.*
	.byte $95	; *..*.*.*
	.byte $B6	; *.**.**.
	.byte $B6	; *.**.**.
	.byte $85	; *....*.*
	.byte $85	; *....*.*
	.byte $67	; .**..***
	.byte $67	; .**..***
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

avoid_sprite1:
	.byte $00	; ........
	.byte $00	; ........
	.byte $74	; .***.*..
	.byte $74	; .***.*..
	.byte $54	; .*.*.*..
	.byte $54	; .*.*.*..
	.byte $55	; .*.*.*.*
	.byte $55	; .*.*.*.*
	.byte $56	; .*.*.**.
	.byte $56	; .*.*.**.
	.byte $54	; .*.*.*..
	.byte $54	; .*.*.*..
	.byte $00	; ........
	.byte $00	; ........
	.byte $01	; .......*
	.byte $01	; .......*
	.byte $01	; .......*
	.byte $01	; .......*
	.byte $01	; .......*
	.byte $01	; .......*
	.byte $01	; .......*
	.byte $01	; .......*
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........
	.byte $00	; ........



avoid_sprite2:
	.byte $00	; ........
	.byte $00	; ........
	.byte $59	; .*.**..*
	.byte $59	; .*.**..*
	.byte $55	; .*.*.*.*
	.byte $55	; .*.*.*.*
	.byte $59	; .*.**..*
	.byte $59	; .*.**..*
	.byte $D5	; **.*.*.*
	.byte $D5	; **.*.*.*
	.byte $59	; .*.**..*
	.byte $59	; .*.**..*
	.byte $00	; ........
	.byte $00	; ........
	.byte $48	; .*..*...
	.byte $48	; .*..*...
	.byte $55	; .*.*.*.*
	.byte $55	; .*.*.*.*
	.byte $D5	; **.*.*.*
	.byte $D5	; **.*.*.*
	.byte $55	; .*.*.*.*
	.byte $55	; .*.*.*.*
	.byte $94	; *..*.*..
	.byte $94	; *..*.*..
	.byte $00	; ........
	.byte $00	; ........

.align $100

avoid_sprite3:
	.byte $00	; ........
	.byte $00	; ........
	.byte $D9	; **.**..*
	.byte $D9	; **.**..*
	.byte $12	; ...*..*.
	.byte $12	; ...*..*.
	.byte $1A	; ...**.*.
	.byte $1A	; ...**.*.
	.byte $12	; ...*..*.
	.byte $12	; ...*..*.
	.byte $19	; ...**..*
	.byte $19	; ...**..*
	.byte $00	; ........
	.byte $00	; ........
	.byte $9D	; *..***.*
	.byte $9D	; *..***.*
	.byte $49	; .*..*..*
	.byte $49	; .*..*..*
	.byte $49	; .*..*..*
	.byte $49	; .*..*..*
	.byte $49	; .*..*..*
	.byte $49	; .*..*..*
	.byte $9D	; *..***.*
	.byte $9D	; *..***.*
	.byte $00	; ........
	.byte $00	; ........

avoid_sprite4:
	.byte $00	; ........
	.byte $00	; ........
	.byte $AA	; *.*.*.*.
	.byte $AA	; *.*.*.*.
	.byte $2A	; ..*.*.*.
	.byte $2A	; ..*.*.*.
	.byte $3B	; ..***.**
	.byte $3B	; ..***.**
	.byte $2A	; ..*.*.*.
	.byte $2A	; ..*.*.*.
	.byte $92	; *..*..*.
	.byte $92	; *..*..*.
	.byte $00	; ........
	.byte $00	; ........
	.byte $80	; *.......
	.byte $80	; *.......
	.byte $40	; .*......
	.byte $40	; .*......
	.byte $40	; .*......
	.byte $40	; .*......
	.byte $40	; .*......
	.byte $40	; .*......
	.byte $80	; *.......
	.byte $80	; *.......
	.byte $00	; ........
	.byte $00	; ........

avoid_sprite5:
	.byte $00	; ........
	.byte $00	; ........
	.byte $B6	; *.**.**.
	.byte $B6	; *.**.**.
	.byte $A1	; *.*....*
	.byte $A1	; *.*....*
	.byte $32	; ..**..*.
	.byte $32	; ..**..*.
	.byte $A4	; *.*..*..
	.byte $A4	; *.*..*..
	.byte $B3	; *.**..**
	.byte $B3	; *.**..**
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


score_bitmap0:  ; turns out this was same pattern
score_zeros:    .byte $22,$55,$55,$55,$55,$55,$22,$00
score_ones:     .byte $22,$66,$22,$22,$22,$22,$77,$00
score_twos:     .byte $22,$55,$11,$22,$44,$44,$77,$00
score_threes:   .byte $22,$55,$11,$22,$11,$55,$22,$00
score_fours:    .byte $55,$55,$55,$77,$11,$11,$11,$00

; --****** ----**-- --****** ----**-- ----**--
; --**---- --**--** ------** --**--** --**--**
; --****-- --**---- ------** --**--** --**--**
; ------** --****-- ----**-- ----**-- ----****
; ------** --**--** --**---- --**--** ------**
; --**--** --**--** --**---- --**--** --**--**
; ----**-- ----**-- --**---- ----**-- ----**--

score_fives:    .byte   $77,$44,$66,$11,$11,$55,$22,$00
score_sixes:    .byte   $33,$44,$44,$66,$55,$55,$22,$00
score_sevens:   .byte   $77,$11,$11,$22,$44,$44,$44,$00
score_eights:   .byte   $22,$55,$55,$22,$55,$55,$22,$00
score_nines:    .byte   $22,$55,$55,$33,$11,$55,$22,$00



strongbad_colors:
	.byte	$42,$42		; head (red)
	.byte	$42,$42		; head (red)
	.byte	$42,$42		; head (red)
	.byte	$42,$42		; head (red)
	.byte	$42,$42		; head (red)
	.byte	$42,$42		; head (red)
	.byte	$4e,$4e		; arm (pink)
	.byte	$4e,$4e		; arm (pink)
	.byte	$02,$02		; pants
	.byte	$02,$02		; pants
	.byte	$02,$02		; pants
	.byte	$42,$42		; shoe (red)
	.byte	$42,$42		; shoe (red)
	.byte	$0E,$0E		; shoe (white)




;=========================================
; sound effects
; doesn't need to be aligned?

sfx_f:
sfx_start:
	.byte	0, 26	; collide
sfx_collide:
	.byte	0, 12, 12, 12, 12, 12, 12, 12, 12	; zap
sfx_zap:
	.byte	0,22,22,23,23,24,24,25,25,26,26,27,28,29,30,31 ; collect
sfx_collect:
	.byte	0, 0, 0, 1, 1, 2, 2, 3, 3 ; speed
sfx_speed:
;	.byte	0, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8 ; ping
;sfx_ping:
;	.byte	0,26,26,26,26,26,26,26,29,29,29,29,29,29,29 ; game over
;	.byte	0,26,26,26,26,26,26
;sfx_game_over:

sfx_cv:
	.byte	0,$8F	; collide
	.byte	0,$3F,$3F,$3F,$3F,$3F,$3f,$3f,$3f	; zap
	.byte	0,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byte	  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f ; collect
	.byte	0,$6f,$6f,$6f,$6f,$6f,$6f,$6f,$6f ; speed
;	.byte	0,$41,$42,$43,$44,$45,$46,$47,$48
;	.byte	  $49,$4a,$4b,$4c,$4d,$4e,$4f ; ping
;	.byte	0,$7f,$7f,$7f,$7f,$7f,$7f,$7f
;	.byte	  0,$E0,$E0,$E0,$E0,$E0,$EF ; game over

; F, C/V
; collide V=F, C=8, F=31    (8,26)
; zap =   V=F, C=3, F=12
; collect V=F, C=6, F=2		; not really
; die	  V=F, C=8, F=24
; level over V=G,  7/26 1/29
; click  V=F C=15, F=26
SFX_COLLIDE	=	sfx_collide-sfx_start-1
SFX_ZAP		=	sfx_zap-sfx_start-1
SFX_COLLECT	=	sfx_collect-sfx_start-1
SFX_SPEED	=	sfx_speed-sfx_start-1
;SFX_PING	=	sfx_ping-sfx_start-1
;SFX_CLICK	=	sfx_game_over-sfx_start-1


; Using background color $D4


bubs_playfield2_left:
	.byte $C0,$C0,$C0,$C0
	.byte $C0,$C0,$C0,$C0,$20,$20,$20,$20
	.byte $E0,$E0,$20,$20,$20,$20,$20,$20
	.byte $20,$20,$20,$20,$20,$20,$20,$20
	.byte $20,$20,$E0,$E0,$E0,$E0,$E0,$E0
	.byte $E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0
	.byte $E0,$E0;,$00,$00,$00,$00,$00,$00

bubs_colors:
	.byte $00,$00,$00,$00
	.byte $00,$00,$00,$00,$40,$40,$40,$40
	.byte $40,$40,$40,$40,$40,$40,$40,$40
	.byte $40,$40,$40,$40,$40,$40,$40,$40
	.byte $40,$40,$2C,$28,$40,$40,$40,$40
	.byte $40,$40,$40,$40,$40,$40,$40,$40
	.byte $40,$40,$00,$00,$00,$00;,$00,$00


stand_overlay_colors:
	.byte $00,$00,$0E,$0E,$0E,$0E,$0E,$0E
	.byte $0E,$0E,$02,$02,$02,$02,$08,$04
	.byte $00,$A8,$A8,$A8,$A8,$0E,$34,$34
	.byte $34,$34,$34,$34,$34,$2C,$00,$00
	.byte $00,$00,$00,$00,$00,$02,$02,$00
	.byte $02,$02,$02,$02,$00,$C2;,$00,$00

stand_overlay_sprite:
	.byte $00,$00,$FF,$FF,$A1,$A1,$FF,$DF
	.byte $FF,$FF,$FF,$FF,$00,$00,$FF,$FF
	.byte $00,$18,$18,$18,$18,$18,$3C,$7E
	.byte $7E,$FF,$FF,$BD,$BD,$FF,$00,$00
	.byte $00,$00,$00,$00,$00,$02,$02,$00
	.byte $05,$05,$80,$80,$00,$91,$00;,$00


cake_message_sprite0:
	.byte $00	; ........
	.byte $22	; ..*...*.
	.byte $22	; ..*...*.
	.byte $2A	; ..*.*.*.
	.byte $36	; ..**.**.
	.byte $22	; ..*...*.
;	.byte $00	; ........

cake_message_sprite1:
	.byte $00	; ........
	.byte $4A	; .*..*.*.
	.byte $AA	; *.*.*.*.
	.byte $AC	; *.*.**..
	.byte $AA	; *.*.*.*.
	.byte $4C	; .*..**..
;	.byte $00	; ........

cake_message_sprite2:
	.byte $00	; ........
	.byte $E1	; ***....*
	.byte $82	; *.....*.
	.byte $C2	; **....*.
	.byte $82	; *.....*.
	.byte $E1	; ***....*
;	.byte $00	; ........

cake_message_sprite3:
	.byte $00	; ........
	.byte $AA	; *.*.*.*.
	.byte $2A	; ..*.*.*.
	.byte $3B	; ..***.**
	.byte $2A	; ..*.*.*.
	.byte $92	; *..*..*.
;	.byte $00	; ........

cake_message_sprite4:
	.byte $00	; ........
	.byte $BB	; *.***.**
	.byte $A0	; *.*.....
	.byte $31	; ..**...*
	.byte $A2	; *.*...*.
	.byte $B9	; *.***..*
	.byte $00	; ........


bubs_face_colors:
	.byte $0E,$00,$00
	.byte $00,$00,$00,$00,$0E,$0E,$00,$00
	.byte $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
	.byte $0E,$0E,$AA,$AA,$00
