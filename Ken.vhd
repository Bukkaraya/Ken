library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Ken is port(
	clk: in std_logic;
	reset : in std_logic;
	instruction : in std_logic_vector(1 downto 0);
	fibo_number : in std_logic_vector(5 downto 0);
	set_fib : in std_logic;
	segment : out std_logic_vector(7 downto 0);
	anodes : out std_logic_vector(3 downto 0)
);
end Ken;

architecture Behavioral of Ken is
-- Component Declarations
	
	
	-- 3-1 Multiplexer
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
	
	
	-- 2-1 Multiplexer
	component mux_2_1 generic(
			Dwidth: integer := 16);
		port( 
				sel : in  std_logic;
				in_1   : in  STD_LOGIC_VECTOR (Dwidth-1 downto 0);
				in_2   : in  STD_LOGIC_VECTOR (Dwidth-1 downto 0);
				mux_out : out std_logic_vector(Dwidth-1 downto 0)
		);
	end component;
	
	component pc_reg generic(
			DWidth : integer := 8
		);
		port(
			instruction : in std_logic_vector(1 downto 0);
			d : in std_logic_vector(DWidth-1 downto 0);
			reset : in std_logic;
			en : in std_logic;
			clk : in std_logic;
			q : out std_logic_vector(DWidth-1 downto 0)
		);
	end component;
	
	-- Instruction Memory
	component instruction_memory generic (
			Dwidth : integer := 16;
			Awidth : integer := 8
		);
		port(
			read_addr: in std_logic_vector(Awidth-1 downto 0);
			data_out: out std_logic_vector(Dwidth-1 downto 0)
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
	
	
	-- Register
	component reg generic(
			DWidth : integer := 8
		);
		port(
			d : in std_logic_vector(DWidth-1 downto 0);
			clk : in std_logic;
			q : out std_logic_vector(DWidth-1 downto 0)
		);
	end component;
	
	
	-- Register File
	component register_file generic (
			Dwidth : integer := 16;
			Awidth : integer := 4);
		port (
			write_enable, clk: in std_logic;
			ra_1, ra_2, write_addr: in std_logic_vector(Awidth-1 downto 0);
			write_data: in std_logic_vector(Dwidth-1 downto 0);
			do_1, do_2: out std_logic_vector(Dwidth-1 downto 0)
		);
	end component;
	
	
	-- Sign Extender
	component sign_extender generic(
			Inwidth : integer := 4;
			Outwidth : integer := 16
		);
		port(
			bus_in : in std_logic_vector(Inwidth-1 downto 0);
			bus_out : out std_logic_vector(Outwidth-1 downto 0)
		);
	end component;
	
	
	-- ALU
	component ALU generic(
			Dwidth : integer := 16);
		port (
			In1, In2 : in std_logic_vector(Dwidth-1 downto 0);
			sel : in std_logic_vector(2 downto 0);
			Alu_out : out std_logic_vector(Dwidth-1 downto 0);
			Cin : in std_logic;
			zero, slt : out std_logic
		);
	end component;
	
	
	-- Data Memory
	component data_memory generic (
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
	end component;
	
	
	-- Microprogrammed Control Unit
	component microsequencer port(
		opcode : in std_logic_vector(3 downto 0);
		reset : in std_logic;
		clk : in std_logic;
		u_instruction : out std_logic_vector(15 downto 0)
	);
	end component;
	
	component clkseg port(
		mclk: in std_logic;
		numbers : in std_logic_vector(15 downto 0);
		segment: out std_logic_vector(7 downto 0);
		anodes: out std_logic_vector(3 downto 0)
	);
	end component;
	
	
-- Component Declarations End

-- Signal Declaration

	-- Control Signals
	signal control_signals : std_logic_vector(15 downto 0);
	signal pcsource : std_logic_vector(1 downto 0);
	signal pc_en : std_logic;
	signal pc_write : std_logic;
	signal pc_write_cond : std_logic;
	signal ir_write : std_logic;
	signal addr_sel, wd_sel : std_logic;
	signal reg_write : std_logic;
	signal alu_srcA : std_logic;
	signal alu_srcB : std_logic_vector(1 downto 0);
	signal alu_op : std_logic_vector(2 downto 0);
	signal mem_write: std_logic;
	
	-- PC Signals
	signal jump_pc : std_logic_vector(15 downto 0);
	signal pc_in : std_logic_vector(15 downto 0);
	
	-- Instruction Memory Signals
	signal im_in : std_logic_vector(15 downto 0);
	signal im_out : std_logic_vector(15 downto 0);
	
	-- Instruction Register Signals
	signal ir_in : std_logic_vector(15 downto 0);
	signal ir_out : std_logic_vector(15 downto 0);
	signal opcode : std_logic_vector(3 downto 0);
	
	-- Register File Mux Signals
	signal rs_addr, rt_addr, rd_addr : std_logic_vector(3 downto 0);
	signal addr_sel_mux : std_logic_vector(3 downto 0);
	signal write_data_mux : std_logic_vector(15 downto 0);
	
	-- Sign Extension Signals
	signal sign_ext_out : std_logic_vector(15 downto 0);
	
	-- Register File Signals
	signal do_1, do_2 : std_logic_vector(15 downto 0);
	
	-- Register A and B Signals
	signal A_out, B_out : std_logic_vector(15 downto 0);
	
	-- ALU Mux Signals
	signal alu_A, alu_B : std_logic_vector(15 downto 0);
	
	-- ALU Signals
	signal alu_out : std_logic_vector(15 downto 0);
	signal zero, slt : std_logic;
	
	-- ALUOut Register Signals
	signal a_reg_out : std_logic_vector(15 downto 0);
	
	-- Data Memory Signals
	signal data_mem_out : std_logic_vector(15 downto 0);
	
	-- MDR Signals
	signal mdr_out : std_logic_vector(15 downto 0);
	
	-- 7 Segment Display Signals
	signal ken_out : std_logic_vector(15 downto 0);

-- Signal Declaration End
begin
	PC_MUX: mux_3_1 port map(
		pcsource, jump_pc, alu_out, a_reg_out, pc_in
	);
	
	PC: pc_reg generic map(16)
	port map(
		instruction ,pc_in, reset, pc_en, clk, im_in
	);
	
	IM: instruction_memory port map(
		im_in(7 downto 0), im_out
	);
	
	IR: reg_w_en generic map(16)
	port map(
		im_out, reset, ir_write, clk, ir_out
	);
	
	jump_pc <= im_in(15 downto 12) & ir_out(11 downto 0);
	
	opcode <= ir_out(15 downto 12);
	rd_addr <= ir_out(11 downto 8);
	rs_addr <= ir_out(7 downto 4);
	rt_addr <= ir_out(3 downto 0);
	
	CONTROL: microsequencer port map(
		opcode, reset, clk, control_signals
	);
	
	pcsource <= control_signals(15 downto 14);	
	pc_write <= control_signals(13);
	pc_write_cond <= control_signals(12);
	ir_write <= control_signals(11);
	addr_sel <= control_signals(10);
	wd_sel <= control_signals(9);
	reg_write <= control_signals(8);
	alu_srcA <= control_signals(7);
	alu_srcB <= control_signals(6 downto 5);
	alu_op <= control_signals(4 downto 2);
	mem_write <= control_signals(1);
	
	pc_en <= pc_write or (pc_write_cond and zero);	
	
	ADDR_MUX: mux_2_1 generic map(4)
	port map(
		addr_sel, rt_addr, rd_addr, addr_sel_mux
	);
	
	WD_MUX: mux_2_1 port map(
		wd_sel, mdr_out, a_reg_out, write_data_mux
	);
	
	
	REG_FILE: register_file generic map(16, 4)
	port map(
		reg_write, clk, rs_addr, addr_sel_mux, rd_addr, write_data_mux, do_1, do_2
	);
	
	
	SIGN_EXT: sign_extender generic map(4, 16)
	port map(
		rt_addr, sign_ext_out
	);
	
	
	REG_A: reg generic map(16)
	port map(
		do_1, clk, A_out
	);
	
	REG_B: reg generic map(16)
	port map(
		do_2, clk, B_out
	);
	
	ALU_A_MUX: mux_2_1 generic map(16)
	port map(
		alu_srcA, im_in, A_out, alu_A
	);
	
	ALU_B_MUX: mux_3_1 generic map(16)
	port map(
		alu_srcB, B_out, sign_ext_out, x"0001", alu_B
	);
	
	M_ALU: ALU generic map(16)
	port map(
		alu_A, alu_B, alu_op, alu_out, '0', zero, slt
	);
	
	
	ALU_REG: reg generic map(16)
	port map(
		alu_out, clk, a_reg_out
	);
	
	
	DATA_MEM: data_memory port map(
		clk, mem_write, fibo_number, set_fib, a_reg_out(7 downto 0), B_out, data_mem_out, ken_out
	);
	
	
	MDR: reg generic map(16)
	port map(
		data_mem_out, clk, mdr_out
	);
	
	DIG_DISP: clkseg port map(
		clk, ken_out, segment, anodes
	);
	
end Behavioral;

