LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
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
			instr_out : OUT std_logic_vector(15 downto 0);
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
	signal instr_out : std_logic_vector(15 downto 0);
   signal alu_mode : std_logic_vector(2 downto 0);
   signal out_data1 : std_logic_vector(15 downto 0);
   signal out_data2 : std_logic_vector(15 downto 0);
   signal ra_out : std_logic_vector(2 downto 0);

   -- Clock period definitions
   constant clk_period : time := 100 us;
 
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
			 instr_out => instr_out,
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
	
      -- hold reset state for 100 us.
      rst <= '1';
		
      wait for 100 us;
		wait until (clk='0' and clk'event);
		wait until (clk='1' and clk'event);
		
		rst <= '0';
		
		wait until (clk='1' and clk'event);
		
			-- add
			instr_in <= "0000001000000000";
			in_direct <= "1010101000000000";
			in_data1 <= "0000000000001010";
			in_data2 <= "0000000000001011";
			ra_in <= "100";
			cl_in <= "1001";
			
		wait until (clk='1' and clk'event);
		
			-- sub
			instr_in <= "0000010000000000";
			in_direct <= "1010101000000000";
			in_data1 <= "0000000000001010";
			in_data2 <= "0000000000001011";
			ra_in <= "100";
			cl_in <= "1001";
			
		wait until (clk='1' and clk'event);
			
			-- mult
			instr_in <= "0000011000000000";
			in_direct <= "1010101000000000";
			in_data1 <= "0000000000001010";
			in_data2 <= "0000000000001011";
			ra_in <= "100";
			cl_in <= "1001";
			
		wait until (clk='1' and clk'event);
			
			-- nand
			instr_in <= "0000100000000000";
			in_direct <= "1010101000000000";
			in_data1 <= "0000000000001010";
			in_data2 <= "0000000000001011";
			ra_in <= "100";
			cl_in <= "1001";
			
		wait until (clk='1' and clk'event);
		
			-- shl
			instr_in <= "0000101000000000";
			in_direct <= "1010101000001111";
			in_data1 <= "0000000000001010";
			in_data2 <= "0000000000001011";
			ra_in <= "100";
			cl_in <= "1001";
			
		wait until (clk='1' and clk'event);
			
			-- rhl
			instr_in <= "0000110000000000";
			in_direct <= "1010101000000000";
			in_data1 <= "1111101000101010";
			in_data2 <= "0000000000001011";
			ra_in <= "100";
			cl_in <= "1001";
			
		wait until (clk='1' and clk'event);
			
			-- in
			instr_in <= "0100000000000000";
			in_direct <= "1111101000000000";
			in_data1 <= "0000000000001010";
			in_data2 <= "0000000000001011";
			ra_in <= "100";
			cl_in <= "1001";
			
		wait until (clk='1' and clk'event);
			
			-- out
			instr_in <= "0100001000000000";
			in_direct <= "1010101000001111";
			in_data1 <= "0000000000001010";
			in_data2 <= "0000000000001011";
			ra_in <= "100";
			cl_in <= "1001";
			
		wait until (clk='1' and clk'event);
			
			-- nop
			instr_in <= "0000000000000000";
			in_direct <= "1010101000000000";
			in_data1 <= "0000000000001010";
			in_data2 <= "0000000000001011";
			ra_in <= "100";
			cl_in <= "1001";
		
      wait;
   end process;

END;
