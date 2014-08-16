SRCDIR := ../src/
SRC    := $(shell find $(SRCDIR) -type f -name "*.vhd")
OUT    := $(patsubst  %.vhd,%.o,$(SRC))

all: $(OUT) test.o
	ghdl -e test

%.o : %.vhd
	ghdl -a $<

run: all
	ghdl -r test --vcd=waves.vcd --disp-time

clean:
	ghdl --clean 
	rm -f *.cf *.vcd
