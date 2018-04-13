library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity exe_mux_in2 is
	Port (
		data_select : IN std_logic;
		data_in2 : IN std_logic_vector(15 downto 0);
		data_out : OUT std_logic_vector(15 downto 0)
	);
end exe_mux_in2;

architecture Behavioral of exe_mux_in2 is

begin

	data_out <=
		"0000000000000010" when data_select = '1' else
		data_in2;


end Behavioral;

