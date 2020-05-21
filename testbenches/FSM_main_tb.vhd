----------------------------------------------------------------------------------
-- Company: UC
-- Engineer: Randipa
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

--The FSM is normally connected to a edge detector which outputs a high pulse for rising edge
--Both the warning clock and button is connected through an edge detector 
architecture Behavioral of FSM_main_tb is
    component FSM_main
    Port (  clk : in std_logic;
            reset : in std_logic := '0';
            warning_edge: in std_logic;     
            btn_edge : in std_logic;                    
            dec_points : out std_logic_vector(3 downto 0);  --Decimal point output
            counter_reset : out std_logic;
            counter_enable : out std_logic);
            end component;


    signal clk : std_logic := '0';
    signal warning_edge : std_logic := '0';
    signal reset, btn_edge : std_logic := '0';
    signal counter_enable, counter_reset : std_logic;
    signal dec_points : std_logic_vector(3 downto 0);
    
    --The clock periods
    constant clk_period : time := 500 us;
    constant clk_warning_period : time := 1000 ms;
begin
    uut: FSM_main port map(clk=>clk, warning_edge=>warning_edge,
                           reset=>reset, btn_edge=>btn_edge, dec_points=>dec_points,
                           counter_reset=>counter_reset, counter_enable=>counter_enable);
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

        --Reset at the start up for one clock cycle
        reset <= '1';
        wait for clk_period;
        reset <= '0';
        wait for clk_period;
        
        --W3 state
        reset <= '0';
        btn_edge <= '0';
        warning_edge <= '0';
        assert dec_points = "1000" and counter_reset = '1' and counter_enable = '0';
        
        --Transition to W2
        --Emulate the warning edge detector with single high clock pulse
        wait for clk_warning_period;
        warning_edge <= '1';
        wait for clk_period;
        warning_edge <= '0';
        
        --W2
        reset <= '0';
        btn_edge <= '0';
        warning_edge <= '0';
        assert dec_points = "1100" and counter_reset = '1' and counter_enable = '0';

        --Transition to W1
        wait for clk_warning_period;
        warning_edge <= '1';
        wait for clk_period;
        warning_edge <= '0';

        --W1
        reset <= '0';
        btn_edge <= '0';
        warning_edge <= '0';
        assert dec_points = "1110" and counter_reset = '1' and counter_enable = '0';
        
        --Transition to TR
        wait for clk_warning_period;
        warning_edge <= '1';
        wait for clk_period;
        warning_edge <= '0';
    
        --TR
        reset <= '0';
        btn_edge <= '0';
        warning_edge <= '0';
        assert dec_points = "1111" and counter_reset = '0' and counter_enable = '1';
        
        --Transition to DPT
        --Emulate the button edge detector with single high clock pulse
        wait for clk_warning_period/2;
        btn_edge <= '1';
        wait for clk_period;
        btn_edge <= '0';

        --DPT
        reset <= '0';
        btn_edge <= '0';
        warning_edge <= '0';
        assert dec_points = "1111" and counter_reset = '0' and counter_enable = '0';
        
        --Transition to W3
        wait for clk_warning_period;
        btn_edge <= '0';
        wait for clk_period;
        btn_edge <= '1';
        wait for clk_period;
        btn_edge <= '0';

        --W3
        wait for clk_warning_period;
        reset <= '0';
        btn_edge <= '0';
        warning_edge <= '0';
        assert dec_points = "1000" and counter_reset = '1' and counter_enable = '0';
    
        report "Testbench passed succesfully!" severity note;
        wait;
       
    end process;
end Behavioral;
