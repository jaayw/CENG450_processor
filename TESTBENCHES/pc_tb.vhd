LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY pc_tb IS
END pc_tb;
 
ARCHITECTURE behavior OF pc_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT pc
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
			en : IN std_logic;
			br : IN std_logic;
			Q_in : IN std_logic_vector(6 downto 0);
         Q : OUT  std_logic_vector(6 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
	signal en : std_logic := '0';
	signal br : std_logic := '0';
	signal Q_in : std_logic_vector(6 downto 0) := (others => '0');

 	--Outputs
   signal Q : std_logic_vector(6 downto 0);

   -- Clock period definitions
   constant clk_period : time := 100 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: pc PORT MAP (
          clk => clk,
          rst => rst,
			 en => en,
			 br => br,
			 Q_in => Q_in,
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
      
		rst <= '1';
		en <= '0';
		br <= '0';
		Q_in <= "0000111"; -- Can be anything
		-- Expected non-running condition
		-- PC should not be incrementing
		
      wait for 200 us;
		wait until (clk='1' and clk'event);

		rst <= '0';
		en <= '0';
		br <= '0';
		Q_in <= "1110000"; -- Can be anything
		-- Expected non-running condition
		-- rst = 0, en = 0, br = 0
		-- PC should not be incrementing
		
		wait for 200 us;
		wait until (clk='1' and clk'event);
		
		rst <= '1';
		en <= '1';
		br <= '0';
		Q_in <= "0101010"; -- Can be anything
		-- Expected non-running condition
		-- rst = 1, en = 1, br = 0
		-- PC should not be incrementing
		
		wait for 200 us;
		wait until (clk='1' and clk'event);
		
		rst <= '1';
		en <= '1';
		br <= '1';
		Q_in <= "1100011"; -- Can be anything
		-- Expected non-running condition
		-- rst = 1, en = 1, br = 1
		-- PC should not be incrementing
		
		wait for 200 us;
		wait until (clk='1' and clk'event);
		
		rst <= '0';
		en <= '1';
		br <= '0';
		Q_in <= "1100011"; -- Can be anything
		-- Expected running condition (no branch)
		-- rst = 0, en = 1, br = 0
		-- PC should be incrementing
		
		wait for 200 us;
		wait until (clk='1' and clk'event);
		
		rst <= '0';
		en <= '1';
		br <= '1';
		Q_in <= "0011100"; -- Can be anything
		-- Expected running condition (branch taken)
		-- rst = 0, en = 1, br = 1
		-- Q (counter) = 28
		-- PC should be incrementing
		
		wait;
		
   end process;

END;
