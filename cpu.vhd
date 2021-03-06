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

component controller is
	port (
		clk : IN std_logic;
		instr : IN std_logic_vector(15 downto 0);
		
		-- Input
		-- EXE
		instr_exe : IN std_logic_vector(15 downto 0);
		ra_exe : IN std_logic_vector(2 downto 0);
		z_flag : IN STD_LOGIC;
		n_flag : IN STD_LOGIC;
		
		-- MEM
		opc_mem : IN std_logic_vector(6 downto 0);
		ra_mem : IN std_logic_vector(2 downto 0);
		
		-- WB
		opc_wb : IN std_logic_vector(6 downto 0);
		ra_wb : IN std_logic_vector(2 downto 0);
		
		-- Output
		stall : OUT std_logic;
		out_en : OUT std_logic;
		pc_overwrite_en : OUT std_logic;
		
		-- ID
		loadimm_en : OUT std_logic;
		loadimm_data : OUT std_logic_vector(7 downto 0);
		loadimm_select : OUT std_logic_vector(1 downto 0);
		mov_en : OUT std_logic;
		mux1_select : OUT std_logic_vector(2 downto 0);
		mux2_select : OUT std_logic_vector(2 downto 0);
		
		-- EXE
		br_flush : OUT std_logic;
		displacement : OUT std_logic_vector(8 downto 0);
		mux_in2_select : OUT std_logic;
		mux_ex_select : OUT std_logic_vector(1 downto 0);
		
		-- MEM
		mux_mem_select : OUT std_logic;
		memory_wr_en : OUT std_logic
	);
end component;

-- FETCH STAGE

component pc is
	port (
			clk : IN  std_logic;
         rst : IN  std_logic;
			hold : IN std_logic;
			br : IN std_logic;
			Q_in : IN std_logic_vector(15 downto 0); -- From ALU (Width change in PC)
         Q : OUT  std_logic_vector(6 downto 0)
			);
end component;

-- Change name according to Format testing
-- Format A: ROM_VHDL_16
-- Format B: ROM_VHDL_B
-- Format L: ROM_VHDL_L
-- Format Final: ROM_VHDL_F1 ROM_VHDL_F2 ROM_VHDL_F3
component ROM_VHDL_F1 is
	port (
			clk : IN STD_LOGIC;
			addr : IN STD_LOGIC_VECTOR(6 downto 0);
			data : OUT STD_LOGIC_VECTOR(15 downto 0)
			);
end component;

-- IF/ID Latch

component fetch_decode is
	port (
			clk : IN STD_LOGIC;
			rst : IN STD_LOGIC;
			br_flush : IN STD_LOGIC;
			instr_in : IN STD_LOGIC_VECTOR(15 downto 0);
			pc_in : IN std_logic_vector(6 downto 0);
			instr_out : OUT STD_LOGIC_VECTOR(15 downto 0);
			pc_out : OUT std_logic_vector(6 downto 0);
			ra_out : OUT STD_LOGIC_VECTOR(2 downto 0);
			rb_out : OUT STD_LOGIC_VECTOR(2 downto 0);
			rc_out : OUT STD_LOGIC_VECTOR(2 downto 0);
			cl_out : OUT STD_LOGIC_VECTOR(3 downto 0)
			);
end component;

-- DECODE STAGE

component register_file is
	port (
			clk : IN STD_LOGIC;
			rst : IN STD_LOGIC;
			rd_index1 : IN STD_LOGIC_VECTOR(2 downto 0);
			rd_index2 : IN STD_LOGIC_VECTOR(2 downto 0);
			wr_index : IN STD_LOGIC_VECTOR(2 downto 0);
			wr_data_reg : IN STD_LOGIC_VECTOR(15 downto 0);
			wr_enable_reg : IN STD_LOGIC;
			loadimm_en : IN std_logic;
			loadimm_select : IN std_logic_vector(1 downto 0);
			loadimm_data : IN std_logic_vector(7 downto 0);
			mov_en : IN std_logic;
			src_reg : IN std_logic_vector(2 downto 0);
			dest_reg : IN std_logic_vector(2 downto 0);
			rd_data1 : OUT STD_LOGIC_VECTOR(15 downto 0);
			rd_data2 : OUT STD_LOGIC_VECTOR(15 downto 0)
			);
