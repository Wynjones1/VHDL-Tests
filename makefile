PART    := xc3s500e-fg320
PROGRAM := decoder
BIN_DIR := ./bin
USE_NEW_PARSER := no
XST_CMD := "run -tmpdir ./bin/tmp -ifn ../$(PROGRAM).prj -ifmt VHDL -ofn $(PROGRAM) -p $(PART) -opt_mode Speed -opt_level 1"
all:
	mkdir -p $(BIN_DIR)/tmp
	cd ./bin/; echo $(XST_CMD)  | xst  | tee xst.log
	cd ./bin/; ngdbuild -p $(PART) -uc ../src/$(PROGRAM).ucf $(PROGRAM).ngc
	cd ./bin/; map -detail -pr b $(PROGRAM).ngd
	cd ./bin/; par -w $(PROGRAM).ncd parout.ncd $(PROGRAM).pcf
	cd ./bin/; bitgen -w -g StartUpClk:JtagClk -g CRC:Enable parout.ncd $(PROGRAM).bit $(PROGRAM).pcf
	cd ./bin/; djtgcfg prog -d Nexys2 -i 0 -f ./decoder.bit

clean:
	rm decoder_xst.xrpt decoder.bld decoder.ngc decoder_ngdbuild.xrpt -Rf xlnx_auto_0_xdb/ _xmsgs/ xst/
	rm -Rf bin
