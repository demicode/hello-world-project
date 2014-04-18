
BIN=hello-atari8.xex

all: $(BIN)

$(BIN): hello-atari8.asm
	mads -o:$(BIN) hello-atari8.asm

clean:
	@rm -f $(BIN)

.PHONY: all clean
