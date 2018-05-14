library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity controlrom is
generic (
	Dwidth : integer := 20;
	Awidth : integer := 8
);
port(
	addr: in std_logic_vector(Awidth-1 downto 0);
	clk, reset : in std_logic;
	dout: out std_logic_vector(Dwidth-1 downto 0)
);
end controlrom;

-- Extend this to get the micro operation and select lines seperately

architecture Behavioral of controlrom is 
	constant zeros : std_logic_vector(Dwidth-1 downto 0) := (others => '0');	

	type memType is array(0 to 2**Awidth-1) of std_logic_vector(Dwidth-1 downto 0);
	signal memory: memType:= (
		x"06840",
		x"40000",
		x"20000",
		x"20000",
		x"00000", 
		x"00080",
		x"10300",
		x"00400",
		x"000A0",
		x"10002",
		x"00400",
		x"000A0",
		x"00000",
		x"00000",
		x"10100",
		x"004A0",
		x"00000",
		x"19084",
		x"00000", 
		x"000a0",
		x"10300",
		x"00000",
		x"10000",
		x"02000",
		x"12000",
		others => x"00000");
begin
	process(clk)
	begin
		if reset = '1' then
			dout <= zeros;
		elsif rising_edge(clk) then
			dout <= memory(conv_integer(addr));
		end if;
	end process;
end Behavioral;

