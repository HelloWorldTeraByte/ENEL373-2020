----------------------------------------------------------------------------------
-- Company: UC
-- Engineer: Jeremy, Randipa, Geeth
-- 
-- Create Date: 11.05.2020 11:03:04
-- Design Name: 
-- Module Name: quad_4_bit_counter - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity quad_4_bit_counter is
    Port (  EN : in STD_LOGIC := '1'; --Active high synchronous enable
            R_SET : in STD_LOGIC := '0'; --Active high asynchronous reset
            --Each intermediate stages outputs, for each 4 bit counter
            stage_1_q_out : out STD_LOGIC_VECTOR (3 downto 0);
            stage_2_q_out : out STD_LOGIC_VECTOR (3 downto 0);
            stage_3_q_out : out STD_LOGIC_VECTOR (3 downto 0);
            stage_4_q_out : out STD_LOGIC_VECTOR (3 downto 0);
            clk_in_ctr : in STD_LOGIC;  --Main clock input
            overflow : out STD_LOGIC);  --Overflow is high for one LSB once it reaches 9999
end quad_4_bit_counter;

architecture Behavioral of quad_4_bit_counter is

--The quad counter is made of 4 4 bit counters
component counter_4bit
	port (
		Clock : in std_logic;
	    EN : in std_logic := '1'; --Active high synchronous enable
		CLR : in std_logic := '0'; -- Active high asynchronous reset
		clk_out : out std_logic := '0'; --Clock out is used to feed in to the next stage of the counter
		Q : out std_logic_vector(3 downto 0)); --Current output of the counter
end component;

signal cnt0_1, cnt1_2, cnt2_3 : std_logic;

begin
    --The counters are cascaded in series
    --The fist counter is fed the main clock
    cnt0: counter_4bit port map(EN=>EN, Clock=>clk_in_ctr,
    CLR=>R_SET, clk_out=>cnt0_1,
    Q=>stage_1_q_out);
    
    --The clock for the second stage is the clock out of the first stage
    --The clock out goes high once it counts to 2^4 then goes low
    --The clock remain high in the max countable number state
    cnt1: counter_4bit port map(EN=>EN, Clock=>cnt0_1,
    CLR=>R_SET, clk_out=>cnt1_2,
    Q=>stage_2_q_out);
    
    cnt2: counter_4bit port map(EN=>EN, Clock=>cnt1_2,
    CLR=>R_SET, clk_out=>cnt2_3,
    Q=>stage_3_q_out);
    
    --clock out of the last stage is used as the overflow output
    cnt3: counter_4bit port map(EN=>EN, Clock=>cnt2_3,
    CLR=>R_SET, clk_out=>overflow,
    Q=>stage_4_q_out);

end Behavioral;