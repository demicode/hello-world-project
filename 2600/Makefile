DASM=/usr/local/bin/dasm

SRC = hellokernel.asm
EXEFILE = hello2600.bin

all: $(EXEFILE)

$(EXEFILE): $(SRC)
	$(DASM) $^ -o$(EXEFILE) -llist.txt -v3 -f3

clean:
	@rm -f $(EXEFILE) list.txt

test: $(EXEFILE)
	/Applications/Stella.app/Contents/MacOS/stella -tv pal $(EXEFILE)

debug: $(EXEFILE)
	/Applications/Stella.app/Contents/MacOS/Stella -tv pal $(EXEFILE)
