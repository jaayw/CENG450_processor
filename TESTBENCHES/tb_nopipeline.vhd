LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_nopipeline IS
END tb_nopipeline;
 
ARCHITECTURE behavior OF tb_nopipeline IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT cpu
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         en : IN  std_logic;
         z_flag : OUT  std_logic;
         n_flag : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal en : std_logic := '0';

 	--Outputs
   signal z_flag : std_logic;
   signal n_flag : std_logic;

   -- Clock period definitions
   constant clk_period : time := 100 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: cpu PORT MAP (
          clk => clk,
          rst => rst,
          en => en,
          z_flag => z_flag,
          n_flag => n_flag
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
		rst <= '1';
		en <= '0';
		z_flag <= '0';
		n_flag <= '0';
		wait for 50 us;
		wait until (clk='0' and clk'event);
		wait until (clk='1' and clk'event);
		
		rst <= '0';
		
		wait until (clk='1' and clk'event);
		
		en <= '1';
		
      wait;
   end process;

END;
