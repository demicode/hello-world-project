;
; Hello world code for the Commodore C64 
;
; Not tested on real hardware.. yet
;
; Assembled using dasm (http://dasm-dillon.sourceforge.net)
; (brew install dasm)
;

	; Tell dasm that this file contains 6502 code.

	.processor 6502

	; This header is actually BASIC code with one line of code:
	; 10 SYS 2064
	; Without this header, you must run the code manually by
	; typing sys 2064 yourself.

	; Tell the assembler that the following code will be located
	; at address $801, which is where all BASIC code is loaded.
	.org $801

	.byte $0c, $08, $0a, $00, $9e, $20
	.byte $32, $30, $36, $34, $00, $00, $00

	; End of BASIC header. 

	; $d011 VIC control register 1.
	; +----------+---------------------------------------------------+
	; | Bit  7   |    Raster Position Bit 8 from $D012               |
	; | Bit  6   |    Extended Color Text Mode: 1 = Enable           |
	; | Bit  5   |    Bitmap Mode: 1 = Enable                        |
	; | Bit  4   |    Blank Screen to Border Color: 0 = Blank        |
	; | Bit  3   |    Select 24/25 Row Text Display: 1 = 25 Rows     |
	; | Bits 2-0 |    Smooth Scroll to Y Dot-Position (0-7)          |
	; +----------+---------------------------------------------------+


	; $D016: VIC Control Register 2
	; +----------+---------------------------------------------------+
	; | Bits 7-6 |    Unused                                         |
	; | Bit  5   |    Reset-Bit: 1 = Stop VIC (no Video Out, no RAM  |
	; |          |                   refresh, no bus access)         |
	; | Bit  4   |    Multi-Color Mode: 1 = Enable (Text or Bitmap)  |
	; | Bit  3   |    Select 38/40 Column Text Display: 1 = 40 Cols  |
	; | Bits 2-0 |    Smooth Scroll to X Dot-Position (0-7)          |
	; +----------+---------------------------------------------------+

	.org $810
	sei

main_loop:

	jsr	hello_standard_bitmap_mode
	jsr hello_multi_color_bitmap_mode

	jmp	main_loop


;----
; Standard bitmap mode is 320 x 200 pixels,
; 2 colors per 8x8 
;
; I chose to use address $2000 - $3fff as video ram
; and $400 - $7ff as color ram

hello_standard_bitmap_mode: subroutine

	; disable video while setting up video memory
	lda	#$0
	sta	$d011
	sta	$d020 	; border color to black

	jsr	clear_screen

	lda	#$10
	jsr	fill_color_ram

	; copy graphics data to screen
	ldy	#gfx_len-1
.copy_loop
	lda	gfx,y
	sta	$2000,y
	dey
	bne	.copy_loop

	; Set video mode
	lda	#3
	sta	$dd00
	lda	#$3b
	ldx	#$08
	ldy	#$18
	sta	$d011
	stx $d016
	sty	$d018

	ldx #$80
.wait
	jsr  wait_vbl
	dex
	bne	.wait
	rts

;----
; Standard bitmap mode is 320 x 200 pixels,
; 2 colors per 8x8 
;
; I chose to use address $2000 - $3fff as video ram
; and $400 - $7ff as color ram

hello_multi_color_bitmap_mode: subroutine

	; disable video while setting up video memory
	lda	#$0
	sta	$d011

	jsr	clear_screen

	; clear color ram at $400
	lda	#$0
	jsr	fill_color_ram

	; copy graphics data to screen
	ldy	#88-1
.copy_row
	lda	multi_gfx,y
	sta	$2200,y
	lda	multi_gfx+88,y
	sta	$2200+320,y
	dey
	bpl	.copy_row

	lda	#$b
	sta	$d020 	; border color gray
	sta	$d021 	; background color also gray


	; Set video mode
	lda	#3
	sta	$dd00
	lda	#$3b
	ldx	#$18	; multi color 
	ldy	#$18
	sta	$d011
	stx $d016
	sty	$d018
	ldx #0

	ldx #$80
.wait
	jsr  wait_vbl
	dex
	bne	.wait
	rts


fill_color_ram: subroutine
	ldx	#0
.cram_clear
	sta	$400,x
	sta	$500,x
	sta	$600,x
	sta	$700,x
	dex
	bne	.cram_clear

	rts


clear_screen: subroutine
	; clear 8000 bytes of screen ram at $2000
	ldx	#$00
	lda	#$20
	stx	$fb		; use memory $fb to $fc
	sta	$fc		; as base pointer to $2000

	ldy	#0
	ldx #32
	lda	#$0
.clear_loop
	sta	($fb),y
	iny
	bne	.clear_loop
	inc $fc
	dex
	bne	.clear_loop
	rts

;----
wait_vbl:
	pha
	lda	#$80
.w1: bit $d011
	bpl .w1
.w2: bit $d011
	bmi .w2
	pla
	rts

gfx:
  dc.b    %00000000
  dc.b    %01000100
  dc.b    %01000100
  dc.b    %01000101
  dc.b    %01111101
  dc.b    %01000101
  dc.b    %01000100
  dc.b    %00000000

  dc.b    %00000000
  dc.b    %00000101
  dc.b    %11100101
  dc.b    %00010101
  dc.b    %11110101
  dc.b    %00000101
  dc.b    %11110101
  dc.b    %00000000

  dc.b    %00000000
  dc.b    %00000001
  dc.b    %00110001
  dc.b    %01001001
  dc.b    %01001001
  dc.b    %01001001
  dc.b    %00110000
  dc.b    %00000000

  dc.b    %00000000
  dc.b    %00010000
  dc.b    %00010011
  dc.b    %00010100
  dc.b    %01010100
  dc.b    %01010100
  dc.b    %10100011
  dc.b    %00000000

  dc.b    %00000000
  dc.b    %00000001
  dc.b    %00011001
  dc.b    %10100101
  dc.b    %10100001
  dc.b    %10100001
  dc.b    %00100001
  dc.b    %00000000

  dc.b    %00000000
  dc.b    %00001010
  dc.b    %00111010
  dc.b    %01001010
  dc.b    %01001010
  dc.b    %01001000
  dc.b    %00111010
  dc.b    %00000000
gfx_len equ	*-gfx


multi_gfx:
	dc.b	0,$00,$40,$40,$40,$40,$40,$40
	dc.b	0,$00,$40,$40,$40,$40,$40,$40
	dc.b	0,$00,$01,$01,$01,$01,$01,$01
	dc.b	0,$00,$10,$10,$10,$10,$10,$10
	dc.b	0,0,0,0,0,0,0,0
	dc.b	0,$00,$10,$10,$10,$10,$10,$10
	dc.b	0,$00,$10,$10,$10,$10,$10,$10
	dc.b	0,0,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,0,0
	dc.b	0,$00,$10,$10,$10,$10,$10,$10
	dc.b	0,$00,$04,$04,$04,$04,$04,$04
	; row 2
	dc.b	$40,$55,$40,$40,$40,$40,$40,0
	dc.b	$41,$44,$44,$45,$44,$44,$41,0
	dc.b	$41,$11,$11,$51,$01,$01,$51,0
	dc.b	$10,$11,$11,$11,$11,$11,$10,0
	dc.b	$50,$04,$04,$04,$04,$04,$50,0
	dc.b	$10,$11,$11,$11,$11,$11,$04,0
	dc.b	$10,$11,$11,$11,$11,$11,$40,0
	dc.b	$50,$04,$04,$04,$04,$04,$50,0
	dc.b	$44,$51,$40,$40,$40,$40,$40,0
	dc.b	$10,$11,$11,$11,$11,$11,$10,0
	dc.b	$54,$04,$04,$04,$04,$04,$54,0

multi_gfx_len equ *-multi_gfx

