; 256.BANK
string_256_bank:
.byte	$27,$30,$62,$05
.byte	$54,$40,$55,$05
.byte	$16,$40,$55,$05
.byte	$21,$60,$67,$76
.byte	$41,$50,$55,$55
.byte	$45,$50,$55,$55
.byte	$72,$20,$60,$55

; 1K.BANK.
string_1k_bank:
.byte	$25,$00,$62,$05
.byte	$65,$00,$55,$05
.byte	$25,$00,$55,$05
.byte	$26,$00,$67,$76
.byte	$25,$00,$55,$55
.byte	$25,$00,$55,$55
.byte	$75,$00,$60,$55

; 256.READ
string_256_read:
.byte	$27,$30,$67,$26
.byte	$54,$40,$54,$55
.byte	$16,$40,$54,$55
.byte	$21,$60,$67,$75
.byte	$41,$50,$64,$55
.byte	$45,$50,$54,$55
.byte	$72,$20,$57,$56

; 256WRITE
string_256_write:
.byte	$27,$35,$67,$77
.byte	$54,$45,$52,$24
.byte	$16,$45,$52,$24
.byte	$21,$65,$62,$27
.byte	$41,$55,$62,$24
.byte	$45,$57,$52,$24
.byte	$72,$27,$57,$27

string_table_l:

.byte <string_256_bank,<string_1k_bank
.byte <string_256_read,<string_256_write
.byte <string_1k_read,<string_1k_write
.byte <string_write_value,<string_read_value

string_table_h:

.byte >string_256_bank,>string_1k_bank
.byte >string_256_read,>string_256_write
.byte >string_1k_read,>string_1k_write
.byte >string_write_value,>string_read_value


.align	$100

; 1K..READ
string_1k_read:
.byte	$25,$00,$67,$26
.byte	$65,$00,$54,$55
.byte	$25,$00,$54,$55
.byte	$26,$00,$67,$75
.byte	$25,$00,$64,$55
.byte	$25,$00,$54,$55
.byte	$75,$00,$57,$56

; 1K.WRITE
string_1k_write:
.byte	$25,$05,$67,$77
.byte	$65,$05,$52,$24
.byte	$25,$05,$52,$24
.byte	$26,$05,$62,$27
.byte	$25,$05,$62,$24
.byte	$25,$07,$52,$24
.byte	$75,$07,$57,$27

; WR.VALUE
string_write_value:
.byte	$56,$05,$24,$57
.byte	$55,$05,$54,$54
.byte	$55,$05,$54,$54
.byte	$56,$05,$74,$57
.byte	$56,$05,$54,$54
.byte	$75,$02,$54,$54
.byte	$75,$02,$57,$77


; RD.VALUE
string_read_value:
.byte	$66,$05,$24,$57
.byte	$55,$05,$54,$54
.byte	$55,$05,$54,$54
.byte	$65,$05,$74,$57
.byte	$65,$05,$54,$54
.byte	$55,$02,$54,$54
.byte	$56,$02,$57,$77




