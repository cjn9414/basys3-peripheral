-- ----------------------------------------------------------------------------
-- File: vga_master_line_bitmap.vhd
--
-- Entity: vga_master_line_bitmap
-- Architecture: structural
-- Date Created: 6 August 2019
-- Date Modified: 6 August 2019
-- 
-- VHDL '93
-- Description: Creates a VGA master output signal using data stored in a 32 MB
--				NOR-Flash ROM chip. Stored data can be modified via switches on
--				board.
-- ----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_master_line_bitmap is
	port (  i_clk 		: in std_logic;
			i_rst 		: in std_logic;
			i_wr_en		: in std_logic;
			i_line	    : in std_logic_vector(9 downto 0);
			i_color		: in std_logic_vector(1 downto 0);
			o_h_sync 	: out std_logic;
			o_v_sync 	: out std_logic;
			o_red 		: out std_logic_vector(3 downto 0);
			o_green 	: out std_logic_vector(3 downto 0);
			o_blue		: out std_logic_vector(3 downto 0) );
end entity vga_master_line_bitmap;

architecture structural of vga_master_line_bitmap is
	type flash_chunk is array (0 to 225) of std_logic_vector(7 downto 0);
	signal flash_data : flash_chunk := ( others => ( others => '0' ) );
	signal flash_out : std_logic_vector(7 downto 0);
	signal color_data : std_logic_vector(1 downto 0);
	signal int_red, int_green, int_blue : std_logic;
begin
	gen_signal : entity work.signal_generator
		generic map ( pol => '0')
		port map ( i_clk => i_clk, i_rst => i_rst, o_h_sync => o_h_sync, o_v_sync => o_v_sync );
	color_signal : entity work.color_gen_line
		port map ( i_clk => i_clk, i_rst => i_rst, i_red => int_red, i_green => int_green,  i_blue => int_blue,
				   o_red => o_red, o_green => o_green, o_blue => o_blue );
	bitmap_signal : entity work.line_fetch
		port map( i_clk => i_clk, i_rst => i_rst, i_wr_en => i_wr_en, i_line => i_line, i_color => i_color, o_data => flash_out);
		
	color_from_byte : process(i_line, i_color) is begin
		case i_line(1 downto 0) is
			when "00" => color_data <= flash_out(1 downto 0);
			when "01" => color_data <= flash_out(3 downto 2);
			when "10" => color_data <= flash_out(5 downto 4);
			when others => color_data <= flash_out(7 downto 6);
		end case;
	end process color_from_byte;

	color_decode : process(color_data) is begin		
		case color data is
			when "00" =>
				int_red <= '0';
				int_green <= '0';
				int_blue <= '0';
			when "01" =>
				int_red <= '1';
				int_green <= '0';
				int_blue <= '0';
			when "10" =>
				int_red <= '0';
				int_green <= '1';
				int_blue <= '0';
			when others =>
				int_red <= '0';
				int_green <= '0';
				int_blue <= '1';
		end case;
	end process color_decode;
				
		
end architecture structural;