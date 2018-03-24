LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY wb_tb IS
END wb_tb;
 
ARCHITECTURE behavior OF wb_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT writeback
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         result_in : IN  std_logic_vector(15 downto 0);
         ra_in : IN  std_logic_vector(2 downto 0);
         wr_en_in : IN  std_logic;
         ra_out : OUT  std_logic_vector(2 downto 0);
         wr_en_out : OUT  std_logic;
         wr_data_out : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal result_in : std_logic_vector(15 downto 0) := (others => '0');
   signal ra_in : std_logic_vector(2 downto 0) := (others => '0');
   signal wr_en_in : std_logic := '0';

 	--Outputs
   signal ra_out : std_logic_vector(2 downto 0);
   signal wr_en_out : std_logic;
   signal wr_data_out : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 100 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: writeback PORT MAP (
          clk => clk,
          rst => rst,
          result_in => result_in,
          ra_in => ra_in,
          wr_en_in => wr_en_in,
          ra_out => ra_out,
          wr_en_out => wr_en_out,
          wr_data_out => wr_data_out
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

      -- insert stimulus here 
			result_in <= "1110000111000111";
         ra_in <= "010";
         wr_en_in <= '1';
			
		wait until (clk='1' and clk'event);

			result_in <= "1010101000000111";
         ra_in <= "111";
         wr_en_in <= '0';

      wait;
   end process;

END;
