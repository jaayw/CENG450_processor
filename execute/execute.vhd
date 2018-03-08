library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity execute is

	PORT (
		clk : IN std_logic;
		rst : IN std_logic;
		
		--input
		instr : IN std_logic_vector(15 downto 0);
		in_direct : IN std_logic_vector(15 downto 0);
		in_data1 : IN std_logic_vector(15 downto 0);
		in_data2 : IN std_logic_vector(15 downto 0);
		cl : IN std_logic_vector(3 downto 0);
		
		--output
		alu_mode : OUT std_logic_vector(2 downto 0);
		out_data1 : OUT std_logic_vector(15 downto 0);
		out_data2 : OUT std_logic_vector(15 downto 0);
		
		--inout
		ra	: IN std_logic_vector(2 downto 0);
		ra_out : out std_logic_vector(2 downto 0)
	);
	
end execute;

architecture Behavioral of execute is

signal op_code : std_logic_vector(6 downto 0);

begin


	op_code <= instr(15 downto 9);

	process(clk, instr, in_direct, in_data1, in_data2, cl, ra, op_code)
	
		begin
		
			-- IN/d1 mux
			if op_code = ("0100001" or "0100000") then -- IN op_code
				out_data1 <= in_direct;
			else
				out_data1 <= in_data1;
			end if;
			
			-- rc/d2 mux
			if op_code = ("0000101" or "0000110") then -- shift
				out_data2 <= "000000000000" & cl;
			else
				out_data2 <= in_data2;
			end if;
			
			alu_mode <= op_code(2 downto 0);
			
			ra_out <= ra;
				
	end process;

end Behavioral;
