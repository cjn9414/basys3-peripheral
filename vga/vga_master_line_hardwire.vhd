-- ----------------------------------------------------------------------------
-- File: vga_master_line_hardwire.vhd
--
-- Entity: vga_master_line_hardwire
-- Architecture: structural
-- Date Created: 6 August 2019
-- Date Modified: 6 August 2019
-- 
-- VHDL '93
-- Description: Creates a VGA master output signal that hardwires a single line
--				of the display to output high.
-- ----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_master_line_hardwire is
	port (  i_clk 		: in std_logic;
			i_rst 		: in std_logic;
			o_h_sync 	: out std_logic;
			o_v_sync 	: out std_logic;
			o_red 		: out std_logic_vector(3 downto 0);
			o_green 	: out std_logic_vector(3 downto 0);
			o_blue		: out std_logic_vector(3 downto 0) );
end entity vga_master_line_hardwire;

architecture structural of vga_master_line_hardwire is
	signal int_x : std_logic_vector(10 downto 0) := (others => '0');
	signal int_y : std_logic_vector(10 downto 0) := (others => '0');
	signal int_red, int_green, int_blue : std_logic := '0';
begin

	int_red <= int_y(5);
	int_green <= int_y(6);
	int_blue <= int_y(7);
--    int_red <= '1' when int_y = x"00" & "000" else '0';
--    int_green <= '1' when int_x = "00" & "000" else '0';
--    int_blue <= '1' when (to_integer(unsigned(int_x)) = 1439 and to_integer(unsigned(int_y)) = 899) else '0';

	gen_signal : entity work.signal_generator_coords
		generic map ( pol_x => '0', pol_y => '1')
		port map ( i_clk => i_clk, i_rst => i_rst, o_h_sync => o_h_sync, o_v_sync => o_v_sync, o_x => int_x, o_y => int_y );
	color_signal : entity work.color_gen_line
		port map ( i_clk => i_clk, i_rst => i_rst, i_red => int_red, i_green => int_green,  i_blue => int_blue,
				   o_red => o_red, o_green => o_green, o_blue => o_blue );
				
		
end architecture structural;