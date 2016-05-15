;
; Hello World for atari 8 bit
; Should work on any Atari with OS/B or later.
;
; Tested on 130XE
;
; Assembled using mads (http://mads.atari8.info/)
;

	opt h+			; Add DOS executable header

	org $2000		; Load address of the code block.

start:
	lda	#0
	sta	$d40e		; Disable all interrupts
	sta	$d400		; disable all screen dma

	; Install VBL interrupt handler
	; at $222, which will disable all
	; OS functionality if I understand
	; correctly
	lda	#<vbl_irq	; Low byte (LSB) of address
	sta	$222		; OS handler jumps through this vector ($222-$223) at start of VBI.
	lda	#>vbl_irq	; High byte (MSB) of address
	sta	$223

	; Set display list pointer.
	lda	#<disp_list
	sta	$d402
	lda	#>disp_list
	sta	$d403

	; save pointer to video ram in zero page
	lda	#<screen_mem
	sta	$b0
	lda	#>screen_mem
	sta	$b1

	lda	#10
	jsr	copy_1bit_gfx

	lda	#<(screen_mem+10*7)
	sta	$b0
	lda	#>(screen_mem+10*7)
	sta	$b1

	lda	#20
	jsr	copy_1bit_gfx

	lda	#<(screen_mem+(10+20)*7)
	sta	$b0
	lda	#>(screen_mem+(10+20)*7)
	sta	$b1

	lda	#40
	jsr	copy_1bit_gfx


	lda	#$0e
	sta	$d016	; set pf0 color to white
	sta	$d017	; set pf1 color to white

	lda	#$0
	sta	$d018	; set pf2 color to black
	sta	$d01a	; set bg color to black


	lda	#$c0	; enable DLI and VBI
	sta	$d40e

	; $20 = enable DMA fetch, $2 = normal pf width
	lda	#$22
	sta $d400		; Re-enable screen DMA

;------------
loop
    jmp loop 		; loop forever

;------------
vbl_irq:
    ; OS pushes the registers before jumping here, better restore them.
	pla
	tay
	pla
	tax
	pla
	rti

;------------
copy_1bit_gfx:
	; params: a - width of scanline in bytes
	; 		$b0-$b1 dest address

	sta	$b4

	; setup ptr to graphics in zero page
	lda #<hello_world_1col
	sta	$b2
	lda #>hello_world_1col
	sta	$b3

	ldx	#6	; six rows
row_loop:
	ldy	#5
byte_loop:
	lda	($b2),y
	sta	($b0),y
	dey
	bpl	byte_loop

	dex
	beq copy_done

	lda	$b4

	; add line width to dest ptr
	clc
	adc	$b0
	sta	$b0
	lda #0
	adc $b1		; add carry
	sta $b1

	; update data ptr (so we can reuse y in inner loop)
	lda	#6
	clc
	adc	$b2
	sta	$b2
	lda	#0
	adc	$b3
	sta	$b3

	jmp row_loop
copy_done:
	rts

;------------
disp_list:
	.db $70,$70,$70
	.db $70,$70,$70
	.db $49
	.dw	screen_mem
	.db $09, $9, $9, $9,$9, $9
	.db $b, $b, $b, $b, $b, $b, $b
	.db $f, $f, $f, $f, $f, $f, $f
	.db	$41
	.dw	disp_list

;---------------
hello_world_1col:

    .db    %10010000,%00010010,%00000000,%10001000,%00000001,%00000101
    .db    %10010011,%10010010,%00110000,%10001001,%10001001,%00011101
    .db    %10010100,%01010010,%01001000,%10001010,%01010101,%00100101
    .db    %11110111,%11010010,%01001000,%10101010,%01010001,%00100101
    .db    %10010100,%00010010,%01001000,%10101010,%01010001,%00100100
    .db    %10010011,%11001001,%00110000,%01010001,%10010000,%10011101

screen_mem:

    run start ;Define run address must be last
