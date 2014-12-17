

; MD HEADER TEST

STACK	equ		$01000000

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


	ORG	$60
	
; $60 - Spurious exception 
	dc.l	irq_handler
; $64 - Interrupt request level 1  
	dc.l	irq_handler
; $68 - Interrupt request level 2  
	dc.l	irq_handler
; $6C - Interrupt request level 3  
	dc.l	irq_handler
; $70 - Interrupt request level 4 (VDP interrupt / Horizontal blank)  
	dc.l	irq_handler
; $74 - Interrupt request level 5  
	dc.l	irq_handler
; $78 - Interrupt request level 6 (Vertical blank)  
	dc.l	irq_handler
; $7C - Interrupt request level 7  
	dc.l	irq_handler
; $80 - TRAP #00 exception  
	dc.l	trap_handler
; $84 - TRAP #01 exception  
	dc.l	trap_handler
; $88 - TRAP #02 exception  
	dc.l	trap_handler
; $8C - TRAP #03 exception  
	dc.l	trap_handler
; $90 - TRAP #04 exception  
	dc.l	trap_handler
; $94 - TRAP #05 exception  
	dc.l	trap_handler
; $98 - TRAP #06 exception  
	dc.l	trap_handler
; $9C - TRAP #07 exception  
	dc.l	trap_handler
; $A0 - TRAP #08 exception  
	dc.l	trap_handler
; $A4 - TRAP #09 exception  
	dc.l	trap_handler
; $A8 - TRAP #10 exception  
	dc.l	trap_handler
; $AC - TRAP #11 exception  
	dc.l	trap_handler
; $B0 - TRAP #12 exception  
	dc.l	trap_handler
; $B4 - TRAP #13 exception  
	dc.l	trap_handler
; $B8 - TRAP #14 exception  
	dc.l	trap_handler
; $BC - TRAP #15 exception  
	dc.l	trap_handler

; $C0-$FF - Reserved by Motorola


	org $100

; $100-$10F - Console name (usually 'SEGA MEGA DRIVE ' or 'SEGA GENESIS    ')
	dc.b	'SEGA MEGA DRIVE '

; $110-$11F - Release date (usually '(C)XXXX YYYY.MMM' 
;            where XXXX is the company code, YYYY is the year and MMM - month)
	dc.b	'(C)XXXX YYYY.MMM'
; $120-$14F - Domestic name
	org $120
	dc.b	'lala'

; $150-$17F - International name
	org $150
	dc.b	'lelalela'

; $180-$18D - Version ('XX YYYYYYYYYYYY' where XX is the game type and YY the game code)
	org	$180
	dc.b	''
; $18E-$18F - Checksum (for info how to calculate checksum go HERE)
	org	$18e
	dc.w	$0000	; <- put checksum here in post build process.
; $190-$19F - I/O support

; $1A0-$1A3 - ROM start 
	org	$1a0
	dc.l	0
; $1A4-$1A7 - ROM end
	dc.l	$20000-1		; 128K rom size

; $1A8-$1AB - RAM start (usually $00FF0000)
	dc.l	$00FF0000
; $1AC-$1AF - RAM end (usually $00FFFFFF)
	dc.l	$00FFFFFF

; $1B0-$1B2 - 'RA' and $F8 enables SRAM.
	dc.b	'AR',$f8
; $1B3      - unused ($20)
	dc.b	$20
; $1B4-$1B7 - SRAM start (default $00200000)
	org	$1b4
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
	tst.l	$a10008
	bne.s	.a_ok
	tst.w	$a1000c
.a_ok:
	bne.s	.c_ok
	move.b	$a10001,d0
	andi.b	#$0f,d0
	beq.s	.bleh
	move.l  #'SEGA',$a14000
.bleh
	lea		VDP_DATA,a0
	moveq	#0,d0
	move.w	#$3f,d7
	move.l	#$c0000000,VDP_CTRL	; write to CRAM
.clear_cram
	move.w	d0,(a0)	
	dbra.w	d7,.clear_cram
.c_ok:

	movea.l	VDP_BASE,a0


	move.w	#$8f02,4(a0)		; update VDP addres by two each write 

	move.l	#$c0000000,4(a0)	; select write to CRAM address 0


	move.w	#$0eee,(a0)		; write word to CRAM
	move.w	#$0777,(a0)		; next work to CRAM
	move.w	#$0073,(a0)		; ... another word to CRAM!


	; chose palette entries 1 and 2 for border and background?
	move.w	#$8712,4(a0)

	move.w	#$8c00,4(a0) ; set vram mode

	move.w	#$8000,4(a0)	; set mode reg 0 - enable stuff..
	move.w	#$8144,4(a0)	; set mode reg 1 - enable stuff..

stay:
	bra.s	stay


trap_handler:
	rte

irq_handler:
	rte

exception_handler:
	stop	#$2700
	bra.s	exception_handler


	org	$20000
; don't put anyting here!

