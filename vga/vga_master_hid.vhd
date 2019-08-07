-- ----------------------------------------------------------------------------
-- File: vga_master_hid.vhd
--
-- Entity: vga_master_hid
-- Architecture: structural
-- Date Created: 5 August 2019
-- Date Modified: 5 August 2019
-- 
-- VHDL '93
-- Description: Creates a VGA master output signal using a structural
--				combination of standard vga sync signals and a color output.
-- ----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_master_hid is
	port (  i_clk 		: in std_logic;
			i_rst 		: in std_logic;
			i_red : in std_logic_vector(3 downto 0);
			i_green : in std_logic_vector(3 downto 0);
			i_blue : in std_logic_vector(3 downto 0);
			o_h_sync 	: out std_logic;
			o_v_sync 	: out std_logic;
			o_red 		: out std_logic_vector(3 downto 0);
			o_green 	: out std_logic_vector(3 downto 0);
			o_blue		: out std_logic_vector(3 downto 0) );
end entity vga_master_hid;

architecture structural of vga_master_hid is
begin
	gen_signal : entity work.signal_generator
		generic map ( pol => '0')
		port map ( i_clk => i_clk, i_rst => i_rst, o_h_sync => o_h_sync, o_v_sync => o_v_sync );
	color_signal : entity work.color_pass
		port map ( i_rst => i_rst, i_red => i_red, i_green => i_green, i_blue => i_blue, 
				   o_red => o_red, o_green => o_green, o_blue => o_blue );
end architecture structural;