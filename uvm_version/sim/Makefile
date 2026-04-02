TOOL = xrun

FILELIST = filelist.f
TOP_FILE = ../tb/top.sv

FLAGS = -f filelist.f -uvm -gui -access +rwc -coverage all -covoverwrite -sv -snapshot top
all: run

run:
	$(TOOL) $(FLAGS) $(TOP_FILE)

clean:
	rm -rf xcelium.d xmsim.log xrun.history xrun.log
	rm -rf waves.shm cov_work .simvision
	rm -rf INCA_libs
	rm -f dump.vcd *.err *.key
	@echo "Project cleaned and coverage data removed."
