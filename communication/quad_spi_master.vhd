-- ----------------------------------------------------------------------------
-- File: quad_spi_master.vhd
--
-- Entity: quad_spi_master
-- Architecture: behavioral
-- Date Created: 7 August 2019
-- Date Modified: 7 August 2019
-- 
-- VHDL '93
-- Description: Master driver for QSPI protocol. First instance will just cover
--				mode where CPOL = 1 and CPHA = 1 
--				(CLK idles HIGH, data captured on rising edge)
-- ----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity quad_spi_master is
	generic ( cs_active_pol : std_logic := '0';					-- polarity of chip select line
			  addr_bytes	: unsigned := 1; 					-- number of bytes for address
			  tx_data_bytes	: unsigned := 1;					-- number of bytes for sending data
			  rx_data_bytes : unsigned := 1;					-- number of bytes for receiving data
			  dummy_cycles  : unsigned := 10;					-- cycles after command transaction before data is sent from device
			  mode : std_logic_vector(1 downto 0))				-- *not currently integrated*
	port (
		i_clk     		: in std_logic;
		i_rst			: in std_logic;										-- resets transaction
		i_wr			: in std_logic;										-- '1' -> write, '0' -> read
		i_command 		: in std_logic_vector(7 downto 0);					-- command sent to device
		i_addr			: in std_logic_vector(8*addr_bytes-1 downto 0);		-- address to send command to
		i_data  		: in std_logic_vector(8*tx_data_bytes-1 downto 0);	-- data sent to register
		o_rx_data 		: out std_logic_vector(8*rx_data_bytes-1 downto 0);	-- received data 
		o_active_event 	: out std_logic;									-- transaction in progress
	)
end quad_spi_master;

architecture oh_behav of quad_spi_master is
	signal r_cs : std_logic := not cs_active_pol;
	signal r_dq : std_logic_vector(3 downto 0) := (others => '0');
	signal r_nibble : std_logic_vector := "00"; -- MSN or LSN in transaction
	signal r_event : std_logic := '0';
	type QSPI_STATE is (IDLE, COMMAND, ADDRESS, DUMMY, DATA)
	signal r_event_status : QSPI_STATE := IDLE;
	
	signal r_rem_tx_data_bytes : unsigned := '0';
	signal r_rem_rx_data_bytes : unsigned := '0';
	signal r_rem_data_bytes : unsigned := '0';
	
begin
	transaction_proc : process(i_clk) is begin
		if i_rst = '1' then
			r_cs <= not cs_active_pol;
			r_dq <= (others => '0');
			r_nibble <= "00";
			r_event <= '0';
		elsif rising_edge(clk) then
			if r_event then
				r_nibble(0) <= not r_nibble(0);
				r_cs <= cs_active_pol;
			else
				r_nibble <= "00";
				r_cs <= not cs_active_pol;
			end if; 
			case r_event_status
				when COMMAND =>
					r_event <= '1';
					if r_nibble = "10"  then -- second nibble just received
						r_event_status <= ADDRESS;
						r_remaining_bytes <= addr_bytes;
					else
						if r_nibble(0) = '0' then
							r_dq <= i_command(7 downto 4);
						else
							r_dq <= i_command(3 downto 0);
						end if;
						r_nibble(1) <= '1';
						r_nibble(0) <= not r_nibble(0);
					end if;
				when ADDRESS =>
					r_event <= '1';
					-- if nibble = '1' then
					-- else
					-- end if;
				when DUMMY =>
					r_event <= '1';
				when DATA =>
					r_event <= '1';
					if r_nibble <= '1' then
						-- if r_rem_data_bytes = 0 then
							-- r_event <= '0';
							-- r_event_status <= IDLE;
						-- end if;
					end if;
				when others =>
					r_event <= '0';
			end case;
		else
			r_event_status <= COMMAND;
			r_event <= '1';
		end if;
	end process transaction_proc;
	o_active_event <= r_event;
end architecture oh_behav;