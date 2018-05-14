library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity data_memory is 
	generic (
		Dwidth : integer := 16;
		Awidth : integer := 8
	);
	port(
		clk: in std_logic;
		write_enable: in std_logic;
		fibo_number : in std_logic_vector(5 downto 0);
		set_fib : in std_logic;
		addr: in std_logic_vector(Awidth-1 downto 0);
		write_data: in std_logic_vector(Dwidth-1 downto 0);
		data_out: out std_logic_vector(Dwidth-1 downto 0);
		fib_out : out std_logic_vector(Dwidth-1 downto 0)
	);
end data_memory;

architecture Behavioral of data_memory is
	constant zeros_less : std_logic_vector(Dwidth-7 downto 0) := (others => '0');

	type memType is array(0 to 2**Awidth-1) of std_logic_vector(Dwidth-1 downto 0);
	signal memory: memType:=(others=> x"0000");
begin
	process(clk, fibo_number)
	begin
		if set_fib = '1' then
			memory(5) <= zeros_less & fibo_number;
		end if;
	   if rising_edge(clk) then
			if (write_enable = '1') then
				memory(conv_integer(addr)) <= write_data;
			else
				data_out <= memory(conv_integer(addr));
			end if;
		end if;
		fib_out <= memory(conv_integer(zeros_less & fibo_number));
	end process;
end Behavioral;

