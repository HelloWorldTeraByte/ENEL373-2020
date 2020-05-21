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
		clk : in std_logic; --Main clock input
		d : in std_logic;	--The data to be edge detected
		edge : out std_logic --The edge output, The output pulse lasts one clock cycle
	);
end edge_detector;

--Use two flip flops to detect the rising edge of the input
--First FF is used to synchronize the asynchronous input
--Second FF detects the rising edge and only outputs a pulse for a clock cycle
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