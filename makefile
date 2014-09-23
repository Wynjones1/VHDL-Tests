PART        := xc3s500e-fg320
PROJECT     := tests.prj
CONSTRAINTS := constraints
BIN_DIR     := ./bin
UCF_IN      := ./src/in.ucf
UCF_OUT     := ./out.ucf

all: constraints compile synth write

constraints: $(UCF_IN)
	cpp -P $(UCF_IN) $(UCF_OUT)

compile:
	mkdir -p $(BIN_DIR)/tmp
	vhdl_compile.sh $(PROJECT) $(BIN_DIR)

synth:
	vhdl_synth.sh tests.prj $(UCF_OUT) $(BIN_DIR)

write:
	vhdl_write.sh $(PROJECT)

rom: compile
	vhdl_synth.sh tests.prj $(UCF_OUT) $(BIN_DIR) --rom
	vhdl_write.sh $(PROJECT) $(BIN_DIR) --rom

clean:
	rm -Rf bin

run: all
