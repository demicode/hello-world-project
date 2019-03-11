SRC = hello_c64.s

DASM=/usr/local/bin/dasm

EXEFILE = runme.prg

all: $(EXEFILE)

$(EXEFILE): $(SRC)
	$(DASM) $^ -o$(EXEFILE) -llist.txt -v3 -E2

clean:
	@rm -f $(EXEFILE)

test: $(EXEFILE)
	/Applications/vice/x64.app/Contents/MacOS/x64 $(EXEFILE)

debug: $(EXEFILE)
	/Applications/vice/x64.app/Contents/MacOS/x64 -moncommands commands.txt $(EXEFILE)
