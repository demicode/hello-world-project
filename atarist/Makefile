
OUT = hellost.prg

SRC = hello_st.s
OBJS = $(SRC:.s=.o)

AS = vasmm68k_mot
AS_FLAGS = -quiet -m68000 -devpac -Faout  -align

LD = $(PREFIX)vlink
LD_FLAGS = -bataritos -s


all: $(OBJS)
	$(LD) $(LD_FLAGS) -o $(OUT) $(OBJS)

%.o: %.s
	$(AS) $(AS_FLAGS) -o $@ $<


clean:
	rm -r $(OUT) $(OBJS)
