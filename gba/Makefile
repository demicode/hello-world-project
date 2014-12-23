OUT = hello-world.gba

all:
	vasmarm_std -maxerrors=0 -Fbin hello_gba.asm -o $(OUT)
	@python fix_gba_header.py $(OUT)

clean:
	rm -f $(OUT)
