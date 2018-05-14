library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity instruction_memory is
	generic (
		Dwidth : integer := 16;
		Awidth : integer := 8
	);
	port(
		read_addr: in std_logic_vector(Awidth-1 downto 0);
		data_out: out std_logic_vector(Dwidth-1 downto 0)
	);
end instruction_memory;


architecture Behavioral of instruction_memory is
	type memType is array(0 to 2**Awidth-1) of std_logic_vector(Dwidth-1 downto 0);
	signal memory: memType:= (
	x"4705", -- addi $7, $0, 5
	x"2270", -- lw $2, 0($7)
	x"4101", -- addi $1, $0, 1
	x"4300", -- addi $3, $0, 0
	x"1100", -- sw $1, 0($0)
	x"1110", -- sw $1, 0($1)
	x"4220", -- addi $2, $2, 0
--LOOP
	x"2430", -- lw $4, 0($3) 
	x"2531", -- lw $5, 1($3)
	x"0645", -- add $6, $4, $5
	x"1632", -- sw $6, 2($3)
	x"4331", -- addi $3, $3, 1
	-- Equal
	x"3321", -- beq $3, $2, Exit 
	x"5007", -- j Loop
-- Exit
	x"500c", -- j Equal






-- Level 2 Starts Here (Instruction: f)
	-- These are for reference
	x"4705", 
	x"2270",	-- Load n from memory into register 2
	x"4300", -- Set Reg 3 to 0
--LOOP
	x"0663",
	x"4301",
	x"3321", -- Check if 2 and 3 are the same
	x"5012", -- If not equal jump to beginning of loop
	x"1620",
	x"5015",
	--x"0312",
	--x"2510",
	--x"3121",
	--x"4437",
	--x"5003",
	others => x"0000");
begin
	data_out <= memory(conv_integer(read_addr));
end Behavioral;
