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

--TODO: Change the naming
entity mux_7seg is
		   Port ( sel: in std_logic_vector (1 downto 0);
		          mux_in0 : in std_logic_vector (3 downto 0);
		          mux_in1 : in std_logic_vector (3 downto 0);
		          mux_in2 : in std_logic_vector (3 downto 0);
		          mux_in3 : in std_logic_vector (3 downto 0);
		          mux_out : out std_logic_vector (3 downto 0));
end mux_7seg;

architecture Behavioral of mux_7seg is

begin
	mux_7seg_proc: process (sel, mux_in0, mux_in1, mux_in2, mux_in3)
		begin
			case sel is
				when "00"	=> mux_out <= mux_in0;
				when "01"	=> mux_out <= mux_in1;
				when "10"	=> mux_out <= mux_in2;
				when "11"	=> mux_out <= mux_in3;
				when others => mux_out <= "0000";
			end case;
	end process mux_7seg_proc;

end Behavioral;
