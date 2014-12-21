; this code is copied from internet examples.
; disassembled and commented added by me.

	org $0

	xor a						; clear accumulator
	ld bc,$2000 - (code_end+1)	; setup bc counter for clearing all ram
	ld de,code_end+1			; destination pointer
	ld hl,code_end				; source pointer
	ld sp,hl					; setup stack pointer.
	ld (hl),a					; store a (0) at source 
	ldir						; copy data (i.e. clear ram)
	pop ix						; pop some zeros to ix reg
	pop iy						; pop some more zeros to iy reg
	ld i,a						; clear interrupt controll vector
	ld r,a						; clear memory refresh register
	pop de						; clear de
	pop hl						; clear hl
	pop af						; clear af
	ex af,af'					; ' swap accumlator and flags regs to alt set. 
	exx							; swap register set to alt set.
	pop bc						; clear bc
	pop de						; clear de
	pop hl						; clear hl
	pop af						; clear af.
	ld sp,hl					; set sp to 0
	di							; disable interrupts

	im 1			; set interrupt mode 1

	; this will in practice set up an infinite jump to self.
	ld (hl),$e9		; set instruction at (hl) to jp (hl)
	jp (hl)			; jump to (hl)
code_end:
	
