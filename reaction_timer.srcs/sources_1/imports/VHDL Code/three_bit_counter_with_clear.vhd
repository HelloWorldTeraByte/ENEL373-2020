library IEEE;
-- As discussed in Lecture 8 of ENEL373, 2019
-- ------------------------------------------
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- this is needed for the adder
-- i.e., the "+"
 
-- external (to the FPGA) input and output connections
entity counter_3bit is
	port (
		Clock, CLR : in std_logic;
		Q : out std_logic_vector(2 downto 0)
	);
end counter_3bit;
 
architecture behav of counter_3bit is 
	constant clk_limit : std_logic_vector(2 downto 0) := "111";
	signal tmp : std_logic_vector(2 downto 0); -- internal to FPGA
	-- note, "in" or "out" 
	-- are invalid
	-- you can also define components here, and only here.
 
begin
	process (Clock, CLR) -- if either of these signals change,
	-- run this process
	begin
		if (CLR = '1') then -- this is an asynchronous clear
 
			tmp <= "000"; 
 
		elsif (Clock'EVENT and Clock = '1') then
			if tmp = clk_limit then
				tmp <= "000";
			else
				tmp <= tmp + 1; -- Counters uses flip-flops to
				-- "remember" the last count,
				-- which can then be added to.
			end if;
		end if; 
 
	end process;
 
	Q <= tmp; -- lastly, copy this internal vector to the output
 
end behav;