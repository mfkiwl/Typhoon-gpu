#**************************************************************
# Create Clock (where ‘Clk’ is the user-defined system clock name)
#**************************************************************

create_clock -name {Clk} -period 1ns [get_ports {Clk}] 
 
# Constrain the input I/O path
set_input_delay -clock {Clk} -max 3 [all_inputs]
set_input_delay -clock {Clk} -min 2 [all_inputs]

# Constrain the output I/O path
set_output_delay -clock {Clk} 2 [all_outputs] 