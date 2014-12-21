
OUT=megahello.smd

.PHONY: all z80

all: z80 hello-mega.s
	vasmm68k_mot -quiet -Fbin -o $(OUT) hello-mega.s 
	@python gen_checksum.py $(OUT)

z80: z80-init.s
	vasmz80_mot -quiet -Fbin -o z80-init.bin z80-init.s


clean:
	rm -f $(OUT) z80-init.bin