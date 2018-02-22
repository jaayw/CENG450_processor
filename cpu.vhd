library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cpu is

	PORT (
		clk : IN std_logic;
		rst : IN std_logic;
		in_data : IN std_logic_vector(15 downto 0);
		out_data : OUT std_logic_vector(15 downto 0)
		);

end cpu;

architecture Behavioral of cpu is

begin


end Behavioral;

