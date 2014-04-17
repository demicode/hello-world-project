
SRC = hello_msx.s
OBJS = $(SRC:.s=.o)

LNKFILE = linkfile.lnk
BINFILE = hello_msx.bin

all: $(BINFILE)


$(BINFILE): $(OBJS) $(LNKFILE)
	wlalink -vr $(LNKFILE) $@

%.o: %.s
	wla-z80 -o $< $@


$(LNKFILE):
	@echo "[objects]" > $@
	@echo "$(OBJS)" >> $@


clean:
	@rm -f $(LNKFILE) $(OBJS) $(BINFILE)
