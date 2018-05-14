--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:52:34 04/05/2018
-- Design Name:   
-- Module Name:   T:/Ken5/Ken/ken_test.vhd
-- Project Name:  Ken
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Ken
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY ken_test IS
END ken_test;
 
ARCHITECTURE behavior OF ken_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Ken
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         instruction : IN  std_logic_vector(1 downto 0);
         fibo_number : IN  std_logic_vector(5 downto 0);
         set_fib : IN  std_logic;
         segment : OUT  std_logic_vector(7 downto 0);
         anodes : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal instruction : std_logic_vector(1 downto 0) := (others => '0');
   signal fibo_number : std_logic_vector(5 downto 0) := (others => '0');
   signal set_fib : std_logic := '0';

 	--Outputs
   signal segment : std_logic_vector(7 downto 0);
   signal anodes : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Ken PORT MAP (
          clk => clk,
          reset => reset,
          instruction => instruction,
          fibo_number => fibo_number,
          set_fib => set_fib,
          segment => segment,
          anodes => anodes
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      fibo_number <= "010000";
		set_fib <= '1';
		reset <= '1';
		wait for 20 ns;
		
		set_fib <= '0';
		reset <= '0';
		instruction <= "01";
      wait for clk_period*25;
      -- insert stimulus here 

      wait;
   end process;

END;
