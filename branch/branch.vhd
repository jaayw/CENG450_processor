library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity branch is
	Port(
		clk : IN std_logic;
		rst : IN std_logic;
		
		-- input
		instr_in : IN std_logic_vector(15 downto 0);
		pc_in : IN std_logic_vector(6 downto 0);
		z_in : IN std_logic;
		n_in : IN std_logic;
		
		-- output
		br_flag : OUT std_logic;
		pc_out : OUT std_logic_vector(6 downto 0)
		
	);
end branch;

architecture Behavioral of branch is

signal op_code : std_logic_vector(6 downto 0);
signal br : std_logic;
signal pc_new : std_logic_vector(6 downto 0);

begin

	op_code <= instr_in(15 downto 9);

	process(clk)
	
		begin
		
			if rising_edge(clk) then
			
				if rst = '1' then
				
					pc_out <= (others => '0');
					br_flag <= '0';
				
				else
		
					case op_code is
					
						-- BRR
						when "1000000" =>
							br_flag <= '1';
							-- PC = PC+ 2 * disp.l (sign extended 2's complement)
						
						-- BRR.N
						when "1000001" =>
							br_flag <= '1';
							-- if negative flag = 1
								-- PC = PC + 2 * disp.l (sign extended 2's complement)
							-- elsif negative flag = 0
								-- PC = PC + 2 (2's complement)
						
						-- BRR.Z
						when "1000010" =>
							br_flag <= '1';
							-- if zero flag = 1
								-- PC = PC + 2 * disp.l (signed extended 2's complement)
							-- elsif zero flag = 0
								-- PC = PC + 2 (2's complement)
						
						-- BR
						when "1000011" =>
							br_flag <= '1';
							-- PC = R[a] + 2 * disp.s (sign extended 2's complement)
						
						-- BR.N
						when "1000100" =>
							br_flag <= '1';
							-- if negative flag = 1
								-- PC = R[a] (word aligned) + 2 * disp.s (sign extended 2's complement)
							-- elsif negative flag = 0
								-- PC = PC + 2 (2's complement)
						
						-- BR.Z
						when "1000101" =>
							br_flag <= '1';
							-- if zero flag = 1
								-- PC = R[a] (word aligned) + 2 * disp.s (sign extended 2's complement)
							-- elsif zero flag = 0
								-- PC = PC + 2 (2's complement)
								
						-- BR.SUB
						when "1000110" =>
							br_flag <= '1';
							-- Store current PC into R[7] + 2 (2's complement)
							-- PC = R[a] (word aligned) + 2 * disp.s (signed extended 2's complement)
						
						-- Return
						when "1000111" =>
						 br_flag <= '0';
						 -- Go read R7
						 -- Store it back into PC
						
						when others =>
						 br_flag <= '0';
						 pc_new <= pc_in;
						
					end case;
					
				end if;
				
				pc_out <= pc_new;
				
			end if; -- end rising_edge(clk)
	
	end process;

end Behavioral;

