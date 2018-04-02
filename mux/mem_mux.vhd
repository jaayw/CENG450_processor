library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mem_mux is
	Port (
		data_select: IN std_logic;
		mem_data : IN std_logic_vector(15 downto 0);
		memory_data : IN std_logic_vector(15 downto 0);
		data_out : OUT std_logic_vector(15 downto 0)
	);
end mem_mux;

architecture Behavioral of mem_mux is

begin

	data_out <=
		-- Select data from RAM
		memory_data when data_select = '1' else
		-- From mem latch
		mem_data;

end Behavioral;

