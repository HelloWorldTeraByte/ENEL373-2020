----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.05.2020 12:26:02
-- Design Name: 
-- Module Name: seg7_control - Behavioral
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

entity seg7_control is
    Port (  dec_points : in std_logic_vector(3 downto 0);
            AN_in : in std_logic_vector(3 downto 0);
            leds_in: in	std_logic_vector (1 to 7);
            dp_out : out std_logic;
            AN_out : out std_logic_vector(3 downto 0);
            leds_out: out std_logic_vector (1 to 7)
         );
end seg7_control;

architecture Behavioral of seg7_control is

component mux_dec_pt
    Port (sel : in std_logic_vector(3 downto 0);
          msg_in0 : in std_logic;
          msg_in1 : in std_logic;
          msg_in2 : in std_logic;
          msg_in3 : in std_logic;
          mux_out : out std_logic);
end component;

begin
    AN_out <= AN_in;
    mux_dec : mux_dec_pt port map(sel=>AN_in,
                msg_in0=>dec_points(0),
                msg_in1=>dec_points(1),
                msg_in2=>dec_points(2),
                msg_in3=>dec_points(3),
                mux_out=>dp_out
                );
    leds_out <= leds_in when dec_points = "1111" else
                "1111111";

end Behavioral;