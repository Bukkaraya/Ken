library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pc_reg is 
	generic(
		DWidth : integer := 8
	);
	port(
		instruction : in std_logic_vector(1 downto 0);
		d : in std_logic_vector(DWidth-1 downto 0);
		reset : in std_logic;
		en : in std_logic;
		clk : in std_logic;
		q : out std_logic_vector(DWidth-1 downto 0)
	);
end pc_reg;

architecture Behavioral of pc_reg is
	constant zeros : std_logic_vector(Dwidth-1 downto 0) := (others => '0');
begin
	process(clk, instruction)
	begin
		if reset = '1' then
				if instruction = "00" then
					q <= zeros;
				elsif instruction = "01" then
					q <= x"000f";
				else
					q <= x"0000";
				end if;
		elsif rising_edge(clk) then
			if en = '1' then
				q <= d;
			end if;
		end if;
	end process;
end Behavioral;

