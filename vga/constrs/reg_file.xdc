### INPUTS ###

# Clock
set_property PACKAGE_PIN W5 [get_ports {CLK100MHZ}]
	set_property IOSTANDARD LVCMOS33 [get_ports {CLK100MHZ}]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {CLK100MHZ}]

# Reset
set_property PACKAGE_PIN U17 [get_ports {rst}]
	set_property IOSTANDARD LVCMOS33 [get_ports {rst}]

# Input signals for Register File
set_property PACKAGE_PIN V17 [get_ports {input[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {input[0]}]
set_property PACKAGE_PIN V16 [get_ports {input[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {input[1]}]
set_property PACKAGE_PIN W16 [get_ports {input[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {input[2]}]
set_property PACKAGE_PIN W17 [get_ports {input[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {input[3]}]
set_property PACKAGE_PIN W15 [get_ports {input[4]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {input[4]}]
set_property PACKAGE_PIN V15 [get_ports {input[5]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {input[5]}]
set_property PACKAGE_PIN W14 [get_ports {input[6]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {input[6]}]
set_property PACKAGE_PIN W13 [get_ports {input[7]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {input[7]}]

# Write signals for Register File
set_property PACKAGE_PIN T3 [get_ports {wr[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {wr[0]}]
set_property PACKAGE_PIN T2 [get_ports {wr[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {wr[1]}]
set_property PACKAGE_PIN R3 [get_ports {wr[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {wr[2]}]

# Write enable
set_property PACKAGE_PIN T18 [get_ports {we}]
	set_property IOSTANDARD LVCMOS33 [get_ports {we}]

# Read signals for Register File
set_property PACKAGE_PIN U1 [get_ports {rd1[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {rd1[0]}]
set_property PACKAGE_PIN T1 [get_ports {rd1[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {rd1[1]}]
set_property PACKAGE_PIN R2 [get_ports {rd1[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {rd1[2]}]

### OUTPUTS ###

# Out1
set_property PACKAGE_PIN U16 [get_ports {out1[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {out1[0]}]
set_property PACKAGE_PIN E19 [get_ports {out1[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {out1[1]}]
set_property PACKAGE_PIN U19 [get_ports {out1[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {out1[2]}]
set_property PACKAGE_PIN V19 [get_ports {out1[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {out1[3]}]
set_property PACKAGE_PIN W18 [get_ports {out1[4]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {out1[4]}]
set_property PACKAGE_PIN U15 [get_ports {out1[5]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {out1[5]}]
set_property PACKAGE_PIN U14 [get_ports {out1[6]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {out1[6]}]
set_property PACKAGE_PIN V14 [get_ports {out1[7]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {out1[7]}]


### UNUSED ###

# rd2
set_property PACKAGE_PIN J1 [get_ports {rd2[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {rd2[0]}]
set_property PACKAGE_PIN L1 [get_ports {rd2[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {rd2[1]}]
set_property PACKAGE_PIN J2 [get_ports {rd2[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {rd2[2]}]

# out2
set_property PACKAGE_PIN G2 [get_ports {out2[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {out2[0]}]
set_property PACKAGE_PIN H1 [get_ports {out2[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {out2[1]}]
set_property PACKAGE_PIN K2 [get_ports {out2[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {out2[2]}]
set_property PACKAGE_PIN H2 [get_ports {out2[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {out2[3]}]
set_property PACKAGE_PIN G3 [get_ports {out2[4]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {out2[4]}]
set_property PACKAGE_PIN A14 [get_ports {out2[5]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {out2[5]}]
set_property PACKAGE_PIN A16 [get_ports {out2[6]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {out2[6]}]
set_property PACKAGE_PIN B15 [get_ports {out2[7]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {out2[7]}]

## Configuration options, can be used for all designs
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
