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

	type MEM_ARRAY is array (0 to 256) of std_logic_vector(15 downto 0);
	signal memory_content : MEM_ARRAY;
	-- Data stored as big endian (2**16 == 65536) -- Use 128 for testing
	
	signal addr_in : std_logic_vector(7 downto 0);
	signal addr_target : integer range 0 to 256;
	
	--signal data_fetch : std_logic_vector(15 downto 0);
	

begin

	addr_in <= addr(7 downto 0);
	addr_target <= conv_integer(unsigned(addr_in));

	-- Write Process
	mem_wr : process(clk, addr_target, wr_data, wr_en_memory, memory_content)
	
		begin
		
			-- Write operation
			if falling_edge(clk) then
				if rst = '1' then
					
						for i in 0 to 256 loop --(2**16 == 65536) -- Use 128 for testing
							memory_content(i) <= (others => '0'); 
						end loop;
					
						data_out <= (others => '0');
						
				elsif(wr_en_memory = '1') then
				
					memory_content(addr_target) <= wr_data;--(7 downto 0); (7 downto 0)
					--memory_content(to_integer(unsigned(addr(7 downto 0))))(15 downto 8) <= wr_data(15 downto 8);
		
				end if;
				
			end if;
			
			-- Read operation
			data_out <= memory_content(addr_target);
		
	end process;
	

end Behavioral;

