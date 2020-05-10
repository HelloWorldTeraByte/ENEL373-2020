-- Display_tb.vhd
-- Testbench to test functionality of display components in 
-- ENEL373 Reaction Timer project.
--
-- C.P. Moore
-- 28 April 2020

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; -- needed for arithmetic

entity Display_tb is
end entity;

architecture behavioral of Display_tb is
component Display_Wrapper is
  port (CLK     : in STD_LOGIC;
        Message : in STD_LOGIC_VECTOR (15 downto 0);
        CA, CB, CC, CD, CE, CF, CG : out STD_LOGIC;
                                 -- Segment cathodes
        AN 	    : out STD_LOGIC_VECTOR ( 3 downto 0));
end component;
  
-- Inputs:
signal CLK_sim : STD_LOGIC := '0';
signal Message_sim : STD_LOGIC_VECTOR (15 downto 0);
 
-- Outputs:
signal C_sim : STD_LOGIC_VECTOR (1 to 7); -- note big-endian vector to match CA..CG arrangement of cathodes. 
signal AN_sim : STD_LOGIC_VECTOR (3 downto 0);

constant CLK_period : time := 10 ns;
  
begin
  -- Unit under test:
  uut: Display_Wrapper port map (CLK => CLK_sim, Message => Message_sim, CA => C_sim(1), CB => C_sim(2), CC => C_sim(3), CD => C_sim(4), CE => C_sim(5), CF => C_sim(6), CG => C_sim(7), AN => AN_sim);
    
  clk_proc: process is
  begin
    CLK_sim <= not(CLK_sim) after CLK_period /2;
  end process;
    
  stimulus_process: process is
  
  variable ctr : integer range 0 to 5 := 0; -- loop counter
  
  begin
    wait for 100 ns;
    Message_sim <= X"4321";
    wait for 4 * CLK_period;
    
    -- Check that AN0 is selected:
    ctr := 0;
    while (AN_sim /= "0001") loop
      wait for CLK_period;
      ctr := ctr + 1;
      assert (ctr < 4) report "AN(0) is never selected." severity failure;
    end loop;
    
    -- Check that 1 is displayed on cahtodes:
    assert (C_sim = "0110000") report "1 not displayed correctly." severity error;

    -- Check that AN1 is selected:
    ctr := 0;
    while (AN_sim /= "0010") loop
      wait for CLK_period;
      ctr := ctr + 1;
      assert (ctr < 4) report "AN(1) is never selected." severity failure;
    end loop; 
    
    -- Check that 2 is displayed on cathodes:
    assert (C_sim = "1101101") report "2 not displayed correctly." severity error ;

    -- Check that AN2 is selected:
    ctr := 0;
    while (AN_sim /= "0100") loop
      wait for CLK_period;
      ctr := ctr + 1;
      assert (ctr < 4) report "AN(2) is never selected." severity failure;
    end loop; 
    
    -- Check that 3 is displayed on cathodes:
    assert (C_sim = "1111001") report "3 not displayed correctly." severity error ;
       
    -- Check that AN3 is selected:
    ctr := 0;
    while (AN_sim /= "1000") loop
      wait for CLK_period;
      ctr := ctr + 1;
      assert (ctr < 4) report "AN(3) is never selected." severity failure;
    end loop; 
    
    -- Check that 4 is displayed on cathodes:
    assert (C_sim = "0110011") report "4 not displayed correctly." severity error;

    Message_sim <= X"8765";
    -- Wait for AN0 to be selected:
    ctr := 0;
    while (AN_sim /= "0001") loop
      wait for CLK_period;
    end loop; 
    
    -- Check that 5 is displayed on cathodes:
    assert (C_sim = "1011011") report "5 not displayed correctly." severity error;

    -- Wait for AN1 to be selected:
    ctr := 0;
    while (AN_sim /= "0010") loop
      wait for CLK_period;
    end loop; 
    
    -- Check that 6 is displayed on cathodes:
    assert (C_sim = "0011111") report "6 not displayed correctly." severity error;

    -- Wait for AN2 to be selected:
    ctr := 0;
    while (AN_sim /= "0100") loop
      wait for CLK_period;
    end loop; 
    
    -- Check that 7 is displayed on cathodes:
    assert (C_sim = "11100000") report "7 not displayed correctly." severity error;

    -- Wait for AN3 to be selected:
    ctr := 0;
    while (AN_sim /= "1000") loop
      wait for CLK_period;
    end loop; 
    
    -- Check that 8 is displayed on cathodes:
    assert (C_sim = "11111111") report "8 not displayed correctly." severity error; 

    Message_sim <= X"9090";
    -- Wait for AN0 to be selected:
    ctr := 0;
    while (AN_sim /= "0001") loop
      wait for CLK_period;
    end loop; 
    
    -- Check that 0 is displayed on cathodes:
    assert (C_sim = "11111110") report "0 not displayed correctly." severity error; 

    -- Wait for AN1 to be selected:
    ctr := 0;
    while (AN_sim /= "0010") loop
      wait for CLK_period;
    end loop; 
    
    -- Check that 9 is displayed on cathodes:
    assert (C_sim = "1110011") report "9 not displayed correctly." severity error; 
    
    end process;
end architecture;
    