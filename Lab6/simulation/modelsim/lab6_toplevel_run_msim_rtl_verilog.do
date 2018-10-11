transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/finnn/Documents/385/385_FPGA/Lab6 {C:/Users/finnn/Documents/385/385_FPGA/Lab6/Synchronizers.sv}
vlog -sv -work work +incdir+C:/Users/finnn/Documents/385/385_FPGA/Lab6 {C:/Users/finnn/Documents/385/385_FPGA/Lab6/internal_register.sv}
vlog -sv -work work +incdir+C:/Users/finnn/Documents/385/385_FPGA/Lab6 {C:/Users/finnn/Documents/385/385_FPGA/Lab6/registerFile.sv}
vlog -sv -work work +incdir+C:/Users/finnn/Documents/385/385_FPGA/Lab6 {C:/Users/finnn/Documents/385/385_FPGA/Lab6/tristate.sv}
vlog -sv -work work +incdir+C:/Users/finnn/Documents/385/385_FPGA/Lab6 {C:/Users/finnn/Documents/385/385_FPGA/Lab6/test_memory.sv}
vlog -sv -work work +incdir+C:/Users/finnn/Documents/385/385_FPGA/Lab6 {C:/Users/finnn/Documents/385/385_FPGA/Lab6/SLC3_2.sv}
vlog -sv -work work +incdir+C:/Users/finnn/Documents/385/385_FPGA/Lab6 {C:/Users/finnn/Documents/385/385_FPGA/Lab6/Mem2IO.sv}
vlog -sv -work work +incdir+C:/Users/finnn/Documents/385/385_FPGA/Lab6 {C:/Users/finnn/Documents/385/385_FPGA/Lab6/ISDU.sv}
vlog -sv -work work +incdir+C:/Users/finnn/Documents/385/385_FPGA/Lab6 {C:/Users/finnn/Documents/385/385_FPGA/Lab6/HexDriver.sv}
vlog -sv -work work +incdir+C:/Users/finnn/Documents/385/385_FPGA/Lab6 {C:/Users/finnn/Documents/385/385_FPGA/Lab6/multiplexer.sv}
vlog -sv -work work +incdir+C:/Users/finnn/Documents/385/385_FPGA/Lab6 {C:/Users/finnn/Documents/385/385_FPGA/Lab6/alu.sv}
vlog -sv -work work +incdir+C:/Users/finnn/Documents/385/385_FPGA/Lab6 {C:/Users/finnn/Documents/385/385_FPGA/Lab6/memory_contents.sv}
vlog -sv -work work +incdir+C:/Users/finnn/Documents/385/385_FPGA/Lab6 {C:/Users/finnn/Documents/385/385_FPGA/Lab6/NZPlogic.sv}
vlog -sv -work work +incdir+C:/Users/finnn/Documents/385/385_FPGA/Lab6 {C:/Users/finnn/Documents/385/385_FPGA/Lab6/datapath.sv}
vlog -sv -work work +incdir+C:/Users/finnn/Documents/385/385_FPGA/Lab6 {C:/Users/finnn/Documents/385/385_FPGA/Lab6/slc3.sv}
vlog -sv -work work +incdir+C:/Users/finnn/Documents/385/385_FPGA/Lab6 {C:/Users/finnn/Documents/385/385_FPGA/Lab6/lab6_toplevel.sv}

vlog -sv -work work +incdir+C:/Users/finnn/Documents/385/385_FPGA/Lab6 {C:/Users/finnn/Documents/385/385_FPGA/Lab6/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 1000 ns