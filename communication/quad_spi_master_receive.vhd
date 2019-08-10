-- ----------------------------------------------------------------------------
-- File: quad_spi_master_receive.vhd
--
-- Entity: quad_spi_master_receive
-- Architecture: behavioral
-- Date Created: 9 August 2019
-- Date Modified: 9 August 2019
-- 
-- VHDL '93
-- Description: Master driver for QSPI protocol transmission. 
-- 				First iteration will just cover mode where CPOL = 1 and CPHA = 1 
--				(CLK idles HIGH, data captured on rising edge)
-- ----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity quad_spi_master_receive is
	generic ( cs_active_pol : std_logic := '0';					-- polarity of chip select line
			  data_rx_bytes : integer := 1;						-- number of bytes in response from peripheral
			  mode : std_logic_vector(1 downto 0));				-- *not currently integrated*
	port (
		i_clk     		: in std_logic;										-- quad spi clock
		i_rst			: in std_logic;										-- resets transaction
		i_dq			: in std_logic_vector(3 downto 0);					-- data input from peripheral
		i_en			: in std_logic;										-- enables receive part of transaction
		o_cs 			: out std_logic;									-- chip select pin
		o_data_out		: out std_logic_vector(8*data_rx_bytes-1 downto 0)	-- output data from device
	);
end quad_spi_master_receive;

architecture oh_behav of quad_spi_master_receive is
	signal r_nibble : std_logic_vector(1 downto 0) := (others => '0'); -- MSN or LSN in transaction
	
	signal r_peripheral_data : std_logic_vector(8*data_rx_bytes-1 downto 0);
	signal r_rem_data_bytes : integer := data_rx_bytes;
	constant byte_received : std_logic_vector(1 downto 0) := "10";
	
begin
	
	receive_proc : process(i_clk, i_rst, i_en) is begin
		if i_rst = '1' then
			o_data_out <= (others => '0');
			o_cs <= not cs_active_pol;
		elsif rising_edge(i_clk) then
			if i_en = '1' then
				if r_nibble(0) = '1' then
					r_peripheral_data(8*r_rem_data_bytes-5 downto 8*(r_rem_data_bytes - 1)) <= i_dq;
					r_nibble(1) <= '1';
				else
					r_peripheral_data(8*r_rem_data_bytes-1 downto 8*r_rem_data_bytes - 4) <= i_dq;
					r_nibble(1) <= '0';
				end if;
				r_nibble(0) <= not r_nibble(0);
			else
				o_data_out <= (others => '0');
				o_cs <= not cs_active_pol;
			end if;
		end if;
	end process receive_proc;
	
	bytes_rem_proc : process(i_clk, i_rst, i_en) is begin
		if i_rst = '1' then
			r_rem_data_bytes <= 0;
		elsif rising_edge(i_clk) and r_nibble = byte_received and i_en = '1' then
			r_rem_data_bytes <= r_rem_data_bytes - 1;
		end if;
	end process bytes_rem_proc;
	
	receive_terminate_proc : process(r_nibble, r_rem_data_bytes, i_en) is begin
		if r_rem_data_bytes = 0 then
			o_cs <= not cs_active_pol;
			o_data_out <= r_peripheral_data;
		elsif i_en = '1' then
			o_cs <= cs_active_pol;
			o_data_out <= (others => '0');
		else
			o_cs <= not cs_active_pol;
			o_data_out <= (others => '0');
		end if;
	end process receive_terminate_proc;
	
end architecture oh_behav;