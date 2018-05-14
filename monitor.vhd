library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity monitor is  port(
	opcode : in std_logic_vector(3 downto 0);
	clk : in std_logic;
	addr: in std_logic_vector(7 downto 0);
	segment: out std_logic_vector(7 downto 0);
	anodes: out std_logic_vector(3 downto 0)
);
end monitor;

architecture Behavioral of monitor is

begin


end Behavioral;

