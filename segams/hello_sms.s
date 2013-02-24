
.MEMORYMAP
  SLOTSIZE $4000
  DEFAULTSLOT 0
  SLOT 0 $0000
  SLOT 1 $4000
  SLOT 2 $8000
.ENDME

.ROMBANKMAP
  BANKSTOTAL 2
  BANKSIZE $4000
  BANKS 2
.ENDRO

.SDSCTAG 1.0 "Hello World", "A hello world example for Master System", "Mikael Degerfält"
.COMPUTESMSCHECKSUM


	.BANK 0
	.org	$0
stay:	jp	stay
