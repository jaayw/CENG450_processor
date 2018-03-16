library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fetch_decode is

	PORT(
			clk : IN std_logic;
			rst : IN std_logic;
			
			-- input
			instr_in : IN std_logic_vector(15 downto 0); -- take in inst from rom
			
			-- output
			ra_out :	OUT std_logic_vector(2 downto 0);
			rb_out :	OUT std_logic_vector(2 downto 0);
			rc_out :	OUT std_logic_vector(2 downto 0);
			cl_out :	OUT std_logic_vector(3 downto 0)
		);
		
end fetch_decode;

architecture Behavioral of fetch_decode is

signal op_code : std_logic_vector(6 downto 0);

begin
	
	op_code <= instr_in(15 downto 9);
	
	process(clk, rst, instr_in, op_code)
	
		begin
		
		if rising_edge(clk) then
			
			if rst = '1' then
				
				ra_out <= (others => '0');
				rb_out <= (others => '0');
				rc_out <= (others => '0');
				cl_out <= (others => '0');
			
			else
			
				-- Format A3
				if op_code = ("0100000" or "0100001") then -- IN (32) or OUT (34)
					ra_out <= instr_in(8 downto 6);
					rb_out <= (others => '0');
					rc_out <= (others => '0');
					
				-- Format A2	
				elsif op_code = ("0000101" or "0000110") then -- SHL (5) or RHL (6)
				
					ra_out <= instr_in(8 downto 6); -- wr_index
					cl_out <= instr_in(3 downto 0); -- rd_index2 (FORMAT A2 - shifting)
				
				-- Format A1
				else
				
					ra_out <= instr_in(8 downto 6); -- wr_index
					rb_out <= instr_in(5 downto 3); -- rd_index1 (FORMAT A1)
					--rc_out <= instr_in(2 downto 0); -- rd_index2 (FORMAT A1)
					
				end if;
				
			end if;
			
		end if;
			
	end process;

end Behavioral;

