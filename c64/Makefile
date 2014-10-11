
SRC = hello_c64.s
OBJS = $(SRC:.s=.o)

LNKFILE = linkfile.lnk
EXEFILE = runme.prg

all: $(EXEFILE)


$(EXEFILE): $(SRC)
	dasm $^ -o$(EXEFILE) -llist.txt -v3
#	wlalink -vr $(LNKFILE) $@

%.o: %.s
	wla-6502 -o $< $@ -v3

$(LNKFILE):
	@echo "[objects]" > $@
	@echo "$(OBJS)" >> $@


clean:
	@rm -f $(OBJS) $(EXEFILE)
