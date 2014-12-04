PART        := xc3s500e-fg320
PROJECT     := tests.prj
CONSTRAINTS := constraints
UCF_IN      := ./src/in.ucf
UCF_OUT     := ./out.ucf

all: synth

constraints: $(UCF_IN)
	cpp -P $(UCF_IN) $(UCF_OUT)

synth:
	./gen_fb.py
	./run.sh
