
OUT = hello_st.prg

SRC = hello_st.s

AS = vasmm68k_mot
AS_FLAGS = -quiet -m68000 -devpac -Faout  -align -Ftos

all:
	$(AS) $(AS_FLAGS) -o $(OUT) $(SRC)

clean:
	rm -f $(OUT)
