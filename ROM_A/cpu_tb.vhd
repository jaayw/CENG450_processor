LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY cpu_tb IS
END cpu_tb;
 
ARCHITECTURE behavior OF cpu_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT cpu
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         in_data : IN  std_logic_vector(15 downto 0);
         out_data : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal in_data : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal out_data : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 100 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: cpu PORT MAP (
          clk => clk,
          rst => rst,
          in_data => in_data,
          out_data => out_data
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
		
		wait for 200 us;
		
		wait until (clk='0' and clk'event);
		wait until (clk='1' and clk'event);
		
		
			in_data <= "0000000000000100"; -- input 4
			
		wait until (clk='1' and clk'event);
		
			in_data <= "0000000000000110"; -- input 6
			
		wait until (clk='1' and clk'event);
		
			in_data <= "0000000000001000"; -- input 8
		
			-- Wait until in_data required
			-- IN instr
			-- R1: 4, R2: 6, R3: 8
			
			-- ADD instr
			-- Result: 000a -> R3: 000a
			-- R1: 4, R2: 6
			
			-- SHL instr
			-- Result: 0028 -> R3: 0028
			-- R1: 4, R2: 6
			
			-- MULT instr
			-- Result: 00a0 -> R2: 00a0
			-- R1: 4, R3: 0028
			
			-- OUT instr
			-- Result: 00a0
			-- R1: 4, R2: 00a0, R3: 0028
			
		wait;
      
   end process;

END;
