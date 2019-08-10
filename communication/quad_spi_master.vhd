-- ----------------------------------------------------------------------------
-- File: quad_spi_master.vhd
--
-- Entity: quad_spi_master
-- Architecture: stuctural
-- Date Created: 10 August 2019
-- Date Modified: 10 August 2019
-- 
-- VHDL '93
-- Description: Master driver for QSPI protocol. Structurally defined reception
--				and transmission entities for qspi transactions.
-- 				First iteration will just cover mode where CPOL = 1 and CPHA = 1 
--				(CLK idles HIGH, data captured on rising edge)
-- ----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity quad_spi_master is
	generic ( tx_data_bytes : integer := 1;									-- number of bytes to transmit
			  tx_addr_bytes : integer := 1;									-- number of bytes for address
			  tx_dummy_cycles : integer := 0;								-- number of cycles after transmission before reception
			  cs_active_pol : std_logic := '0';								-- cs line polarity
			  rx_data_bytes : integer := 1;  								-- number of bytes expected to receive
			  spi_mode : std_logic_vector(1 downto 0) := "00"				-- SPI mode (not implemented)
			);
	port (	i_clk : in std_logic;											-- QSPI input clock
			io_dq : inout std_logic_vector(3 downto 0);						-- half duplex DQ line
			o_cs  : out std_logic;											-- chip select output
		  
			i_rst : in std_logic;											-- resets QSPI transmission
			i_en  : in std_logic;											-- enables the start of a transmission (keep high for one cycle)
		  
			i_tx_data : in std_logic_vector(8*tx_data_bytes-1 downto 0);	-- data to transmit
			o_rx_data : out std_logic_vector(8*rx_data_bytes-1 downto 0);	-- received data
			
			i_tx_addr : in std_logic_vector(8*tx_addr_bytes-1 downto 0);	-- address to transmit data to
			i_tx_command : in std_logic_vector(7 downto 0)					-- command transmitted			
		  );
end entity quad_spi_master;

architecture structural of quad_spi_master is
	signal rx_en 				: std_logic := '0';
	signal r_tx_active 			: std_logic := '0';
	signal r_active_transaction : std_logic := '0';
	signal r_tx_data 			: std_logic_vector(8*tx_data_bytes-1 downto 0) := (others => '0');
	signal r_tx_addr 			: std_logic_vector(8*tx_addr_bytes-1 downto 0) := (others => '0');
	signal r_tx_command 		: std_logic_vector(7 downto 0) := (others => '0');
	signal r_tx_active_out 		: std_logic := '0';
	signal r_tx_dq_out 			: std_logic_vector(3 downto 0) := (others => '0');
	signal r_rx_dq_out 			: std_logic_vector(3 downto 0) := (others => '0');
	signal r_rx_cs              : std_logic := not cs_active_pol;
	signal r_clk				: std_logic := '1';
begin

	active_transaction_proc : process(i_clk, i_en, i_rst) is begin
		if i_rst = '1' then
			r_active_transaction <= '0';
			r_tx_data <= (others => '0');
			r_tx_addr <= (others => '0');
			r_tx_command <= (others => '0');
		elsif rising_edge(i_clk) then
			if i_en = '1' then
				r_active_transaction <= '1';
			elsif r_tx_active = '1' or r_rx_cs = cs_active_pol then
				r_active_transaction <= '1';
			else 
				r_active_transaction <= '0';
			end if;
			r_tx_data <= i_tx_data;
			r_tx_addr <= i_tx_addr;
			r_tx_command <= i_tx_command;
			r_tx_active <= '1';
		end if;
	end process active_transaction_proc;
	
	tx_active_proc : process(i_clk, i_en, i_rst) is begin
		if i_rst = '1' then
			r_tx_active <= '0';
		elsif rising_edge(i_clk) then
			if i_en = '1' then
				r_tx_active <= '1';
			else
				r_tx_active <= r_tx_active_out;
			end if;
		end if;
	end process tx_active_proc;

	tx_comp : entity work.quad_spi_master_transmit
		generic map(cs_active_pol => cs_active_pol, addr_bytes => tx_addr_bytes,
					data_bytes => tx_data_bytes, dummy_cycles => tx_dummy_cycles, mode => spi_mode)
		port map(i_clk => r_clk, i_rst => i_rst, i_command => r_tx_command, i_addr => r_tx_addr,
				 i_data => r_tx_data, o_active_event => r_tx_active_out, o_dq => r_tx_dq_out);
				 
	rx_comp : entity work.quad_spi_master_receive
		generic map(cs_active_pol => cs_active_pol, rx_data_bytes => rx_data_bytes, mode => spi_mode)
		port map(i_clk => r_clk, i_rst => i_rst, i_dq => io_dq, i_en => rx_en, o_cs => r_rx_cs, o_data_out => o_rx_data);
		
	io_dq <= r_tx_dq_out when r_tx_active = '1' else (others => 'Z');
	o_cs <= '1' when r_tx_active = '1' else r_rx_cs;
	r_clk <= '1' when r_active_transaction = '0' else i_clk;
	rx_en <= (not r_tx_active) and r_active_transaction;

end architecture structural;