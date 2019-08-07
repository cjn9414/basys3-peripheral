### INPUTS ###

# Clock
set_property PACKAGE_PIN W5 [get_ports {i_clk}]
	set_property IOSTANDARD LVCMOS33 [get_ports {i_clk}]
	create_clock -add -name sys_clk_pin -period 9.39231708 -waveform {0 4.69615854} [get_ports {i_clk}]

# Reset
set_property PACKAGE_PIN U17 [get_ports {i_rst}]
	set_property IOSTANDARD LVCMOS33 [get_ports {i_rst}]

### OUTPUTS ###

# H-Sync
set_property PACKAGE_PIN P19 [get_ports {o_h_sync}]
	set_property IOSTANDARD LVCMOS33 [get_ports {o_h_sync}]
	
# V-Sync
set_property PACKAGE_PIN R19 [get_ports {o_v_sync}]
	set_property IOSTANDARD LVCMOS33 [get_ports {o_v_sync}]

# Red
set_property PACKAGE_PIN G19 [get_ports {o_red[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {o_red[3]}]
	
set_property PACKAGE_PIN H19 [get_ports {o_red[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {o_red[2]}]
	
set_property PACKAGE_PIN J19 [get_ports {o_red[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {o_red[1]}]
	
set_property PACKAGE_PIN N19 [get_ports {o_red[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {o_red[0]}]
	
# Green
set_property PACKAGE_PIN J17 [get_ports {o_green[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {o_green[3]}]
	
set_property PACKAGE_PIN H17 [get_ports {o_green[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {o_green[2]}]
	
set_property PACKAGE_PIN G17 [get_ports {o_green[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {o_green[1]}]
	
set_property PACKAGE_PIN D17 [get_ports {o_green[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {o_green[0]}]
	
# Blue
set_property PACKAGE_PIN N18 [get_ports {o_blue[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {o_blue[3]}]
	
set_property PACKAGE_PIN L18 [get_ports {o_blue[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {o_blue[2]}]
	
set_property PACKAGE_PIN K18 [get_ports {o_blue[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {o_blue[1]}]
	
set_property PACKAGE_PIN J18 [get_ports {o_blue[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {o_blue[0]}]