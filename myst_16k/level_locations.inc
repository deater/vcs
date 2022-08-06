level_bank_lookup:
	.byte	0			; 0 = clock
	.byte	0			; 1 = rocket
	.byte	0			; 2 = arrival_n
	.byte	0			; 3 = hilltop_w
	.byte	0			; 4 = pool
	.byte	0			; 5 = hilltop_s
	.byte	0			; 6 = hilltop_n
	.byte	0			; 7 = hilltop_e
	.byte	0			; 8 = arrival_e

level_compress_data_low:
	.byte	<$1000
	.byte	<$10d1
	.byte	<$116C
	.byte	<$1229
	.byte	<$1316
	.byte	<$1418
	.byte	<$14e1
	.byte	<$15b1
	.byte	<$167F

level_compress_data_high:
	.byte	>$1000
	.byte	>$10d1
	.byte	>$116C
	.byte	>$1229
	.byte	>$1316
	.byte	>$1418
	.byte	>$14e1
	.byte	>$15b1
	.byte	>$167f

