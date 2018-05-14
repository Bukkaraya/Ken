library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU is 
	generic(
		Dwidth : integer := 16);
	port (
		In1, In2 : in std_logic_vector(Dwidth-1 downto 0);
		sel : in std_logic_vector(2 downto 0);
		Alu_out : out std_logic_vector(Dwidth-1 downto 0);
		Cin : in std_logic;
		zero, slt : out std_logic
	);
end ALU;

architecture Behavioral of ALU is
	constant zeros : std_logic_vector(Dwidth-1 downto 0) := (others => '0');
	signal temp : std_logic_vector(Dwidth-1 downto 0);
begin
	process(In1, In2, sel)
	begin
		case sel is
			when "000" =>
				Alu_out <= std_logic_vector(signed(In1) + signed(In2));
			when "001" =>
				temp <= std_logic_vector(signed(In1) - signed(In2));
				if In1 = In2 then
					zero <= '1';
				else
					zero <= '0';
				end if;
				Alu_out <= temp;
			when "010" =>
				Alu_out <= In1 and In2;
			when "011" =>
				Alu_out <= In1 or In2;
			when "100" =>
				if (In1 < In2) then 
					slt <= '1';
					Alu_out <= x"0001";
				else 
					slt <= '0';
					Alu_out <= x"0000";
				end if;
			when others =>
				Alu_out <= x"0000";
		end case;
	end process;
end Behavioral;

