----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/14/2020 11:50:51 AM
-- Design Name: 
-- Module Name: Quad_4_bit_counter_TB - Behavioral
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
use std.textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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


   signal EN : STD_LOGIC;
   signal R_SET : STD_LOGIC;
   signal stage_1_q_out : STD_LOGIC_VECTOR (3 downto 0);
   signal stage_2_q_out : STD_LOGIC_VECTOR (3 downto 0);
   signal stage_3_q_out : STD_LOGIC_VECTOR (3 downto 0);
   signal stage_4_q_out : STD_LOGIC_VECTOR (3 downto 0);
   signal clk_in_ctr : STD_LOGIC;
   signal overflow : STD_LOGIC;
   -- signal ClockPeriod : TIME := 50 ns;

   constant ClockPeriod : Time := 1000 ns;

begin

   UUT: Quad_4_bit_counter
      port map( EN => EN, R_SET => R_SET, stage_1_q_out => stage_1_q_out, stage_2_q_out => stage_2_q_out, 
                  stage_3_q_out => stage_3_q_out, stage_4_q_out => stage_4_q_out, 
                     clk_in_ctr => clk_in_ctr, overflow => overflow); 

   clk_process : process
   begin
      clk_in_ctr <= '0';
      wait for 500 ns;
      clk_in_ctr <= '1';
      wait for 500 ns;
   end process clk_process;

   io_process : process 
   file infile: text is in "./counter_input.txt";
   variable fileline : line;
   variable check : std_logic_vector(18 downto 0);

   begin
   while not endfile(infile) loop
      readline(infile, fileline);
      read(fileline, check);

      EN <= check(0);
      R_SET <= check(1);
      stage_1_q_out <= check(5 downto 2);
      stage_2_q_out <= check(9 downto 6);
      stage_1_q_out <= check(13 downto 10);
      stage_1_q_out <= check(17 downto 14);
      overflow <= check(18);
      wait for 5 ns;
   end loop;
   wait;
   end process io_process; 

end Behavioral;
