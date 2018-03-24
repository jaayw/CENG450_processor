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
			-- #TODO
			-- Create input for branch flag(s)
			
			
			-- output
			instr_out : OUT std_logic_vector(15 downto 0); -- Output instr to 
			ra_out :	OUT std_logic_vector(2 downto 0);
			rb_out :	OUT std_logic_vector(2 downto 0);
			rc_out :	OUT std_logic_vector(2 downto 0);
			cl_out :	OUT std_logic_vector(3 downto 0)
		);
		
end fetch_decode;

architecture Behavioral of fetch_decode is

signal instr : std_logic_vector(15 downto 0);
signal op_code : std_logic_vector(6 downto 0);
signal ra_internal : std_logic_vector(2 downto 0);
signal rb_internal : std_logic_vector(2 downto 0);
signal rc_internal : std_logic_vector(2 downto 0);
signal cl_internal : std_logic_vector(3 downto 0);

begin
	
	instr <= instr_in;
	op_code <= instr_in(15 downto 9);
	ra_internal <= instr_in(8 downto 6);
	rb_internal <= instr_in(5 downto 3);
	rc_internal <= instr_in(2 downto 0);
	cl_internal <= instr_in(3 downto 0);
	
	process(clk, rst, op_code, ra_internal, rb_internal, rc_internal, cl_internal)
	
		begin
		
		if rising_edge(clk) then
			
			if rst = '1' then
				
				instr_out <= (others => '0');
				ra_out <= (others => '0');
				rb_out <= (others => '0');
				rc_out <= (others => '0');
				cl_out <= (others => '0');
			
			else
				
				case op_code is
				
					-- when add, sub, mult, nand
					when "0000001" | "0000010" | "0000011" | "0000100" =>
						ra_out <= ra_internal;
						rb_out <= rb_internal;
						rc_out <= rc_internal;
						cl_out <= (others => '0');
					-- when shl, lhl	
					when "0000101" | "0000110" =>
						ra_out <= ra_internal;
						rb_out <= ra_internal;
						rc_out <= (others => '0');
						cl_out <= cl_internal;
					-- when in and out
					when "0100000" | "0100001" =>
						ra_out <= ra_internal;
						rb_out <= (others => '0');
						rc_out <= (others => '0');
						cl_out <= (others => '0');
					when others =>
						ra_out <= (others => '0');
						rb_out <= (others => '0');
						rc_out <= (others => '0');
						cl_out <= (others => '0');
					
					end case;
					
					-- #TODO
					-- Create logic and conditions for branching
					
					instr_out <= instr;
				
			end if;
			
		end if;
			
	end process;

end Behavioral;

