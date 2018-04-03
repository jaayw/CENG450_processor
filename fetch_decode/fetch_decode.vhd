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
			pc_in : IN std_logic_vector(6 downto 0); -- might remove testing
			
			-- output
			instr_out : OUT std_logic_vector(15 downto 0); -- Output instr to
			pc_out : OUT std_logic_vector(6 downto 0); -- might remove testing
			ra_out :	OUT std_logic_vector(2 downto 0);
			rb_out :	OUT std_logic_vector(2 downto 0);
			rc_out :	OUT std_logic_vector(2 downto 0);
			cl_out :	OUT std_logic_vector(3 downto 0)
		);
		
end fetch_decode;

architecture Behavioral of fetch_decode is

signal instr : std_logic_vector(15 downto 0);

alias op_code is instr_in(15 downto 9);
alias ra_internal is instr_in(8 downto 6);
alias rb_internal is instr_in(5 downto 3);
alias rc_internal is instr_in(2 downto 0);
alias cl_internal is instr_in(3 downto 0);

begin
	
	instr <= instr_in;
	
	process(clk, rst, pc_in, op_code, ra_internal, rb_internal, rc_internal, cl_internal)
	
		begin
		
		if (clk = '1' and clk'event) then
			
			if rst = '1' then
				
				instr_out <= (others => '0');
				pc_out <= (others => '0');
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
					-- OUT (32)
					when "0100000" =>
						ra_out <= ra_internal;
						rb_out <= ra_internal;
						rc_out <= (others => '0');
						cl_out <= (others => '0');
					-- IN (33)
					when "0100001" =>
						ra_out <= ra_internal;
						rb_out <= (others => '0');
						rc_out <= (others => '0');
						cl_out <= (others => '0');
					
					-- BRR, BRR.N, BRR.Z, BR, BR.N, BR.Z 
					when "1000000" | "1000001" | "1000010" | "1000011" | "1000100" | "1000101" =>
						ra_out <= ra_internal;
						rb_out <= ra_internal;
						rc_out <= (others => '0');
						cl_out <= (others => '0');
						
					-- BR.SUB
					when "1000110" =>
						ra_out <= "111";
						rb_out <= ra_internal;
						rc_out <= (others => '0');
						cl_out <= (others => '0'); 
					
					-- RETURN
					when "1000111" =>
						ra_out <= (others => '0');
						rb_out <= "111";
						rc_out <= (others => '0');
						cl_out <= (others => '0');
					
					-- LOAD
					when "0010000" =>
						ra_out <= ra_internal;
						rb_out <= rb_internal;
						rc_out <= (others => '0');
						cl_out <= (others => '0');
						
					-- STORE
					when "0010001" =>
						ra_out <= ra_internal;
						rb_out <= ra_internal;
						rc_out <= rc_internal;
						cl_out <= '0' & rb_internal;
						
					-- LOADIMM
					when "0010010" =>
						ra_out <= "111";
						rb_out <= (others => '0');
						rc_out <= (others => '0');
						cl_out <= (others => '0');
						
					-- MOV
					when "0010011" =>
						ra_out <= ra_internal;
						rb_out <= rb_internal;
						rc_out <= (others => '0');
						cl_out <= (others => '0');
						
					when others =>
						ra_out <= (others => '0');
						rb_out <= (others => '0');
						rc_out <= (others => '0');
						cl_out <= (others => '0');
					
					end case;
					
					instr_out <= instr;
					pc_out <= pc_in;
				
			end if;
			
		end if;
			
	end process;

end Behavioral;

