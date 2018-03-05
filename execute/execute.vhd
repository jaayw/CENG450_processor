library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity execute is

	PORT (
		clk : IN std_logic;
		rst : IN std_logic;
		
		--input
		instr : IN std_logic_vector(15 downto 0);
		in_data1 : IN std_logic_vector(15 downto 0);
		in_data2 : IN std_logic_vector(15 downto 0);
		
		alu_mode : OUT std_logic_vector(2 downto 0);
		out_data1 : OUT std_logic_vector(15 downto 0);
		out_data2 : OUT std_logic_vector(15 downto 0)
	);
end execute;

architecture Behavioral of execute is

signal oper : std_logic_vector(2 downto 0);

begin

	oper <= instr(11 downto 9);

	process
	
		begin
		
			out_data1 <= in_data1;
			
			if oper = ("101" or "110") then
				out_data2 <= instr & X"000F"; -- cl
			else
				out_data2 <= in_data2;
			end if;
			
			alu_mode <= oper;
				
	end process;

end Behavioral;

