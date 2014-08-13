PART    := xc3s500e-fg320
PROGRAM := decoder
BIN_DIR := ./bin
USE_NEW_PARSER := no
XST_CMD := "run -tmpdir ./bin/tmp -ifn ../$(PROGRAM).prj -ifmt VHDL -ofn $(PROGRAM) -p $(PART) -opt_mode Speed -opt_level 1"

all: compile synth write

compile:
	mkdir -p $(BIN_DIR)/tmp
	cd ./bin/; echo $(XST_CMD)  | xst  | tee ../log.txt 
synth:
	cd ./bin/; ngdbuild -p $(PART) -uc ../src/$(PROGRAM).ucf $(PROGRAM).ngc | tee -a ../log.txt 
	cd ./bin/; map -detail -pr b $(PROGRAM).ngd | tee -a ../log.txt 
	cd ./bin/; par -w $(PROGRAM).ncd parout.ncd $(PROGRAM).pcf | tee -a ../log.txt 
	cd ./bin/; bitgen -w -g StartUpClk:JtagClk -g CRC:Enable parout.ncd $(PROGRAM).bit $(PROGRAM).pcf | tee -a ../log.txt 
write:
	cd ./bin/; djtgcfg prog -d Nexys2 -i 0 -f ./decoder.bit | tee -a ../log.txt 

clean:
	rm decoder_xst.xrpt decoder.bld decoder.ngc decoder_ngdbuild.xrpt -Rf xlnx_auto_0_xdb/ _xmsgs/ xst/
	rm -Rf bin
