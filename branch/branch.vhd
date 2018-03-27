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
						
						-- BRR.N
						when "1000001" =>
							br_flag <= '1';
						
						-- BRR.Z
						when "1000010" =>
							br_flag <= '1';
						
						-- BR
						when "1000011" =>
							br_flag <= '1';
						
						-- BR.N
						when "1000100" =>
							br_flag <= '1';
						
						-- BR.Z
						when "1000101" =>
							br_flag <= '1';
						
						-- BR.SUB
						when "1000110" =>
							br_flag <= '1';
						
						-- Return
						when "1000111" =>
						 br_flag <= '1';
						
						when others =>
						 br_flag <= '0';
						
					end case;
					
					if z_in = '1' then
						-- z flag branch stuff
					else
						-- other z flag branch stuff
					end if;
					
					if n_in = '1' then
						-- n flag branch stuff
					else
						-- other n flag branch stuff
					end if;
					
				end if;
				
			end if; -- end rising_edge(clk)
	
	end process;

end Behavioral;

