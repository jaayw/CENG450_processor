LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY pc_tb IS
END pc_tb;
 
ARCHITECTURE behavior OF pc_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT pc
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
			-- br : IN std_logic;
			en : IN std_logic;
			-- Q_in : IN std_logic_vector(6 downto 0);
         Q : OUT  std_logic_vector(6 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
	-- br : IN std_logic;
	signal en : std_logic := '0';
	-- Q_in : IN std_logic_vector(6 downto 0);

 	--Outputs
   signal Q : std_logic_vector(6 downto 0);

   -- Clock period definitions
   constant clk_period : time := 100 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: pc PORT MAP (
          clk => clk,
          rst => rst,
			 -- br : IN std_logic;
			 en => en,
			-- Q_in : IN std_logic_vector(6 downto 0);
          Q => Q
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
		rst <= '1';
		en <= '0';
		-- Nothing should be running
		
      wait for 100 us;
		wait until (clk='1' and clk'event);

		rst <= '0';
		en <= '0';
		-- Again, nothing should be running
		
		wait for 100 us;
		wait until (clk='1' and clk'event);
		
		rst <= '1';
		en <= '1';
		-- Again, nothing should be running
		
		wait for 100 us;
		wait until (clk='1' and clk'event);
		
		rst <= '0';
		en <= '1';
		-- Running condition, PC should be incrementing
		
		wait;
		
   end process;

END;
