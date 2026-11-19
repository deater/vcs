; draw ootw-style dna

	;====================================
        ; Draw DNA
        ;====================================
draw_dna:

        lda     #0      ; count
        sta     DNA_COUNT

draw_dna_loop:
        clc
        lda     DNA_COUNT
        adc     #10
        sta     YPOS

        lda     #26
        sta     XPOS




 lda     DNA_COUNT               ; 0, 4, 8, 12, 16....
        lsr
        clc
        adc     DNA_PROGRESS            ; 0,2,4,6,8,...

        and     #$e
        tax

	jsr	put_sprite

lda     DNA_COUNT
        clc
        adc     #4
        sta     DNA_COUNT

        ; for DNA_PROGRESS 0,2,4,6,8,10,12 we only want to print
        ; first X lines (gradually fade in)
        ; after that, draw the whole thing

        lda     DNA_PROGRESS
        cmp     #14
        bpl     dna_full

        asl
        cmp     DNA_COUNT
        bpl     draw_dna_loop
        bmi     dna_full_done

dna_full:
        lda     DNA_COUNT
        cmp     #28
        bne     draw_dna_loop

dna_full_done:

        inc     DNA_PROGRESS
        inc     DNA_PROGRESS




dna_list:
        .word dna0_sprite
        .word dna1_sprite
        .word dna2_sprite
        .word dna3_sprite
        .word dna4_sprite
        .word dna5_sprite
        .word dna6_sprite
        .word dna7_sprite

dna0_sprite:
        .byte   $7,$2
        .byte   $66,$40,$40,$40,$40,$40,$cc
        .byte   $06,$00,$00,$00,$00,$00,$0c

dna1_sprite:
        .byte   $7,$2
        .byte   $00,$66,$40,$40,$40,$cc,$00
        .byte   $00,$06,$00,$00,$00,$0c,$00

dna2_sprite:
        .byte   $7,$2
        .byte   $00,$00,$66,$40,$cc,$00,$00
        .byte   $00,$00,$06,$00,$0c,$00,$00

dna3_sprite:
        .byte   $7,$2
        .byte   $00,$00,$00,$66,$00,$00,$00
        .byte   $00,$00,$00,$06,$00,$00,$00

dna4_sprite:
        .byte   $7,$2
        .byte   $00,$00,$CC,$40,$66,$00,$00
        .byte   $00,$00,$0C,$00,$06,$00,$00

dna5_sprite:
        .byte   $7,$2
        .byte   $00,$CC,$40,$40,$40,$66,$00
        .byte   $00,$0C,$00,$00,$00,$06,$00

dna6_sprite:
        .byte   $7,$2
        .byte   $CC,$40,$40,$40,$40,$40,$66
        .byte   $0C,$00,$00,$00,$00,$00,$06

dna7_sprite:
        .byte   $7,$2
        .byte   $66,$40,$40,$40,$40,$40,$cc
        .byte   $06,$00,$00,$00,$00,$00,$0c

