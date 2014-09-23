SRCDIR := ../src/
SRC    := $(shell find $(SRCDIR) -type f -name "*.vhd")
OUT    := $(patsubst  %.vhd,%.o,$(SRC))

all: $(OUT) test.o
	ghdl -e test

%.o : %.vhd
	ghdl -a $<

run: all
	ghdl -r test --vcd=waves.vcd --stop-time=100ms

view:
	vcd2fst -v waves.vcd -f waves.fst
	gtkwave waves.fst

clean:
	ghdl --clean 
	rm -f *.cf *.vcd
