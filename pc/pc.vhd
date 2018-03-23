library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pc is

	PORT (
		-- input
		clk :	in std_logic;
		rst : in std_logic;
		-- #TODO
		-- Create enable and/or branch flag
		
		-- output
		Q : out std_logic_vector(6 downto 0) --counter
	);	

end pc;

architecture Behavioral of pc is

signal Pre_Q: integer range 0 to 127;

begin

	process(clk)
		begin
			if rising_edge(clk) then
				if rst = '1' then
					Pre_Q <= 0;
				else
					Pre_Q <= Pre_Q + 1;
				end if;
				
				-- #TODO
				-- Create conditions for enable/branching
				-- Create logic for branching
				
			end if;
	end process;	
 
	Q <= conv_std_logic_vector(Pre_Q,7);

end Behavioral;
