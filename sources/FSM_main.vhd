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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FSM_main is
    Port ( clk : in std_logic;  --Main clock input
            reset : in std_logic := '0'; --Active low reset to FSM, resets to warning 3 state
            warning_edge: in std_logic;     --The warning edge is used to transition from W3->W2->W1->TR states
            btn_edge : in std_logic;        --Used to transition from TR->DPT->W3
            dec_points : out std_logic_vector(3 downto 0);  --Main output of the FSM, used to control the seg control component
            counter_reset : out std_logic;  --Quad counter reset signal
            counter_enable : out std_logic); --Quad counter enable signal
end FSM_main;

architecture Behavioral of FSM_main is

--Warning 3, Warning 2, Warning 1, Timer running, Display Timer states
type type_state is (w3, w2, w1, tr, dpt);
signal curr_state, next_state : type_state; --Create state variable for current and next states
--signal prev_btn_state : std_logic := '0';

begin

    process(clk, reset)
    begin
        if(reset = '1') then
            curr_state <= w3;   --Reset should be at warning 3 state
        elsif(rising_edge(clk)) then
            curr_state <= next_state;   --State transition needs to be synchronous
        end if;
    end process;

    --Next state logic
    process(curr_state, warning_edge, btn_edge)
    begin
        next_state <= curr_state;
        case curr_state is 
            when w3 =>
                --Transition on the edge of the warning clock
                if(warning_edge = '1') then 
                   next_state <= w2;
                else 
                   next_state <= w3;
                end if;
            when w2 =>
                --Transition on the edge of the warning clock
                if(warning_edge = '1') then
                   next_state <= w1;
                else
                   next_state <= w2;
                end if;
            when w1 =>
                --Transition on the edge of the warning clock
                if(warning_edge = '1') then
                   next_state <= tr;
                else
                   next_state <= w1;
                end if;
            when tr =>
                --Transition on the edge of the button
               if(btn_edge = '1') then
                    next_state <= dpt;
                else
                    next_state <= tr;
                end if;
           when dpt =>
                --Transition on the edge of the button
               if(btn_edge = '1') then
                    next_state <= w3;
                else
                    next_state <= dpt;
                end if;
       end case;
    end process;

    --Output logic
    process(curr_state, warning_edge, btn_edge)
    begin
        --Default values of the outputs
        counter_enable <= '0';
        counter_reset <= '0';
        dec_points <= "1000";
         
        --For each states output should be as shown
        --Decimal points are active low
        --Counter should be resent and not enabled W3,W2,W1 states
        case curr_state is 
            when w3 =>
                counter_reset <= '1';
                counter_enable <= '0';
                dec_points <= "1000";
            when w2 =>
                counter_reset <= '1';
                counter_enable <= '0';
                dec_points <= "1100";
            when w1 =>
                counter_reset <= '1';
                counter_enable <= '0';
                dec_points <= "1110";
            when tr =>
                counter_reset <= '0';   --We need to count up so stop resetting the counter
                counter_enable <= '1';  --Start counting 
                dec_points <= "1111";
            when dpt =>
               counter_reset <= '0';
               counter_enable <= '0';   --Stop counting to show the user the reaction time
               dec_points <= "1111";
       end case;
    end process;

end Behavioral;