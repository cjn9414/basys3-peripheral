-- ----------------------------------------------------------------------------
-- File: signal_generator.vhd
--
-- Entity: signal_generator
-- Architecture: behavioral
-- Date Created: 3 August 2019
-- Date Modified: 3 August 2019
-- 
-- VHDL '93
-- Description: Creates a basic VGA signal output without inclusion of the color
-- 						  components, as they will be more customizable and should be
--						  placed in a separate file.
-- ----------------------------------------------------------------------------

entity signal_generator is
	o_h_sync : out std_logic;
	o_v_sync : out std_logic;
end entity signal_generator;

architecture oh_behav of signal_generator is
	
begin

end architecture oh_behav;
