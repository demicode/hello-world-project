;
; Hello World for Gameboy Advance!
;
; For simplicity, this code uses MODE 4, (chunky 256 colours) 
; 
; Compiled with vasmarm_std. 
;
; Tested in VisualBoyAdvance-M (svn1149)
;

	.arm		; Use arm instruction set.

	; header...
	.org	0x08000000		; GBA ROM Address starts at 0x08000000
	.section text			

	b	_start

	.space 0xf0,0x9c		; fill 0x9c bytes with 0xf0

	; Game title starts at 0x080000a0, 12 chars
	.ascii "Hello World!"	; 12 chars
	; game code follows, 4 chars.
	.ascii	"1234"
	; then two chars of makers id...
	.byte	"GB"
	; after that, i don't know.
	.space 0xba,0			; Reset of header.. fill with 0
_start:

	; Set display mode
	mov		r4,#0x04000000			; Display control register.
	mov		r2,#4|0x400				; Set mode 4 and enable background 2
	str		r2,[r4]					; load display control with mode

	; set palette
	adr		r0,palette_1-4		; address to palette data
	mov		r1,#0x05000000		; palette register address
	mov		r2,#16				; words to copy...

.set_pal_loop:
	ldr		r3,[r0,#4]!			; load palette data 
	str		r3,[r1]				; store in palette register
	add		r1,r1,#4
	subs	r2,r2,#1			; 
	bne		.set_pal_loop


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
	.half	0x0000,0x7fff,0x0f03,0x0005,0x0007,0x0009,0x000b,0x000d
	.half	0x0008,0x0009,0x000a,0x000b,0x000c,0x000d,0x000e,0x7fff

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
