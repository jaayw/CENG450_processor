LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL; 
USE work.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY RF8_16TB IS
END RF8_16TB;
 
ARCHITECTURE behavior OF RF8_16TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT register_file
    PORT(
         rst : IN  std_logic;
         clk : IN  std_logic;
         rd_index1 : IN  std_logic_vector(2 downto 0);
         rd_index2 : IN  std_logic_vector(2 downto 0);
         rd_data1 : OUT  std_logic_vector(15 downto 0);
         rd_data2 : OUT  std_logic_vector(15 downto 0);
         wr_index : IN  std_logic_vector(2 downto 0);
         wr_data : IN  std_logic_vector(15 downto 0);
         wr_enable : IN  std_logic
        );
    END COMPONENT;
    
   --Inputs
   signal rst : std_logic;
   signal clk : std_logic;
   signal rd_index1 : std_logic_vector(2 downto 0);
   signal rd_index2 : std_logic_vector(2 downto 0);
   signal wr_index : std_logic_vector(2 downto 0);
   signal wr_data : std_logic_vector(15 downto 0);
   signal wr_enable : std_logic;

 	--Outputs
   signal rd_data1 : std_logic_vector(15 downto 0);
   signal rd_data2 : std_logic_vector(15 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT) - u0
   u0: register_file PORT MAP (
          rst => rst,
          clk => clk,
          rd_index1 => rd_index1,
          rd_index2 => rd_index2,
          rd_data1 => rd_data1,
          rd_data2 => rd_data2,
          wr_index => wr_index,
          wr_data => wr_data,
          wr_enable => wr_enable
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for 50 us;
		clk <= '1';
		wait for 50 us;
   end process;
 
   -- Stimulus process
   process begin		
		rst <= '1';
		rd_index1 <= "000";
		rd_index2 <= "000";
		wr_enable <= '0';
		wr_index <= "000";
		wr_data <= X"0000";
		wait until (clk='0' and clk'event);
		wait until (clk='1' and clk'event);
		wait until (clk='1' and clk'event);
		rst <= '0';
		wait until (clk='1' and clk'event); wr_enable <= '1'; wr_data <= X"200a";
		wait until (clk='1' and clk'event); wr_index <= "001"; wr_data <= X"0037";
		wait until (clk='1' and clk'event); wr_index <= "010"; wr_data <= X"8b00";
		wait until (clk='1' and clk'event); wr_index <= "101"; wr_data <= X"f00d";
		wait until (clk='1' and clk'event); wr_index <= "110"; wr_data <= X"00fd";
		wait until (clk='1' and clk'event); wr_index <= "111"; wr_data <= X"fd00";
		wait until (clk='1' and clk'event); wr_enable <= '0';
		wait until (clk='1' and clk'event); rd_index2 <= "001";
		wait until (clk='1' and clk'event); rd_index1 <= "010";
		wait until (clk='1' and clk'event); rd_index2 <= "101";
		wait until (clk='1' and clk'event); rd_index1 <= "110";
		rd_index2 <= "111"; wait;
   end process;

END;
