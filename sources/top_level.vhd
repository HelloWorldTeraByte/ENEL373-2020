----------------------------------------------------------------------------------
-- Company: UC
-- Engineer: Randipa, Jeremy, Geeth
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

entity top_level is
    Port ( CLK100MHZ: in STD_LOGIC; 
           AN : out STD_LOGIC_VECTOR (3 downto 0);
           CA : out STD_LOGIC;
           CB : out STD_LOGIC;
           CC : out STD_LOGIC;
           CD : out STD_LOGIC;
           CE : out STD_LOGIC;
           CF : out STD_LOGIC;
           CG : out STD_LOGIC);
end top_level;

architecture structural of top_level is

signal clk_div_1, clk_div_1k, clk_div_2k : STD_LOGIC;
signal quad_cnt_en, quad_cnt_rst, quad_cnt_overflow  : STD_LOGIC;
signal quad_cnt_1_q, quad_cnt_2_q, quad_cnt_3_q, quad_cnt_4_q : STD_LOGIC_VECTOR (3 downto 0);

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

component quad_4_bit_counter
    port ( EN : in STD_LOGIC := '1';
          R_SET : in STD_LOGIC := '0';
          stage_1_q_out : out STD_LOGIC_VECTOR (3 downto 0);
          stage_2_q_out : out STD_LOGIC_VECTOR (3 downto 0);
          stage_3_q_out : out STD_LOGIC_VECTOR (3 downto 0);
          stage_4_q_out : out STD_LOGIC_VECTOR (3 downto 0);
          clk_in_ctr : in STD_LOGIC;
          overflow : out STD_LOGIC);
end component;

component display_wrapper
    port (CLK     : in STD_LOGIC; -- This should be your 'display' clock, the clock that is used to switch between anodes
          Message : in STD_LOGIC_VECTOR (15 downto 0);
          CA, CB, CC, CD, CE, CF, CG : out STD_LOGIC; -- Segment cathodes
          AN 		: out STD_LOGIC_VECTOR ( 3 downto 0));
end component;
 
begin
    div1: divider_1hz port map(Clk_in=>CLK100MHZ,
        Clk_out=>clk_div_1);
        
    div1k: divider_1khz port map(Clk_in=>CLK100MHZ,
        Clk_out=>clk_div_1k);
        
    div2k: divider_2khz port map(Clk_in=>CLK100MHZ,
        Clk_out=>clk_div_2k);

    quad_4_cnt: quad_4_bit_counter port map(EN=>quad_cnt_en,
        R_set=>quad_cnt_rst,
        stage_1_q_out=>quad_cnt_1_q,
        stage_2_q_out=>quad_cnt_2_q,
        stage_3_q_out=>quad_cnt_3_q,
        stage_4_q_out=>quad_cnt_4_q,
        clk_in_ctr=>clk_div_1k,
        overflow=>quad_cnt_overflow);
        
        --TODO: Anode is 8 bits but the component only 4 bits
    dp_wrap: display_wrapper port map(CLK=>clk_div_2k,
             Message(15 downto 12)=>quad_cnt_4_q,
             Message(11 downto 8)=>quad_cnt_3_q,
             Message(7 downto 4)=>quad_cnt_2_q,
             Message(3 downto 0)=>quad_cnt_1_q,
             CA=>CA,
             CB=>CB,
             CC=>CC,
             CD=>CD,
             CE=>CE,
             CF=>CF,
             CG=>CG,
             AN=>AN);
end structural;