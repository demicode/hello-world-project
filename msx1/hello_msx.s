

.MEMORYMAP
  SLOTSIZE $4000
  DEFAULTSLOT 0
  SLOT 0 $0000
  SLOT 1 $4000
  SLOT 2 $8000
.ENDME

.ROMBANKSIZE $4000
.ROMBANKS 1

.BANK 0 SLOT 0
.orga	$0

	ret

