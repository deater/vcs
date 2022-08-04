;=============================
; sound data
;=============================

;=========================================
; sound effects
; doesn't need to be aligned?

sfx_f:
sfx_start:
	.byte	0, 31, 31
sfx_click:
	.byte   0 ,25,25,25,25
	.byte   25,25,25,25,25,25,25,25
	.byte   25,25,25,25,25 ,04,04,04
	.byte	04,04,04,22,22,22,22,22		; link
sfx_link:

sfx_cv:
	.byte   $00,$C3,$CF
	.byte   $00,$32,$34,$36,$38
	.byte   $3A,$38,$36,$38,$3A,$3C,$3A,$38
	.byte   $3A,$3C,$3E,$3C,$3A, $E4,$E6,$EA
	.byte   $E8,$E6,$E4,$3A,$3c,$3d,$3e,$3e	; link

SFX_CLICK	=       sfx_click-sfx_start-1
SFX_LINK	=       sfx_link-sfx_start-1

