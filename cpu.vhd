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
		wr_enable : IN std_logic;
		en : IN std_logic;
		addr : IN std_logic_vector (6 downto 0);
		
		-- output
		Q : OUT std_logic_vector(6 downto 0);
		z_flag : OUT std_logic;
		n_flag : OUT std_logic
		);

end cpu;

architecture Behavioral of cpu is

signal rd_data1 : std_logic_vector(15 downto 0); 
signal rd_data2 : std_logic_vector(15 downto 0);

--signal a_mode : std_logic_vector(2 downto 0);
--signal rd_index1, rd_index2 : std_logic_vector(2 downto 0);
--signal wr_index : std_logic_vector(2 downto 0);
signal wr_data :  std_logic_vector(15 downto 0);
signal instr : std_logic_vector (15 downto 0);
signal count : std_logic_vector(6 downto 0);
signal result : std_logic_vector(15 downto 0);

-- alu_mode = instr(11 downto 9)
-- rd_index1 = rb = instr(5 downto 3)
-- rd_index2 = rc = instr(2 downto 0)
-- wr_index = ra = instr(8 downto 6)
-- Q = addr = count(6 downto 0)

signal ra : std_logic_vector(2 downto 0);
signal rb : std_logic_vector(2 downto 0);
signal rc : std_logic_vector(2 downto 0);
signal cl : std_logic_vector(3 downto 0);

begin

--IN: clk, rst OUT: en, Q 
PC0 : entity work.pc port map(clk, rst, en, count); 
--IN: clk, count OUT: instr
ROM_A_16 : entity work.ROM_VHDL_16 port map(clk, count, instr);
--IN: clk, rst, instr OUT: ra, rb, rc, cl
IF_ID : entity work.fetch_decode port map(clk, rst, instr, ra, rb, rc, cl); 
--IN: clk, rst, rd_index1, rd_index2, wr_index, wr_data, wr_enable OUT: rd_data1, rd_data2
REG0 : entity work.register_file port map(clk, rst, rb, rc, ra, wr_data, wr_enable, rd_data1, rd_data2);
--IN: clk, rst, instr, in_data1, in_data2 OUT: alu_mode, out_data1, out_data2
EX0 : entity work.execute port map(clk, rst, instr, rd_data1, rd_data2, alu_mode, out_data1, out_data2);
--IN: clk, rst, in1, in2, alu_mode OUT: result, z_flag, n_flag
ALU0 : entity work.alu port map(clk, rst, rd_data1, rd_data2, instr(11 downto 9), result, z_flag, n_flag);

end Behavioral;

