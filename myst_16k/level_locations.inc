level_bank_lookup:
	.byte	0			; 0 = clock_s
	.byte	0			; 1 = rocket
	.byte	0			; 2 = arrival_n
	.byte	0			; 3 = hilltop_w
	.byte	0			; 4 = pool
	.byte	0			; 5 = hilltop_s
	.byte	0			; 6 = hilltop_n
	.byte	0			; 7 = hilltop_e
	.byte	0			; 8 = arrival_e
	.byte	0			; 8 = clock_n

level_compress_data_low:
	.byte	<$1000
	.byte	<$10d3
	.byte	<$116E
	.byte	<$122B
	.byte	<$1318
	.byte	<$141A
	.byte	<$14e3
	.byte	<$15b3
	.byte	<$1681
	.byte	<$16FA

level_compress_data_high:
	.byte	>$1000
	.byte	>$10d3
	.byte	>$116E
	.byte	>$122B
	.byte	>$1318
	.byte	>$141A
	.byte	>$14e3
	.byte	>$15b3
	.byte	>$1681
	.byte	>$16FA

