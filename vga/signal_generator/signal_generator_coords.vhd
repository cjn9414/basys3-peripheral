-- ----------------------------------------------------------------------------
-- File: signal_generator_coords.vhd
--
-- Entity: signal_generator_coords
-- Architecture: behavioral
-- Date Created: 7 August 2019
-- Date Modified: 7 August 2019
-- 
-- VHDL '93
-- Description: Generates a basic VGA signal without any color components.
--				Pixel location provided as output.
-- ----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity signal_generator_coords is
	generic ( pol_x : std_logic := '0';
	          pol_y : std_logic := '1';
              h_visible_area_end : integer := 1440;
              h_front_porch_end  : integer := 1520;
              h_sync_pulse_end	: integer := 1672;
              h_back_porch_end   : integer := 1904;
              v_visible_area_end : integer := 900;
              v_front_porch_end  : integer := 901;
              v_sync_pulse_end	: integer := 904;
              v_back_porch_end   : integer := 932);
	port (
		i_clk		: in  std_logic;
		i_rst  		: in  std_logic;
		o_h_sync 	: out std_logic;
		o_v_sync 	: out std_logic;
		o_x			: out std_logic_vector(10 downto 0);
		o_y 		: out std_logic_vector(10 downto 0));
end entity signal_generator_coords;

architecture oh_behav of signal_generator_coords is
	signal int_h_counter		: std_logic_vector(10 downto 0) := (others => '0');
	signal next_h				: std_logic_vector(10 downto 0);
	signal next_v				: std_logic_vector(10 downto 0);
	signal int_v_counter		: std_logic_vector(10 downto 0) := (others => '0');
	constant int_one_vec		: std_logic_vector(10 downto 0) := x"00" & "001";
begin
	h_adder : entity work.adder_n
		generic map(WIDTH => 11)
		port map(A => int_h_counter, B => int_one_vec, Y => next_h);
	v_adder : entity work.adder_n
		generic map(WIDTH => 11)
		port map(A => int_v_counter, B => int_one_vec, Y => next_v);
	

	count_proc : process(i_clk, i_rst) is begin
		if i_rst = '1' then
			o_h_sync <= not pol_x;
			o_v_sync <= not pol_y;
		elsif rising_edge(i_clk) then
			if to_integer(unsigned(int_h_counter)) < h_front_porch_end OR to_integer(unsigned(int_h_counter)) >= h_sync_pulse_end then
				o_h_sync <= pol_x;
			else
				o_h_sync <= not pol_x;
			end if;

			if to_integer(unsigned(int_v_counter)) < v_front_porch_end OR to_integer(unsigned(int_v_counter)) >= v_sync_pulse_end then
				o_v_sync <= pol_y;
			else
				o_v_sync <= not pol_y;
			end if;

			if to_integer(unsigned(int_h_counter)) < h_back_porch_end then
				int_h_counter <= next_h;
			else
				int_h_counter <= (others => '0');
				if to_integer(unsigned(int_v_counter)) < v_back_porch_end then
					int_v_counter <= next_v;
				else
					int_v_counter <= (others => '0');
				end if;
			end if;
		end if;
	end process count_proc;
	o_x <= int_h_counter;
	o_y <= int_v_counter;
end architecture oh_behav;
