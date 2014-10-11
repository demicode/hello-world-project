;
; Hello World for atari 8 bit
; Should atleast work on XL and XE revisions of the hardware.
; 
; Tested on 130XE
;
; Assembled using mads (http://mads.atari8.info/)
;

	opt h+			; Add DOS executable header

	org $2000		; Load address of the code block.

start:				; 
	lda	#0
	sta	$d40e		; Disable all interrupts
	sta	$d400		; disable all screen dma

	; Install VBL interrupt handler
	; at $222, which will disable all
	; OS functionality
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
	sta	screen_ptr
	lda	#>screen_mem
	sta	$b1
	sta	screen_ptr+1


	lda	#10
	jsr	copy_1bit_gfx

	lda	#<(screen_mem+10*7)
	sta	$b0
	lda	#>(screen_mem+10*7)
	sta	$b1

	lda	#20
	jsr	copy_1bit_gfx

	lda	#<(screen_mem+10*7 + 20*7 )
	sta	$b0
	lda	#>(screen_mem+10*7 + 20*7 )
	sta	$b1

	lda	#40
	jsr	copy_1bit_gfx


	lda	#$0f
	sta	$d016	; set pf0 color to white
	sta	$d017	; set pf1 color to white

	lda	#$0
	sta	$d018	; set pf2 color to black


	lda	#$c0	; enable DLI and VBI
	sta	$d40e

	; 32 = enable DMA fetch, 16 = single line, 2 = normal pf
	; 1 = narrow pf -> (1+2) = wide pf
	lda	#32+16+2
	sta $d400		; Re-enable screen DMA

loop
    jmp loop 		; loop forever

;------------
vbl_irq:
    ; OS pushes the registers before jumping here, better restore them.
    lda	#0
    sta	$d01b	; clear GTIA bits of PRIOR reg
	pla
	tay
	pla
	tax
	pla
	rti

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
	ldy	#0
?byte_loop:
	lda	($b2),y
	sta	($b0),y
	iny
	cpy #6
	bmi	?byte_loop

	dex
	beq copy_done
	ldy	#0

	lda	$b4

	; add line width to dest ptr
	clc
	adc	$b0
	sta	$b0
	lda #0
	adc $b1		; add carry
	sta $b1

	; update data ptr (so we can reuse y in inner loop)
	clc
	lda	#6
	adc	$b2
	sta	$b2
	lda	#0
	adc	$b3
	sta	$b3

	jmp ?byte_loop
;---
copy_done:
	rts

;------------
	org $2200
disp_list:
	.db $70,$70, $70
	.db $70,$70, $70
	.db $9 + $40		
screen_ptr
	.dw	start
	.db $9
	.db $9
	.db $9
	.db $9
	.db $9
	.db $9
	.db $b
	.db $b
	.db $b
	.db $b
	.db $b
	.db $b
	.db $b
	.db $f
	.db $f
	.db $f
	.db $f
	.db $f
	.db $f
	.db $f
	.db	$41
	.dw	disp_list

;---------------
hello_world_1col:

    .db    %01000100,%00000101,%00000001,%00010000,%00000001,%00001010
    .db    %01000100,%11100101,%00110001,%00010011,%00011001,%00111010
    .db    %01000101,%00010101,%01001001,%00010100,%10100101,%01001010
    .db    %01111101,%11110101,%01001001,%01010100,%10100001,%01001010
    .db    %01000101,%00000101,%01001001,%01010100,%10100001,%01001000
    .db    %01000100,%11110101,%00110000,%10100011,%00100001,%00111010

screen_mem:

    run start ;Define run address must be last
