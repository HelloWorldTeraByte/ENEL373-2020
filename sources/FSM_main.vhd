----------------------------------------------------------------------------------
-- Company: UC
-- Engineer: Randipa
-- 
-- Create Date: 12.05.2020 10:17:17
-- Design Name: 
-- Module Name: FSM_main - Behavioral
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

entity FSM_main is
    Port ( clk : in std_logic;
            reset : in std_logic := '0';
            clk_warning: in std_logic;
            btn : in std_logic;
            dec_points : out std_logic_vector(2 downto 0);
            counter_enable : out std_logic);
end FSM_main;

architecture Behavioral of FSM_main is

--Warning 3, Warning 2, Warning 1, Timer running, Display Timer
type states is (w3, w2, w1, tr, dpt);
signal curr_state, next_state : states;
signal prev_btn_state : std_logic := '0';

begin

    process(clk, reset)
    begin
        if(reset = '1') then
            curr_state <= w3;
        elsif(rising_edge(clk)) then
            curr_state <= next_state;
        end if;
    end process;

    process(curr_state, clk_warning, btn)
    begin
        case curr_state is 
            when w3 =>
                counter_enable <= '0';
                dec_points <= "000";
                if(rising_edge(clk_warning)) then
                   next_state <= w2;
                end if;
            when w2 =>
                counter_enable <= '0';
                dec_points <= "100";
                if(rising_edge(clk_warning)) then
                   next_state <= w1;
                end if;
            when w1 =>
                counter_enable <= '0';
                dec_points <= "110";
                if(rising_edge(clk_warning)) then
                   next_state <= tr;
                end if;
            when tr =>
                counter_enable <= '1';
                dec_points <= "111";
               if(btn = '1' and prev_btn_state = '0') then 
                    next_state <= dpt;
                end if;
                prev_btn_state <= btn;
            when dpt =>
                counter_enable <= '0';
                --TODO: Change this to 111
                dec_points <= "001";
                if(btn = '1' and prev_btn_state = '0') then 
                    next_state <= w3;
                end if;
                prev_btn_state <= btn;
       end case;
    end process;

end Behavioral;