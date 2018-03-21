LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY fetch_decode_tb IS
END fetch_decode_tb;
 
ARCHITECTURE behavior OF fetch_decode_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT fetch_decode
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         instr_in : IN  std_logic_vector(15 downto 0);
         ra_out : OUT  std_logic_vector(2 downto 0);
         rb_out : OUT  std_logic_vector(2 downto 0);
         rc_out : OUT  std_logic_vector(2 downto 0);
         cl_out : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal instr_in : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal ra_out : std_logic_vector(2 downto 0);
   signal rb_out : std_logic_vector(2 downto 0);
   signal rc_out : std_logic_vector(2 downto 0);
   signal cl_out : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 100 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: fetch_decode PORT MAP (
          clk => clk,
          rst => rst,
          instr_in => instr_in,
          ra_out => ra_out,
          rb_out => rb_out,
          rc_out => rc_out,
          cl_out => cl_out
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
		
      wait for 100 us;
		wait until (clk='0' and clk'event);
		wait until (clk='1' and clk'event);
		
		rst <= '0';
		
		wait until (clk='1' and clk'event);

      -- input instructions
		instr_in <= "0000000000000000"; -- nop
		-- Expected outputs:
		-- ra_out => 000
		-- rb_out => 000
		-- rc_out => 000
		-- cl_out => 0000
		
		wait until (clk='1' and clk'event);
		
		instr_in <= "0000001100101111"; -- add
		-- Expected outputs:
		-- ra_out => 100
		-- rb_out => 101
		-- rc_out => 111
		-- cl_out => 0000
		
		wait until (clk='1' and clk'event);
		
		instr_in <= "0000010011010001"; -- sub
		-- Expected outputs:
		-- ra_out => 011
		-- rb_out => 010
		-- rc_out => 001
		-- cl_out => 0000
		
		wait until (clk='1' and clk'event);
		
		instr_in <= "0000011000011111"; -- mult
		-- Expected outputs:
		-- ra_out => 000
		-- rb_out => 011
		-- rc_out => 111
		-- cl_out => 0000
		
		wait until (clk='1' and clk'event);
		
		instr_in <= "0000100100001000"; -- nand
		-- Expected outputs:
		-- ra_out => 100
		-- rb_out => 001
		-- rc_out => 000
		-- cl_out => 0000
		
		wait until (clk='1' and clk'event);
		
		instr_in <= "0000101001000100"; -- shl
		-- Expected outputs:
		-- ra_out => 001
		-- rb_out => 000
		-- rc_out => 000
		-- cl_out => 0100
		
		wait until (clk='1' and clk'event);
		
		instr_in <= "0000110100000101"; -- rhl
		-- Expected outputs:
		-- ra_out => 100
		-- rb_out => 000
		-- rc_out => 000
		-- cl_out => 0101
		
		wait until (clk='1' and clk'event);
		
		instr_in <= "0100000000000000"; -- in (32)
		-- Expected outputs:
		-- ra_out => 100
		-- rb_out => 000
		-- rc_out => 000
		-- cl_out => 0000
		
		wait until (clk='1' and clk'event);
		
		instr_in <= "0100001111000000"; -- out (33)
		-- Expected outputs:
		-- ra_out => 111
		-- rb_out => 000
		-- rc_out => 000
		-- cl_out => 0000
		
		wait;
		
   end process;

END;
