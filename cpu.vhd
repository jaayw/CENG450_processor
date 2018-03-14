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
		-- inputs
		clk : IN std_logic;
		rst : IN std_logic;
		en : IN std_logic;
		in_data : std_logic_vector(15 downto 0);
		
		-- outputs
		out_data : OUT std_logic_vector(15 downto 0)
	);

end cpu;

architecture Behavioral of cpu is

-- PC Signals
-- Q -> count [signal] -> addr [ROM]
signal counter : std_logic_vector(6 downto 0);

-- ROM Signals
-- data -> in_inst [fetch_decode]
--		  -> instr [execute]
-- instr(15 downto 9) = op_code
-- instr(11 downto 9) = alu_mode
-- instr(8 downto 6) = ra = wr_index
-- instr(5 downto 3) = rb = rd_index1
-- instr(2 downto 0) = rc = rd_index2
signal instr : std_logic_vector (15 downto 0);

-- fetch_decode Signals
-- ra -> wr_index [register_file]
-- rb -> rd_index1 [register_file]
-- rc -> rd_index2 [register_file]
signal ra_id : std_logic_vector(2 downto 0);
signal rb : std_logic_vector(2 downto 0);
signal rc : std_logic_vector(2 downto 0);
signal cl : std_logic_vector(3 downto 0);

-- register_file Signals
-- rd_data1 -> in_data1 [execute]
-- rd_data2 -> in_data2 [execute]
signal rd_data1 : std_logic_vector(15 downto 0); 
signal rd_data2 : std_logic_vector(15 downto 0);

-- execute Signals
signal alu_mode : std_logic_vector(2 downto 0);
signal out_data1 : std_logic_vector(15 downto 0);
signal out_data2 : std_logic_vector(15 downto 0);
signal ra_ex : std_logic_vector(2 downto 0);

-- alu Signals
signal result : std_logic_vector(15 downto 0);

signal wr_index : std_logic_vector(2 downto 0);
signal wr_data :  std_logic_vector(15 downto 0);
signal wr_enable : std_logic;

signal ra_mem : std_logic_vector(2 downto 0);
signal result_mem : std_logic_vector(15 downto 0);
signal z_flag : std_logic;
signal n_flag : std_logic;


begin

--IN: clk, rst OUT: en, Q 
PC0 : entity work.pc port map(clk, rst, en, counter);

--IN: clk, count OUT: instr
ROM_A_16 : entity work.ROM_VHDL_16 port map(clk, counter, instr);

--IN: clk, rst, instr OUT: wr_index_out, wr_data_in, ra, rb, rc, cl
IF_ID : entity work.fetch_decode port map(clk, rst, instr, wr_index, wr_data, ra_id, rb, rc, cl); 

--IN: clk, rst, rd_index1, rd_index2, wr_index, wr_data, wr_enable OUT: rd_data1, rd_data2
REG0 : entity work.register_file port map(clk, rst, rb, rc, ra_id, wr_data, wr_enable, rd_data1, rd_data2);

--IN: clk, rst, instr, in_direct, in_data1, in_data2, cl, ra OUT: alu_mode, out_data1, out_data2, ra
EX0 : entity work.execute port map(clk, rst, instr, in_data, rd_data1, rd_data2, cl, alu_mode, out_data1, out_data2, ra_id, ra_ex);

--IN: clk, rst, in1, in2, alu_mode OUT: result, z_flag, n_flag
ALU0 : entity work.alu port map(clk, rst, out_data1, out_data2, alu_mode, result, z_flag, n_flag);

--IN: clk, rst, ra_in, result_in, n_flag, z_flag OUT: ra_out, result_out, n_flag, z_flag
MEM0 : entity work.mem port map(clk, rst, ra_ex, result, ra_mem, result_mem, z_flag, n_flag);

--IN: clk, rst, wr_enable, wr_index, wr_data OUT: wr_enable, wr_index, wr_data
WRB0 : entity work.writeback port map(clk, rst, wr_enable, wr_index, wr_data);
	
end Behavioral;

