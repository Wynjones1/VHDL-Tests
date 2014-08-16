PART        := xc3s500e-fg320
PROJECT     := tests.prj
CONSTRAINTS := constraints
BIN_DIR     := ./bin

all: compile synth write

compile:
	mkdir -p $(BIN_DIR)/tmp
	vhdl_compile.sh $(PROJECT) $(BIN_DIR)

synth:
	vhdl_synth.sh tests.prj src/constraints.ucf $(BIN_DIR)
write:
	cd ./bin/; djtgcfg prog -d Nexys2 -i 0 -f $(PROJECT).bit | tee -a ../log.txt 

clean:
	rm -Rf bin

run: all
