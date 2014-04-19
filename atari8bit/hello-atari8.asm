	opt h+
	org $4000 ;Start of code 
start
	; custom nmi

	lda	#0		; Disable all interrupts
	sta	$d40e

	lda #0
	sta	$d400	; disable all screen dma


	lda	#<dl_irq
	sta	$200
	lda	#>dl_irq
	sta	$201


	lda	#<vbl_irq
	sta	$222
	lda	#>vbl_irq
	sta	$223

	; Set display list pointer.
	lda	#<disp_list
	sta	$d402
	lda	#>disp_list
	sta	$d403


	; save pointer to video ram in zero page 
	lda	#<end
	sta	$b0
	sta	screen_ptr
	lda	#>end
	sta	$b1
	sta	screen_ptr+1

	; setup ptr to graphics in zero page
	lda #<hello_world_1col
	sta	$b2
	lda #>hello_world_1col
	sta	$b3

	ldx	#6	; six rows
	ldy	#0
byte_loop:
	lda	($b2),y
	sta	($b0),y
	iny
	cpy #6
	bmi	byte_loop

	dex
	beq copy_done
	ldy	#0

	lda	#10

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

	jmp byte_loop

copy_done:


	lda	#$c0	; enable DLI and VBI
	sta	$d40e

	; 32 = enable DMA fetch, 16 = single line, 2 = normal pf
	; 1 = narrow pf -> (1+2) = wide pf
	lda	#32+16+2
	sta $d400		; Re-enable screen DMA

loop
    jmp loop 

;------------
vbl_irq:
	lda	#$92
	sta $d01a 	; Change background color

    ; OS stores the registers before jumping here, better restore them.
	pla
	tay
	pla
	tax
	pla
	rti

;------------
dl_irq:
	pha
	; setting background color here to produce rasterbars?

	lda	#$f6
	sta $d40a ; wsync (wait for horizontal sync)
	sta $d01a 	;Change background color 


	pla
	rti
;------------
	org $4200
disp_list:
	.db $70,$70
	.db 9 + $40
screen_ptr
	.dw	start
	.db 9
	.db 9 + 128
	.db 9
	.db 9
	.db 9
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

end:


    run start ;Define run address must be last

