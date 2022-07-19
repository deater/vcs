level1_data:
	.byte	6,$FF		; secret_x,secret_y
	.byte	$FF,$FF		; bonus_x,bonus_y
	.byte	9,29		; zap_begin,zap_end
	.byte	8,32		; start_x,start_y
	.byte	<l1_playfield0_left,>l1_playfield0_left
	.byte	<l1_playfield1_left,>l1_playfield1_left
	.byte	<l1_playfield2_left,>l1_playfield2_left
	.byte	$FF,$FF		; padding to 16-byte boundary

level2_data:
	.byte	6,$FF		; secret_x,secret_y
	.byte	$FF,$FF		; bonus_x,bonus_y
	.byte	9,29		; zap_begin,zap_end
	.byte	8,32		; start_x,start_y
	.byte	<l2_playfield0_left,>l2_playfield0_left
	.byte	<l2_playfield1_left,>l2_playfield1_left
	.byte	<l2_playfield2_left,>l2_playfield2_left
	.byte	$FF,$FF		; padding to 16-byte boundary

level3_data:
	.byte	6,$FF		; secret_x,secret_y
	.byte	$FF,$FF		; bonus_x,bonus_y
	.byte	9,29		; zap_begin,zap_end
	.byte	8,32		; start_x,start_y
	.byte	<l1_playfield0_left,>l1_playfield0_left
	.byte	<l1_playfield1_left,>l1_playfield1_left
	.byte	<l1_playfield2_left,>l1_playfield2_left
	.byte	$FF,$FF		; padding to 16-byte boundary

level4_data:
	.byte	6,$FF		; secret_x,secret_y
	.byte	$FF,$FF		; bonus_x,bonus_y
	.byte	9,29		; zap_begin,zap_end
	.byte	8,32		; start_x,start_y
	.byte	<l2_playfield0_left,>l2_playfield0_left
	.byte	<l2_playfield1_left,>l2_playfield1_left
	.byte	<l2_playfield2_left,>l2_playfield2_left
	.byte	$FF,$FF		; padding to 16-byte boundary
