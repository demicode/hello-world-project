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

    lda     #$10
    sta     128


kernel_loop: SUBROUTINE
    sei
    lda     #0
    sta     VBLANK
    lda     #2
    sta     VSYNC       ; Start VSYNC
    lda     #0
    ; VSYNC for 3 scanlines
    sta     WSYNC
    sta     WSYNC
    sta     WSYNC

    sta     VSYNC       ; Stop VSYNC

    ; 37 scanlines for vertical blank, followed by waiting 58 lines before the graphics starts
    ldx     #45+50
.vblank
    sta     WSYNC
    dex
    bne     .vblank


    lda     128     ; Color byte in RAM
;    inc     128     ; Increase color by one
    sta     WSYNC

DATA_ADDR set datas

    .repeat 6     ; 6 rows

    ldy     #8
apa set .
    sta     8   ; background color

    ldx     DATA_ADDR
    stx     $0d
    ldx     DATA_ADDR+1
    stx     $0e
    ldx     DATA_ADDR+2
    stx     $0f

    nop
    nop

    ldx     DATA_ADDR+3
    stx     $0d
    ldx     DATA_ADDR+4
    stx     $0e
    ldx     DATA_ADDR+5
    stx     $0f

    clc
    adc     #2

    sta     WSYNC

    dey
    bne     apa

DATA_ADDR set DATA_ADDR + 6

    .repend


    ldy #0
    sty $d
    sty $e
    sty $f
    sty 9
    sty 8

    ldy     #0
    ldx     #165-36
.display
    sta     WSYNC

    dex
    bne     .display

    lda     #2
    sta     VBLANK

    ldx     #36
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
