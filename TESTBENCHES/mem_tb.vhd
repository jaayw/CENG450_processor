LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY mem_tb IS
END mem_tb;
 
ARCHITECTURE behavior OF mem_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT mem
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         instr_in : IN  std_logic_vector(15 downto 0);
         ra_in : IN  std_logic_vector(2 downto 0);
         result_in : IN  std_logic_vector(15 downto 0);
         z_in : IN  std_logic;
         n_in : IN  std_logic;
         ra_out : OUT  std_logic_vector(2 downto 0);
         result_out : OUT  std_logic_vector(15 downto 0);
         wr_en : OUT  std_logic;
         z_out : OUT  std_logic;
         n_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal instr_in : std_logic_vector(15 downto 0) := (others => '0');
   signal ra_in : std_logic_vector(2 downto 0) := (others => '0');
   signal result_in : std_logic_vector(15 downto 0) := (others => '0');
   signal z_in : std_logic := '0';
   signal n_in : std_logic := '0';

 	--Outputs
   signal ra_out : std_logic_vector(2 downto 0);
   signal result_out : std_logic_vector(15 downto 0);
   signal wr_en : std_logic;
   signal z_out : std_logic;
   signal n_out : std_logic;

   -- Clock period definitions
   constant clk_period : time := 100 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: mem PORT MAP (
          clk => clk,
          rst => rst,
          instr_in => instr_in,
          ra_in => ra_in,
          result_in => result_in,
          z_in => z_in,
          n_in => n_in,
          ra_out => ra_out,
          result_out => result_out,
          wr_en => wr_en,
          z_out => z_out,
          n_out => n_out
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
		wait until (clk='1' and clk'event);

      -- insert stimulus here
         instr_in <= "0100000010111101";
         ra_in <= "010";
         result_in <= "1010000000000111";
         z_in <= '0';
         n_in <= '1';
		
		wait until (clk='1' and clk'event);
		
			instr_in <= "0001111101111010";
         ra_in <= "011";
         result_in <= "1110000111000111";
         z_in <= '1';
         n_in <= '0';
		
      wait;
   end process;

END;
