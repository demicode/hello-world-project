;
; Hello World for Gameboy Advance!
;
; For simplicity, this code uses MODE 4, (chunky 256 colours) 
; 
; Compiled with vasmarm_std. 
;
; Tested with:
;  VisualBoyAdvance-M (svn1149)
;  mess64 (0.156)
;  Boycott Advance (0.4.0)
;

	.arm		; Use arm instruction set.

	; header...
	.section .text

	b	_start

	; Special Nintendo GBA header (graphics) data   
	.incbin 	"gba_data.bin"

	; Game title starts at 0x080000a0, 12 chars
	.ascii "Hello World!"	; 12 chars
	; game code follows, 4 chars.
	.ascii	"1234"
	; then two chars of makers id...
	.byte	"DC"
	; Fixed value 
	.byte	0x96
	; Main unit code
	.byte	0x00
	; Device type
	.byte 0x80
	; Reserved area
	.space 7,0
	; Mask ROM version
	.byte 0
	; Compliment Check
	.byte 0 			; Calculated by separate python script 
	; More reserved
	.half 0

_start:

	; Set display mode
	mov		r4,#0x04000000			; Display control register.
	mov		r2,#4|0x400				; Set mode 4 and enable background 2
	str		r2,[r4]					; load display control with mode

	; set palette
	adr		r0,palette_1		; address to palette data
	mov		r1,#0x05000000		; palette register address

	ldr		r3,[r0]			    ; load colour data 
	str		r3,[r1]				; store in palette register


	;---------
	adr		r4,hello_data-4		; use address 4 bytes before to use auto update later
	mov		r3,#0x06000000		; VRAM
	sub		r3,r3,#4			; subtract 4 to allow auto update work later

	mov		r0,#6		; 6 rows
.row_loop:
	mov		r1,#48/4	; 48 bytes per row = 12 words
.pixel_loop:
	ldr		r2,[r4,#4]!
	str		r2,[r3,#4]!
	subs	r1,r1,#1
	bne		.pixel_loop
	add		r3,r3,#240-48
	subs	r0,r0,#1
	bne		.row_loop

; ---

stay_forever:
	b	stay_forever

; -------------------------------------
;
; -------------------------------------
; 16 color palette

palette_1:
	.half	0x7000,0x7fff

hello_data:
    .byte   0,1,0,0,0,1,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,1
    .byte   0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,1,0
	.byte   0,1,0,0,0,1,0,0,1,1,1,0,0,1,0,1,0,0,1,1,0,0,0,1
	.byte	0,0,0,1,0,0,1,1,0,0,0,1,1,0,0,1,0,0,1,1,1,0,1,0
	.byte   0,1,0,0,0,1,0,1,0,0,0,1,0,1,0,1,0,1,0,0,1,0,0,1
	.byte	0,0,0,1,0,1,0,0,1,0,1,0,0,1,0,1,0,1,0,0,1,0,1,0
	.byte   0,1,1,1,1,1,0,1,1,1,1,1,0,1,0,1,0,1,0,0,1,0,0,1
	.byte	0,1,0,1,0,1,0,0,1,0,1,0,0,0,0,1,0,1,0,0,1,0,1,0
	.byte   0,1,0,0,0,1,0,1,0,0,0,0,0,1,0,1,0,1,0,0,1,0,0,1
	.byte	0,1,0,1,0,1,0,0,1,0,1,0,0,0,0,1,0,1,0,0,1,0,0,0
	.byte   0,1,0,0,0,1,0,0,1,1,1,1,0,1,0,1,0,0,1,1,0,0,0,0
	.byte	1,0,1,0,0,0,1,1,0,0,1,0,0,0,0,1,0,0,1,1,1,0,1,0

