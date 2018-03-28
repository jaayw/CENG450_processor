library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity memory is
	Port(
		clk : IN std_logic;
		
		-- inputs
		addr : IN std_logic_vector(6 downto 0);
		wr_en_mem : IN std_logic;
		wr_data : IN std_logic_vector(15 downto 0);
		
		-- outputs
		data_out : OUT std_logic_vector(15 downto 0)
		
	);
end memory;

architecture Behavioral of memory is

	type MEM_ARRAY is array (0 to (2**12)) of std_logic_vector(15 downto 0);
	signal memory_content : MEM_ARRAY;
	-- Data stored as big endian

begin

	-- Write Process
	mem_wr : process(clk)
	
		variable addr : integer := 0;
	
		begin
		
			if(clk='0' and clk'event) then
			
				addr := conv_integer(unsigned(addr));
			
				if(rst='1') then
				
					for i in 0 to (2**12) loop
						memory_content(i)<= (others => '0'); 
					end loop;
				
				elsif(wr_en_mem='1') then
			
					addr := conv_integer(unsigned(addr));
					memory_content(addr) <= wr_data;
				
				end if;
			
			end if;
		
	end process;
	
	-- Read Process
	mem_rd : process
	
		variable addr : integer := 0;
		
		begin
		
			addr := conv_integer(unsigned(addr));
		
			if wr_en_mem = '0' then
				data_out <= memory_content(addr);
			end if;
	
	end process;

end Behavioral;