end component;

component reg_mux1 is
	port (
		data_select : IN std_logic_vector(2 downto 0);
		pc_val : IN std_logic_vector(6 downto 0);
		data_reg : IN std_logic_vector(15 downto 0);
		data_exe : IN std_logic_vector(15 downto 0);
		data_mem : IN std_logic_vector(15 downto 0);
		data_wb : IN std_logic_vector(15 downto 0);
		data_out : OUT std_logic_vector(15 downto 0)
	);
end component;

component reg_mux2 is
	port (
		data_select : IN std_logic_vector(2 downto 0);
		data_displ : IN std_logic_vector(8 downto 0);
		data_reg : IN std_logic_vector(15 downto 0);
		data_exe : IN std_logic_vector(15 downto 0);
		data_mem : IN std_logic_vector(15 downto 0);
		data_wb : IN std_logic_vector(15 downto 0);
		data_out : OUT std_logic_vector(15 downto 0)
	);
end component;

-- ID/EXE Latch
			
component execute is
	port (
			clk : IN STD_LOGIC;
			rst : IN STD_LOGIC;
			br_flush : IN STD_LOGIC;
			instr_in : IN STD_LOGIC_VECTOR(15 downto 0);
			pc_in : IN STD_LOGIC_VECTOR(6 downto 0);
			in_direct : IN STD_LOGIC_VECTOR(15 downto 0);
			in_data1 : IN STD_LOGIC_VECTOR(15 downto 0);
			in_data2 : IN STD_LOGIC_VECTOR(15 downto 0);
			ra_in : IN STD_LOGIC_VECTOR(2 downto 0);
			cl_in : IN STD_LOGIC_VECTOR(3 downto 0);
			instr_out : OUT STD_LOGIC_VECTOR(15 downto 0);
			pc_out : OUT STD_LOGIC_VECTOR(6 downto 0);
			opc_out : OUT std_logic_vector(6 downto 0);
			out_data1 : OUT STD_LOGIC_VECTOR(15 downto 0);
			out_data2 : OUT STD_LOGIC_VECTOR(15 downto 0);
			ra_out : out std_logic_vector(2 downto 0)
			);
end component;

-- EXECUTE STAGE

component exe_mux_in2 is
	port (
		data_select : IN std_logic;
		data_in2 : IN std_logic_vector(15 downto 0);
		data_out : OUT std_logic_vector(15 downto 0)
	);
end component;

component alu is
	port (
			clk : IN STD_LOGIC;
			rst : IN STD_LOGIC;
			in1 : IN STD_LOGIC_VECTOR(15 downto 0);
			in2 : IN STD_LOGIC_VECTOR(15 downto 0);
			opc_in : IN std_logic_vector(6 downto 0);
			result : OUT STD_LOGIC_VECTOR(15 downto 0);
			z_flag : OUT STD_LOGIC;
			n_flag : OUT STD_LOGIC
			);
end component;

component exe_mux is
	port(
		data_select : IN std_logic_vector(1 downto 0);
		pc_val : IN std_logic_vector(6 downto 0);
		alu_in1 : IN std_logic_vector(15 downto 0);
		alu_result : IN std_logic_vector(15 downto 0);
		data_out : OUT std_logic_vector(15 downto 0)
	);
end component;

-- EXE/MEM Latch

