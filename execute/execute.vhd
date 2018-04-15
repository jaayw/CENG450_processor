library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity execute is

	PORT (
		clk : IN std_logic;
		rst : IN std_logic;
		br_flush : IN std_logic;
		
		--input
		instr_in : IN std_logic_vector(15 downto 0);
		pc_in : IN std_logic_vector(6 downto 0);
		in_direct : IN std_logic_vector(15 downto 0);
		in_data1 : IN std_logic_vector(15 downto 0);
		in_data2 : IN std_logic_vector(15 downto 0);
		ra_in	: IN std_logic_vector(2 downto 0);
		cl_in : IN std_logic_vector(3 downto 0);
		
		--output
		instr_out : OUT std_logic_vector(15 downto 0);
		pc_out : OUT std_logic_vector(6 downto 0);
		opc_out : OUT std_logic_vector(6 downto 0);
		out_data1 : OUT std_logic_vector(15 downto 0);
		out_data2 : OUT std_logic_vector(15 downto 0);
		ra_out : out std_logic_vector(2 downto 0)
		
	);
	
end execute;

architecture Behavioral of execute is

signal instr : std_logic_vector(15 downto 0);
alias op_code is instr_in(15 downto 9);

begin

	instr <= instr_in;
	
	process(clk, instr_in, pc_in, in_direct, in_data1, in_data2, cl_in, ra_in, op_code)
	
		begin
			
			if rising_edge(clk) then
			
				if (rst ='1' or br_flush = '1') then
				
					instr_out <= (others => '0');
					pc_out <= (others => '0');
					opc_out <= (others => '0');
					out_data1 <= (others => '0');
					out_data2 <= (others => '0');
					ra_out <= (others => '0');
				
				else
				
				case op_code is
				
					-- Format A3
					-- IN (33)
					when "0100001" =>
						instr_out <= instr;
						opc_out <= "0000001";
						out_data1 <= in_direct;
						out_data2 <= (others => '0');
						
					-- OUT (32)
					when "0100000" =>
						instr_out <= instr;
						opc_out <= "0000001";
						out_data1 <= in_data1;
						out_data2 <= (others => '0');
					
					-- Format A2
					-- Shift (5/6)
					when "0000101" | "0000110" =>
						instr_out <= instr;
						opc_out <= op_code;
						out_data1 <= in_data1;
						out_data2 <= "000000000000" & cl_in;
					
					-- ALU Mode -> ADD when BRR, BRR.N, BRR.Z, BR, BR.N, BR.Z, BR.SUB, RETURN
					when "1000000" | "1000001" | "1000010" | "1000011" | "1000100" | "1000101" | "1000110" | "1000111" =>
						instr_out <= instr;
						opc_out <= "0000001";
						out_data1 <= in_data1;
						out_data2 <= in_data2;
						
					-- LOAD
					when "0010000" =>
						instr_out <= instr;
						opc_out <= "1111111";
						out_data1 <= in_data1;--(others => '0');--
						out_data2 <= in_data2;
						
					-- LOADIMM, MOV
					-- Send out NOPS to prevent erraneous writes
					when "0010010" | "0010011"=>
						instr_out <= (others => '0');
						opc_out <= (others => '0');
						out_data1 <= (others => '0');
						out_data2 <= (others => '0');
						
					-- STORE
					when "0010001" =>
						instr_out <= instr;
						opc_out <= "1111111";
						out_data1 <= in_data1;
						out_data2 <= in_data2;
					
					-- Format A1/0
					-- Add/Sub/Mult/NAnd/NOP (1, 2, 3, 4 5, 0)
					when others =>
						instr_out <= instr;
						opc_out <= op_code;
						out_data1 <= in_data1;
						out_data2 <= in_data2;

				end case;
					
					pc_out <= pc_in;
					ra_out <= ra_in;
					
				end if;
				
			end if;
				
	end process;

end Behavioral;
