;
; Hello world code for the Commodore C64 
;
; Not tested on real hardware.. 
;
; Assembled using dasm (http://dasm-dillon.sourceforge.net)
;

	; Tell dasm that this file contains 6502 code.

	processor 6502

	; This header is actually BASIC code with one line of code:
	; 10 SYS 4096
	; Without this header, you must run the code manually by
	; typing ys 4096 yourself.

	; Tell the assembler that the following code will be located
	; at address $801, which is where all BASIC code is loaded.
	org $801

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

	org $810

	lda	#$10		; 
	sta	$d011
	lda	#$00
	sta	$d016

	lda	#0
	;sta	$d020 ; border color?
	;sta	$d021 ; background color 0
	tax
	lda	#$2
.clear_screen
	sta	$400,x
	sta	$500,x
	sta	$600,x
	sta	$700,x
	inx
	bne	.clear_screen

.loop
	jmp .loop
