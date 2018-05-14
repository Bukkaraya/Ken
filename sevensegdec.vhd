library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity sevensegdec is port(
	a: in std_logic_vector(3 downto 0);
	b: out std_logic_vector(7 downto 0)
);
end sevensegdec;

architecture Behavioral of sevensegdec is

begin
	process(a)
	begin
		case a is
			when "0000" => b <= "11000000";
			when "0001" => b <= "11111001";
			when "0010" => b <= "10100100";
			when "0011" => b <= "10110000";
			when "0100" => b <= "10011001";
			when "0101" => b <= "10010010";
			when "0110" => b <= "10000010";
			when "0111" => b <= "11111000";
			when "1000" => b <= "10000000";
			when "1001" => b <= "10011000";
			when "1010" => b <= "10001000";
			when "1011" => b <= "10000011";
			when "1100" => b <= "11000110";
			when "1101" => b <= "10100001";
			when "1110" => b <= "10000110";
			when "1111" => b <= "10001110";
			when others => b <= "10111111";
		end case;
		b(7) <= '1'; -- Add decimal point based on input
	end process;
	
	
end Behavioral;