component mem is
	port (
			clk : IN STD_LOGIC;
			rst : IN STD_LOGIC;
			instr_in : IN STD_LOGIC_VECTOR(15 downto 0);
			ra_in : IN STD_LOGIC_VECTOR(2 downto 0);
			result_in : IN STD_LOGIC_VECTOR(15 downto 0);
			in2_in : IN STD_LOGIC_VECTOR(15 downto 0);
			opc_out : OUT STD_LOGIC_VECTOR(6 downto 0);
			ra_out : OUT STD_LOGIC_VECTOR(2 downto 0);
			result_out : OUT STD_LOGIC_VECTOR(15 downto 0);
			in2_out : OUT STD_LOGIC_VECTOR(15 downto 0);
			wr_en : OUT STD_LOGIC
			);
end component;	

-- MEM STAGE

component memory is
	Port(
		clk : IN std_logic;
		rst : IN std_logic;
		addr : IN std_logic_vector(15 downto 0);
		wr_en_memory : IN std_logic;
		wr_data : IN std_logic_vector(15 downto 0);
		data_out : OUT std_logic_vector(15 downto 0)
		);
end component;

component mem_mux is
	port (
		data_select: IN std_logic;
		mem_data : IN std_logic_vector(15 downto 0);
		memory_data : IN std_logic_vector(15 downto 0);
		data_out : OUT std_logic_vector(15 downto 0)
	);
end component;

component output_mux is
	Port (
		clk : IN std_logic;
		rst : IN std_logic;
		out_en : IN std_logic;
		data_in : IN std_logic_vector(15 downto 0);
		data_out : OUT std_logic_vector(15 downto 0)
	);
end component;

-- MEM/WB Latch

component writeback is
	port (
			clk : IN STD_LOGIC;
			rst : IN STD_LOGIC;
			opc_in : IN STD_LOGIC_VECTOR(6 downto 0);
			result_in : IN STD_LOGIC_VECTOR(15 downto 0);
			ra_in : IN STD_LOGIC_VECTOR(2 downto 0);
			wr_en_in : IN STD_LOGIC;
			opc_out : OUT STD_LOGIC_VECTOR(6 downto 0);
			ra_out : OUT STD_LOGIC_VECTOR(2 downto 0);
			wr_en_out : OUT STD_LOGIC;
			wr_data_out : OUT STD_LOGIC_VECTOR(15 downto 0)
			);
end component;

-- Fetch SIGNALS
signal counter : std_logic_vector(6 downto 0);
signal pc_hold : std_logic;
signal br_en : std_logic;

-- DECODE SIGNALS
signal instr : std_logic_vector (15 downto 0);
signal instr_ifid : std_logic_vector (15 downto 0);
signal instr_exe : std_logic_vector (15 downto 0);
signal pc_ifid : std_logic_vector(6 downto 0); -- might remove testing
signal ra_id : std_logic_vector(2 downto 0);
signal rb : std_logic_vector(2 downto 0);
signal rc : std_logic_vector(2 downto 0);
signal cl : std_logic_vector(3 downto 0);
signal rd_data1 : std_logic_vector(15 downto 0); 
signal rd_data2 : std_logic_vector(15 downto 0);
signal mux1_select : std_logic_vector(2 downto 0);
signal mux2_select : std_logic_vector(2 downto 0);
signal mux1_data : std_logic_vector(15 downto 0);
signal mux2_data : std_logic_vector(15 downto 0);
signal loadimm_en : std_logic; -- From CU -> Register
signal loadimm_select : std_logic_vector(1 downto 0); -- From CU for LOADIMM MSB or LSB
signal loadimm_data : std_logic_vector(7 downto 0); -- From CU -> Register
signal mov_en : std_logic;

-- EXECUTE SIGNALS
signal counter_exe : std_logic_vector(6 downto 0);
signal op_code_exe : std_logic_vector(6 downto 0);
signal out_data1 : std_logic_vector(15 downto 0);
signal out_data2 : std_logic_vector(15 downto 0);
signal ra_exe : std_logic_vector(2 downto 0);
signal ml_exe : std_logic;
signal displacement : std_logic_vector(8 downto 0); -- CU -> BRANCH
signal mux_in2_select : std_logic; -- From CU -> mux_in2
signal mux_in2_result : std_logic_vector(15 downto 0); -- mux_in2 -> ALU
signal result_alu : std_logic_vector(15 downto 0); -- ALU -> MUX or PC -> MEM
signal mux_ex_result : std_logic_vector(15 downto 0); -- Data forwarding from EXE to ID
signal mux_ex_select : std_logic_vector(1 downto 0); -- From CU
--signal z_flag_alu : std_logic;
--signal n_flag_alu : std_logic;
signal z_flag : std_logic;
signal n_flag : std_logic;
signal br_flush : std_logic;

