LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY memory_tb IS
END memory_tb;
 
ARCHITECTURE behavior OF memory_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT memory
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         addr : IN  std_logic_vector(6 downto 0);
         wr_en_mem : IN  std_logic;
         wr_data : IN  std_logic_vector(15 downto 0);
         data_out : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal addr : std_logic_vector(6 downto 0) := (others => '0');
   signal wr_en_mem : std_logic := '0';
   signal wr_data : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal data_out : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 100 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: memory PORT MAP (
          clk => clk,
          rst => rst,
          addr => addr,
          wr_en_mem => wr_en_mem,
          wr_data => wr_data,
          data_out => data_out
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
		wait until (clk='1' and clk'event);
		
		rst <= '0';
		
		wait until (clk='1' and clk'event);
		wait until (clk='1' and clk'event);

      -- Write to memory
		
		wr_en_mem <= '1';
		
		addr <= "0000000";
		wr_data <= X"000a";
		
		wait until (clk='1' and clk'event);
		
		addr <= "0000001";
		wr_data <= X"000b";
		
		wait until (clk='1' and clk'event);
		
		addr <= "0000010";
		wr_data <= X"000c";
		
		wait until (clk='1' and clk'event);
		
		addr <= "0000011";
		wr_data <= X"000d";
		
		wait until (clk='1' and clk'event);
		
		addr <= "0000100";
		wr_data <= X"000e";
		
		wait until (clk='1' and clk'event);
		
		addr <= "0000101";
		wr_data <= X"000f";
		
		wait until (clk='1' and clk'event);
		
		-- Read from memory
		
		wr_en_mem <= '0';
		
		addr <= "0000000";

		wait until (clk='1' and clk'event);
		
		addr <= "0000001";

		wait until (clk='1' and clk'event);
		
		addr <= "0000010";

		wait until (clk='1' and clk'event);
		
		addr <= "0000011";

		wait until (clk='1' and clk'event);
		
		addr <= "0000100";

		wait until (clk='1' and clk'event);
		
		addr <= "0000101";

      wait;
   end process;

END;
