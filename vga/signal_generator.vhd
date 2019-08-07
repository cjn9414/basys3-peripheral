-- ----------------------------------------------------------------------------
-- File: signal_generator.vhd
--
-- Entity: signal_generator
-- Architecture: behavioral
-- Date Created: 3 August 2019
-- Date Modified: 5 August 2019
-- 
-- VHDL '93
-- Description: Creates a basic VGA signal output without inclusion of the color
-- 						  components, as they will be more customizable and should be
--						  placed in a separate file. Base Monitor Specs: 1440x900 @ 60Hz
--							Clock Speed: 106.47 MHz
-- ----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity signal_generator is
	generic ( pol : std_logic := '0');
	port (
		i_clk		: in  std_logic;
		i_rst  		: in  std_logic;
		o_h_sync 	: out std_logic;
		o_v_sync 	: out std_logic );
end entity signal_generator;

architecture oh_behav of signal_generator is
	constant h_visible_area_end : integer := 1440;
	constant h_front_porch_end  : integer := 1520;
	constant h_sync_pulse_end	  : integer := 1672;
	constant h_back_porch_end   : integer := 1904;
	constant v_visible_area_end : integer := 900;
	constant v_front_porch_end  : integer := 901;
	constant v_sync_pulse_end	  : integer := 904;
	constant v_back_porch_end   : integer := 932;
	signal int_h_counter				: std_logic_vector(10 downto 0) := (others => '0');
	signal next_h								: std_logic_vector(10 downto 0);
	signal next_v								: std_logic_vector(10 downto 0);
	signal int_v_counter				: std_logic_vector(10 downto 0) := (others => '0');
	constant int_one_vec					: std_logic_vector(10 downto 0) := x"00" & "001";
	type VGA_STATE is (VISIBLE, FRONT_PORCH, SYNC_PULSE, BACK_PORCH);
	signal signal_state_h : VGA_STATE;
	signal signal_state_v : VGA_STATE;
begin
	h_adder : entity work.adder_n
		generic map(N => 11)
		port map(A => int_h_counter, B => int_one_vec, Y => next_h);
	v_adder : entity work.adder_n
		generic map(N => 11)
		port map(A => int_v_counter, B => int_one_vec, Y => next_v);
	

	count_proc : process(i_clk, i_rst) is begin
		if i_rst = '1' then
			o_h_sync <= not pol;
			o_v_sync <= not pol;
		elsif rising_edge(i_clk) then
			if to_integer(unsigned(int_h_counter)) < h_visible_area_end OR to_integer(unsigned(int_h_counter)) > h_sync_pulse_end then
				o_h_sync <= pol;
			else
				o_h_sync <= not pol;
			end if;

			if to_integer(unsigned(int_v_counter)) < v_visible_area_end OR to_integer(unsigned(int_v_counter)) > v_sync_pulse_end then
				o_v_sync <= pol;
			else
				o_v_sync <= not pol;
			end if;

			if to_integer(unsigned(int_h_counter)) <= h_back_porch_end then
				int_h_counter <= next_h;
			else
				int_h_counter <= (others => '0');
				if to_integer(unsigned(int_v_counter)) <= v_back_porch_end then
					int_v_counter <= next_v;
				else
					int_v_counter <= (others => '0');
				end if;
			end if;
		end if;
	end process count_proc;
end architecture oh_behav;
