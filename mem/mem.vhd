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
		
		--output
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
		
					if op_code = "0100000" then 
							wr_en <= '0';
					else
							wr_en <= '1';
					end if;
					
					-- write data out to WB stage AND out
					result_out <= result_in; --alu_result;
					ra_out <= ra_in; --ra register
					z_out <= z_in;
					n_out <= n_in;
					
				end if;
		
			end if;
		
	end process;
		


end Behavioral;

