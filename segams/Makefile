


SRC = hello_sms.s
OBJS = $(SRC:.s=.o)

LNKFILE = linkfile.lnk
ROMFILE = hello_sms.sms

all: $(ROMFILE)


$(ROMFILE): $(OBJS) $(LNKFILE)
	wlalink -vr $(LNKFILE) $@

%.o: %.s
	wla-z80 -o $< $@


$(LNKFILE):
	@echo "[objects]" > $@
	@echo "$(OBJS)" >> $@


clean:
	@rm -f $(LNKFILE) $(OBJS) $(ROMFILE)
