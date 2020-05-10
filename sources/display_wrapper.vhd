----------------------------------------------------------------------------------
-- Company: UC
-- Engineer: Randipa
-- 
-- Create Date: 10.05.2020 15:28:34
-- Design Name: 
-- Module Name: display_wrapper - Behavioral
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

entity display_wrapper is
    port (CLK     : in STD_LOGIC; -- This should be your 'display' clock, the clock that is used to switch between anodes
          Message : in STD_LOGIC_VECTOR (15 downto 0);
          CA, CB, CC, CD, CE, CF, CG : out STD_LOGIC; -- Segment cathodes
          AN 		: out STD_LOGIC_VECTOR ( 3 downto 0));
end display_wrapper;
  
 
architecture structural of display_wrapper is

component counter_2bit
    port(Clock, CLR : in  std_logic;
        Q : out std_logic_vector(1 downto 0));
end component;

component decoder_2_to_4 is
    port ( Select_vector : in STD_LOGIC_VECTOR (1 downto 0);
           Output : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component mux_7seg is
		   Port ( sel: in std_logic_vector (1 downto 0);
		          mux_in0 : in std_logic_vector (3 downto 0);
		          mux_in1 : in std_logic_vector (3 downto 0);
		          mux_in2 : in std_logic_vector (3 downto 0);
		          mux_in3 : in std_logic_vector (3 downto 0);
		          mux_out : out std_logic_vector (3 downto 0));
end component;

component BCD_to_7SEG
    Port ( bcd_in: in std_logic_vector (3 downto 0);
    			leds_out: out	std_logic_vector (1 to 7));
end component;

begin

end structural;