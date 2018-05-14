library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_w_en is 
	generic(
		DWidth : integer := 8
	);
	port(
		d : in std_logic_vector(DWidth-1 downto 0);
		reset : in std_logic;
		en : in std_logic;
		clk : in std_logic;
		q : out std_logic_vector(DWidth-1 downto 0)
	);
end reg_w_en;

architecture Behavioral of reg_w_en is
	constant zeros : std_logic_vector(Dwidth-1 downto 0) := (others => '0');
begin
	process(clk)
	begin
		if reset = '1' then
				q <= zeros;
		elsif rising_edge(clk) then
			if en = '1' then
				q <= d;
			end if;
		end if;
	end process;
end Behavioral;

