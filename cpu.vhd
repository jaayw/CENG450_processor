library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

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
		in_data : IN std_logic_vector(15 downto 0);
		
		-- outputs
		out_data : OUT std_logic_vector(15 downto 0)
	);

end cpu;

architecture Behavioral of cpu is

component pc is
	port (
			clk : IN STD_LOGIC;
			rst : IN STD_LOGIC;
			Q : OUT STD_LOGIC_VECTOR(6 downto 0)
			);
end component;

component ROM_VHDL_16 is
	port (
			clk : IN STD_LOGIC;
			addr : IN STD_LOGIC_VECTOR(6 downto 0);
			data : OUT STD_LOGIC_VECTOR(15 downto 0)
			);
end component;

component fetch_decode is
	port (
			clk : IN STD_LOGIC;
			rst : IN STD_LOGIC;
			instr_in : IN STD_LOGIC_VECTOR(15 downto 0);
			ra_out : OUT STD_LOGIC_VECTOR(2 downto 0);
			rb_out : OUT STD_LOGIC_VECTOR(2 downto 0);
			rc_out : OUT STD_LOGIC_VECTOR(2 downto 0);
			cl_out : OUT STD_LOGIC_VECTOR(3 downto 0)
			);
end component;

component register_file is
	port (
			clk : IN STD_LOGIC;
			rst : IN STD_LOGIC;
			rd_index1 : IN STD_LOGIC_VECTOR(2 downto 0);
			rd_index2 : IN STD_LOGIC_VECTOR(2 downto 0);
			wr_index : IN STD_LOGIC_VECTOR(2 downto 0);
			wr_data_reg : IN STD_LOGIC_VECTOR(15 downto 0);
			wr_enable_reg : IN STD_LOGIC;
			rd_data1 : OUT STD_LOGIC_VECTOR(15 downto 0);
			rd_data2 : OUT STD_LOGIC_VECTOR(15 downto 0)
			);
end component;	
			
component execute is
	port (
			clk : IN STD_LOGIC;
			rst : IN STD_LOGIC;
			instr_in : IN STD_LOGIC_VECTOR(15 downto 0);
			in_direct : IN STD_LOGIC_VECTOR(15 downto 0);
			in_data1 : IN STD_LOGIC_VECTOR(15 downto 0);
			in_data2 : IN STD_LOGIC_VECTOR(15 downto 0);
			ra_in : IN STD_LOGIC_VECTOR(2 downto 0);
			cl_in : IN STD_LOGIC_VECTOR(3 downto 0);
			alu_mode : OUT STD_LOGIC_VECTOR(2 downto 0);
			out_data1 : OUT STD_LOGIC_VECTOR(15 downto 0);
			out_data2 : OUT STD_LOGIC_VECTOR(15 downto 0);
			ra_out : out std_logic_vector(2 downto 0)
			);
end component;

component alu is
	port (
			clk : IN STD_LOGIC;
			rst : IN STD_LOGIC;
			in1 : IN STD_LOGIC_VECTOR(15 downto 0);
			in2 : IN STD_LOGIC_VECTOR(15 downto 0);
			alu_mode_in : IN STD_LOGIC_VECTOR(2 downto 0);
			result : OUT STD_LOGIC_VECTOR(15 downto 0);
			z_flag : OUT STD_LOGIC;
			n_flag : OUT STD_LOGIC
			);
end component;	

component mem is
	port (
			clk : IN STD_LOGIC;
			rst : IN STD_LOGIC;
			instr_in : IN STD_LOGIC_VECTOR(15 downto 0);
			ra_in : IN STD_LOGIC_VECTOR(2 downto 0);
			result_in : IN STD_LOGIC_VECTOR(15 downto 0);
			z_in : IN STD_LOGIC;
			n_in : IN STD_LOGIC;
			ra_out : OUT STD_LOGIC_VECTOR(2 downto 0);
			result_out : OUT STD_LOGIC_VECTOR(15 downto 0);
			wr_en : OUT STD_LOGIC;
			z_out : OUT STD_LOGIC;
			n_out : OUT STD_LOGIC
			);
