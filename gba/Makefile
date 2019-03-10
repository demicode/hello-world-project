OUT = hello-world.gba

all:
	vasmarm_std -maxerrors=0 -a4t -Fvobj -o hello_gba.o hello_gba.asm
	vlink -o $(OUT) -T gba.ld -b rawbin1 hello_gba.o
	@python fix_gba_header.py $(OUT)

clean:
	rm -f $(OUT) *.o
