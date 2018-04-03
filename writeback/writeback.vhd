library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity writeback is
	
	PORT (
		clk : IN std_logic;
		rst : IN std_logic;
		
		-- input
		opc_in : IN std_logic_vector(6 downto 0);
		result_in : IN std_logic_vector(15 downto 0);
		ra_in : IN std_logic_vector(2 downto 0);
		ml_in : IN std_logic;
		wr_en_in : in std_logic;
		
		-- output
		opc_out : OUT std_logic_vector(6 downto 0);
		ra_out : OUT std_logic_vector(2 downto 0); -- wr_index
		ml_out : OUT std_logic;
		wr_en_out : out std_logic;
		wr_data_out : out std_logic_vector(15 downto 0) --wr_data
		
	);

end writeback;

architecture Behavioral of writeback is

signal op_code : std_logic_vector(6 downto 0);

begin

op_code <= opc_in;

	process(clk, rst, op_code, wr_en_in, result_in)
	
		begin
		
			if rising_edge(clk) then
			
				if rst = '1' then
				
					ra_out <= (others => '0');
					ml_out <= '0';
					wr_en_out <= '0';
					wr_data_out <= (others => '0');
					
				else
				
					if wr_en_in = '1' then
						wr_data_out <= result_in;
						wr_en_out <= '1';
					else
						wr_en_out <= '0';
					end if;
					
					opc_out <= op_code;
					ra_out <= ra_in; --outputs to ra -> wr_index [rom]
					ml_out <= ml_in;
					
				end if;
				
			end if;
	
	end process;

end Behavioral;

