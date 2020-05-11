----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
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

entity quad_4_bit_counter is
    port ( EN : in STD_LOGIC := '1';
          R_SET : in STD_LOGIC := '0';
          stage_1_q_out : out STD_LOGIC_VECTOR (3 downto 0);
          stage_2_q_out : out STD_LOGIC_VECTOR (3 downto 0);
          stage_3_q_out : out STD_LOGIC_VECTOR (3 downto 0);
          stage_4_q_out : out STD_LOGIC_VECTOR (3 downto 0);
          clk_in_ctr : in STD_LOGIC;
          overflow : out STD_LOGIC);
end quad_4_bit_counter;

architecture Behavioral of quad_4_bit_counter is

signal cnt0_1, cnt1_2, cnt2_3, cnt3_4: std_logic;

component counter_4bit
	port (
		Clock : in std_logic;
		CLR : in std_logic := '0';
		clk_out : out std_logic;
		Q : out std_logic_vector(3 downto 0));
end component;

begin
    cnt0: counter_4bit port map(Clock=>clk_in_ctr,
    CLR=>open, clk_out=>cnt0_1,
    Q=>stage_1_q_out);
    
    cnt1: counter_4bit port map(Clock=>cnt0_1,
    CLR=>open, clk_out=>cnt1_2,
    Q=>stage_2_q_out);
    
    cnt2: counter_4bit port map(Clock=>cnt1_2,
    CLR=>open, clk_out=>cnt2_3,
    Q=>stage_3_q_out);
    
    cnt3: counter_4bit port map(Clock=>cnt2_3,
    CLR=>open, clk_out=>cnt3_4,
    Q=>stage_4_q_out);

end Behavioral;
