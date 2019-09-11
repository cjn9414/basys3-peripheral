-- --------------------------------------------------------------------------------
-- File: uart_dev.vhd
--
-- Entity: uart_dev
-- Architecture: structural
-- Author: Carter Nesbitt
-- Created : 8 September 2019
-- Modified : 8 September 2019
--
-- VHDL '93
-- Description : UART hardware realization for serial communication between
--				Basys-3 FGPA board and a PC via a COM port.
-- --------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_dev is
	generic (
		HOST_UART_CLK_RATIO	: integer := 2;	-- how many times faster is host clock compared to uart_dev clock
		BAUD_RATE : integer := 115200;
		OS_RATE	: integer := 16;
		DATA_WIDTH	: integer := 8;
		PARITY_EN	: std_logic := '1';
		EVEN_ODD_N	: std_logic := '0'
	);
	
	port (
		i_clk : in std_logic;
		i_rst_n : in std_logic; -- 
		
		i_rx : in std_logic; -- rx data line for input
		o_rx : out std_logic_vector(DATA_WIDTH-1 downto 0); -- rx data (serial -> parallel)
		
		i_tx : in std_logic_vector(DATA_WIDTH-1 downto 0); -- tx data to be sent as serial
		i_tx_en : in std_logic; -- set for a clock cycle to begin data transmission
		o_tx : out std_logic; -- tx line sent as output 
		
		o_rx_busy : out std_logic;	-- set until rx data sent as parallel output
		o_rx_error : out std_logic -- set for a clock period when parity checking fails
		
	);
end entity uart_dev;

architecture behavioral of uart_dev is
	type STATE_RX is (IDLE, START, RECEIVE, PARITY, STOP);
	type STATE_TX is (IDLE, START, TRANSMIT, PARITY, STOP);
	signal rx_state : STATE_RX := IDLE;
	signal rx_next_state : STATE_RX := IDLE;
	signal tx_state : STATE_TX := IDLE;
	signal tx_next_state : STATE_TX := IDLE;
	signal uart_clk : std_logic := '0';
	constant uart_clk_period : integer := OS_RATE*BAUD_RATE;

	signal os_count : integer := 0;
	signal rx_bit_count : integer := 0;
	signal r_rx : std_logic := '1';	-- keep previous rx signal registered
	signal r_rx_out : std_logic_vector(0 to 7) := (others => '0');
	signal r_parity : std_logic;
	
begin

	clock_div : entity work.clock_divider
		generic map (DIV => HOST_UART_CLK_RATIO)
		port map (i_clk => i_clk, o_clk => uart_clk);

	next_state_proc : process(uart_clk) is begin
		if rising_edge(uart_clk) then
			r_rx <= i_rx;
			case rx_state is
				when IDLE => 
				    o_rx_error <= '0';
				    r_parity <= '0';
					if r_rx = '1' and i_rx = '0' then
						rx_next_state <= START;
						o_rx_busy <= '1';
						os_count <= OS_RATE/2;
					else
						rx_next_state <= IDLE;
						o_rx_busy <= '0';
						os_count <= 0;
					end if;
				when START => 
					if os_count = OS_RATE-1 then
						os_count <= 0;
						if i_rx = '1' then -- should never happen
							o_rx_error <= '1';
							rx_next_state <= RECEIVE;
						else
							o_rx_error <= '0';
							rx_next_state <= RECEIVE;		
						end if;
					else
						os_count <= os_count + 1;
					end if;
				when RECEIVE =>
					if os_count = OS_RATE-1 then
						os_count <= 0;
						r_rx_out(rx_bit_count) <= i_rx;
						r_parity <= r_parity XOR i_rx;	-- compute parity
						if rx_bit_count = DATA_WIDTH-1 then
							rx_bit_count <= 0;
							if PARITY_EN = '1' then
								rx_next_state <= PARITY;
							else
								rx_next_state <= STOP;
							end if;
						else
							rx_bit_count <= rx_bit_count + 1;
						end if;			
					else
						os_count <= os_count + 1;
					end if;
				when PARITY =>
					if os_count = OS_RATE-1 then
						os_count <= 0;
						if EVEN_ODD_N = '0' then	-- odd parity
							if i_rx = r_parity then	-- error
								o_rx_error <= '1';
								rx_next_state <= STOP;
							else
								o_rx_error <= '0';
								rx_next_state <= STOP;
							end if;
						else							-- even parity
							if i_rx = not r_parity then	-- error
								o_rx_error <= '1';
								rx_next_state <= STOP;
							else
								o_rx_error <= '0';
								rx_next_state <= STOP;
							end if;
						end if;
					else
						os_count <= os_count + 1;
					end if;	
				when STOP =>
					if os_count = OS_RATE-1 then
						os_count <= 0;
						if i_rx = '0' then			-- should always be high
							rx_next_state <= IDLE;
							o_rx_error <= '1';
						else
							rx_next_state <= IDLE;
							o_rx_busy <= '0';
							o_rx_error <= '0';
						end if;
					else
						os_count <= os_count + 1;
					end if;	
			end case;
		end if;
	end process next_state_proc;

	state_proc : process(uart_clk) is begin
		rx_state <= rx_next_state;
		tx_state <= tx_next_state;
	end process state_proc;
	
	o_tx <= '0';
	o_rx <= (others => '0') when rx_state = RECEIVE else r_rx_out;
end architecture behavioral;