-- MEM SIGNALS
signal op_code_mem : std_logic_vector(6 downto 0);
signal ra_mem : std_logic_vector(2 downto 0);
signal ml_mem : std_logic;
signal result_mem : std_logic_vector(15 downto 0);
signal outCPU_en : std_logic;
signal wr_en_mem : std_logic;
signal wr_en_memory : std_logic;
signal memory_addr : std_logic_vector(15 downto 0);
signal rd_memory_data : std_logic_vector(15 downto 0);
signal mux_mem_select : std_logic;
signal mux_mem_result : std_logic_vector(15 downto 0); -- Data forwarding from MEM to ID


-- WB SIGNALS
signal op_code_wb : std_logic_vector(6 downto 0);
signal wr_index : std_logic_vector(2 downto 0);
signal wr_data :  std_logic_vector(15 downto 0);
signal wr_enable : std_logic;

-- TEMPORARY FOR OPEN INPUTS AND OUTPUTS
-- TEMPORARY INPUTS
-- PC

-- TEMPORARY OUTPUTS


begin

-- Controller
			
CU0: controller port map(
				clk => clk,
				-- Inputs
				instr => instr_ifid,
				instr_exe => instr_exe,
				ra_exe => ra_exe,
				z_flag => z_flag,
				n_flag => n_flag,
				opc_mem => op_code_mem,
				ra_mem => ra_mem,
				opc_wb => op_code_wb,
				ra_wb => wr_index,
				-- Outputs
				stall => pc_hold,
				out_en => outCPU_en,
				pc_overwrite_en => br_en,
				loadimm_en => loadimm_en,
				loadimm_data => loadimm_data,
				loadimm_select => loadimm_select,
				mov_en => mov_en,
				mux1_select => mux1_select,
				mux2_select => mux2_select,
				br_flush => br_flush,
				displacement => displacement,
				mux_in2_select => mux_in2_select,
				mux_ex_select => mux_ex_select,
				mux_mem_select => mux_mem_select,
				memory_wr_en => wr_en_memory
			);

-- FETCH STAGE

PC0: pc port map (
			clk => clk,
			rst => rst,
			hold => pc_hold,
			br => br_en,
			Q_in => mux_ex_result,
			Q => counter
			);

-- Change name according to Format testing
-- Format A: ROM_VHDL_16
-- Format B: ROM_VHDL_B
-- Format L: ROM_VHDL_L
-- Format Final: ROM_VHDL_F1 ROM_VHDL_F2 ROM_VHDL_F3
ROM: ROM_VHDL_F1 port map (
			clk => clk,
			addr => counter,
			data => instr
			);
			
-- IF/ID Latch

IF_ID: fetch_decode port map (
			clk => clk,
			rst => rst,
			br_flush => br_flush,
			instr_in => instr,
			pc_in => counter, -- might remove -- need to remove
			instr_out => instr_ifid,
			pc_out => pc_ifid, -- might remove testing -- need to remove
			ra_out => ra_id,
			rb_out => rb,
			rc_out => rc,
			cl_out => cl
			);
			
-- DECODE STAGE

REG0: register_file	port map (
			clk => clk,
			rst => rst,
			rd_index1 => rb,
			rd_index2 => rc,
			wr_index => wr_index,
			wr_data_reg => wr_data,
			wr_enable_reg => wr_enable,
			loadimm_en => loadimm_en,
			loadimm_select => loadimm_select,
			loadimm_data => loadimm_data,
			mov_en => mov_en,
			src_reg => rb,
			dest_reg => ra_id,
			rd_data1 => rd_data1,
			rd_data2 =>	rd_data2
			);
			