end component;	

component writeback is
	port (
			clk : IN STD_LOGIC;
			rst : IN STD_LOGIC;
			result_in : IN STD_LOGIC_VECTOR(15 downto 0);
			ra_in : IN STD_LOGIC_VECTOR(2 downto 0);
			wr_en_in : IN STD_LOGIC;
			ra_out : OUT STD_LOGIC_VECTOR(2 downto 0);
			wr_en_out : OUT STD_LOGIC;
			wr_data_out : OUT STD_LOGIC_VECTOR(15 downto 0)
			);
end component;				

signal counter : std_logic_vector(6 downto 0);
signal instr : std_logic_vector (15 downto 0);
signal ra_id : std_logic_vector(2 downto 0);
signal rb : std_logic_vector(2 downto 0);
signal rc : std_logic_vector(2 downto 0);
signal cl : std_logic_vector(3 downto 0);
signal rd_data1 : std_logic_vector(15 downto 0); 
signal rd_data2 : std_logic_vector(15 downto 0);
signal alu_mode : std_logic_vector(2 downto 0);
signal out_data1 : std_logic_vector(15 downto 0);
signal out_data2 : std_logic_vector(15 downto 0);
signal ra_ex : std_logic_vector(2 downto 0);
signal result_alu : std_logic_vector(15 downto 0);
signal wr_index : std_logic_vector(2 downto 0);
signal wr_data :  std_logic_vector(15 downto 0);
signal wr_enable : std_logic;
signal ra_mem : std_logic_vector(2 downto 0);
signal result_mem : std_logic_vector(15 downto 0);
signal wr_en_mem : std_logic;
signal z_flag_alu : std_logic;
signal n_flag_alu : std_logic;
signal z_flag : std_logic;
signal n_flag : std_logic;


begin
			
PC0: pc port map (
			clk => clk,
			rst => rst,
			Q => counter
			);
			
ROM_16: ROM_VHDL_16 port map (
			clk => clk,
			addr => counter,
			data => instr
			);

IF_ID: fetch_decode port map (
			clk => clk,
			rst => rst,
			instr_in => instr,
			ra_out => ra_id,
			rb_out => rb,
			rc_out => rc,
			cl_out => cl
			);

REG0: register_file	port map (
			clk => clk,
			rst => rst,
			rd_index1 => rb,
			rd_index2 => rc,
			wr_index => wr_index,
			wr_data_reg => wr_data,
			wr_enable_reg => wr_enable,
			rd_data1 => rd_data1,
			rd_data2 =>	rd_data2
			);
			
EX0: execute port map (
			clk => clk,
			rst => rst,
			instr_in => instr,
			in_direct => in_data,
			in_data1 => rd_data1,
			in_data2 => rd_data2,
			ra_in => ra_id,
			cl_in => cl,
			alu_mode => alu_mode,
			out_data1 => out_data1,
			out_data2 => out_data2,
			ra_out => ra_ex
			);
	
ALU0: alu port map (
			clk => clk,
			rst => rst,
			in1 => out_data1,
			in2 => out_data2,
			alu_mode_in => alu_mode,
			result => result_alu,
			z_flag => z_flag,
			n_flag => n_flag
			);
				
MEM0: mem port map (
			clk => clk,
			rst => rst,
			instr_in => instr,
			ra_in => ra_ex,
			result_in => result_alu,
			z_in => z_flag_alu,
			n_in => n_flag_alu,
			ra_out => ra_mem,
			result_out => result_mem,
			wr_en => wr_en_mem,
			z_out => z_flag,
			n_out => n_flag
			);
			
out_data <= result_mem;
			
WB0: writeback port map(
			clk => clk,
			rst => rst,
			result_in => result_mem,
			ra_in => ra_mem,
			wr_en_in => wr_en_mem,
			ra_out => wr_index,
			wr_en_out => wr_enable,
			wr_data_out => wr_data
			);
			
		

end Behavioral;