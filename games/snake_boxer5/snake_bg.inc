; Using background color $00
;snake_pf_colors:
;	.byte $40,$00,$00,$00
;	.byte $40,$00,$00,$00,$00,$40,$40,$40
;	.byte $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E

	; 0 1 2 3 4 5 6 7 | 7 6 5 4 3 2 1 0

snake_pf2_left:
	.byte $00
	.byte $E0,$00,$E0,$00	; wide bottom
	.byte $E0,$00,$E0,$00
	.byte $E0,$00,$E0,$00
	.byte $E0,$00,$E0,$00

	.byte $C0,$00,$C0,$00	; narrow
	.byte $C0,$00,$C0,$00
	.byte $C0,$00,$C0,$00
	.byte $C0,$00,$C0,$C0

	.byte $40,$40,$40,$40	; tongue
	.byte $40,$40,$40,$40
	.byte $40,$40,$40,$40

	.byte $00,$00,$00,$00
	.byte $00,$00,$00,$00
	.byte $00,$00,$00,$00
	.byte $00,$00,$00,$00

	.byte $A0,$A0,$A0,$A0	; eyes

	.byte $00,$00,$00,$00
	.byte $00,$00,$00,$00
	.byte $00,$00,$00,$00
;	.byte $FF,$FF,$FF,$FF
;	.byte $08,$08,$08,$08	; drip off fangs