MUX1_REG: reg_mux1 port map(
			-- Inputs
			data_select => mux1_select, -- From CU
			pc_val => pc_ifid, -- From PC for branching
			data_reg => rd_data1, -- Data read from reg (op1)
			data_exe => mux_ex_result, -- Data forwarded from EXE
			data_mem => mux_mem_result, -- Data forwarded from MEM
			data_wb => wr_data, -- Data forwarded from WB
			-- Outputs
			data_out => mux1_data
			);
			
MUX2_REG: reg_mux2 port map(
			-- Inputs
			data_select => mux2_select, -- From CU
			data_displ => displacement, -- From CU displaced data for branching
			data_reg => rd_data2, -- Data read from reg (op2)
			data_exe => mux_ex_result, -- Data forwarded from EXE
			data_mem => mux_mem_result, -- Data forwarded from MEM
			data_wb => wr_data, -- Data forwarded from WB
			-- Outputs
			data_out => mux2_data
			);
			
-- ID/EXE Latch

EX0: execute port map (
			clk => clk,
			rst => rst,
			br_flush => br_flush,
			-- Inputs
			instr_in => instr_ifid,
			pc_in => counter,
			in_direct => in_data,
			in_data1 => mux1_data,
			in_data2 => mux2_data,
			ra_in => ra_id,
			cl_in => cl,
			-- Ouputs
			instr_out => instr_exe,
			pc_out => counter_exe,
			opc_out => op_code_exe,
			out_data1 => out_data1,
			out_data2 => out_data2,
			ra_out => ra_exe
			);
			
-- EXECUTE STAGE

MUX_IN20: exe_mux_in2 port map (
		data_select => mux_in2_select,
		data_in2 => out_data2,
		data_out => mux_in2_result
		);
	
ALU0: alu port map (
			clk => clk,
			rst => rst,
			-- Inputs
			in1 => out_data1,
			in2 => mux_in2_result,
			opc_in => op_code_exe,
			-- Outputs
			result => result_alu,
			z_flag => z_flag,
			n_flag => n_flag
			);
			
MUX_EXE0: exe_mux port map (
			data_select => mux_ex_select,
			pc_val => counter_exe,
			alu_in1 => out_data1,
			alu_result => result_alu,
			data_out => mux_ex_result
			);
			
-- EXE/MEM Latch
				
MEM0: mem port map (
			clk => clk,
			rst => rst,
			-- Inputs
			instr_in => instr_exe,
			ra_in => ra_exe,
			result_in => result_alu,
			in2_in => out_data2,
			-- Outputs
			opc_out => op_code_mem,
			ra_out => ra_mem,
			result_out => result_mem,
			in2_out => memory_addr,
			wr_en => wr_en_mem
			);

-- MEM STAGE

RAM: memory port map (
		clk => clk,
		rst => rst,
		addr => memory_addr,
		wr_en_memory => wr_en_memory,
		wr_data => result_mem,
		data_out => rd_memory_data
		);

MUX_MEM0: mem_mux port map (
		data_select => mux_mem_select,
		mem_data => result_mem,
		memory_data => rd_memory_data,
		data_out => mux_mem_result
		);
		
MUX_OUT0: output_mux port map (
		clk => clk,
		rst => rst,
		out_en => outCPU_en,
		data_in => result_mem,
		data_out => out_data
		);

-- MEM/WB Latch
			
WB0: writeback port map(
			clk => clk,
			rst => rst,
			-- Inputs
			opc_in => op_code_mem,
			result_in => mux_mem_result,
			ra_in => ra_mem,
			wr_en_in => wr_en_mem,
			-- Outputs
			opc_out => op_code_wb,
			ra_out => wr_index,
			wr_en_out => wr_enable,
			wr_data_out => wr_data
			);
			
end Behavioral;