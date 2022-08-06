level_bank_lookup:
	.byte	0			; 0 = clock
	.byte	0			; 1 = rocket
	.byte	0			; 2 = arrival
	.byte	0			; 3 = hilltop_w
	.byte	0			; 4 = pool
	.byte	0			; 5 = hilltop_s
	.byte	0			; 6 = hilltop_n
	.byte	0			; 7 = hilltop_e

level_compress_data_low:
	.byte	<$1000
	.byte	<$10d1
	.byte	<$1169
	.byte	<$1224
	.byte	<$1311
	.byte	<$1414
	.byte	<$14dd
	.byte	<$15ad

level_compress_data_high:
	.byte	>$1000
	.byte	>$10d1
	.byte	>$1169
	.byte	>$1224
	.byte	>$1311
	.byte	>$1414
	.byte	>$14dd
	.byte	>$15ad

