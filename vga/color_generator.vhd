-- ----------------------------------------------------------------------------
-- File: color_generator.vhd
--
-- Entity: color_generator
-- Architecture: behavioral
-- Date Created: 5 August 2019
-- Date Modified: 6 August 2019
-- 
-- VHDL '93
-- Description: Creates a basic VGA color output.
-- ----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity color_generator is
	port (
		i_clk : in std_logic;
		i_rst : in std_logic;
		o_red : out std_logic_vector(3 downto 0);
		o_green : out std_logic_vector(3 downto 0);
		o_blue	: out std_logic_vector(3 downto 0)
		);
end entity color_generator;

architecture oh_behav of color_generator is
	signal int_add_in : std_logic_vector(11 downto 0) := (others => '0');
	signal int_add_out : std_logic_vector(11 downto 0);
	constant adder_one : std_logic_vector(11 downto 0) := x"001";
begin
	int_color_adder : entity work.adder_n
		generic map ( N => 12 )
		port map(A => int_add_in, B => adder_one, Y => int_add_out);
		
	clk_proc : process(i_clk, i_rst) is begin
		if i_rst = '1' then
		    int_add_in <= (others => '0');
		elsif rising_edge(i_clk) then
		    int_add_in <= int_add_out;
		end if;
	end process clk_proc;
	o_red <= int_add_out(11 downto 8);
	o_green <= int_add_out(7 downto 4);
	o_blue <= int_add_out(3 downto 0);
end architecture oh_behav;