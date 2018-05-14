library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity addr_decoder is port(
	opcode : in std_logic_vector(3 downto 0);
	addr : out std_logic_vector(7 downto 0)
);
end addr_decoder;

architecture Behavioral of addr_decoder is
begin
	process(opcode)
	begin
		case opcode is
			when x"0" => addr <= x"04";
			when x"1" => addr <= x"07";
			when x"2" => addr <= x"0a";
			when x"3" => addr <= x"0f";
			when x"4" => addr <= x"12";
			when x"5" => addr <= x"15";
			when others => addr <= x"00";
		end case;
	end process;

end Behavioral;

