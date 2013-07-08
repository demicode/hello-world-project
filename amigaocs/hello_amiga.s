

    section code_c

    ; To access the OS API, you will find the address to exec library
    ; at address $4. Through this library you can load other libs.
    move.l  $4,a6

    ; load "graphics.library" by placing the address to library name
    ; string in CPU register a1, and jump to the "OldOpenLibrary" function.
    ; The return value will be in d0.

    lea     lib_name,a1         ; Library name as null terminated string in a1
    jsr     -408(a6)            ; Call OldOpenLibrary function


    move.l  d0,a1               ; Move graphics lib handle to a1
    lea     saved_regs,a2       ; Get address to mem where we save some register.
    move.l  $26(a1),(a2)+       ; save old copperlist 1
    move.l  $32(a1),(a2)+       ; save old copperlist 2
    jsr     -414(a6)            ; close lib

    lea     $dff000,a1          ; Base address to hardware registers
    move.w  $1c(a1),(a2)+       ; Save IRQ enable flags.
    move.w  $2(a1),(a2)+        ; Save DMACON register

    move.w  #$7fff,$9a(a1)      ; Disable interrupts
    move.w  #$7fff,$96(a1)      ; Disable all DMA.

    move.w  #$8380,$96(a1)      ; Re-enable DMA for copper and bitplane data.

    lea     screen_mem,a0       ; Get address to screen memory
    lea     gfx,a3              ; Get address to the graphics.
    moveq   #5,d0               ; Loop 6 times.
.draw_loop:
    move.w  (a3)+,(a0)+         ; Move a word to graphics mem
    move.w  (a3)+,(a0)+
    move.w  (a3)+,(a0)+
    lea     34(a0),a0           ; Skip 34 bytes, to the beginning of the next line
    dbra    d0,.draw_loop       ; Decrease d0 and jump to draw_loop if d0 not -1.

    ; Setup copper list.
    lea     vmem_ptr+2,a0       ; Offset to video register setup in copper list
    move.l  #screen_mem,d0      ; Get address to screen memory
    move.w  d0,4(a0)            ; Move low word of address to copper data.
    swap    d0                  ; swap position of low and high word in d0
    move.w  d0,(a0)            ; Write high word of address to copper data.

    move.l  #copper_list,$80(a1)  ; Start using our copper list.
    clr.w   $88(a1)             ; Strobe 

.loop:
    btst #6,$bfe001             ; Test it left mouse button is pressed.
    bne.s .loop                 ; If nop - jump to .loop label.


    ; Restore Registers.

    move.l  copper_1,$80(a1)    ; restore copperlist 1
    move.l  copper_2,$84(a1)    ; restore copperlist 2
    move.w  dmacon,d0           ; restore dma control register.
    ori.w   #$8000,d0           ; Set high bit to enable 'set'
    move.w  d0,$96(a1)

    move.w  irqena,d0           ; Restore IRQ enabled register.
    ori.w   #$8000,d0
    move.w  d0,$9a(a1)          ; Re-enable IRQs.

    rts


    section data_c

lib_name:
    dc.b    "graphics.library",0

    even

    ; Reuse graphics from the Atari ST version.
gfx:
    dc.w    %0100010000000101,%0000000100010000,%0000000100001010
    dc.w    %0100010011100101,%0011000100010011,%0001100100111010
    dc.w    %0100010100010101,%0100100100010100,%1010010101001010
    dc.w    %0111110111110101,%0100100101010100,%1010000101001010
    dc.w    %0100010100000101,%0100100101010100,%1010000101001000
    dc.w    %0100010011110101,%0011000010100011,%0010000100111010

copper_list:
    dc.w    $0100,$1200     ; Bitplane setup, 1 bitplane, color.
    dc.w    $0102,$0000     ; Horisontal scroll
    dc.w    $0108,$0000     ; modulo-register, odd scanlines
    dc.w    $010a,$0000     ; modulo-register, even scanlines
    dc.w    $008e,$2c81     ; Display window start (top left corner)
    dc.w    $0090,$2cc1     ; Display window end (bottom rigth corner)
    dc.w    $0092,$0038     ; Data fetch start
    dc.w    $0094,$00d0     ; Data fetch stop.
vmem_ptr:
    dc.w    $00e0,$0000     ; high word of bitplane 0 address 
    dc.w    $00e2,$0000     ; low word of bitplane 0 address

    dc.w    $0180,$0000     ; Write to color 0 register.
    dc.w    $0182,$0fff     ; Write to color 1 register.

    ; So this is how you make rasterbars on the amiga.. no
    ; challange at all.. Some day I will show you how it's made
    ; on the ST. 
    dc.w    $2b01,$ff00,$0180,$0012
    dc.w    $2c01,$ff00,$0180,$0123
    dc.w    $2d01,$ff00,$0180,$0234
    dc.w    $2e01,$ff00,$0180,$0345
    dc.w    $2f01,$ff00,$0180,$0234
    dc.w    $3001,$ff00,$0180,$0123
    dc.w    $3101,$ff00,$0180,$0012
    dc.w    $3201,$ff00,$0180,$0001
    dc.w    $3301,$ff00,$0180,$0000
cend:
    dc.w    $ffff,$fffe     ; Last command, wait until screen ends.


    section bss_c
saved_regs:
copper_1:   ds.l    1
copper_2:   ds.l    1
irqena:     ds.w    1
dmacon:     ds.w    1
adkcon:     ds.w    1

    even
screen_mem
    ds.b   320*256/8        ; Memory for one bitplane.
