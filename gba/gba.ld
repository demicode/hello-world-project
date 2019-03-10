MEMORY
{
	rom(rx) : ORIGIN = 0x08000000, LENGTH = 0x1000000
	ram(rwx) : ORIGIN = 0x02000000, LENGTH = 0x40000
}

SECTIONS
{
	.text 0x08000000 :
	{
		*(text text.* .text .text.*)
		*(rodata .rodata)
		*(.comment)
	} > rom

	.data : AT ( ADDR (.text) + SIZEOF (.text) )
	{
		*(data .data data* data.*)
		*(.shdata)
	} > rom

	.bss (NOLOAD) : 
	{
		*(bss .bss)
	} > ram
}
