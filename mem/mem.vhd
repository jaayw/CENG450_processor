library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mem is

	PORT (
		clk : IN std_logic;
		rst : IN std_logic;
		
		--input
		instr_in : std_logic_vector(15 downto 0);
		ra_in : in std_logic_vector(2 downto 0);
		result_in : in std_logic_vector(15 downto 0);
		z_in : in std_logic;
		n_in : in std_logic;
		-- #TODO
		-- Create input for branch and Format L
		
		--output
		opc_out : out std_logic_vector(6 downto 0);
		ra_out : out std_logic_vector(2 downto 0);
		result_out : out std_logic_vector(15 downto 0);
		wr_en : out std_logic;
		z_out : out std_logic;
		n_out : out std_logic
		
	);

end mem;

architecture Behavioral of mem is

signal op_code : std_logic_vector(6 downto 0);

begin

	op_code <= instr_in(15 downto 9);

	process (clk, result_in, ra_in, z_in, n_in)
	
		begin
		
			if rising_edge(clk) then
			
				if rst = '1' then
				
					ra_out <= (others => '0');
					result_out <= (others => '0');
					wr_en <= '0';
					z_out <= '0';
					n_out <= '0';
				
				else	
		
					case op_code is
					
						-- DO NOT WRITE TO REGISTER WHEN
						-- FORMAT A: OUT, TEST, NOP
						-- FORMAT B: BRR, BRR,N, BRR.Z, BR, BR.N, BR.Z, RETURN
						-- FORMAT L:
						when "0100000" | "0000111" |"0000000" | "1000000" | "1000001" | "1000010" | "1000011" | "1000100" | "1000101" =>
							wr_en <= '0';
						when others	 =>
							wr_en <= '1';
					end case;
			
					-- #TODO
					-- Create logic for Format B and Format L
					
					-- write data out to WB stage AND out
					result_out <= result_in; --alu_result to wb stage
					ra_out <= ra_in; --ra register
					z_out <= z_in;
					n_out <= n_in;
				end if;
		
			end if;
			
			opc_out <= op_code;
		
	end process;
	
end Behavioral;

