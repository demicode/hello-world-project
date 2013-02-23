
OUT = hello_amiga.exe

SRC = hello_amiga.s

AS = vasmm68k_mot
AS_FLAGS = -m68000 -Fhunkexe  -align

all:
	$(AS) $(AS_FLAGS) -o $(OUT) $(SRC)

clean:
	rm -f $(OUT)
