

; MD HEADER TEST

STACK	equ		$01000000
ENTRY	equ		$220

EXCEPTION_HANDLER equ	$200 ; <- random value...

IRQ_HANDLER	equ	$204

TRAP_HANDLER equ	$208

	ORG	0

; Initial stack pointer
	dc.l	STACK
; Initial program counter
	dc.l	ENTRY
; $08 - Bus error  
	dc.l	EXCEPTION_HANDLER
; $0C - Address error 
	dc.l	EXCEPTION_HANDLER
; $10 - Illegal instruction 
	dc.l	EXCEPTION_HANDLER
; $14 - Divistion by zero
	dc.l	EXCEPTION_HANDLER
; $18 - CHK exception
	dc.l	EXCEPTION_HANDLER
; $1C - TRAPV exception 
	dc.l	EXCEPTION_HANDLER
; $20 - Privilege violation 
	dc.l	EXCEPTION_HANDLER
; $24 - TRACE exeption  
	dc.l	EXCEPTION_HANDLER
; $28 - LINE 1010 EMULATOR  
	dc.l	EXCEPTION_HANDLER
; $2C - LINE 1111 EMULATOR  
	dc.l	EXCEPTION_HANDLER
; $30-$5F - Reserved by Motorola  


	ORG	$60
	
; $60 - Spurious exception 
	dc.l	IRQ_HANDLER
; $64 - Interrupt request level 1  
	dc.l	IRQ_HANDLER
; $68 - Interrupt request level 2  
	dc.l	IRQ_HANDLER
; $6C - Interrupt request level 3  
	dc.l	IRQ_HANDLER
; $70 - Interrupt request level 4 (VDP interrupt / Horizontal blank)  
	dc.l	IRQ_HANDLER
; $74 - Interrupt request level 5  
	dc.l	IRQ_HANDLER
; $78 - Interrupt request level 6 (Vertical blank)  
	dc.l	IRQ_HANDLER
; $7C - Interrupt request level 7  
	dc.l	IRQ_HANDLER
; $80 - TRAP #00 exception  
	dc.l	TRAP_HANDLER
; $84 - TRAP #01 exception  
	dc.l	TRAP_HANDLER
; $88 - TRAP #02 exception  
	dc.l	TRAP_HANDLER
; $8C - TRAP #03 exception  
	dc.l	TRAP_HANDLER
; $90 - TRAP #04 exception  
	dc.l	TRAP_HANDLER
; $94 - TRAP #05 exception  
	dc.l	TRAP_HANDLER
; $98 - TRAP #06 exception  
	dc.l	TRAP_HANDLER
; $9C - TRAP #07 exception  
	dc.l	TRAP_HANDLER
; $A0 - TRAP #08 exception  
	dc.l	TRAP_HANDLER
; $A4 - TRAP #09 exception  
	dc.l	TRAP_HANDLER
; $A8 - TRAP #10 exception  
	dc.l	TRAP_HANDLER
; $AC - TRAP #11 exception  
	dc.l	TRAP_HANDLER
; $B0 - TRAP #12 exception  
	dc.l	TRAP_HANDLER
; $B4 - TRAP #13 exception  
	dc.l	TRAP_HANDLER
; $B8 - TRAP #14 exception  
	dc.l	TRAP_HANDLER
; $BC - TRAP #15 exception  
	dc.l	TRAP_HANDLER

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
	dc.l	$20000		; 128K rom size

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


	ORG	EXCEPTION_HANDLER
	dc.w	$60fe

	ORG	IRQ_HANDLER
	rte

	ORG TRAP_HANDLER
	rte

	ORG	ENTRY

start:
	move.w	#0,d0


stay:
	bra.s	stay


	org	$20000
; don't put anyting here!

