	opt h+
	org $4000 ;Start of code 
start
	; custom nmi

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


	;lda #0 ;Disable screen DMA 
	lda	#32+16 +2 ;  32 = enable DMA fetch, 16 = single line, 2 = normal pf, 1 = narrow pf -> (1+2) = wide pf
	;sta $d400 ; 559 


	ldx	#0

@	lda	hello_world_1col,x
	sta	end,x
	inx
	txa
	sub	#6
	bne	@-1

	lda	#<end
	sta	screen_ptr
	lda	#>end
	sta	screen_ptr+1

loop
	;lda $d40b ; Load VCOUNT 
	;rol
	;sta $d40a ; wsync (wait for horizontal sync)
	;lda	$d20a	; get random value
    jmp loop 

;------------
vbl_irq:

;	lda	#0
;	sta $d01a 	;Change background color 


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

	;lda	#$07
	;sta $d01a 	;Change background color 

	pla
	rti
;------------

disp_list:
	.db $70,$70,$70
	.db 9 + $40
screen_ptr
	.dw	start
	.db 9
	.db 9 + 128
	.db	$41
	.dw	disp_list


hello_world_1col:

    .dw    %0100010000000101,%0000000100010000,%0000000100001010
    .dw    %0100010011100101,%0011000100010011,%0001100100111010
    .dw    %0100010100010101,%0100100100010100,%1010010101001010
    .dw    %0111110111110101,%0100100101010100,%1010000101001010
    .dw    %0100010100000101,%0100100101010100,%1010000101001000
    .dw    %0100010011110101,%0011000010100011,%0010000100111010

end:


    run start ;Define run address must be last

