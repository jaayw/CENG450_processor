library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity exe_mux is
	Port(
		data_select : IN std_logic_vector(1 downto 0);
		pc_val : IN std_logic_vector(6 downto 0);
		alu_in1 : IN std_logic_vector(15 downto 0);
		alu_result : IN std_logic_vector(15 downto 0);
		data_out : OUT std_logic_vector(15 downto 0)
	);
end exe_mux;

architecture Behavioral of exe_mux is

begin

	data_out <=
		("000000000" & pc_val) when data_select = "01" else
		alu_in1 when data_select = "10" else
		alu_result;

end Behavioral;

