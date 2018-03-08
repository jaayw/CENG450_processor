library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity writeback is
	
	PORT (
		clk : IN std_logic;
		rst : IN std_logic;
		
		-- input
		
		-- output
		
		-- inout
		wr_enable : inout std_logic;
		wr_index : inout std_logic_vector(2 downto 0);
		wr_data : inout std_logic_vector(15 downto 0)
		
	);

end writeback;

architecture Behavioral of writeback is

begin

	process(clk, rst, wr_enable, wr_index, wr_data)
	
		begin
		
	end process;


end Behavioral;

