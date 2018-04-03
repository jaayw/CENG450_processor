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
		addr : IN std_logic_vector(15 downto 0);
		wr_en_memory : IN std_logic;
		wr_data : IN std_logic_vector(15 downto 0);
		
		-- outputs
		data_out : OUT std_logic_vector(15 downto 0)
		
	);
end memory;

architecture Behavioral of memory is

	type MEM_ARRAY is array (0 to 2048) of std_logic_vector(7 downto 0);
	signal memory_content : MEM_ARRAY;
	-- Data stored as big endian (2**16 == 65536) -- Use 63 for testing
	
	signal data_fetch : std_logic_vector(15 downto 0);

begin	

	-- Write Process
	mem_wr : process(clk, wr_en_memory, memory_content)
	
		begin
		
			-- Write operation
			if rising_edge(clk) then
				if rst = '1' then
					
						for i in 0 to 2048 loop --(2**16 == 65536) -- Use 63 for testing
							memory_content(i) <= (others => '0'); 
						end loop;
					
						data_out <= (others => '0');
						
				elsif(wr_en_memory = '1') then
				
					memory_content(conv_integer(unsigned(addr))) <= wr_data(7 downto 0);
					memory_content(conv_integer(unsigned(addr)) + 1) <= wr_data(15 downto 8);
					
				end if;
			end if;
			
			-- Read operation
			if wr_en_memory = '0' then
				data_fetch <= memory_content(conv_integer(unsigned(addr))) & memory_content(conv_integer(unsigned(addr(7 downto 0)))+1);
				data_out <= data_fetch;
			end if;
		
	end process;

end Behavioral;

