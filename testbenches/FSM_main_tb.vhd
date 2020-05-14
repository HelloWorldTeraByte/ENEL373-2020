----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.05.2020 11:56:58
-- Design Name: 
-- Module Name: FSM_main_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FSM_main_tb is
--  Port ( );
end FSM_main_tb;

architecture Behavioral of FSM_main_tb is
    component FSM_main
    Port ( clk : in std_logic;
            reset : in std_logic := '0';
            warning_edge: in std_logic;
            btn_edge : in std_logic;
            dec_points : out std_logic_vector(3 downto 0);
            counter_enable : out std_logic);
            end component;


    signal clk : std_logic := '0';
    signal warning_edge : std_logic := '0';
    signal reset, btn_edge : std_logic := '0';
    signal counter_enable : std_logic;
    signal dec_points : std_logic_vector(3 downto 0);
    
    constant clk_period : time := 500 us;
    constant clk_warning_period : time := 1000 ms;
begin
    uut: FSM_main port map(clk=>clk, warning_edge=>warning_edge,
                           reset=>reset, btn_edge=>btn_edge, dec_points=>dec_points,
                           counter_enable=>counter_enable);
    clk_process : process
    begin
         clk <= '0';
         wait for clk_period/2; -- for half a period, signal is '0'.
         clk <= '1';
         wait for clk_period/2; -- for next half a period, signal is '1'.
     end process;
     
    stimulus_process: process
    begin
        wait for 100 ns;

        reset <= '1';
        wait for clk_period;
        reset <= '0';
        wait for clk_period;

        btn_edge <= '0';
        --w3
        wait for clk_warning_period;
        warning_edge <= '1';
        wait for clk_period;
        warning_edge <= '0';
        --w2
        wait for clk_warning_period;
        warning_edge <= '1';
        wait for clk_period;
        warning_edge <= '0';
        --w1
        wait for clk_warning_period;
        warning_edge <= '1';
        wait for clk_period;
        warning_edge <= '0';

        --tr
        wait for clk_warning_period;
        btn_edge <= '1';
        wait for clk_period;
        btn_edge <= '0';

        --dpt
        wait for clk_warning_period*2;
        btn_edge <= '0';
        wait for clk_period;
        btn_edge <= '1';

        --w3
        wait for clk_warning_period;
        wait;
    end process;
end Behavioral;
