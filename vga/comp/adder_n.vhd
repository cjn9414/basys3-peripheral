-- --------------------------------------------------------------------------------
-- File: adder_n.vhd
--
-- Entity: adder_n
-- Architecture: Behavioral
-- Author: Carter Nesbitt
-- Created : 5 Feb 2019
-- Modified : 12 Feb 2019
--
-- VHDL '93
-- Description : Module that will add two n-bit values. The generic n is 28, since
--				 the program counter of the microprocessor is 28-bits wide.
-- --------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder_n is
    generic (n : integer := 28);
    Port ( A : in STD_LOGIC_VECTOR(n-1 downto 0);		-- IN
           B : in STD_LOGIC_VECTOR(n-1 downto 0);		-- IN
           Y : out STD_LOGIC_VECTOR(n-1 downto 0));		-- OUT
end adder_n;

architecture Behavioral of adder_n is
begin
    Y <= std_logic_vector(to_unsigned(to_integer(unsigned(A)) + to_integer(unsigned(B)), n));
end Behavioral;
