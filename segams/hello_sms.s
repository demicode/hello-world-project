
; This part is to tell wla-dx how to generate code
; and where to place it in the ROM file that it 
; produces.
;
; First we define how the memory in the Master System
; is divided into three slots. This is only important
; if you ROMS are bigger than 32k and therefore need
; bank switching to access all of the ROM.
.MEMORYMAP
  SLOTSIZE $4000
  DEFAULTSLOT 0
  SLOT 0 $0000
  SLOT 1 $4000
  SLOT 2 $8000
.ENDME

; 
.ROMBANKMAP
  BANKSTOTAL 2
  BANKSIZE $4000
  BANKS 2
.ENDRO

.SDSCTAG 1.0 "Hello World", "A hello world example for Master System", "Mikael Degerfalt"
.COMPUTESMSCHECKSUM


.BANK 0 SLOT 0
.orga	$0
  di
  im  1
  jp	start

.orga $38
  reti

.orga $66
  retn

start:
  ; Upload the graphics mode to VDP
  ld  c,$bf   ; Out port for 
  ld  b,vdp_data_end-vdp_setup
  ld  hl,vdp_setup
  otir

  ld  c,$bf
  ld  hl,$4020
  out (c),l
  out (c),h
  ld  hl,gfx
  ld  de, 32*6
  dec c
-:
  outi 
  dec de
  ld  a,e
  or  d
  jp nz,-

  ; Upload color palette to palette memory in VDP
  ld hl,color_palette
  inc c
  xor a       ; xor a clear the a register in a fast way.
  out (c),a   ; write content of register a to port $bf
  ld  a,$c0   ; load high byte of VPD palette address 
  out (c),a   ; output address.
  dec c       ; Decrease register c, it now contains $be
  ld b,16     ; Load counter register for otir instruction with 16 (number of palette entries)
  otir        ; Write (hl) value to port (c), increase hl, decrease b, and repeat until b == 0

  inc c       ; c = $bf
  ld  de,$3800
  out (c),e
  out (c),d
  dec c
  xor a
  ld b,6
-:
  inc a
  out (c),e
  out (c),a
  djnz -


halt:
  jp halt


vdp_setup:
  .db   $34,$80     ; Mode control reg. 1
  .db   $40,$81     ; Mode control reg. 2 ( bit 6 enables display)
  .db   $ff,$82     ; Name table base
  .db   $ff,$83     ; Color table base
  .db   $ff,$84     ; Pattern gen. table base
  .db   $ff,$85     ; Sprite Attr. table base
  .db   $ff,$86     ; Sprite Pattern get. table base
  .db   $ff,$87     ; Overscan/backdrop color
  .db   $00,$88     ; background scroll x
  .db   $00,$89     ; background scroll y
  .db   $ff,$8a     ; Interrupt line counter.
vdp_data_end:


color_palette:
  .db $00,$3f,$03,$0c,$30,$ff,$ff,$ff
  .db $00,$03,$0c,$ff,$ff,$ff,$ff,$ff


gfx:
    ; 8*8 pixels, 4 bit plane
  .db     %00000000,%00000000,%00000000,%00000000
  .db     %01000100,%00000000,%00000000,%00000000
  .db     %01000100,%00000000,%00000000,%00000000
  .db     %01000101,%00000000,%00000000,%00000000
  .db     %01111101,%00000000,%00000000,%00000000
  .db     %01000101,%00000000,%00000000,%00000000
  .db     %01000100,%00000000,%00000000,%00000000
  .db     %00000000,%00000000,%00000000,%00000000

  .db     %00000000,%00000000,%00000000,%00000000
  .db     %00000101,%00000000,%00000000,%00000000
  .db     %11100101,%00000000,%00000000,%00000000
  .db     %00010101,%00000000,%00000000,%00000000
  .db     %11110101,%00000000,%00000000,%00000000
  .db     %00000101,%00000000,%00000000,%00000000
  .db     %11110101,%00000000,%00000000,%00000000
  .db     %00000000,%00000000,%00000000,%00000000

  .db     %00000000,%00000000,%00000000,%00000000
  .db     %00000001,%00000000,%00000000,%00000000
  .db     %00110001,%00000000,%00000000,%00000000
  .db     %01001001,%00000000,%00000000,%00000000
  .db     %01001001,%00000000,%00000000,%00000000
  .db     %01001001,%00000000,%00000000,%00000000
  .db     %00110000,%00000000,%00000000,%00000000
  .db     %00000000,%00000000,%00000000,%00000000

  .db     %00000000,%00000000,%00000000,%00000000
  .db     %00010000,%00000000,%00000000,%00000000
  .db     %00010011,%00000000,%00000000,%00000000
  .db     %00010100,%00000000,%00000000,%00000000
  .db     %01010100,%00000000,%00000000,%00000000
  .db     %01010100,%00000000,%00000000,%00000000
  .db     %10100011,%00000000,%00000000,%00000000
  .db     %00000000,%00000000,%00000000,%00000000

  .db     %00000000,%00000000,%00000000,%00000000
  .db     %00000001,%00000000,%00000000,%00000000
  .db     %00011001,%00000000,%00000000,%00000000
  .db     %10100101,%00000000,%00000000,%00000000
  .db     %10100001,%00000000,%00000000,%00000000
  .db     %10100001,%00000000,%00000000,%00000000
  .db     %00100001,%00000000,%00000000,%00000000
  .db     %00000000,%00000000,%00000000,%00000000

  .db     %00000000,%00000000,%00000000,%00000000
  .db     %00001010,%00000000,%00000000,%00000000
  .db     %00111010,%00000000,%00000000,%00000000
  .db     %01001010,%00000000,%00000000,%00000000
  .db     %01001010,%00000000,%00000000,%00000000
  .db     %01001000,%00000000,%00000000,%00000000
  .db     %00111010,%00000000,%00000000,%00000000
  .db     %00000000,%00000000,%00000000,%00000000



