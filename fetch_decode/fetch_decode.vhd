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
signal ra_internal : std_logic_vector(2 downto 0);
signal rb_internal : std_logic_vector(2 downto 0);
signal rc_internal : std_logic_vector(2 downto 0);
signal cl_internal : std_logic_vector(3 downto 0);

begin
	
	op_code <= instr_in(15 downto 9);
	ra_internal <= instr_in(8 downto 6);
	rb_internal <= instr_in(5 downto 3);
	rc_internal <= instr_in(2 downto 0);
	cl_internal <= instr_in(3 downto 0);
	
	process(clk, rst, op_code, ra_internal, rb_internal, rc_internal, cl_internal)
	
		begin
		
		if rising_edge(clk) then
			
			if rst = '1' then
				
				ra_out <= (others => '0');
				rb_out <= (others => '0');
				rc_out <= (others => '0');
				cl_out <= (others => '0');
			
			else
				
--				case op_code is
--				
--					-- when add, sub, mult, nand
--					when "0000001" | "0000010" | "0000011" | "0000100" =>
--						ra_out <= ra_internal;
--						rb_out <= rb_internal;
--						rc_out <= rc_internal;
--						cl_out <= (others => '0');
--					-- when shl, lhl	
--					when "0000101" | "0000110" =>
--						ra_out <= ra_internal;
--						rb_out <= (others => '0');
--						rc_out <= (others => '0');
--						cl_out <= cl_internal;
--					-- when in and out
--					when "0100000" | "0100001" =>
--						ra_out <= ra_internal;
--						rb_out <= (others => '0');
--						rc_out <= (others => '0');
--						cl_out <= (others => '0');
--					when others =>
--						ra_out <= (others => '0');
--						rb_out <= (others => '0');
--						rc_out <= (others => '0');
--						cl_out <= (others => '0');
--					
--					end case;
					
			
				-- Format A3
				if op_code = ("0000001" or "0000010" or "0000011" or "0000100") then
				
					--ra_internal <= instr_in(8 downto 6);
					ra_out <= ra_internal; -- wr_index
					
					--rb_internal <= instr_in(5 downto 3);
					rb_out <= rb_internal; -- rd_index1 (FORMAT A1)
					
					--rc_internal <= instr_in(2 downto 0);
					rc_out <= rc_internal; -- rd_index2 (FORMAT A1)
					
					cl_out <= (others => '0');
				
					
				-- Format A2	
				elsif op_code = ("0000101" or "0000110") then -- SHL (5) or RHL (6)
				
					--ra_internal <= instr_in(8 downto 6);
					ra_out <= ra_internal; -- wr_index
					
					rb_out <= (others => '0');
					rc_out <= (others => '0');
					
					--cl_internal <= instr_in(3 downto 0);
					cl_out <= cl_internal; -- rd_index2 (FORMAT A2 - shifting)
				
				-- Format A1
				elsif op_code = ("0100000" or "0100001") then -- IN (32) or OUT (34)
				
					--ra_internal <= instr_in(8 downto 6);
					ra_out <= ra_internal;
					
					rb_out <= (others => '0');
					rc_out <= (others => '0');
					cl_out <= (others => '0');
					
				else
				
					ra_out <= (others => '0');
					rb_out <= (others => '0');
					rc_out <= (others => '0');
					cl_out <= (others => '0');					
					
				end if;
				
			end if;
			
		end if;
			
	end process;

end Behavioral;

