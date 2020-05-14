----------------------------------------------------------------------------------
-- Sourced from: vhdlguide, pwkolas
-- URL: https://vhdlguide.com/2016/07/23/edge-detector/
-- Modified by: Randipa
-- Create Date: 13.05.2020 22:16:24
-- Design Name: 
-- Module Name: edge_detector - Behavioral
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
library ieee;
use ieee.std_logic_1164.all;
entity edge_detector is
	port (
		clk : in std_logic;
		d : in std_logic;
		edge : out std_logic
	);
end edge_detector;

architecture behavioural of edge_detector is
	signal reg1 : std_logic;
	signal reg2 : std_logic;
begin
	reg : process (clk)
	begin
		if rising_edge(clk) then
			reg1 <= d;
			reg2 <= reg1;
		end if;
	end process;
	edge <= reg1 and (not reg2);
end behavioural;