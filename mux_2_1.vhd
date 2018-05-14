library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_2_1 is
	generic(Dwidth: integer := 16);
	port( 
		sel : in  std_logic;
      in_1   : in  STD_LOGIC_VECTOR (Dwidth-1 downto 0);
      in_2   : in  STD_LOGIC_VECTOR (Dwidth-1 downto 0);
		mux_out : out std_logic_vector(Dwidth-1 downto 0)
	);
end mux_2_1;

architecture Behavioral of mux_2_1 is
begin
	process(sel, in_1, in_2)
		begin
		case sel is 
			when '0' =>
				mux_out <= in_1;
			when '1' =>
				mux_out <= in_2;
         when others =>
		end case;
	end process;
end Behavioral;

