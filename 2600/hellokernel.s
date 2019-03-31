; Hello world for atari 2600


VSYNC   equ 0
VBLANK  equ 1
WSYNC   equ 2
COLUBK  equ 9


    .processor 6502
    seg
    org $f000

start
    lda     #0
    tax
    txs
.clear
    sta     $0,x
    inx
    bne     .clear

    lda     #0
    sta     128


kernel_loop:
    sei
    lda     #0
    sta     VBLANK
    lda     #2
    sta     VSYNC
    lda     #0
    ; VSYNC for 3 scanlines
    sta     WSYNC
    sta     WSYNC
    sta     WSYNC

    sta     VSYNC

    ldx     #37+58
.vblank
    sta     WSYNC
    dex
    bne     .vblank



;    .repeat      58
;    sta     WSYNC
;    .repend

    lda     128
    inc     128
    sta     WSYNC

DATA_ADDR set datas

    .repeat 6     ; 6 rows
    .repeat 6      ; 4 blocks

    sta     8   ; background color

    ldx     DATA_ADDR
    stx     $0d
    ldx     DATA_ADDR+1
    stx     $0e
    ldx     DATA_ADDR+2
    stx     $0f

    nop
    nop
    nop

    ldx     DATA_ADDR+3
    stx     $0d
    ldx     DATA_ADDR+4
    stx     $0e
    ldx     DATA_ADDR+5
    stx     $0f

    clc
    adc #2

    sta     WSYNC

    .repend

DATA_ADDR set DATA_ADDR + 6

;DATA_ADDR equ DATA_ADDR+6
;    tya
;    clc
;    adc #6
;    tay

    .repend


    ldy #0
    sty $d
    sty $e
    sty $f
    sty 9
    sty 8

    ldy     #0
    ldx     #171-24
.display
    sta     WSYNC

    dex
    bne     .display

    lda     #2
    sta     VBLANK

    ldx     #30
.overscan
    sta     WSYNC
    dex
    bne     .overscan

    jmp kernel_loop

datas:
    dc.b    %10100000,%00000101,%01000000,%01000000,%00000000,%01010001
    dc.b    %10100000,%00100101,%01000100,%01000000,%01000110,%01010001
    dc.b    %10100000,%01010101,%01001010,%01000000,%10101000,%01011001
    dc.b    %11100000,%01110101,%01001010,%01010000,%10101000,%01010101
    dc.b    %10100000,%01000101,%01001010,%01010000,%10101000,%00010101
    dc.b    %10100000,%00110101,%10000100,%00100000,%01001000,%01011001
    dc.b    %00000000,%00000000,%00000000,%00000000,%00000000,%00000000



    org $fffc
    .word start
    .word start
