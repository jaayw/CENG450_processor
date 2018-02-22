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

signal rd_data1 : std_logic_vector(15 downto 0); 
signal rd_data2 : std_logic_vector(15 downto 0);

begin

ALU0 : entity work.alu port map(rst, clk, in1, in2, alu_mode, result, z_flag, n_flag);
REG0 : entity work.register_file port map(rst, clk, rd_index1, rd_index2, rd_data1, rd_data2, wr_index, wr_data, wr_enable);

end Behavioral;

