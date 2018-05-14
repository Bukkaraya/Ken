library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity clkseg is port(
	mclk: in std_logic;
	numbers : in std_logic_vector(15 downto 0);
	segment: out std_logic_vector(7 downto 0);
	anodes: out std_logic_vector(3 downto 0)
);
end clkseg;

architecture Behavioral of clkseg is
	COMPONENT sevensegdec PORT(
		a: in std_logic_vector(3 downto 0);
		b: out std_logic_vector(7 downto 0)
	);
	end COMPONENT;
	signal temp_anodes : std_logic_vector(3 downto 0);
	signal clkdiv : std_logic_vector(10 downto 0);
	signal cur_num : std_logic_vector(3 downto 0);
begin
	process (mclk)
	begin
		if mclk = '1' and mclk'Event then
			clkdiv <= clkdiv + 1;
		end if;
	end process;
	
	process(clkdiv(10))
	begin
	temp_anodes <= "0000";
	if clkdiv(10) = '1' and clkdiv(10)'Event then
		case temp_anodes is
			when "1110" =>
				temp_anodes <= "1101";
				cur_num <= numbers(7 downto 4);
			when "1101" =>
				temp_anodes <= "1011";
				cur_num <= numbers(11 downto 8);
			when "1011" =>
				temp_anodes <= "0111";
				cur_num <= numbers(15 downto 12);
			when "0111" =>
				temp_anodes <= "1110";
				cur_num <= numbers(3 downto 0);
			when others =>
				temp_anodes <= "1110";
				cur_num <= numbers(3 downto 0);
		end case;
	end if;
	end process;
	
	anodes <= temp_anodes;
	SEG0: sevensegdec PORT MAP(
			a => cur_num(3 downto 0),
			b => segment
	);

end Behavioral;