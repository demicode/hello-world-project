
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
;	ld bc,32*32
;	ld hl,$9800	 ; tile map
;	xor a
;	ld e,a
;-:
;	ld a,e
;	ldi (hl),a
;	dec bc
;	ld a,c
;	or b
;	jp nz,-


	ld de,$8000
	ld hl,gfx
	ld b,$10
-:
	ldi a,(hl)
	ld  (de),a
	inc de 
	dec bc
	ld a,e
	or d
	jp nz,-


	ld hl,$9800
	ld a,1
	ldi (hl),a
	inc a
	ldi (hl),a


	
-:	jp -



gfx:  
	.db   $ff,$ff,$ff,$ff
	.db   $ff,$ff,$ff,$ff
	.db   $ff,$ff,$ff,$ff
	.db   $ff,$ff,$ff,$ff

	.db   $ff,$ff,$ff,$ff
	.db   $ff,$ff,$ff,$ff
	.db   $ff,$ff,$ff,$ff
	.db   $ff,$ff,$ff,$ff
