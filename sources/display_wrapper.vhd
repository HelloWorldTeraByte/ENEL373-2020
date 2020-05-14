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

signal seg_mux_in : STD_LOGIC_VECTOR (1 downto 0) := "00";
signal bcd_in : STD_LOGIC_VECTOR (3 downto 0);

component counter_2bit
    port (
		Clock: in std_logic;
		CLR: in std_logic := '0';
		Q : out std_logic_vector(1 downto 0));
end component;

component decoder_2_to_4
    port ( Select_vector : in STD_LOGIC_VECTOR (1 downto 0);
           Output : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component mux_7seg
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
    cnt_2_bit: counter_2bit port map(Clock=>CLK,
        CLR=>open,
        Q=>seg_mux_in);

    dec_2_4: decoder_2_to_4 port map(Select_vector=>seg_mux_in,
        Output=>AN);

    mux7seg: mux_7seg port map(sel=>seg_mux_in,
        mux_in3=>Message(15 downto 12),
        mux_in2=>Message(11 downto 8),
        mux_in1=>Message(7 downto 4),
        mux_in0=>Message(3 downto 0),
        mux_out=>bcd_in);

    BCD_7SEG: BCD_to_7SEG port map(bcd_in=>bcd_in,
        leds_out(1)=>CA,
        leds_out(2)=>CB,
        leds_out(3)=>CC,
        leds_out(4)=>CD,
        leds_out(5)=>CE,
        leds_out(6)=>CF,
        leds_out(7)=>CG);

end structural;