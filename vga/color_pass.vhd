-- ----------------------------------------------------------------------------
-- File: color_pass.vhd
--
-- Entity: color_pass
-- Architecture: behavioral
-- Date Created: 5 August 2019
-- Date Modified: 5 August 2019
-- 
-- VHDL '93
-- Description: Connection between basic VGA color HID.
-- ----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity color_pass is
	port (
		--i_clk : in std_logic;
		i_rst : in std_logic;
		i_red : in std_logic_vector(3 downto 0);
		i_green : in std_logic_vector(3 downto 0);
		i_blue : in std_logic_vector(3 downto 0);
		o_red : out std_logic_vector(3 downto 0);
		o_green : out std_logic_vector(3 downto 0);
		o_blue	: out std_logic_vector(3 downto 0)
		);
end entity color_pass;

architecture oh_behav of color_pass is
	--signal int_red : std_logic_vector(3 downto 0) := (others => '0');
	--signal int_green : std_logic_vector(3 downto 0) := (others => '0');
	--signal int_blue : std_logic_vector(3 downto 0) := (others => '0');
begin
	--clk_proc : process(i_clk, i_rst) is begin
	--	if i_rst = '1' then
	--		int_red <= (others => '0');
	--		int_green <= (others => '0');
	--		int_blue <= (others => '0');
	--	elsif rising_edge(i_clk) then
	--		int_red <= i_red;
	--		int_blue <= i_blue;
	--		int_green <= i_green;
	--	end if;
	--end process clk_proc;
	o_red <= i_red when i_rst = '0' else (others => '0');
	o_green <= i_green when i_rst = '0' else (others => '0');
	o_blue <= i_blue when i_rst = '0' else (others => '0');
end architecture oh_behav;