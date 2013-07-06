
.MEMORYMAP
  SLOTSIZE $4000
  DEFAULTSLOT 0
  SLOT 0 $0000
  SLOT 1 $4000
.ENDME

.ROMBANKSIZE $4000
.ROMBANKS 2

; Ram memory at $a000 - $bfff


.bank 0
.orga $00 
	jp $100 
.orga $08 
	jp $100 
.orga $10 
	jp $100 
.orga $18
	jp $100 
.orga $20
	jp $100 
.orga $28
	jp $100 
.orga $30
	jp $100 
.orga $38
	jp $100 

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
	.db	$ce,$ed,$66,$66,$cc,$0d,$00,$0b,$03,$73,$00,$83,$00,$0c,$00,$0d
	.db	$00,$08,$11,$1f,$88,$89,$00,$0e,$dc,$cc,$6e,$e6,$dd,$dd,$d9,$99
	.db	$bb,$bb,$67,$63,$6e,$0e,$ec,$cc,$dd,$dc,$99,$9f,$bb,$b9,$33,$3e

.NAME "HELLOWORLD " ; must be 11 bytes.
.COMPUTEGBCHECKSUM
.CARTRIDGETYPE $1
.LICENSEECODENEW "1A"
.ROMDMG
.COMPUTEGBCOMPLEMENTCHECK

.orga $150
main:
	ld sp,$e000  ; Setup stackpointer.

	ld hl,$8000
	ld de,gfx
	ld b,16*7
-:
	ld a,(de)
	xor	$ff
	ldi (hl),a
	ldi (hl),a
	inc de 
	dec b
	jp nz,-


	ld hl,$9800
	ld a,1
	ld b,6
-:
	ldi (hl),a
	inc a
	dec b
	jp nz,-


	
-:	jp -



gfx:  
	.db     $00
	.db     $00
	.db     $00
	.db     $00
	.db     $00
	.db     $00
	.db     $00
	.db     $00

	.db     %00000000
	.db     %01000100
	.db     %01000100
	.db     %01000101
	.db     %01111101
	.db     %01000101
	.db     %01000100
	.db     %00000000

	.db     %00000000
	.db     %00000101
	.db     %11100101
	.db     %00010101
	.db     %11110101
	.db     %00000101
	.db     %11110101
	.db     %00000000

	.db     %00000000
	.db     %00000001
	.db     %00110001
	.db     %01001001
	.db     %01001001
	.db     %01001001
	.db     %00110000
	.db     %00000000

	.db     %00000000
	.db     %00010000
	.db     %00010011
	.db     %00010100
	.db     %01010100
	.db     %01010100
	.db     %10100011
	.db     %00000000

	.db     %00000000
	.db     %00000001
	.db     %00011001
	.db     %10100101
	.db     %10100001
	.db     %10100001
	.db     %00100001
	.db     %00000000

	.db     %00000000
	.db     %00001010
	.db     %00111010
	.db     %01001010
	.db     %01001010
	.db     %01001000
	.db     %00111010
	.db     %00000000

