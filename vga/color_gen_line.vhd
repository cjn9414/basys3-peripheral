-- ----------------------------------------------------------------------------
-- File: color_gen_line.vhd
--
-- Entity: color_gen_line
-- Architecture: behavioral
-- Date Created: 6 August 2019
-- Date Modified: 6 August 2019
-- 
-- VHDL '93
-- Description: Creates a basic VGA color output with a binary state
--				for each RGB component, based upon input signals.
-- ----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity color_gen_line is
	port (
		i_clk : in std_logic;
		i_rst : in std_logic;
		i_red : in std_logic;
		i_green : in std_logic;
		i_blue : in std_logic;
		o_red : out std_logic_vector(3 downto 0);
		o_green : out std_logic_vector(3 downto 0);
		o_blue	: out std_logic_vector(3 downto 0)
		);
end entity color_gen_line;

architecture oh_behav of color_gen_line is
	constant color_on : std_logic_vector(3 downto 0) := (others => '1');
	constant color_off : std_logic_vector(3 downto 0) := (others => '0');
begin
	clk_proc : process(i_clk, i_rst) is begin
		if i_rst = '1' then
			o_red <= color_off;
			o_green <= color_off;
			o_blue <= color_off;
		elsif rising_edge(i_clk) then
			if i_red = '1' then
				o_red <= color_on;
			else
				o_red <= color_off;
			end if;
			
			if i_green = '1' then
				o_green <= color_on;
			else
				o_green <= color_off;
			end if;
			
			if i_blue = '1' then
				o_blue <= color_on;
			else
				o_blue <= color_off;
			end if;
			
		end if;
	end process clk_proc;
end architecture oh_behav;