library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_3_1 is
	generic(Dwidth: integer := 16);
	port(
		sel : in  STD_LOGIC_VECTOR(1 downto 0);
		in_1   : in  STD_LOGIC_VECTOR (Dwidth-1 downto 0);
		in_2   : in  STD_LOGIC_VECTOR (Dwidth-1 downto 0);
		in_3   : in STD_LOGIC_VECTOR (Dwidth-1 downto 0);
		mux_out : out std_logic_vector(Dwidth-1 downto 0)
	);

end mux_3_1;

architecture Behavioral of mux_3_1 is
begin
	process(in_1, in_2, in_3, sel)
		begin
		case sel is 
			when "00" =>
				mux_out <= in_1;
			when "01" =>
				mux_out <= in_2;
			when "10" =>
				mux_out <= in_3;	
         when others =>
		end case;
	end process;
end Behavioral;

