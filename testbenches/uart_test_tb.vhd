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
   
	constant clk_period : time := 100 ns;
	constant byte_send : std_logic_vector := "01000001";
	constant byte_recv : std_logic_vector := "01010101";
	
begin
	
	UUT : entity work.mips_controller
		port map( 
			i_clk => clk,
			i_rst_n => rst_n,
			i_uart_rx => uart_rx,
			i_uart_tx => uart_tx_par,
			i_uart_tx_en => uart_tx_en,
			o_char => char,
			o_uart_tx => uart_tx_ser,
			o_rx_busy => rx_busy,
			o_rx_error => rx_error,
			o_tx_busy => tx_busy
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
		for i in byte_recv'length-1 downto 0 loop
			uart_rx <= byte_recv(i);
			wait for clk_period;
		end loop;
		
		assert char = byte_recv
		report "Data receive failure.";
		
		uart_tx_en <= '1';
		wait for clk_period;
		uart_tx_en <= '0';
		for i in byte_send'length-1 downto 0 loop
			assert uart_tx_ser = byte_send(i)
			report "Serial data transmission failure.";
			wait for clk_period;
		end loop;
		
		uart_tx_en <= '1';
		for i in byte_send'length-1 downto 0 loop
			assert uart_tx_ser = byte_send(i)
			report "Serial data transmission failure.";
			wait for clk_period;
		end loop;
		uart_tx_en <= '0';

		wait;
	end process test_proc;
	
end architecture oh_behav;