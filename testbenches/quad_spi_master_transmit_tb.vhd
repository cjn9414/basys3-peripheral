-- ----------------------------------------------------------------------------
-- File: quad_spi_master_transmit_tb.vhd
--
-- Entity: quad_spi_master_transmit_tb
-- Architecture: behavioral
-- Date Created: 10 August 2019
-- Date Modified: 10 August 2019
-- 
-- VHDL '93
-- Description: Testbench for QSPI protocol transmission. 
-- 				This testbench will just cover mode where CPOL = 1 and CPHA = 1 
--				(CLK idles HIGH, data captured on rising edge), as this
--				is currently the only mode that has been implemented.
-- ----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity quad_spi_master_transmit_tb is
end entity quad_spi_master_transmit_tb;

architecture oh_behav of quad_spi_master_transmit_tb is
        constant addr_bytes : integer := 3;
        constant data_bytes : integer := 1;
		constant dummy_cycles  : integer := 10;					-- cycles after command transaction before data is sent from device
		constant mode : std_logic_vector(1 downto 0) := "00";
		signal i_clk_tb     		: std_logic := '1';
		signal i_rst_tb				: std_logic := '1';													-- resets transaction
		signal i_command_tb		    : std_logic_vector(7 downto 0) := (others => '0');					-- command sent to device
		signal i_addr_tb			: std_logic_vector(8*addr_bytes-1 downto 0) := (others => '0');		-- address to send command to
		signal i_data_tb			: std_logic_vector(8*data_bytes-1 downto 0) := (others => '0');		-- data to send to device
		signal o_active_event_tb 	: std_logic := '0';													-- transaction in progress
		signal o_cs_tb 				: std_logic;
		signal o_dq_tb 				: std_logic_vector(3 downto 0);
		signal dq                   : std_logic_vector(3 downto 0);
		
	    signal transmission         : std_logic := '0';
		
		constant cs_active_pol : std_logic := '0';				-- polarity of chip select line
		
		constant clk_period : time := 50 ns;
		
		constant fast_read_command : std_logic_vector := x"EB";
		
		procedure send_message_3b_addr_1b_data_10b_dummy (
			i_command : in std_logic_vector(7 downto 0);
			i_addr    : in std_logic_vector(23 downto 0);
			i_data	  : in std_logic_vector(7 downto 0);
			signal o_nibble	  : out std_logic_vector(3 downto 0)
		) is
		begin
			o_nibble <= i_command(7 downto 4);
			wait for clk_period;
			assert o_dq_tb = i_command(7 downto 4) and o_active_event_tb = '1'
			report "command transmission error";
			o_nibble <= i_command(3 downto 0);			
			wait for clk_period;
			assert o_dq_tb = i_command(3 downto 0) and o_active_event_tb = '1'
			report "command transmission error";
			
			for byte in addr_bytes downto 1 loop
				o_nibble <= i_addr(8*byte-1 downto 8*byte-4);
				wait for clk_period;
				assert o_dq_tb = i_addr(8*byte-1 downto 8*byte-4) and o_active_event_tb = '1'
				report "address transmission error";
				o_nibble <= i_addr(8*byte-5 downto 8*(byte-1));				
				wait for clk_period;
				assert o_dq_tb = i_addr(8*byte-5 downto 8*(byte-1)) and o_active_event_tb = '1'
				report "address transmission error";
			end loop;
			
			for byte in data_bytes downto 1 loop
				o_nibble <= i_data(8*byte-1 downto 8*byte-4);
				wait for clk_period;
				assert o_dq_tb = i_data(8*byte-1 downto 8*byte-4) and o_active_event_tb = '1'
				report "data transmission error";
				o_nibble <= i_data(8*byte-5 downto 8*(byte-1));
				wait for clk_period;
				assert o_dq_tb = i_data(8*byte-5 downto 8*(byte-1)) and o_active_event_tb = '1'
				report "data transmission error";
			end loop;
			
			for byte in dummy_cycles downto 1 loop
				o_nibble <= (others => '0');
				wait for clk_period;
				assert o_dq_tb = (o_dq_tb'range => '0') and o_active_event_tb = '1'
				report "dummy wait error";
			end loop;
			
			wait for clk_period;
			assert o_dq_tb = (o_dq_tb'range => '0') and o_active_event_tb = '0'
			report "idle response error";
		end procedure send_message_3b_addr_1b_data_10b_dummy;
		
begin

    UUT : entity work.quad_spi_master_transmit
        generic map( cs_active_pol => '0', data_bytes => data_bytes,
                     addr_bytes => addr_bytes, dummy_cycles => dummy_cycles, mode => mode )
        port map(i_clk => i_clk_tb, i_rst => i_rst_tb, i_command => i_command_tb, 
                 i_addr => i_addr_tb, i_data => i_data_tb,
				 o_active_event => o_active_event_tb, o_dq => o_dq_tb);

	send_3_1_10_clk_proc : process is begin
	   if transmission = '1' then
	       wait for clk_period / 2;
	       i_clk_tb <= '0';
	       wait for clk_period / 2;
	       i_clk_tb <= '1';
	   else
	       wait for clk_period / 2;
	       i_clk_tb <= '1';
	   end if;
	end process send_3_1_10_clk_proc;

	test_proc : process is begin
       transmission <= '1';
	   send_message_3b_addr_1b_data_10b_dummy(fast_read_command, x"C3FFE0", x"81", o_dq_tb);
	   transmission <= '0';
	   wait for clk_period*4;
	   transmission <= '1';
	   send_message_3b_addr_1b_data_10b_dummy(fast_read_command, x"A5A5A5", x"FF", o_dq_tb);
	   transmission <= '0';
	   wait for clk_period*4;
	   i_rst_tb <= '1';
	   transmission <= '1';
	   send_message_3b_addr_1b_data_10b_dummy(fast_read_command, x"999999", x"DB", o_dq_tb);
	   transmission <= '0';
	   
	end process test_proc;
	
end architecture oh_behav;