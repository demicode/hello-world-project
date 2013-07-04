

SRC = hello_gb.s
OBJS = $(SRC:.s=.o)

LNKFILE = linkfile.lnk
ROMFILE = hello_gb.gb

all: $(ROMFILE)


$(ROMFILE): $(OBJS) $(LNKFILE)
	wlalink -vr $(LNKFILE) $@

%.o: %.s
	wla-gb -o $< $@


$(LNKFILE):
	@echo "[objects]" > $@
	@echo "$(OBJS)" >> $@


clean:
	@rm -f $(LNKFILE) $(OBJS) $(ROMFILE)
