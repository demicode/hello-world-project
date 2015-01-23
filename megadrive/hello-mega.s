

; MD HEADER TEST

STACK	equ		$00fffe00

	ORG	0

; Initial stack pointer
	dc.l	STACK
; Initial program counter
	dc.l	start
; $08 - Bus error  
	dc.l	exception_handler
; $0C - Address error 
	dc.l	exception_handler
; $10 - Illegal instruction 
	dc.l	exception_handler
; $14 - Divistion by zero
	dc.l	exception_handler
; $18 - CHK exception
	dc.l	exception_handler
; $1C - TRAPV exception 
	dc.l	exception_handler
; $20 - Privilege violation 
	dc.l	exception_handler
; $24 - TRACE exeption  
	dc.l	exception_handler
; $28 - LINE 1010 EMULATOR  
	dc.l	exception_handler
; $2C - LINE 1111 EMULATOR  
	dc.l	exception_handler
; $30-$5F - Reserved by Motorola  
	ds.b	48 ; reserved bytes.
	
; $60 - Spurious exception 
	dc.l	irq_handler
; $64 - Interrupt request level 1  
	dc.l	irq_handler
; $68 - Interrupt request level 2  
	dc.l	irq_handler
; $6C - Interrupt request level 3  
	dc.l	irq_handler
; $70 - Interrupt request level 4 (VDP interrupt / Horizontal blank)  
	dc.l	hbi_handler
; $74 - Interrupt request level 5  
	dc.l	irq_handler
; $78 - Interrupt request level 6 (Vertical blank)  
	dc.l	vbi_handler
; $7C - Interrupt request level 7  
	dc.l	irq_handler

; $80 - TRAP #0-15 exception handler
	REPT 16
	dc.l	trap_handler
	ENDR

; $C0-$FF - Reserved by Motorola
	ds.b	64		; 64 bytes reserved

	org $100

; $100-$10F - Console name (usually 'SEGA MEGA DRIVE ' or 'SEGA GENESIS    ')
	dc.b	'SEGA MEGA DRIVE '

; $110-$11F - Release date (usually '(C)XXXX YYYY.MMM' 
;            where XXXX is the company code, YYYY is the year and MMM - month)
	dc.b	'(C)DEMI 2014.DEC'
; $120-$14F - Domestic name  (48 bytes)
	dc.b	'Hero woduru, Mega Drive                         '

; $150-$17F - International name (48 bytes)
	dc.b	'Hello world, Mega Drive                         '

; $180-$18D - Version ('XX YYYYYYYYYYYY' where XX is the game type and YY the game code)
	dc.b	'GM 01234567891'
; $18E-$18F - Checksum (for info how to calculate checksum go HERE)
	dc.w	$0000	; <- put checksum here in post build process.

; $190-$19F - I/O support
	ds.b	 16	; Unused bytes?

; $1A0-$1A3 - ROM start 
	dc.l	0
; $1A4-$1A7 - ROM end
	dc.l	end_of_rom-1		; 128K rom size

; $1A8-$1AB - RAM start (usually $00FF0000)
	dc.l	$00FF0000
; $1AC-$1AF - RAM end (usually $00FFFFFF)
	dc.l	$00FFFFFF

; $1B0-$1B2 - 'RA' and $F8 enables SRAM.
	dc.b	'AR',$f8
; $1B3      - unused ($20)
	dc.b	$20
; $1B4-$1B7 - SRAM start (default $00200000)
	dc.l	$00200000
; $1B8-$1BB - SRAM end (default $0020FFFF)
	dc.l	$0020FFFF
; $1BC-$1FF - Notes (unused)
	ds.b	52
	dc.b	'JUE             '

	org $200

start:

	; Try to set background color or something...

VDP_BASE	equ	$c00000
VDP_DATA	equ	VDP_BASE
VDP_CTRL	equ	VDP_BASE+4

	move.w	#$2700,sr
;	move.l	$a10008,d0	; Reset test.
;	or.w	$a1000c,d0
;	bne.s	.softreset

	move.b	$a10001,d0		; Version 
	andi.b	#$0f,d0			; is low byte zero?
	beq.s	.softreset		; yes, skip unlocking of VDP
	move.l  #'SEGA',$a14000
