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
		clk :	IN std_logic;
		rst : IN std_logic;
		
		-- Input
		hold : IN std_logic; -- From CU for stall
		br : IN std_logic; -- From CU for PC overwrite
		Q_in : IN std_logic_vector(15 downto 0); -- From ALU for PC overwrite value
		
		-- Output
		Q : out std_logic_vector(6 downto 0) -- Counter out
	);	

end pc;

architecture Behavioral of pc is

--signal Q_mask : std_logic_vector(15 downto 0);
signal overwrite_val : std_logic_vector(6 downto 0);

signal Pre_Q : integer range 0 to 127;
signal br_Q : integer range 0 to 127;

begin

-- Convert new PC value into integer
--Q_mask <= Q_in(15 downto 0);
overwrite_val <= Q_in(6 downto 0);
br_Q <= conv_integer(overwrite_val);

	process(clk)
		begin
			if rising_edge(clk) then
				if rst = '1' then
					Pre_Q <= 0;
				
				elsif (hold = '0' and br = '1') then
					Pre_Q <= br_Q;
					
				elsif (hold = '0' and br = '0') then
					Pre_Q <= Pre_Q + 2;
					
				end if;
			end if;
			
	end process;
 
	-- Convert counter value back to binary for output
	Q <= conv_std_logic_vector(Pre_Q,7);

end Behavioral;
