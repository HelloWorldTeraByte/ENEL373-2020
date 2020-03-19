library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
--library UNISIM;
--use UNISIM.VComponents.all;

-- Author: Steve Weddell
-- Date: June 25, 2004
-- Purpose: VHDL Module for BCD to 7-segment Decoder
-- Usage: Laboratory 1; Example VHDL file for ENEL353


entity mux_7seg is
		   Port ( sel: in std_logic_vector (2 downto 0);
		          anode : out std_logic_vector(7 downto 0);
		          mux_in0 : in std_logic_vector (3 downto 0);
		          mux_in1 : in std_logic_vector (3 downto 0);
		          mux_in2 : in std_logic_vector (3 downto 0);
		          mux_in3 : in std_logic_vector (3 downto 0);
		          mux_in4 : in std_logic_vector (3 downto 0);
		          mux_in5 : in std_logic_vector (3 downto 0);
		          mux_in6 : in std_logic_vector (3 downto 0);
		          mux_in7 : in std_logic_vector (3 downto 0);
		          mux_out : out std_logic_vector (3 downto 0));
end mux_7seg;

architecture Behavioral of mux_7seg is

begin
	mux_7seg_proc: process (sel)
		begin
			case sel is
				when "000"	=> mux_out <= mux_in0;
				               anode <= "11111110";
				when "001"	=> mux_out <= mux_in1;
				               anode <= "11111101";
				when "010"	=> mux_out <= mux_in2;
				               anode <= "11111011";
				when "011"	=> mux_out <= mux_in3;
				               anode <= "11110111";
				when "100"	=> mux_out <= mux_in4;
				               anode <= "11101111";
				when "101"	=> mux_out <= mux_in5;
				               anode <= "11011111";
				when "110"	=> mux_out <= mux_in6;
				               anode <= "10111111";
				when "111"	=> mux_out <= mux_in7;
				               anode <= "01111111";				               				               				               				               				               				               
			end case;
	end process mux_7seg_proc;

end Behavioral;
