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
	.byte $34, $30, $39, $36, $00, $00
	.byte $00

	; End of BASIC header. 

	; The following code will be placed at $1000
	org	$1000
	lda	#0
	sta	$d020
	sta	$d021
	ldx	#0
	lda	#0
.clear_screen
	sta	$400,x
	sta	$500,x
	sta	$600,x
	sta	$700,x
	inx
	bne	.clear_screen

.loop
	jmp .loop
