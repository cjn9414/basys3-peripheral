-- ----------------------------------------------------------------------------
-- File: color_generator.vhd
--
-- Entity: color_generator
-- Architecture: behavioral
-- Date Created: 5 August 2019
-- Date Modified: 5 August 2019
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
	signal int_red : std_logic_vector(3 downto 0) := (others => '0');
	signal int_green : std_logic_vector(3 downto 0) := (others => '0');
	signal int_blue : std_logic_vector(3 downto 0) := (others => '0');
	signal next_red, next_green, next_blue : std_logic_vector(3 downto 0);
	constant adder_one : std_logic_vector(3 downto 0) := "0001";
begin
	int_red_adder : entity work.adder_n
		generic map ( N => 4 )
		port map ( A => int_red, B => adder_one, Y => next_red);
	int_green_adder : entity work.adder_n
		generic map ( N => 4 )
		port map ( A => int_green, B => adder_one, Y => next_green);
	int_blue_adder : entity work.adder_n
		generic map ( N => 4 )
		port map ( A => int_blue, B => adder_one, Y => next_blue);

	clk_proc : process(i_clk, i_rst) is begin
		if i_rst = '1' then
			int_red <= (others => '0');
			int_green <= (others => '0');
			int_blue <= (others => '0');
		elsif rising_edge(i_clk) then
			int_red <= next_red;
			int_blue <= next_blue;
			int_green <= next_green;
		end if;
	end process clk_proc;
	o_red <= int_red;
	o_green <= int_green;
	o_blue <= int_blue;
end architecture oh_behav;