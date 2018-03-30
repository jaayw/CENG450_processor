library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity memory is
	Port(
		clk : IN std_logic;
		rst : IN std_logic;
		
		-- inputs
		addr : IN std_logic_vector(6 downto 0);
		wr_en_mem : IN std_logic;
		wr_data : IN std_logic_vector(15 downto 0);
		
		-- outputs
		data_out : OUT std_logic_vector(15 downto 0)
		
	);
end memory;

architecture Behavioral of memory is

	type MEM_ARRAY is array (0 to 2**8) of std_logic_vector(15 downto 0);
	signal memory_content : MEM_ARRAY;
	-- Data stored as big endian (2**12)
	
	signal data_fetch : std_logic_vector(15 downto 0);

begin	

	-- Write Process
	mem_wr : process(clk)
	
		begin
		
			if rising_edge(clk) then
			
				if rst = '1' then
					
						for i in 0 to 2**8 loop --(2**8)
							memory_content(i) <= (others => '0'); 
						end loop;
					
						data_out <= (others => '0');
						
				elsif(wr_en_mem='1') then
					memory_content(conv_integer(unsigned(addr))) <= wr_data;
				end if;
			
			end if;
			
			if wr_en_mem = '0' then
				data_fetch <= memory_content(conv_integer(unsigned(addr)));
				data_out <= data_fetch;
			end if;
		
	end process;

end Behavioral;
