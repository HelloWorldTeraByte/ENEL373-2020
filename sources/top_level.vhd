----------------------------------------------------------------------------------
-- Company: University of Canterbury 
-- Engineers: Randipa, Jeremy, Geeth
-- 
-- Create Date: 06.03.2020 11:13:47
-- Design Name: 
-- Module Name: top_level - Behavioral
-- Project Name: Reaction Timer
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

-------------   7 segment naming convention    -------------
----------------       -----CA------      ------------------
----------------       |           |      ------------------
----------------       CF          CB     ------------------
----------------       |           |      ------------------
----------------       -----CG------      ------------------
----------------       |           |      ------------------
----------------       CE          CC     ------------------
----------------       |           |      ------------------
----------------       -----CD------      ------------------

entity top_level is
    Port ( CLK100MHZ : in STD_LOGIC;    --Main Clock
           BTNC : in STD_LOGIC;         --Center button used for the stopping and restarting the timer
           AN : out STD_LOGIC_VECTOR (7 downto 0);      --Anodes for the 7 segment display
           DP : out STD_LOGIC;          --The decimal point in the 7 segment display
           --The segments for the 7 seg display; All the dp and segments of the 7seg is connected in parrallel
           CA : out STD_LOGIC;
           CB : out STD_LOGIC;
           CC : out STD_LOGIC;
           CD : out STD_LOGIC;
           CE : out STD_LOGIC;
           CF : out STD_LOGIC;
           CG : out STD_LOGIC);
end top_level;

architecture structural of top_level is

signal clk_div_1, clk_div_1k, clk_div_2k, clk_div_4k : STD_LOGIC;   --Clock divider signals
signal quad_cnt_en, quad_cnt_rst, quad_cnt_overflow  : STD_LOGIC;   --Signal for the quad counter
signal quad_cnt_1_q, quad_cnt_2_q, quad_cnt_3_q, quad_cnt_4_q : STD_LOGIC_VECTOR (3 downto 0);  --Connections used to pass message from couner to display wrapper 
signal dec_points : std_logic_vector(3 downto 0);   --Decimal points of the 7 segment display
signal segs : std_logic_vector(1 to 7);             --Used to pass the data through the seg control for clarity
signal anode : std_logic_vector(3 downto 0);        --Passed throught the seg control component
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
    AN(7 downto 4) <= "1111"; --All the unused 7seg displays should be turned off. Anode is active low

    --Clock dividers
    div1: divider_1hz port map(Clk_in=>CLK100MHZ,
        Clk_out=>clk_div_1);
        
    div1k: divider_1khz port map(Clk_in=>CLK100MHZ,
        Clk_out=>clk_div_1k);
        
    div2k: divider_2khz port map(Clk_in=>CLK100MHZ,
        Clk_out=>clk_div_2k);

    --Quad couner, the enable and reset is controlled by the FSM module
    quad_4_cnt: quad_4_bit_counter port map(EN=>quad_cnt_en,
        R_set=>quad_cnt_rst,
        stage_1_q_out=>quad_cnt_1_q,    --Each 4 bit counter's output is concatened to pass to the display wrapper
        stage_2_q_out=>quad_cnt_2_q,
        stage_3_q_out=>quad_cnt_3_q,
        stage_4_q_out=>quad_cnt_4_q,
        clk_in_ctr=>clk_div_1k,         --Main control clock
        overflow=>quad_cnt_overflow);   --Overflows goes high for once LSB clock cycle after 9999
     
    -- Wrapper module for the 7seg display
    --Since the 7segs are connected in parralel, each 7seg is turned on and off rapidly
    --to create persistence of vision effect 
    dp_wrap: display_wrapper port map(CLK=>clk_div_2k,  --The 2KHz clock is used to turn on and off the 7seg displays
             Message(15 downto 12)=>quad_cnt_4_q,       --The message from the quad counter
             Message(11 downto 8)=>quad_cnt_3_q,
             Message(7 downto 4)=>quad_cnt_2_q,
             Message(3 downto 0)=>quad_cnt_1_q,
             CA=>segs(1),       --Segs signal is used to pass to the seg control component
             CB=>segs(2),
             CC=>segs(3),
             CD=>segs(4),
             CE=>segs(5),
             CF=>segs(6),
             CG=>segs(7),
             AN=>anode);        --anode signal is passed through the seg control component
    
    --The button needs to debounced first   
    btnc_debounce : btn_debouncer port map(Clock=>clk_div_2k,
                    Reset=>open,
                    button_in=>BTNC,
                    pulse_out=>btnc_debounce_out);

    --Detect the rising edge of the button signal
    btnc_edge : edge_detector port map( clk=>clk_div_2k,
                d=>btnc_debounce_out,
                edge=>btnc_edge_sig);
                
    --Pass the rising edge of the warning clock 
    warning_edge : edge_detector port map( clk=>clk_div_2k,
                d=>clk_div_1,
                edge=>warning_edge_sig);

    --The main FSM for the reaction timer
    FSM_controller: FSM_main port map(clk=>clk_div_2k,
                    reset=>open,    
                    warning_edge=>warning_edge_sig, --The rising edge of the warining clock is used for the transition of state
                    btn_edge=>btnc_edge_sig,        --Used for the transisition of a state
                    dec_points=>dec_points,         --Decimal point signal is passed to the seg control
                    counter_reset=>quad_cnt_rst,    --Quad counter control signals
                    counter_enable=>quad_cnt_en);

    --Main purpose is deciding when to turn the 7seg numbers on an off
    --The decimal point signal from the FSM is used to determine this
    --The mux inside controls the decimal point of the 7seg
    seg_ctrl: seg7_control port map(dec_points=>dec_points, --Main input to determine the DP poitns and 7segs
                AN_in=>anode,   --Pass thought from the display wrapper
                leds_in=>segs,  --Pass throught from the display wrapper with dp control logic
                dp_out=>DP,     --Connect to the hardware display points in the 7seg
                AN_out=>AN(3 downto 0), --Connect to the hardware
                leds_out(1)=>CA,
                leds_out(2)=>CB,
                leds_out(3)=>CC,
                leds_out(4)=>CD,
                leds_out(5)=>CE,
                leds_out(6)=>CF,
                leds_out(7)=>CG);
end structural;