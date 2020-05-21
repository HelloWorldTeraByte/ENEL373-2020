----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.05.2020 16:12:38
-- Design Name: 
-- Module Name: mux_dec_pt - Behavioral
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

--Controls which decimal point is needed to displayed 
--The msg_in* is the bit of the decimal point vector
--The dp is turned on and off rapidly using the decoded anode as the control
entity mux_dec_pt is
    Port (sel : in std_logic_vector(3 downto 0);
          msg_in0 : in std_logic;
          msg_in1 : in std_logic;
          msg_in2 : in std_logic;
          msg_in3 : in std_logic;
          mux_out : out std_logic);
end mux_dec_pt;

architecture Behavioral of mux_dec_pt is

begin

    --Output the decimal point based on the anode as the select vector
	mux_dec_pt_proc: process (sel, msg_in0, msg_in1, msg_in2, msg_in3)
    begin
        case sel is
            when "1110"	=> mux_out <= msg_in0;
    	    when "1101"	=> mux_out <= msg_in1;
    	    when "1011"	=> mux_out <= msg_in2;
            when "0111"	=> mux_out <= msg_in3;
            when others => mux_out <= '1';
        end case;
    end process mux_dec_pt_proc;

end Behavioral;