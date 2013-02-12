
	SECTION TEXT

	pea	super_run
	move.w	#$26,-(sp)	; XBIOS call to Supexec.
	trap	#14
	addq.w	#6,sp

.halt	bra.s	.halt

super_run:

	; On ST, the screen address should be aligned by 256 bytes.
	; The add.w and clr.b below takes care of that. Note that
	; the screen_mem reservation is 32000 + 256 extra bytes.
	move.l	#screen_mem,d0	
	add.w	#$ff,d0
	clr.b	d0
	move.l	d0,a6		; Store screen pointer in a6
	lsr.l	#8,d0
	move.l	d0,$ffff8200.w	; Set screen address registers.

	; Set palette
	movea.w	#$8240,a1	; Pointer to palette entries.
	moveq	#0,d0		; Color is black.
	moveq	#15,d1
.clear_palette
	move.w	d0,(a1)+
	dbra.w	d1,.clear_palette

	; Setup resolution, since d0 still contains 0, we
	; use that to set screen to lowres.
	move.w	d0,$ffff8260.w

	rts

	SECTION DATA
gfx:
	dc.w	$0000,$0000,$0000,$0000,$0000


	SECTION BSS

; Reserve screen memory 
screen_mem:
	ds.b	32256

	END
