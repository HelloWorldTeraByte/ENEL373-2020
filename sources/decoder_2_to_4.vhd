----------------------------------------------------------------------------------
-- Company: UC
-- Engineer: Geeth
-- 
-- Create Date: 11.05.2020 10:38:53
-- Design Name: 
-- Module Name: decoder_2_to_4 - Behavioral
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

--TODO: Do we need these?
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decoder_2_to_4 is
    port ( Select_vector : in STD_LOGIC_VECTOR (1 downto 0);
           Output : out STD_LOGIC_VECTOR (3 downto 0));
end decoder_2_to_4;

architecture Behavioral of decoder_2_to_4 is
begin

    process (Select_vector)
    begin
        case Select_vector is
            when "00" => Output <= "1110";
            when "01" => Output <= "1101";
            when "10" => Output <= "1011";
            when "11" => Output <= "0111";
            when others => Output <= "0000";
        end case;
    end process;
        
end Behavioral;