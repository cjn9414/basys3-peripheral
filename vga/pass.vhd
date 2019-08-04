-- ----------------------------------------------------------------------------
-- File: vhd_pass.vhd
--
-- Entity: vhd_pass
-- Architecture: behavioral
-- Author: Carter Nesbitt
-- Date Created: 3 August 2019
-- Date Modified: 3 August 2019
--
-- VHDL '93
-- Description: Takes a VGA signal as input and directly feeds it to an output.
--							No pixel maniulation is performed; simply a test to assert
--							inputs and outputs operate as expected.
-- ----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vhd_pass is
	i_h_sync: in std_logic;
	i_v_sync: in std_logic;
	i_red: in std_logic;
	i_green: in std_logic;
	i_blue: in std_logic;
	o_h_sync: out std_logic;
	o_v_sync: out std_logic;
	o_red: out std_logic;
	o_green: out std_logic;
	o_blue: out std_logic;
end entity vhd_pass;

architecture oh_behav of vhd_pass is
begin
	o_h_sync <= i_h_sync;
	o_v_sync <= i_vsync;
	o_red <= i_red;
	o_green <= i_green;
	o_blue <= i_blue;
end architecture oh_behav;


