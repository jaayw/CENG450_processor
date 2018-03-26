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
		pc_in : IN std_logic_vector(6 downto 0);
		z_in : IN std_logic;
		n_in : IN std_logic;
		
		-- output
		pc_out : OUT std_logic_vector(6 downto 0)
		
	);
end branch;

architecture Behavioral of branch is

begin

	process(clk, rst, z_in, n_in)
	
		begin
		
			if rising_edge(clk) then
			
				if rst = '1' then
				
					pc_out <= (others => '0');
				
				else
		
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

