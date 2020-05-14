----------------------------------------------------------------------------------
-- Company: University of Canterbury - ENEL373
--
-- Create Date: 04/14/2020 11:50:51 AM
-- Module Name: Quad_4_bit_counter_TB - Behavioral
-- Project Name: Rxn
-- Target Devices: xc7a100tcsg324-3
-- Tool Versions: 2019.2
-- Description: Test bench for quad 4-bit BCD counter.
-- 
-- Revision: 0.01 - File Created
--           0.02 - External input removed, asserts added for 9->0 transitions.
-- Additional Comments:
-- Run for at least 1.0001 ms to complete all checks.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Quad_4_bit_counter_TB is
--  Port ( );
end Quad_4_bit_counter_TB;

architecture Behavioral of Quad_4_bit_counter_tb is

   component Quad_4_bit_counter is
   Port ( EN : in STD_LOGIC;
          R_SET : in STD_LOGIC;
          stage_1_q_out : out STD_LOGIC_VECTOR (3 downto 0);
          stage_2_q_out : out STD_LOGIC_VECTOR (3 downto 0);
          stage_3_q_out : out STD_LOGIC_VECTOR (3 downto 0);
          stage_4_q_out : out STD_LOGIC_VECTOR (3 downto 0);
          clk_in_ctr : in STD_LOGIC;
          overflow : out STD_LOGIC);
   end component;


   signal EN : STD_LOGIC := '0';
   signal R_SET : STD_LOGIC := '0';
   signal stage_1_q_out : STD_LOGIC_VECTOR (3 downto 0) := X"0";
   signal stage_2_q_out : STD_LOGIC_VECTOR (3 downto 0) := X"0";
   signal stage_3_q_out : STD_LOGIC_VECTOR (3 downto 0) := X"0";
   signal stage_4_q_out : STD_LOGIC_VECTOR (3 downto 0) := X"0";
   signal clk_in_ctr : STD_LOGIC := '0';
   signal overflow : STD_LOGIC := '0';
   
   constant ClockPeriod : Time := 100 ns;

begin

   UUT: Quad_4_bit_counter
      port map( EN => EN, R_SET => R_SET, stage_1_q_out => stage_1_q_out, stage_2_q_out => stage_2_q_out, 
                  stage_3_q_out => stage_3_q_out, stage_4_q_out => stage_4_q_out, 
                     clk_in_ctr => clk_in_ctr, overflow => overflow); 

   clk_process : process
   begin
      clk_in_ctr <= '0';
      wait for ClockPeriod / 2;
      clk_in_ctr <= '1';
      wait for ClockPeriod / 2;
   end process clk_process;

   io_process : process
   begin
     wait for 100 ns;
     EN <= '1';
     R_SET <= '0';
     -- Check initial counter state is 0000: 
     assert (stage_1_q_out = X"0") and (stage_2_q_out = X"0") and (stage_3_q_out = X"0") and (stage_4_q_out = X"0") report "Initial counter state is not 0000. Test bench will not report errors correctly." severity note; 
     
     -- Check 9 to 10 transition:
     wait for (ClockPeriod * 9);
     assert (stage_1_q_out = X"9") and (stage_2_q_out = X"0") and (stage_3_q_out = X"0") and (stage_4_q_out = X"0") report "count 9 failed." severity failure;
     wait for ClockPeriod;
     assert (stage_1_q_out = X"0") and (stage_2_q_out = X"1") and (stage_3_q_out = X"0") and (stage_4_q_out = X"0") report "count 10 failed." severity failure;
     
     -- Check 99 to 100 transition:
     wait for (ClockPeriod * 89);
     assert (stage_1_q_out = X"9") and (stage_2_q_out = X"9") and (stage_3_q_out = X"0") and (stage_4_q_out = X"0") report "count 99 failed." severity failure;
     wait for ClockPeriod;
     assert (stage_1_q_out = X"0") and (stage_2_q_out = X"0") and (stage_3_q_out = X"1") and (stage_4_q_out = X"0") report "count 100 failed." severity failure;
     
     -- Check 999 to 1000 transition:
     wait for (ClockPeriod * 899);
     assert (stage_1_q_out = X"9") and (stage_2_q_out = X"9") and (stage_3_q_out = X"9") and (stage_4_q_out = X"0") report "count 999 failed." severity failure;
     wait for ClockPeriod;
     assert (stage_1_q_out = X"0") and (stage_2_q_out = X"0") and (stage_3_q_out = X"0") and (stage_4_q_out = X"1") report "count 1000 failed." severity failure;
     
     -- Check 9999 to 0000 transition:
     wait for (ClockPeriod * 8999);
     assert (stage_1_q_out = X"9") and (stage_2_q_out = X"9") and (stage_3_q_out = X"9") and (stage_4_q_out = X"9") report "count 9999 failed." severity failure;
     wait for ClockPeriod;
     assert (stage_1_q_out = X"0") and (stage_2_q_out = X"0") and (stage_3_q_out = X"0") and (stage_4_q_out = X"0") report "count 0000 failed." severity failure;  
     
     assert false report "Testbench completed successfully!" severity note;
     wait;
  end process io_process;

end Behavioral;