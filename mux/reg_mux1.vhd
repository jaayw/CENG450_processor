library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reg_mux1 is
	Port(
		-- Inputs
		data_select : IN std_logic_vector(2 downto 0);
		pc_val : IN std_logic_vector(6 downto 0);
		data_imm : IN std_logic_vector(15 downto 0);
		data_reg : IN std_logic_vector(15 downto 0);
		data_exe : IN std_logic_vector(15 downto 0);
		data_mem : IN std_logic_vector(15 downto 0);
		data_wb : IN std_logic_vector(15 downto 0);
		
		-- Outputs
		data_out : OUT std_logic_vector(15 downto 0)
	);
end reg_mux1;

architecture Behavioral of reg_mux1 is

begin

	data_out <=
		("000000000" & pc_val) when data_select = "001" else
		data_imm when data_select = "010" else
		data_exe when data_select = "101" else
		data_mem when data_select = "110" else
		data_wb when data_select = "111" else
		data_reg;

end Behavioral;

