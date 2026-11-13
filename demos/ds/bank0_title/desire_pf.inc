.align $100
; Using background color $00

; 41, 256/41=6

;desire1_colors:
;	.byte         $2E,$2E,$2E,$2E,$2E,$2E	; 9
;	.byte $2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E	; 10
;	.byte $2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E	; 11
;	.byte $2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E	; 12
;	.byte $2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E	; 13
;	.byte $2E,$2E,$2E			; 14

desire1_playfield0_left:
	.byte         $C0,$C0,$C0,$C0,$C0,$C0	; 9
	.byte $E0,$C0,$E0,$E0,$E0,$E0,$60,$E0	; 10
	.byte $60,$E0,$60,$E0,$70,$60,$70,$30	; 11
	.byte $70,$30,$F0,$F0,$F0,$F0,$F0,$F0	; 12
	.byte $F0,$F0,$00,$F0,$00,$E0,$00,$E0	; 13
	.byte $00,$C0				; 14

desire1_playfield1_left:
	.byte         $C0,$EF,$E0,$FF,$F0,$FF	; 9
	.byte $70,$FF,$30,$FF,$3F,$FF,$3F,$FF	; 10
	.byte $3F,$FF,$78,$7F,$78,$7F,$78,$7F	; 11
	.byte $FF,$FF,$CF,$FF,$CF,$FF,$8C,$FF	; 12
	.byte $0C,$FF,$0C,$F7,$0F,$F7,$07,$E7	; 13
	.byte $07,$C7,$07			; 14

desire1_playfield2_left:
	.byte         $E0,$FB,$F0,$FF,$F8,$FF	; 9
	.byte $FC,$FF,$1C,$FD,$0C,$FD,$1C,$FF	; 10
	.byte $7C,$FF,$F8,$FF,$F0,$FB,$C0,$F1	; 11
	.byte $C0,$F1,$FE,$FF,$FE,$FF,$FF,$FF	; 12
	.byte $7F,$FF,$00,$FF,$01,$FF,$01,$FF	; 13
	.byte $03,$7B,$03			; 14


desire1_playfield0_right:
	.byte         $30,$70,$30,$F0,$30,$F0	; 9
	.byte $10,$F0,$00,$F0,$30,$F0,$30,$F0	; 10
	.byte $30,$F0,$30,$F0,$30,$F0,$30,$F0	; 11
	.byte $70,$F0,$70,$F0,$60,$F0,$60,$F0	; 12
	.byte $60,$F0,$60,$F0,$E0,$F0,$C0,$D0	; 13
	.byte $C0,$C0,$C0			; 14


desire1_playfield1_right:
	.byte         $3C,$3E,$3E,$3F,$3F,$3F	; 9
	.byte $76,$BF,$72,$FF,$63,$FF,$63,$FF	; 10
	.byte $67,$FF,$7F,$FF,$FF,$FF,$FD,$FF	; 11
	.byte $D9,$FE,$CC,$FF,$C6,$FF,$C6,$FF	; 12
	.byte $C3,$FF,$00,$FF,$00,$F9,$00,$F9	; 13
	.byte $00,$B0,$00			; 14

desire1_playfield2_right:
	.byte         $00,$3F,$00,$3F,$00,$1F	; 9
	.byte $00,$1F,$00,$1F,$0F,$1F,$0F,$3F	; 10
	.byte $0F,$3F,$01,$3F,$01,$3F,$01,$1F	; 11
	.byte $0F,$1F,$0F,$FF,$0F,$FF,$03,$FF	; 12
	.byte $03,$FF,$03,$FF,$3F,$7F,$3E,$7F	; 13
	.byte $3E,$3F,$3E			; 14
