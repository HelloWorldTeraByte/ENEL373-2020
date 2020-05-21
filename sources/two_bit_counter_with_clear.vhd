----------------------------------------------------------------------------------
-- Company: UC
-- Engineer: Randipa
-- 
-- Create Date: 11.05.2020 10:29:42
-- Design Name: 
-- Module Name: three_bit_counter_with_clear - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- this is needed for the adder
-- i.e., the "+"
 
-- external (to the FPGA) input and output connections
entity counter_2bit is
	port (
		Clock: in std_logic;
		CLR: in std_logic := '0';
		Q : out std_logic_vector(1 downto 0)
	);
end counter_2bit;
 
architecture behav of counter_2bit is 
	constant clk_limit : std_logic_vector(1 downto 0) := "11";
	signal tmp : std_logic_vector(1 downto 0) := "00"; -- internal to FPGA
	-- note, "in" or "out" 
	-- are invalid
	-- you can also define components here, and only here.
 
begin
	process (Clock, CLR) -- if either of these signals change,
	-- run this process
	begin
		if (CLR = '1') then -- this is an asynchronous clear
			tmp <= "00"; 
 
		elsif (Clock'EVENT and Clock = '1') then
			if tmp = clk_limit then
				tmp <= "00";
			else
				tmp <= tmp + 1; -- Counters uses flip-flops to
				-- "remember" the last count,
				-- which can then be added to.
			end if;
		end if; 
 
	end process;
 
	Q <= tmp; -- lastly, copy this internal vector to the output
 
end behav;