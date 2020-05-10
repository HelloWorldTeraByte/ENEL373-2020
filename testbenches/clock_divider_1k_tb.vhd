----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.03.2020 11:36:27
-- Design Name: 
-- Module Name: clock_divider_1k_tb - Behavioral
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

entity clock_divider_1k_tb is
--  Port ( );
end clock_divider_1k_tb;

architecture Behavioral of clock_divider_1k_tb is

    component my_divider_1k
        Port (  
            Clk_in : in STD_LOGIC := '0';
            Clk_out: out STD_LOGIC
        );
    end component;
    
    signal div_clk_1ms : std_logic;
    
    -- our automated testbench clock
    signal clk_1us : std_logic := '0';
    constant clk_period : time := 1 us;

begin

    UUT: my_divider_1k port map ( Clk_in => clk_1us, Clk_out => div_clk_1ms);

    -- we also need a clock process, so we define one here.
    clk_process_1us : process
    begin
         clk_1us <= '0';
         wait for clk_period/2; -- for half a period, signal is '0'.
         clk_1us <= '1';
         wait for clk_period/2; -- for next half a period, signal is '1'.
     end process;

end Behavioral;
