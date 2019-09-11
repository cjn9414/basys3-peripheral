-- --------------------------------------------------------------------------------
-- File: uart_test_tb.vhd
--
-- Entity: uart_test_tb
-- Architecture: behavioral
-- Author: Carter Nesbitt
-- Created : 8 September 2019
-- Modified : 8 September 2019
--
-- VHDL '93
-- Description : Simple testbench for uart hardware implementation.
-- --------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity uart_test_tb is
end entity uart_test_tb;

architecture oh_behav of uart_test_tb is
	signal clk : std_logic := '0';
	signal rst_n : std_logic := '0';
	
	signal uart_rx : std_logic := '0';
	
	signal uart_tx_par : std_logic_vector(7 downto 0) := (others => '0');
	signal uart_tx_en : std_logic := '0';
	
	signal char : std_logic_vector (7 downto 0) := (others => '0');
	
	signal uart_tx_ser : std_logic := '0';
	signal rx_busy : std_logic := '0';
	signal rx_error : std_logic := '0';
	signal tx_busy : std_logic := '0';
   
	constant clk_period : time := 271.27 ns;
	constant uart_clk_period : time := clk_period * 16 * 2;
	constant byte_send : std_logic_vector(7 downto 0) := "01000001";
	constant byte_recv : std_logic_vector(7 downto 0) := "01010101";
	
begin
	
	UUT : entity work.uart_dev
		port map( 
			i_clk => clk,
			i_rst_n => rst_n,
			i_rx => uart_rx,
			i_tx => uart_tx_par,
			i_tx_en => uart_tx_en,
			o_rx => char,
			o_tx => uart_tx_ser,
			o_rx_busy => rx_busy,
			o_rx_error => rx_error
			--o_tx_busy => tx_busy
			);
	
	clk_process : process is begin
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
		clk <= '0';
	end process clk_process;
	
	test_proc : process is begin
		rst_n <= '1';
		uart_tx_par <= "01000001";
		uart_tx_en <= '0';
		uart_rx <= '1';
	    wait for uart_clk_period;
	    
		uart_rx <= '0';   -- start bit
		wait for uart_clk_period;
		for i in byte_recv'range loop
			uart_rx <= byte_recv(i);
			wait for uart_clk_period;
		end loop;
		
		uart_rx <= '1';   -- parity bit
		wait for uart_clk_period;
		
		uart_rx <= '1';   -- stop bit
		wait for uart_clk_period;
		
		assert char = byte_recv and rx_error = '0'
		report "Data receive failure.";
		
		uart_tx_en <= '1';
		wait for uart_clk_period;
		uart_tx_en <= '0';
		for i in byte_send'range loop
			assert uart_tx_ser = byte_send(i)
			report "Serial data transmission failure.";
			wait for uart_clk_period;
		end loop;
		
		uart_tx_en <= '1';
		for i in byte_send'range loop
			assert uart_tx_ser = byte_send(i)
			report "Serial data transmission failure.";
			wait for uart_clk_period;
		end loop;
		uart_tx_en <= '0';

		wait;
	end process test_proc;
	
end architecture oh_behav;