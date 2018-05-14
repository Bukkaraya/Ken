library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
	

entity sign_extender is 
	generic(
		Inwidth : integer := 4;
		Outwidth : integer := 16
	);
	port(
		bus_in : in std_logic_vector(Inwidth-1 downto 0);
		bus_out : out std_logic_vector(Outwidth-1 downto 0)
	);
end sign_extender;

architecture Behavioral of sign_extender is
begin
	bus_out <= std_logic_vector(resize(signed(bus_in), bus_out'length));	
end Behavioral;

