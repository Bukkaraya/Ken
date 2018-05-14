library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity microsequencer is port(
	opcode : in std_logic_vector(3 downto 0);
	reset : in std_logic;
	clk : in std_logic;
	u_instruction : out std_logic_vector(15 downto 0)
);
end microsequencer;

architecture Behavioral of microsequencer is

	-- Component Declarations
	
	-- Control ROM Component Declaration
	component controlrom is 
	generic(
		Dwidth : integer := 20;
		Awidth : integer := 8
	);
	port(
		addr: in std_logic_vector(Awidth-1 downto 0);
		clk, reset : in std_logic;
		dout: out std_logic_vector(Dwidth-1 downto 0)
	);
	end component;
	
	-- Mux Declaration
	component mux_3_1 generic(
			Dwidth: integer := 16);
		port(
			sel : in  STD_LOGIC_VECTOR(1 downto 0);
			in_1   : in  STD_LOGIC_VECTOR (Dwidth-1 downto 0);
			in_2   : in  STD_LOGIC_VECTOR (Dwidth-1 downto 0);
			in_3   : in STD_LOGIC_VECTOR (Dwidth-1 downto 0);
			mux_out : out std_logic_vector(Dwidth-1 downto 0)
		);
	end component;
	
	-- Address decoder Declaration
	component addr_decoder is
	port(
		opcode : in std_logic_vector(3 downto 0);
		addr : out std_logic_vector(7 downto 0)
	);
	end component;
	
	-- Register With Enable
	component reg_w_en generic(
			DWidth : integer := 8
		);
		port(
			d : in std_logic_vector(DWidth-1 downto 0);
			reset : in std_logic;
			en : in std_logic;
			clk : in std_logic;
			q : out std_logic_vector(DWidth-1 downto 0)
		);
	end component;
	
	-- Component Declarations End
	
	-- Signals Declaration
	
	signal op_reg : std_logic_vector(7 downto 0);
	signal mc_out : std_logic_vector(7 downto 0);
	signal addr : std_logic_vector(7 downto 0);
	signal u_addr : std_logic_vector(7 downto 0);
	signal en : std_logic;
	signal sel : std_logic_vector(1 downto 0);
	signal i_out : std_logic_vector(19 downto 0);
	signal next_addr : std_logic_vector(7 downto 0);
	signal op_addr : std_logic_vector(7 downto 0);

	-- Signal Declaration End
begin
	op_reg <= opcode & "0000";
	
	MC: reg_w_en generic map(8)
	port map(
		op_reg, reset, en, clk, mc_out
	);
	
	-- Get the address from the selected opcode
	DEC: addr_decoder port map(
		op_reg(7 downto 4), op_addr
	);
	
	-- Select the correct address for the next micro instruction
	MUX1: mux_3_1 
	generic map(8)
	port map(
		sel, next_addr, x"00", op_addr, addr
	);
	
	
	-- Store the micro instruction address in the register
	U_REG: reg_w_en generic map(8)
	port map(
		addr, reset, '1', clk, u_addr
	);
	
	-- Calculate the next address
	next_addr <= u_addr + 1;
	
	-- Get the instruction from the address in the control ROM
	CROM : controlrom generic map(20, 8)
	port map(
		u_addr, clk, reset, i_out
	);
	
	-- Calculate the controls for mux and enable for next cycle 
	-- Send micro instruction to the 7 segment decoder
	sel <= i_out(17 downto 16);
	en <= i_out(18);
	u_instruction <= i_out(15 downto 0);

end Behavioral;

