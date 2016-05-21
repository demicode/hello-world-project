;
; Hello World Gameboy.
;
; Orignal Gameboy version.
;

; WLA DX setup.
.MEMORYMAP
  SLOTSIZE $4000
  DEFAULTSLOT 0
  SLOT 0 $0000
  SLOT 1 $4000
.ENDME

; Fill unused memory with ff to be kind to flash memory.
.EMPTYFILL $ff

.ROMBANKSIZE $4000
.ROMBANKS 2

; Ram memory at $a000 - $bfff

; All jump vectors just jump to main code.
.bank 0
.orga $00
    ret

; Interrupt vectors.
.orga $40
vbl:
    reti

.org $48
lcd:
    reti

.orga $50
timer:
    reti

.orga $58
serial:
    reti

.orga $60
joypad:
    reti

.orga $100
    .db 0
    jp main

    ; $0104-$0133
    ; (Nintendo logo - do _not_ modify the logo data here or the GB will not run the program)
.orga $104
    .db $ce,$ed,$66,$66,$cc,$0d,$00,$0b,$03,$73,$00,$83,$00,$0c,$00,$0d
    .db $00,$08,$11,$1f,$88,$89,$00,$0e,$dc,$cc,$6e,$e6,$dd,$dd,$d9,$99
    .db $bb,$bb,$67,$63,$6e,$0e,$ec,$cc,$dd,$dc,$99,$9f,$bb,$b9,$33,$3e

; This block tells wla dx to generate a GB rom with the expected values
; in the header.

.NAME "HELLOWORLD " ; must be 11 bytes.
.COMPUTEGBCHECKSUM
.CARTRIDGETYPE $0
.LICENSEECODENEW "1A"
.ROMDMG
.COMPUTEGBCOMPLEMENTCHECK

.orga $14a
    .db $01     ; destination country, 00 is japan, 01 is other
.orga   $14c
    .db $00     ; mask ROM version
.orga $150
main:
    di

    ; ldh is a special opcode for gameboy.
    ; ldh (x),a essentially writes content of a to address $ff00 + x
    ; by coincidence the gameboys memory mapped i/o is in address range $ff00 -> $ffff

    ; Wait for vblank period before disabling lcd controller
-:  ldh a,($44)
    sub 144
    jp  nz,-

    xor a           ; clear register a
    ldh ($40),a     ; disable LCD and stuff

    ; clear screen memory
    ld  hl,$9bff
-:  xor a
    ldd (hl),a
    ld  a,h
    sub $97
    jp nz,-

    ld hl,$8000     ; Load address to tile ram
    ld de,gfx       ; Load address to graphics data.
    ld b,8*7        ; seven tiles of 8 bytes of data.
                    ; Not that tile data is actually 16 bytes, but
                    ; we duplicate the data on two bilplanes in loop.
-:  ld a,(de)       ; Get graphics data.
    ldi (hl),a      ; load and increase
    ldi (hl),a      ; same data on both bitplanes
    inc de          ; increase source
    dec b           ; decrease register b
    jp nz,-         ; loop if result not zero

    ld hl,$9800     ; Load address to tilemap
    ld a,1          ; first tile to set (tile 0 is empty)
    ld b,6          ; Hello world consists of 6 tiles
-:
    ldi (hl),a      ; Write tile number to tilemap
    inc a           ; next tile number
    dec b           ; decrease counter
    jp nz,-         ; repeat until b is 0.

    ld  a,%10010001 ; LCD Controller = On, tile ram @ $8000, BG = On
    ldh ($40),a
-:
    halt
    jp -            ; endless loop

gfx:
    .db     $00,$00,$00,$00,$00,$00,$00,$00
    .db     $00,$44,$44,$45,$7d,$45,$44,$00
    .db     $00,$05,$e5,$15,$f5,$05,$f5,$00
    .db     $00,$01,$31,$49,$49,$49,$30,$00
    .db     $00,$10,$13,$14,$54,$54,$a3,$00
    .db     $00,$01,$19,$a5,$a1,$a1,$21,$00
    .db     $00,$0a,$3a,$4a,$4a,$48,$3a,$00
