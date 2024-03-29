level1_data:
	.byte	108,72		; secret_x, secret_y
;	.byte	72,80		; secret_ystart, secret_yend
;	.byte	$FF		; padding
;	.byte	$FF,$FF		; bonus_x,bonus_y
;	.byte	9,29		; zap_begin,zap_end
;	.byte	8,32		; start_x,start_y
	.byte	<l1_playfield0_left,>l1_playfield0_left
	.byte	<l1_playfield1_left,>l1_playfield1_left
	.byte	<l1_playfield2_left,>l1_playfield2_left

level2_data:
	.byte	71,72		; secret_x, secret_y
;	.byte	72,80		; secret_ystart, secret_yend
;	.byte	$FF		; padding
;	.byte	$FF,$FF		; bonus_x,bonus_y
;	.byte	9,29		; zap_begin,zap_end
;	.byte	8,32		; start_x,start_y
	.byte	<l1_playfield0_left,>l1_playfield0_left
	.byte	<l2_playfield1_left,>l2_playfield1_left
	.byte	<l2_playfield2_left,>l2_playfield2_left

level3_data:
	.byte	144,72		; secret_x, secret_y
;	.byte	72,80		; secret_ystart, secret_yend
;	.byte	$FF		; padding
;	.byte	$FF,$FF		; bonus_x,bonus_y
;	.byte	9,29		; zap_begin,zap_end
;	.byte	8,32		; start_x,start_y
	.byte	<l3_playfield0_left,>l3_playfield0_left
	.byte	<l3_playfield1_left,>l3_playfield1_left
	.byte	<l3_playfield2_left,>l3_playfield2_left

level4_data:
	.byte	146,163		; secret_x, secret_y
;	.byte	164,172		; secret_ystart, secret_yend
;	.byte	$FF		; padding
;	.byte	$FF,$FF		; bonus_x,bonus_y
;	.byte	9,29		; zap_begin,zap_end
;	.byte	8,32		; start_x,start_y
	.byte	<l3_playfield0_left,>l3_playfield0_left
	.byte	<l1_playfield1_left,>l1_playfield1_left
	.byte	<l1_playfield2_left,>l1_playfield2_left

level5_data:
	.byte	71,91		; secret_x, secret_y
;	.byte	120,128		; secret_ystart, secret_yend
;	.byte	$FF		; padding
;	.byte	$FF,$FF		; bonus_x,bonus_y
;	.byte	9,29		; zap_begin,zap_end
;	.byte	8,32		; start_x,start_y
	.byte	<l1_playfield0_left,>l1_playfield0_left
	.byte	<l3_playfield1_left,>l3_playfield1_left
	.byte	<l4_playfield2_left,>l4_playfield2_left

level6_data:
	.byte	145,98		; secret_x, secret_y
;	.byte	128,136		; secret_ystart, secret_yend
;	.byte	$FF		; padding
;	.byte	$FF,$FF		; bonus_x,bonus_y
;	.byte	9,29		; zap_begin,zap_end
;	.byte	8,32		; start_x,start_y
	.byte	<l3_playfield0_left,>l3_playfield0_left
	.byte	<l2_playfield1_left,>l2_playfield1_left
	.byte	<l1_playfield2_left,>l1_playfield2_left

level7_data:
	.byte	112,108		; secret_x,secret_y
;	.byte	112,120		; secret_ystart, secret_yend
;	.byte	$FF		; padding
;	.byte	$FF,$FF		; bonus_x,bonus_y
;	.byte	9,29		; zap_begin,zap_end
;	.byte	8,32		; start_x,start_y
	.byte	<l3_playfield0_left,>l3_playfield0_left
	.byte	<l4_playfield1_left,>l4_playfield1_left
	.byte	<l1_playfield2_left,>l1_playfield2_left

	; weird hat level
level8_data:
	.byte	108,76		; secret_x, secret_y
;	.byte	72,80		; secret_ystart, secret_yend
;	.byte	$FF		; padding
;	.byte	$FF,$FF		; bonus_x,bonus_y
;	.byte	9,29		; zap_begin,zap_end
;	.byte	8,32		; start_x,start_y
	.byte	<l1_playfield0_left,>l1_playfield0_left
	.byte	<l4_playfield1_left,>l4_playfield1_left
	.byte	<l4_playfield2_left,>l4_playfield2_left
