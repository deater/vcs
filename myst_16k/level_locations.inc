level_bank_lookup:
	.byte	0			; 0 = clock
	.byte	0			; 1 = rocket
	.byte	0			; 2 = arrival
	.byte	0			; 3 = hilltop_w
	.byte	0			; 4 = pool
	.byte	0			; 5 = hilltop_s

level_compress_data_low:
	.byte	<$1000
	.byte	<$10d1
	.byte	<$1168
	.byte	<$1223
	.byte	<$1310
	.byte	<$1413

level_compress_data_high:
	.byte	>$1000
	.byte	>$10d1
	.byte	>$1168
	.byte	>$1223
	.byte	>$1310
	.byte	>$1413


