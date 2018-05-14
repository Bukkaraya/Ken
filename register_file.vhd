-- Authors: Sumit, Yannick, Abinav
-- COMPONENT: Register File

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity register_file is generic (
		Dwidth : integer := 16;
		Awidth : integer := 4);
	port (
		write_enable, clk: in std_logic;
		ra_1, ra_2, write_addr: in std_logic_vector(Awidth-1 downto 0);
		write_data: in std_logic_vector(Dwidth-1 downto 0);
		do_1, do_2: out std_logic_vector(Dwidth-1 downto 0)
	);
end register_file;

architecture Behavioral of register_file is
	type memType is array(0 to 2**Awidth-1) of std_logic_vector(Dwidth-1 downto 0);
	signal memory: memType:=(
	x"0000",
	x"0002",
	x"0003",
	others=> x"0000");
begin
	process(clk)
	begin
	   if falling_edge(clk) then
			if (write_enable = '1') then
				memory(conv_integer(write_addr)) <= write_data;
			end if;
		end if;
		if rising_edge(clk) then
				do_1 <= memory(conv_integer(ra_1));
				do_2 <= memory(conv_integer(ra_2));
		end if;
	end process;
end Behavioral;

