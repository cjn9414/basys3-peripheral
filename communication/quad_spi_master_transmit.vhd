-- ----------------------------------------------------------------------------
-- File: quad_spi_master_transmit.vhd
--
-- Entity: quad_spi_master_transmit
-- Architecture: behavioral
-- Date Created: 7 August 2019
-- Date Modified: 10 August 2019
-- 
-- VHDL '93
-- Description: Master driver for QSPI protocol transmission. 
-- 				First iteration will just cover mode where CPOL = 1 and CPHA = 1 
--				(CLK idles HIGH, data captured on rising edge)
-- ----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity quad_spi_master_transmit is
	generic ( cs_active_pol : std_logic := '0';					-- polarity of chip select line
			  addr_bytes	: integer := 1; 					-- number of bytes for address
			  data_bytes 	: integer := 1;					    -- number of bytes for sending data
			  dummy_cycles  : integer := 10;					-- cycles after command transaction before data is sent from device
			  mode : std_logic_vector(1 downto 0));			-- *not currently integrated*
	port (
		i_clk     		: in std_logic;
		i_rst			: in std_logic;										-- resets transaction
		i_command 		: in std_logic_vector(7 downto 0);					-- command sent to device
		i_addr			: in std_logic_vector(8*addr_bytes-1 downto 0);		-- address to send command to
		i_data			: in std_logic_vector(8*data_bytes-1 downto 0);		-- data to send to device
		o_active_event 	: out std_logic;									-- transaction in progress
		o_dq 			: out std_logic_vector(3 downto 0)
	);
end quad_spi_master_transmit;

architecture oh_behav of quad_spi_master_transmit is
	signal r_nibble : std_logic := '0';  -- MSN or LSN in transaction
	type QSPI_STATE is (IDLE, COMMAND, ADDRESS, DATA, DUMMY);
	
	signal r_event_status : QSPI_STATE := IDLE;
	signal r_next_event : QSPI_STATE := IDLE;
	
	signal r_rem_addr_bytes : integer := 0;
	signal r_rem_data_bytes : integer := 0;
	signal r_rem_dummy_cycles : integer := 0;
	constant byte_sent : std_logic := '1';
	
begin
	transaction_proc : process(i_clk, i_rst) is begin
	    if i_rst = '1' then
			o_dq <= (others => '0');
			r_rem_addr_bytes <= addr_bytes;
			r_rem_data_bytes <= data_bytes;
			r_rem_dummy_cycles <= dummy_cycles;
		elsif rising_edge(i_clk) then
			case r_event_status is
				when COMMAND =>
					if r_nibble = '0' then
						o_dq <= i_command(7 downto 4);
					else
						o_dq <= i_command(3 downto 0);
					end if;

				when ADDRESS =>
					if r_nibble = byte_sent then
						r_rem_addr_bytes <= r_rem_addr_bytes - 1;
					else
						if r_nibble = '0' then
							o_dq <= i_addr(8*r_rem_addr_bytes-1 downto 8*r_rem_addr_bytes-4);
						else
							o_dq <= i_addr(8*r_rem_addr_bytes-5 downto 8*(r_rem_addr_bytes-1));
						end if;
					end if;
				when DATA =>
					if r_nibble = byte_sent then
						r_rem_data_bytes <= r_rem_data_bytes - 1;
					else
						if r_nibble = '0' then
							o_dq <= i_data(8*r_rem_data_bytes-1 downto 8*r_rem_data_bytes-4);
						else
							o_dq <= i_data(8*r_rem_data_bytes-5 downto 8*(r_rem_data_bytes-1));
						end if;
					end if;
				when DUMMY =>
					r_rem_dummy_cycles <= r_rem_dummy_cycles - 1;
					o_dq <= (others => '0');
				when others =>
					o_dq <= (others => '0');
					r_rem_addr_bytes <= addr_bytes;
					r_rem_data_bytes <= data_bytes;
					r_rem_dummy_cycles <= dummy_cycles;
			end case;
		end if;
	end process transaction_proc;
	
	next_state_proc : process(r_event_status, r_nibble, r_rem_addr_bytes,
									 r_rem_data_bytes, r_rem_dummy_cycles, r_rem_data_bytes) is begin
		case r_event_status is
			when COMMAND =>
				if r_nibble = byte_sent then
					if r_rem_addr_bytes = 0 then
						if r_rem_data_bytes = 0 then
							if r_rem_dummy_cycles = 0 then
								r_next_event <= IDLE;
							else
								r_next_event <= DUMMY;
							end if;
						else
							r_next_event <= DATA;
						end if;
					else
						r_next_event <= ADDRESS;
					end if;
				else
					r_next_event <= COMMAND;
				end if;
			when ADDRESS =>
				if r_nibble = byte_sent and r_rem_addr_bytes = 0 then
					if r_rem_data_bytes = 0 then
						if r_rem_dummy_cycles = 0 then
							r_next_event <= IDLE;
						else
							r_next_event <= DUMMY;
						end if;
					else
						r_next_event <= DATA;
					end if;
				else
					r_next_event <= ADDRESS;
				end if;
			when DATA =>
				if r_nibble = byte_sent and r_rem_data_bytes = 0 then
					if r_rem_dummy_cycles = 0 then
						r_next_event <= IDLE;
					else
						r_next_event <= DUMMY;
					end if;
				else
					r_next_event <= DATA;
				end if;
			when DUMMY =>
				if r_nibble = byte_sent then
					r_next_event <= IDLE;
				else
					r_next_event <= DUMMY;
				end if;
			when others =>
				if i_clk = '1' then
					r_next_event <= IDLE;
				else
					r_next_event <= COMMAND;
				end if;
		end case;
	end process next_state_proc;
	
	
	
	assign_event_proc : process(i_clk, i_rst) is begin
		if i_rst = '1' then
			r_event_status <= IDLE;
		elsif rising_edge(i_clk) then
			r_event_status <= r_next_event;
		end if;
	end process assign_event_proc;
	
	nibble_transmission_proc : process(i_clk, i_rst, r_event_status) is begin
		if i_rst = '1' or r_event_status'event then
			r_nibble <= '0';
		elsif r_nibble = byte_sent then
		    r_nibble <= '0';
		elsif rising_edge(i_clk) then
            r_nibble <= not r_nibble;
		end if;
	end process nibble_transmission_proc;
	
	o_active_event <= '0' when r_event_status = IDLE else '1';
	
end architecture oh_behav;