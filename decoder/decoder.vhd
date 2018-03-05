library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decoder is

	PORT(
		-- input
		in_inst : IN std_logic_vector(15 downto 0);
		
		-- output
		out_inst : OUT std_logic_vector(15 downto 0);
		cl : OUT std_logic_vector(3 downto 0)
	);

end decoder;

architecture Behavioral of decoder is

signal op_code : in_inst(15 downto 12);

begin

	process
	
		begin
		
		
		
			
		
			cl <= in_inst & X"000F";
				
	end process;
	
end Behavioral;

