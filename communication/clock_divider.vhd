-- --------------------------------------------------------------------------------
-- File: clock_divider.vhd
--
-- Entity: clock_divider
-- Architecture: behavioral
-- Author: Carter Nesbitt
-- Created : 9 September 2019
-- Modified : 9 September 2019
--
-- VHDL '93
-- Description : Implements a clock divider to generate lower frequency clock
--				 signal based upon a host clock.
-- --------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clock_divider is
	generic ( DIV : integer := 2 );
	port (
		i_clk : in std_logic;
		o_clk : out std_logic
	);
end entity clock_divider;

architecture oh_behav of clock_divider is
	signal r_count : integer range 0 to DIV-1 := 0;
begin
	process ( i_clk ) is begin
		if rising_edge ( i_clk ) then
			if r_count = 0 then
				r_count <= DIV - 1;
			else
				r_count <= r_count - 1;
			end if;
		end if;
	end process;
	o_clk <= '1' when r_count < DIV/2 else '0';
end architecture oh_behav;