shortsteps_w_data_zx02:
.incbin "shortsteps_w_data.zx02"
dock_n_data_zx02:
.incbin "dock_n_data.zx02"
library_n_data_zx02:
.incbin "library_n_data.zx02"
gear_n_data_zx02:
.incbin "gear_n_data.zx02"
gear_s_data_zx02:
.incbin "gear_s_data.zx02"
library_s_data_zx02:
.incbin "library_s_data.zx02"
arrival_s_data_zx02:
.incbin "arrival_s_data.zx02"
arrival_w_data_zx02:
.incbin "arrival_w_data.zx02"
dentist_n_data_zx02:
.incbin "dentist_n_data.zx02"
hill_w_data_zx02:
.incbin "hill_w_data.zx02"

; note, intentionnaly lined up so no level starts greater than
; $700 as otherwise our 256 byte copy loop (?) goes off the end of
; the ROM area and messes things up somehow

rom_bank1_end:
