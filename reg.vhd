library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg is 
	generic(
		DWidth : integer := 8
	);
	port(
		d : in std_logic_vector(DWidth-1 downto 0);
		clk : in std_logic;
		q : out std_logic_vector(DWidth-1 downto 0)
	);
end reg;

architecture Behavioral of reg is
begin	
	process(clk)
	begin
		if rising_edge(clk) then -- Positive edge 
			q <= d;
		end if;
	end process;
end Behavioral;