.softreset

	bsr.s	setup_vdp

	lea		VDP_BASE,a0
	moveq	#0,d0
	move.w	#$8f02,4(a0)		; update VDP addres by two each write 

	move.w	#$3fff,d7
	move.l	#$40000000,4(a0)	; write to VRAM addr 0.
.clear_vram:
	move.l	d0,(a0)
	dbra.w	d7,.clear_vram

	move.l	#$c0000000,4(a0)	; write to CRAM
	move.l	#$00000eee,(a0)		; write black to palette entry 0 and white to entry 1


	; upload the tile data to VRAM.
	; not using DMA for simplicity.

	lea		tile_set,a1
	move.l	#$40000000,4(a0)		; Select VRAM address to upload tile data ($0)
.copy_loop:
	move.w	(a1)+,(a0)				; one word at the time.
	cmpa.l	#tile_set_end,a1
	blt.s	.copy_loop


	move.l	#$60000000,d0	; $40000000  + VRAM address to plane A 
	move.l	d0,4(a0)	; Select VRAM address write 

	move.l	#$00010002,(a0)	; Tiles 1 and 2
	move.l	#$00030004,(a0)	; tiles 3 and 4
	move.l	#$00050006,(a0)	; tiles 5 and 6


stay:
	stop	#$2400
	bra.s	stay

;---------------------------

setup_vdp:
	lea		VDP_CTRL,a1
	lea		vdp_regs,a0
	move.w	#((vdp_regs_end-vdp_regs)/2)-1,d2
.copy_loop:
	move.w	(a0)+,(a1)
	dbra.w	d2,.copy_loop
	rts

vbi_handler:
	rte

hbi_handler:
	rte

trap_handler:
	rte

irq_handler:
	rte

exception_handler:
	stop	#$2700
	bra.s	exception_handler

; http://md.squee.co/wiki/VDP
vdp_regs:
	dc.w	$8004		; mode register 1 
	dc.w	$8144		; mode register 2 - Display enable bit set ($40) + VBI ($20)
	dc.w	$8208		; plane a table location - VRAM:$2000
	dc.w	$8318		; window table location -  VRAM:$3000
	dc.w	$8406		; plane b table location - VRAM:$4000
	dc.w	$8500		; sprite table location (reg 5) 2*$200 = $400
	dc.w	$8600		; sprite pattern generator base addr. (always 0 on unmodified hardware)
	dc.w	$8700		; backgroud colour,  (reg 7)
	dc.w	$8800		; 0
	dc.w	$8900		; 0
	dc.w	$8b00		; Mode register 3
	dc.w	$8c00		; mode register 4
	dc.w	$8d05		; HBL_scroll data location. ($1400)
	dc.w	$8e00		; 0
	dc.w	$8f02		; auto-increment value
	dc.w	$9000		; plane size
	dc.w	$9100		; window plane h-pos
	dc.w	$9200		; window place v-pos
vdp_regs_end:


tile_set:
	ds.l	8	; first tile is empty.

    dc.l    $00000000
    dc.l    $01000100
    dc.l    $01000100
    dc.l    $01000101
    dc.l    $01111101
    dc.l    $01000101
    dc.l    $01000100
    dc.l    $00000000

    dc.l    $00000000
    dc.l    $00000101
    dc.l    $11100101
    dc.l    $00010101
    dc.l    $11110101
    dc.l    $00000101
    dc.l    $11110101
    dc.l    $00000000

    dc.l    $00000000
    dc.l    $00000001
    dc.l    $00110001
    dc.l    $01001001
    dc.l    $01001001
    dc.l    $01001001
    dc.l    $00110000
    dc.l    $00000000

    dc.l    $00000000
    dc.l    $00010000
    dc.l    $00010011
    dc.l    $00010100
    dc.l    $01010100
    dc.l    $01010100
    dc.l    $10100011
    dc.l    $00000000

    dc.l    $00000000
    dc.l    $00000001
    dc.l    $00011001
    dc.l    $10100101
    dc.l    $10100001
    dc.l    $10100001
    dc.l    $00100001
    dc.l    $00000000

    dc.l    $00000000
    dc.l    $00001010
    dc.l    $00111010
    dc.l    $01001010
    dc.l    $01001010
    dc.l    $01001000
    dc.l    $00111010
    dc.l    $00000000
tile_set_end:


	org	$20000
; don't put anyting here!
end_of_rom:

; RAM 
	offset $ff0000
test	ds.l	12

