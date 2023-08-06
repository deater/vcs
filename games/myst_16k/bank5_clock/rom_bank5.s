.include "../zp.inc"
.include "../common_routines.inc"

.include "../../../vcs.inc"
.include "../bank6_intro/title.s"
.include "../bank6_intro/title_data.inc"

steps_e_data_zx02:
.incbin "steps_e_data.zx02"
library_up_data_zx02:
.incbin "library_up_data.zx02"
library_nw_data_zx02:
.incbin "library_nw_data.zx02"
library_ne_data_zx02:
.incbin "library_ne_data.zx02"
clock_puzzle_data_zx02:
.incbin "clock_puzzle_data.zx02"
elevator_s_data_zx02:
.incbin "elevator_s_data.zx02"
.include "clock_sprites.s"
elevator_n_data_zx02:
.incbin "elevator_n_data.zx02"
inside_elevator_data_zx02:
.incbin "inside_elevator_data.zx02"

.include "clock_update.s"
.include "../fireplace_update.s"
;.include "../sound_update.s"
;.include "../sfx_data.inc"

rom_bank5_end:
