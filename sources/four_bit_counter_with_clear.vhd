library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- this is needed for the adder
-- i.e., the "+"
 
-- external (to the FPGA) input and output connections
entity counter_4bit is
	port (
	    EN : in std_logic := '1';
		Clock : in std_logic;
		CLR : in std_logic := '0';
		clk_out : out std_logic;
		Q : out std_logic_vector(3 downto 0)
		);
end counter_4bit;
 
architecture behav of counter_4bit is 
	constant clk_limit : std_logic_vector(3 downto 0) := X"9";
	signal tmp : std_logic_vector(3 downto 0) := "0000"; -- internal to FPGA
	-- note, "in" or "out" 
	-- are invalid
	-- you can also define components here, and only here.
 
begin
	process (Clock, CLR, EN) -- if either of these signals change,
	-- run this process
	begin
		if (CLR = '1') then -- this is an asynchronous clear
			tmp <= "0000"; 
		elsif (EN = '1') then
			if (Clock'EVENT and Clock = '1') then
				if tmp = clk_limit then
					tmp <= "0000";
					clk_out <= '1'; 
				else
						clk_out <= '0';
						tmp <= tmp + 1; -- Counters uses flip-flops to
						-- "remember" the last count,
						-- which can then be added to.
				end if;
			end if; 
		end if;
 
	end process;
 
	Q <= tmp; -- lastly, copy this internal vector to the output
 
end behav;