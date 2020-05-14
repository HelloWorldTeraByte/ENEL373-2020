----------------------------------------------------------------------------------
-- Company: University of Canterbury 
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
    Port ( CLK100MHZ : in STD_LOGIC; 
           BTNC : in STD_LOGIC;
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           DP : out STD_LOGIC;
           CA : out STD_LOGIC;
           CB : out STD_LOGIC;
           CC : out STD_LOGIC;
           CD : out STD_LOGIC;
           CE : out STD_LOGIC;
           CF : out STD_LOGIC;
           CG : out STD_LOGIC);
end top_level;

architecture structural of top_level is

signal clk_div_1, clk_div_1k, clk_div_2k, clk_div_4k : STD_LOGIC;
signal quad_cnt_en, quad_cnt_rst, quad_cnt_overflow  : STD_LOGIC;
signal quad_cnt_1_q, quad_cnt_2_q, quad_cnt_3_q, quad_cnt_4_q : STD_LOGIC_VECTOR (3 downto 0);
signal dec_points : std_logic_vector(3 downto 0);
signal segs : std_logic_vector(1 to 7);
signal anode : std_logic_vector(3 downto 0);
signal btnc_debounce_out, btnc_edge_sig, warning_edge_sig: std_logic;

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
    Port (  EN : in STD_LOGIC := '1';
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

component FSM_main
    Port ( clk : in std_logic;
            reset : in std_logic := '0';
            warning_edge: in std_logic;
            btn_edge : in std_logic;
            dec_points : out std_logic_vector(3 downto 0);
            counter_reset : out std_logic;
            counter_enable : out std_logic);
end component;

component seg7_control
    Port (  dec_points : in std_logic_vector(3 downto 0);
            AN_in : in std_logic_vector(3 downto 0);
            leds_in: in	std_logic_vector (1 to 7);
            dp_out : out std_logic;
            AN_out : out std_logic_vector(3 downto 0);
            leds_out: out std_logic_vector (1 to 7)
         );
end component;

component btn_debouncer
    port(   Clock : in std_logic;
                Reset : in std_logic := '0';
            button_in : in std_logic;
            pulse_out : out std_logic
        );
end component;

component edge_detector
	port (
		clk : in std_logic;
		d : in std_logic;
		edge : out std_logic
	);
end component;

begin
    AN(7 downto 4) <= "1111";

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
        
    dp_wrap: display_wrapper port map(CLK=>clk_div_2k,
             Message(15 downto 12)=>quad_cnt_4_q,
             Message(11 downto 8)=>quad_cnt_3_q,
             Message(7 downto 4)=>quad_cnt_2_q,
             Message(3 downto 0)=>quad_cnt_1_q,
             CA=>segs(1),
             CB=>segs(2),
             CC=>segs(3),
             CD=>segs(4),
             CE=>segs(5),
             CF=>segs(6),
             CG=>segs(7),
             AN=>anode);
           
    btnc_debounce : btn_debouncer port map(Clock=>clk_div_2k,
                    Reset=>open,
                    button_in=>BTNC,
                    pulse_out=>btnc_debounce_out);

    btnc_edge : edge_detector port map( clk=>clk_div_2k,
                d=>btnc_debounce_out,
                edge=>btnc_edge_sig);

    warning_edge : edge_detector port map( clk=>clk_div_2k,
                d=>clk_div_1,
                edge=>warning_edge_sig);

    FSM_controller: FSM_main port map(clk=>clk_div_2k,
                    reset=>open,
                    warning_edge=>warning_edge_sig,
                    btn_edge=>btnc_edge_sig,
                    dec_points=>dec_points,
                    counter_reset=>quad_cnt_rst,
                    counter_enable=>quad_cnt_en);

    seg_ctrl: seg7_control port map(dec_points=>dec_points,
                AN_in=>anode,
                leds_in=>segs,
                dp_out=>DP,
                AN_out=>AN(3 downto 0),
                leds_out(1)=>CA,
                leds_out(2)=>CB,
                leds_out(3)=>CC,
                leds_out(4)=>CD,
                leds_out(5)=>CE,
                leds_out(6)=>CF,
                leds_out(7)=>CG);
end structural;