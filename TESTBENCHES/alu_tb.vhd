LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY alu_tb IS
END alu_tb;
 
ARCHITECTURE behavior OF alu_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT alu
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         in1 : IN  std_logic_vector(15 downto 0);
         in2 : IN  std_logic_vector(15 downto 0);
         opc_in : IN  std_logic_vector(6 downto 0);
         result : OUT  std_logic_vector(15 downto 0);
         z_flag : OUT  std_logic;
         n_flag : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal in1 : std_logic_vector(15 downto 0) := (others => '0');
   signal in2 : std_logic_vector(15 downto 0) := (others => '0');
   signal opc_in : std_logic_vector(6 downto 0) := (others => '0');

 	--Outputs
   signal result : std_logic_vector(15 downto 0);
   signal z_flag : std_logic;
   signal n_flag : std_logic;

   -- Clock period definitions
   constant clk_period : time := 100 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: alu PORT MAP (
          clk => clk,
          rst => rst,
          in1 => in1,
          in2 => in2,
          opc_in => opc_in,
          result => result,
          z_flag => z_flag,
          n_flag => n_flag
        );

   --Clock process definitions
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
		-- Perform reset prior to testing
		rst <= '1';
      wait for 100 us;
		wait until (clk='0' and clk'event);
		wait until (clk='1' and clk'event);
		
		rst <= '0';
		
		wait until (clk='1' and clk'event);
			-- Testing IN (mode: 33)
			opc_in <= "0100001";
			in1 <= "1011101010011111";
			in2 <= "0000000111110100";
			
		wait until (clk='1' and clk'event);
			-- Testing IN (mode: 32)
			opc_in <= "0100000";
			in1 <= "0011101010011001";
			in2 <= "0000000111110101";
		
		wait until (clk='1' and clk'event);
			-- Testing add (mode: 1)
			opc_in <= "0000001";
			in1 <= "0011101010011000";
			in2 <= "0000000111110100";
			-- Result should be:
			-- decimal: 15500 hexa: 3C8C
		
		wait until (clk='1' and clk'event);
			-- Testing sub (mode: 2)
			opc_in <= "0000010";
			in1 <= "0100000001110100";
			in2 <= "0100000001000010";
			-- Result should be:
			-- decimal: 50 hex: 0032
		
		wait until (clk='1' and clk'event);
			-- Testing multi (mode: 3)
			opc_in <= "0000011";
			in1 <= "0000000010011011";
			in2 <= "0000000001111101";
			-- Result should be:
			-- decimal: 19375 hex: 4BAF
		
		wait until (clk='1' and clk'event);
			-- Testing nand (mode: 4)
			opc_in <= "0000100";
			in1 <= "1010101010101010";
			in2 <= "1010101010101010";
			-- Result should be:
			-- decimal: 21845 hexa: 5555
		
		wait until (clk='1' and clk'event);
			-- Testing SHL (mode: 5)
			opc_in <= "0000101";
			in1 <= "0000000000111111";
			in2 <= "0000000000000100"; -- left shift 4
			-- Result should be:
			-- decimal: 1008 hex: 03F0
		
		wait until (clk='1' and clk'event);
			-- Testing SHR (mode: 6)
			opc_in <= "0000110";
			in1 <= "1010100000000000";
			in2 <= "0000000000001000"; -- right shift 8
			-- Result should be"
			-- decimal: 168 hexa: 00A8
			
		wait until (clk='1' and clk'event);
			-- Testing test mode (mode: 7)
			opc_in <= "0000111";
			
		wait until (clk='1' and clk'event);
			-- Testing NOP
			opc_in <= "0000000";
		
      wait;
		
   end process;

END;
