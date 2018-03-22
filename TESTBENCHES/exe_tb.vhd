--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:02:04 03/21/2018
-- Design Name:   
-- Module Name:   E:/Documents/Xilinx/CENG450_processor/TESTBENCHES/exe_tb.vhd
-- Project Name:  CENG450_processor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: execute
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
 
ENTITY exe_tb IS
END exe_tb;
 
ARCHITECTURE behavior OF exe_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT execute
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         instr_in : IN  std_logic_vector(15 downto 0);
         in_direct : IN  std_logic_vector(15 downto 0);
         in_data1 : IN  std_logic_vector(15 downto 0);
         in_data2 : IN  std_logic_vector(15 downto 0);
         ra_in : IN  std_logic_vector(2 downto 0);
         cl_in : IN  std_logic_vector(3 downto 0);
         alu_mode : OUT  std_logic_vector(2 downto 0);
         out_data1 : OUT  std_logic_vector(15 downto 0);
         out_data2 : OUT  std_logic_vector(15 downto 0);
         ra_out : OUT  std_logic_vector(2 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal instr_in : std_logic_vector(15 downto 0) := (others => '0');
   signal in_direct : std_logic_vector(15 downto 0) := (others => '0');
   signal in_data1 : std_logic_vector(15 downto 0) := (others => '0');
   signal in_data2 : std_logic_vector(15 downto 0) := (others => '0');
   signal ra_in : std_logic_vector(2 downto 0) := (others => '0');
   signal cl_in : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal alu_mode : std_logic_vector(2 downto 0);
   signal out_data1 : std_logic_vector(15 downto 0);
   signal out_data2 : std_logic_vector(15 downto 0);
   signal ra_out : std_logic_vector(2 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: execute PORT MAP (
          clk => clk,
          rst => rst,
          instr_in => instr_in,
          in_direct => in_direct,
          in_data1 => in_data1,
          in_data2 => in_data2,
          ra_in => ra_in,
          cl_in => cl_in,
          alu_mode => alu_mode,
          out_data1 => out_data1,
          out_data2 => out_data2,
          ra_out => ra_out
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
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
