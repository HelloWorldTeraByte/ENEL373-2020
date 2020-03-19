----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.03.2020 11:13:47
-- Design Name: 
-- Module Name: top_level - Behavioral
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

entity top_level is
    Port ( CLK100MHZ: in STD_LOGIC; 
           LED : out STD_LOGIC_VECTOR (15 downto 0);
           SW : in STD_LOGIC_VECTOR (15 downto 0);
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           CA : out STD_LOGIC;
           CB : out STD_LOGIC;
           CC : out STD_LOGIC;
           CD : out STD_LOGIC;
           CE : out STD_LOGIC;
           CF : out STD_LOGIC;
           CG : out STD_LOGIC);
end top_level;

architecture Struct of top_level is

signal clck_div_1, clck_div_2k, clck_div_1k: std_logic;
signal seg_mux_in : std_logic_vector(2 downto 0);
signal cnt0_q, cnt1_q, cnt2_q, cnt3_q, cnt4_q, cnt5_q, cnt6_q, cnt7_q : std_logic_vector (3 downto 0);
signal bcd_in : std_logic_vector (3 downto 0);
signal cnt0_1, cnt1_2, cnt2_3, cnt3_4, cnt4_5, cnt5_6, cnt6_7 : std_logic;


component divider_1hz
    Port ( Clk_in : in  STD_LOGIC;
           Clk_out : out  STD_LOGIC);
end component;

component divider_1khz
    Port ( Clk_in : in  STD_LOGIC;
           Clk_out : out  STD_LOGIC);
end component;

component divider_2khz
    Port ( Clk_in : in  STD_LOGIC;
           Clk_out : out  STD_LOGIC);
end component;

component BCD_to_7SEG
    Port ( bcd_in: in std_logic_vector (3 downto 0);
    			leds_out: out	std_logic_vector (1 to 7));
end component;

component counter_4bit
    port(Clock, CLR : in  std_logic;
                    clk_out : out std_logic;
                    Q : out std_logic_vector(3 downto 0));
end component;

component counter_3bit
    port(Clock, CLR : in  std_logic;
                    Q : out std_logic_vector(2 downto 0));
end component;

component mux_7seg
    port ( sel: in std_logic_vector (2 downto 0);
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
end component;

begin
    div1: divider_1hz port map(Clk_in=>CLK100MHZ,
        Clk_out=>clck_div_1);
        
    div1k: divider_1khz port map(Clk_in=>CLK100MHZ,
        Clk_out=>clck_div_1k);
        
    div2k: divider_2khz port map(Clk_in=>CLK100MHZ,
        Clk_out=>clck_div_2k);
        
    cnt3bit: counter_3bit port map(Clock=>clck_div_2k,
    CLR=>SW(7),
    Q=>seg_mux_in);
    
    mux7seg: mux_7seg port map(sel=>seg_mux_in,
    anode=>AN,
    mux_in0=>cnt0_q,
    mux_in1=>cnt1_q,
    mux_in2=>cnt2_q,
    mux_in3=>cnt3_q,
    mux_in4=>cnt4_q,
    mux_in5=>cnt5_q,
    mux_in6=>cnt6_q,
    mux_in7=>cnt7_q,
    mux_out=>bcd_in);
        
    cnt0: counter_4bit port map(Clock=>clck_div_1k,
    CLR=>SW(0), clk_out=>cnt0_1,
    Q=>cnt0_q);
    
    cnt1: counter_4bit port map(Clock=>cnt0_1,
    CLR=>SW(1), clk_out=>cnt1_2,
    Q=>cnt1_q);
    
    cnt2: counter_4bit port map(Clock=>cnt1_2,
    CLR=>SW(2), clk_out=>cnt2_3,
    Q=>cnt2_q);
    
    cnt3: counter_4bit port map(Clock=>cnt2_3,
    CLR=>SW(3), clk_out=>cnt3_4,
    Q=>cnt3_q);
    
    cnt4: counter_4bit port map(Clock=>cnt3_4,
    CLR=>SW(4), clk_out=>cnt4_5,
    Q=>cnt4_q);
    
    cnt5: counter_4bit port map(Clock=>cnt4_5,
    CLR=>SW(5), clk_out=>cnt5_6,
    Q=>cnt5_q);
    
    cnt6: counter_4bit port map(Clock=>cnt5_6,
    CLR=>SW(6), clk_out=>cnt6_7,
    Q=>cnt6_q);
    
    cnt7: counter_4bit port map(Clock=>cnt6_7,
    CLR=>SW(7), clk_out=>LED(0),
    Q=>cnt7_q);
              
    seg7: BCD_to_7SEG port map(bcd_in=>bcd_in,
        leds_out(1)=>CA,
        leds_out(2)=>CB,
        leds_out(3)=>CC,
        leds_out(4)=>CD,
        leds_out(5)=>CE,
        leds_out(6)=>CF,
        leds_out(7)=>CG);
end Struct;