; LOCATION ATRUS_E data

.include "../locations.inc"
.include "../zp.inc"

.byte $22			; color of pointer (sprite0)
.byte $00,$00			; background color, background color2
.byte 66			; overlay (sprite1) X location
.byte LOCATION_DNI_E		; center destination
.byte $FF			; left destination
.byte $FF			; right destination
.byte 34*2,48*2			; XMAX/XMIN of grab area
.byte 16,34			; YMAX/YMIN of grab area
.byte 0				; missile0 (vertical line) X location
.byte BARRIER_ATRUS_DONE	; center dest patch condition
.byte LOCATION_DNI_E		; center_dest_patch_location
.byte OVERLAY_PATCH_BARRIER|4	; overlay patch type
.byte $00			; unused

.include "atrus_e_data.inc"
