### INPUTS ###

# Clock
set_property PACKAGE_PIN W5 [get_ports {i_clk}]
	set_property IOSTANDARD LVCMOS33 [get_ports {i_clk}]
	create_clock -add -name sys_clk_pin -period 9.39231708 -waveform {0 4.69615854} [get_ports {i_clk}]

# Reset
set_property PACKAGE_PIN U17 [get_ports {i_rst}]
	set_property IOSTANDARD LVCMOS33 [get_ports {i_rst}]

	
# Input signals for line color assignment
set_property PACKAGE_PIN R2 [get_ports {i_color[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {i_color[1]}]
set_property PACKAGE_PIN T1 [get_ports {i_color[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {i_color[0]}]

	
# Input signal for write enable
set_property PACKAGE_PIN V1 [get_ports {i_wr_en}]
	set_property IOSTANDARD LVCMOS33 [get_ports {i_w_en}]
	
# Input signal for vertical line index
set_property PACKAGE_PIN T2 [get_ports {i_line[9]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {i_line[9]}]
set_property PACKAGE_PIN T3 [get_ports {i_line[8]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {i_line[8]}]
set_property PACKAGE_PIN V2 [get_ports {i_line[7]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {i_line[7]}]
set_property PACKAGE_PIN W13 [get_ports {i_line[6]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {i_line[6]}]
set_property PACKAGE_PIN W14 [get_ports {i_line[5]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {i_line[5]}]
set_property PACKAGE_PIN W15 [get_ports {i_line[4]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {i_line[4]}]
set_property PACKAGE_PIN W17 [get_ports {i_line[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {i_line[3]}]
set_property PACKAGE_PIN W16 [get_ports {i_line[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {i_line[2]}]
set_property PACKAGE_PIN V16 [get_ports {i_line[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {i_line[1]}]
set_property PACKAGE_PIN V17 [get_ports {i_line[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {i_line[0]}]
	
	
### OUTPUTS ###

# H-Sync
set_property PACKAGE_PIN P19 [get_ports {o_h_sync}]
	set_property IOSTANDARD LVCMOS33 [get_ports {o_h_sync}]
	
# V-Sync
set_property PACKAGE_PIN R19 [get_ports {o_v_sync}]
	set_property IOSTANDARD LVCMOS33 [get_ports {o_v_sync}]

# Red
set_property PACKAGE_PIN G19 [get_ports {o_red[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {o_red[0]}]
	
set_property PACKAGE_PIN H19 [get_ports {o_red[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {o_red[1]}]
	
set_property PACKAGE_PIN J19 [get_ports {o_red[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {o_red[2]}]
	
set_property PACKAGE_PIN N19 [get_ports {o_red[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {o_red[3]}]
	
# Green
set_property PACKAGE_PIN J17 [get_ports {o_green[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {o_green[0]}]
	
set_property PACKAGE_PIN H17 [get_ports {o_green[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {o_green[1]}]
	
set_property PACKAGE_PIN G17 [get_ports {o_green[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {o_green[2]}]
	
set_property PACKAGE_PIN D17 [get_ports {o_green[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {o_green[3]}]
	
# Blue
set_property PACKAGE_PIN N18 [get_ports {o_blue[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {o_blue[0]}]
	
set_property PACKAGE_PIN L18 [get_ports {o_blue[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {o_blue[1]}]
	
set_property PACKAGE_PIN K18 [get_ports {o_blue[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {o_blue[2]}]
	
set_property PACKAGE_PIN J18 [get_ports {o_blue[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {o_blue[3]}]
	
	
### OTHER

# Input signals for 32 MB NOR Flash Chip
set_property PACKAGE_PIN A14 [get_ports {n_cs}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {n_cs}]
set_property PACKAGE_PIN A16 [get_ports {mosi}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {mosi}]
set_property PACKAGE_PIN B15 [get_ports {miso}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {miso}]
set_property PACKAGE_PIN B16 [get_ports {sck}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sck}]
	
set_property PACKAGE_PIN A17 [get_ports {rst}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {rst}]
set_property PACKAGE_PIN C15 [get_ports {wr}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {wr}]
set_property PACKAGE_PIN C16 [get_ports {hold}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {hold}]