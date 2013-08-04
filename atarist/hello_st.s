
    SECTION TEXT

    ; System call to execute a function in Supervisor mode.
    ; If we don't run our code in supervisor mode, we
    ; cannot write to the registers to set up screen pointer
    ; and palette.

    pea    super_run    ; Push address pointer to stack 
    move.w  #$26,-(sp)  ; XBIOS call to Supexec.
    trap    #14         ; Software interript #14 -> XBIOS
    addq.w  #6,sp       ; Fix stack pointer (not really needed in this case.)

.halt   bra.s   .halt

super_run:

    ; On ST, the screen address should be aligned by 256 bytes.
    ; The add.w and clr.b below takes care of that. Note that
    ; the screen_mem reservation is 32000 + 256 extra bytes.

    move.l  #screen_mem,d0  ; Move address to screen mem to d0
    add.l   #$ff,d0         ; Add 255 d0 address
    clr.b   d0              ; Clear lowest byte in address
    move.l  d0,a6           ; Store screen pointer in a6

    ; Set screen base address. Please read some hardware 
    ; docs and try to understand what we do here. Keep in mind
    ; that the CPU is big endian. If someone really wants to 
    ; know, I might add an explanation here.

    lsr.w   #8,d0           
    move.l  d0,$ffff8200.w

    ; Set palette
    movea.w #$8240,a1   ; Pointer to palette entries.
    moveq   #0,d0       ; Color is black.
    moveq   #15,d1      ; loop 16 times. (dbra loops until dn == -1 )
.clear_palette
    move.w  d0,(a1)+
    dbra.w  d1,.clear_palette

    ; Setup resolution, since d0 still contains 0, we
    ; use that to set screen to lowres.
    ; In theory, we could just increate the iteration
    ; count in the clear_palette loop by one, since
    ; the screen mode register is at the next address 
    ; after palette, but that would make the code harder
    ; to understand.
    move.w  d0,$ffff8260.w


    ; Start copying data to the screen memory.
    ; In lowres mode, the screen consists of four bitplanes, 
    ; split up in 16 bit words for each plane. Our graphics
    ; is one bitplane, so we skip three bitplanes when 
    ; copying data.

    lea     gfx,a0  ; Load graphics data pointer to a0.
    move.l  a6,a1   ; Copy screen address to a1
    moveq   #5,d1   ; loop 6 times (dbra loops until dn == -1)
.draw_loop
    move.w  (a0)+,0(a1)
    move.w  (a0)+,8(a1)
    move.w  (a0)+,16(a1)
    lea     160(a1),a1      ; Skip to next row, (160 bytes per row)
    dbra.w  d1,.draw_loop

    ; Set color 1 to white (zero indexed of course, color 0 being
    ; the background/border color).
    ; On plain ST the palette data consists three bits of data 
    ; for each RGB channel in the lowest three nibbles.
    ; $700 would be max red, $070 max blue and $007 max green.
    move.w  #$777,d0
    move.w  d0,$ffff8242.w

    rts         ; Return from subroutine

    SECTION DATA
gfx:
    dc.w    %0100010000000101,%0000000100010000,%0000000100001010
    dc.w    %0100010011100101,%0011000100010011,%0001100100111010
    dc.w    %0100010100010101,%0100100100010100,%1010010101001010
    dc.w    %0111110111110101,%0100100101010100,%1010000101001010
    dc.w    %0100010100000101,%0100100101010100,%1010000101001000
    dc.w    %0100010011110101,%0011000010100011,%0010000100111010


    SECTION BSS

; Reserve screen memory 
screen_mem:
    ds.b    32256

    END
