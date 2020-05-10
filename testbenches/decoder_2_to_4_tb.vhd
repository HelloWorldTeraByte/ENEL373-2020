----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.04.2020 15:36:59
-- Design Name: 
-- Module Name: two_to_four_decoder_tb - Behavioral
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

entity decoder_2_to_4_tb is
    -- nothing required here for a testbench ( );
end decoder_2_to_4_tb;

architecture Behavioral of decoder_2_to_4_tb is

-- Set up signals
signal Select_vector : STD_LOGIC_VECTOR (1 downto 0);
signal Output : STD_LOGIC_VECTOR (3 downto 0);

-- Import the component
component decoder_2_to_4 is
    Port ( Select_vector : in STD_LOGIC_VECTOR (1 downto 0);
           Output : out STD_LOGIC_VECTOR (3 downto 0));
end component; 

-- Helper function for converting std_logic_vectors to strings
-- from https://groups.google.com/d/msg/comp.lang.vhdl/aod5TIOuTL8/q6vlfWXhXkYJ
function to_string(arg : std_logic_vector) return string is
    variable result : string (1 to arg'length);
    variable v : std_logic_vector (result'range) := arg;
begin
      for i in result'range loop
         case v(i) is
            when 'U' =>
               result(i) := 'U';
            when 'X' =>
               result(i) := 'X';
            when '0' =>
               result(i) := '0';
            when '1' =>
               result(i) := '1';
            when 'Z' =>
               result(i) := 'Z';
            when 'W' =>
               result(i) := 'W';
            when 'L' =>
               result(i) := 'L';
            when 'H' =>
               result(i) := 'H';
            when '-' =>
               result(i) := '-';
         end case;
      end loop;
      return result;
end function;

-- Helper procedure for running tests
procedure do_test(test : in integer; expected : in std_logic_vector; actual : in std_logic_vector) is begin

    -- ATTENTION:
    -- If the simulation stops on this next line you have failed a test.
    -- Check the "Tcl Console" for more information 
    assert (actual = expected) report "Failed Test #" & integer'image(test) & ": expected " & to_string(expected) & " but got " & to_string(actual) severity failure;
    
end procedure;

begin

    -- port map the unit under test (UUT)
    UUT: decoder_2_to_4 port map (Select_vector => Select_vector, Output => Output);
    
    process begin
        
        -- Test 1
        -- Check that Output is "1110" when Select_vector is "00"
        Select_vector <= "00";
        wait for 10 ns;
        do_test(1, "1110", Output);
        
        -- Test 2
        -- Check that Output is "1101" when Select_vector is "01"
        Select_vector <= "01";
        wait for 10 ns;
        do_test(2, "1101", Output); 
        
        -- Test 3
        -- Check that Output is "1011" when Select_vector is "10"
        Select_vector <= "10";
        wait for 10 ns;
        do_test(3, "1011", Output); 
        
        -- Test 4
        -- Check that Output is "0111" when Select_vector is "11"
        Select_vector <= "11";
        wait for 10 ns;
        do_test(4, "0111", Output); 
        
        -- ATTENTION:
        -- If you get to this point, all tests have passed!
        -- Congratulations!
        report "All tests passed!" severity note;
        wait;
        
    end process;
    

end Behavioral;
